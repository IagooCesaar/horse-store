unit Loja.Model.Caixa;

interface

uses
  System.SysUtils,
  System.Classes,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Movimento,
  Loja.Model.Dto.Req.Caixa.Abertura,
  Loja.Model.Dto.Req.Caixa.Fechamento,
  Loja.Model.Dto.Req.Caixa.CriarMovimento,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto;

type
  TLojaModelCaixa = class(TInterfacedObject, ILojaModelCaixa)
  private
    function CriarMovimentoCaixa(AMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelCaixa;

    { ILojaModelCaixa }
    function ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
    function ObterCaixaPorCodigo(ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
    function AberturaCaixa(AAbertura: TLojaModelDtoReqCaixaAbertura): TLojaModelEntityCaixaCaixa;
    function FechamentoCaixa(AFechamento: TLojaModelDtoReqCaixaFechamento): TLojaModelEntityCaixaCaixa;

    function CriarReforcoCaixa(AMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
    function CriarSangriaCaixa(AMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;

    function ObterResumoCaixa(ACodCaixa: Integer): TLojaModelDtoRespCaixaResumoCaixa;
    function ObterMovimentoCaixa(ACodCaixa: Integer): TLojaModelEntityCaixaMovimentoLista;
  end;

implementation

uses
  Horse,
  Horse.Exception,
  System.Math,

  Loja.Model.Dao.Factory,
  Loja.Model.Bo.Factory;

{ TLojaModelCaixa }

function TLojaModelCaixa.AberturaCaixa(
  AAbertura: TLojaModelDtoReqCaixaAbertura): TLojaModelEntityCaixaCaixa;
begin
  if AAbertura.VrAbert < 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O caixa não poderá ser aberto com valor negativo');

  AAbertura.DatAbert := Now;

  var LCaixaAberto := TLojaModelDaoFactory.New.Caixa
    .Caixa
    .ObterCaixaAberto;
  if LCaixaAberto <> nil
  then try
    raise EHorseException.New
      .Status(THTTPStatus.PreconditionFailed)
      .&Unit(Self.UnitName)
      .Error(Format(
        'Há um caixa aberto (Data abertura: %s). Feche-o para então realizar nova abertura.',
        [DateTimeToStr(LCaixaAberto.DatAbert)])
      );
  finally
    LCaixaAberto.Free;
  end;

  var LUltFechado := TLojaModelDaoFactory.New.Caixa
    .Caixa
    .ObterUltimoCaixaFechado(AAbertura.DatAbert);

  var LNovoCaixa := TLojaModelDaoFactory.New.Caixa
    .Caixa
    .CriarNovoCaixa(AAbertura);

  if LUltFechado <> nil
  then begin
    if LNovoCaixa.VrAbert <> LUltFechado.VrFecha
    then begin
      var LMovAbert := TLojaModelDtoReqCaixaCriarMovimento.Create;
      try
        LMovAbert.CodCaixa := LNovoCaixa.CodCaixa;
        LMovAbert.DatMov := LNovoCaixa.DatAbert;
        LMovAbert.DscObs := 'Saldo abertura divergente do último fechamento';
        LMovAbert.CodMeioPagto := pagDinheiro;
        LMovAbert.VrMov := Abs(LNovoCaixa.VrAbert - LUltFechado.VrFecha);
        if LNovoCaixa.VrAbert > LUltFechado.VrFecha
        then begin
          LMovAbert.CodTipoMov := movEntrada;
          LMovAbert.CodOrigMov := orgReforco;
        end
        else
        begin
          LMovAbert.CodTipoMov := movSaida;
          LMovAbert.CodOrigMov := orgSangria;
        end;
        var LMovimento := CriarMovimentoCaixa(LMovAbert);
        LMovimento.Free;
      finally
        LMovAbert.Free;
      end;
    end;
    LUltFechado.Free;
  end
  else
  if LNovoCaixa.VrAbert > 0
  then begin
    var LMovAbert := TLojaModelDtoReqCaixaCriarMovimento.Create;
    try
      LMovAbert.CodCaixa := LNovoCaixa.CodCaixa;
      LMovAbert.DatMov := LNovoCaixa.DatAbert;
      LMovAbert.DscObs := 'Saldo de abertura de caixa';
      LMovAbert.CodMeioPagto := pagDinheiro;
      LMovAbert.VrMov := LNovoCaixa.VrAbert;
      LMovAbert.CodTipoMov := movEntrada;
      LMovAbert.CodOrigMov := orgReforco;

      var LMovimento := CriarMovimentoCaixa(LMovAbert);
      LMovimento.Free;
    finally
      LMovAbert.Free;
    end;
  end;

  Result := LNovoCaixa;
end;

constructor TLojaModelCaixa.Create;
begin

end;

function TLojaModelCaixa.CriarMovimentoCaixa(
  AMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
const C_OBS_MIN = 4; C_OBS_MAX = 60;
var LSaldo: Currency;
begin
  if AMovimento.CodCaixa <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.PreconditionFailed)
    .&Unit(Self.UnitName)
    .Error('O código de caixa informado é inválido');

  if  (AMovimento.CodOrigMov in [orgReforco, orgSangria])
  then begin
    if (AMovimento.DscObs = '')
    then raise EHorseException.New
      .Status(THTTPStatus.PreconditionFailed)
      .&Unit(Self.UnitName)
      .Error('Você deverá informar uma observação para este tipo de movimento');

    if Length(AMovimento.DscObs) < C_OBS_MIN
    then raise EHorseException.New
      .Status(THTTPStatus.PreconditionFailed)
      .&Unit(Self.UnitName)
      .Error('A observação deverá ter no mínimo '+C_OBS_MIN.ToString+' caracteres');

    if Length(AMovimento.DscObs) > C_OBS_MAX
    then raise EHorseException.New
      .Status(THTTPStatus.PreconditionFailed)
      .&Unit(Self.UnitName)
      .Error('A observação deverá ter no máximo '+C_OBS_MAX.ToString+' caracteres');
  end;

  if AMovimento.VrMov <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.PreconditionFailed)
    .&Unit(Self.UnitName)
    .Error('O valor do movimento deverá ser superior a zero');

  var LCaixa := TLojaModelDaoFactory.New.Caixa
    .Caixa
    .ObterCaixaPorCodigo(AMovimento.CodCaixa);

  if LCaixa = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('O código de caixa informado não existe');

  if LCaixa.CodSit <> sitAberto
  then raise EHorseException.New
    .Status(THTTPStatus.PreconditionFailed)
    .&Unit(Self.UnitName)
    .Error('O caixa informado não está na stuação "Aberto"');

  AMovimento.DatMov := Now;
  if AMovimento.CodOrigMov in CAIXA_MOVIMENTOS_SAIDA
  then AMovimento.CodTipoMov := movSaida
  else AMovimento.CodTipoMov := movEntrada;

  if  (AMovimento.CodTipoMov = movSaida)
  and (AMovimento.CodMeioPagto = pagDinheiro)
  then begin
    LSaldo := 0;

    var LMovimentos := TLojaModelDaoFactory.New.Caixa
      .Movimento
      .ObterMovimentoPorCaixa(LCaixa.CodCaixa);
    for var LMovimento in LMovimentos
    do begin
      if LMovimento.CodMeioPagto = pagDinheiro
      then
        if LMovimento.CodTipoMov = movEntrada
        then LSaldo := LSaldo + LMovimento.VrMov
        else LSaldo := LSaldo - LMovimento.VrMov;
    end;
    LMovimentos.Free;

    if LSaldo < AMovimento.VrMov
    then raise EHorseException.New
      .Status(THTTPStatus.PreconditionFailed)
      .&Unit(Self.UnitName)
      .Error('Não há saldo disponível em dinheiro para realizar este tipo de movimento');
  end;


  var LNovoMovimento := TLojaModelDaoFactory.New.Caixa
    .Movimento
    .CriarNovoMovimento(AMovimento);
  Result := LNovoMovimento;

  LCaixa.Free;
end;

function TLojaModelCaixa.CriarReforcoCaixa(
  AMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
begin
  AMovimento.CodMeioPagto := pagDinheiro;
  AMovimento.CodOrigMov := orgReforco;

  Result := CriarMovimentoCaixa(AMovimento);
end;

function TLojaModelCaixa.CriarSangriaCaixa(
  AMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
begin
  AMovimento.CodMeioPagto := pagDinheiro;
  AMovimento.CodOrigMov := orgSangria;

  Result := CriarMovimentoCaixa(AMovimento);
end;

destructor TLojaModelCaixa.Destroy;
begin

  inherited;
end;

function TLojaModelCaixa.FechamentoCaixa(
  AFechamento: TLojaModelDtoReqCaixaFechamento): TLojaModelEntityCaixaCaixa;
begin
  if ACodCaixa <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O código de caixa informado é inválido');
end;

class function TLojaModelCaixa.New: ILojaModelCaixa;
begin
  Result := Self.Create;
end;

function TLojaModelCaixa.ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
begin
  Result := TLojaModelBoFactory.New.Caixa
    .ObterCaixaAberto;
end;

function TLojaModelCaixa.ObterCaixaPorCodigo(
  ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
begin
  if ACodCaixa <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O código de caixa informado é inválido');

  Result := TLojaModelDaoFactory.New.Caixa
    .Caixa
    .ObterCaixaPorCodigo(ACodCaixa);
end;

function TLojaModelCaixa.ObterMovimentoCaixa(
  ACodCaixa: Integer): TLojaModelEntityCaixaMovimentoLista;
begin
  if ACodCaixa <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O código de caixa informado é inválido');

  var LCaixa := TLojaModelDaoFactory.New.Caixa
    .Caixa
    .ObterCaixaPorCodigo(ACodCaixa);

  if LCaixa = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('O código de caixa informado não existe');
  LCaixa.Free;

  Result := TLojaModelDaoFactory.New.Caixa
    .Movimento
    .ObterMovimentoPorCaixa(ACodCaixa);
end;

function TLojaModelCaixa.ObterResumoCaixa(
  ACodCaixa: Integer): TLojaModelDtoRespCaixaResumoCaixa;
begin
  var LMovimentos := ObterMovimentoCaixa(ACodCaixa);
  var LCaixa := TLojaModelDaoFactory.New.Caixa
    .Caixa
    .ObterCaixaPorCodigo(ACodCaixa);

  Result := TLojaModelDtoRespCaixaResumoCaixa.Create;
  Result.CodCaixa := LCaixa.CodCaixa;
  Result.CodSit := LCaixa.CodSit;
  Result.MeiosPagto := TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista.Create;

  for var LMeioPagto := Low(TLojaModelEntityCaixaMeioPagamento) to High(TLojaModelEntityCaixaMeioPagamento)
  do begin
    Result.MeiosPagto.Add(TLojaModelDtoRespCaixaResumoCaixaMeioPagto.Create);
    Result.MeiosPagto.Last.CodMeioPagto := LMeioPagto;
    Result.MeiosPagto.Last.VrTotal := 0;
  end;

  for var LMovimento in LMovimentos
  do begin
    var LVrMov := IfThen(LMovimento.CodTipoMov = movEntrada, LMovimento.VrMov, LMovimento.VrMov * -1 );

    Result.VrSaldo := Result.VrSaldo + LVrMov;
    Result.MeiosPagto[Integer(LMovimento.CodMeioPagto)].VrTotal :=
      Result.MeiosPagto[Integer(LMovimento.CodMeioPagto)].VrTotal + LVrMov;
  end;

  LMovimentos.Free;
  LCaixa.Free;
end;

end.
