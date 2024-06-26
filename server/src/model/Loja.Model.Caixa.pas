unit Loja.Model.Caixa;

interface

uses
  System.SysUtils,
  System.Classes,

  Loja.Environment.Interfaces,
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
    FEnvRules: ILojaEnvironmentRuler;
  public
    constructor Create(AEnvRules: ILojaEnvironmentRuler);
    destructor Destroy; override;
    class function New(AEnvRules: ILojaEnvironmentRuler): ILojaModelCaixa;

    { ILojaModelCaixa }
    function ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
    function ObterCaixaPorCodigo(ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
    function ObterCaixasPorDataAbertura(ADatIni, ADatFim: TDate): TLojaModelEntityCaixaCaixaLista;

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
    .Error('O caixa n�o poder� ser aberto com valor negativo');

  AAbertura.DatAbert := Now;

  var LCaixaAberto := TLojaModelDaoFactory.New(FEnvRules).Caixa
    .Caixa
    .ObterCaixaAberto;
  if LCaixaAberto <> nil
  then try
    raise EHorseException.New
      .Status(THTTPStatus.PreconditionFailed)
      .&Unit(Self.UnitName)
      .Error(Format(
        'H� um caixa aberto (Data abertura: %s). Feche-o para ent�o realizar nova abertura.',
        [DateTimeToStr(LCaixaAberto.DatAbert)])
      );
  finally
    LCaixaAberto.Free;
  end;

  var LUltFechado := TLojaModelDaoFactory.New(FEnvRules).Caixa
    .Caixa
    .ObterUltimoCaixaFechado(AAbertura.DatAbert);

  var LNovoCaixa := TLojaModelDaoFactory.New(FEnvRules).Caixa
    .Caixa
    .CriarNovoCaixa(AAbertura);

  if LUltFechado <> nil
  then begin
    var LResumo := ObterResumoCaixa(LUltFechado.CodCaixa);
    var LVrDin := LResumo.MeiosPagto.Get(pagDinheiro).VrTotal;
    var LMovAbert := TLojaModelDtoReqCaixaCriarMovimento.Create;
    try
      if LResumo.MeiosPagto.Get(pagDinheiro).VrTotal > 0
      then begin
        LMovAbert.CodCaixa := LNovoCaixa.CodCaixa;
        LMovAbert.DatMov := Now;
        LMovAbert.DscObs := 'Saldo fechamento do caixa anterior';
        LMovAbert.CodMeioPagto := pagDinheiro;
        LMovAbert.CodTipoMov := movEntrada;
        LMovAbert.CodOrigMov := orgReforco;
        LMovAbert.VrMov := LVrDin;

        var LMov1 := TLojaModelBoFactory.New(FEnvRules).Caixa.CriarMovimentoCaixa(LMovAbert);
        LMov1.Free;
      end;

      if LNovoCaixa.VrAbert <> LVrDin
      then begin
        // fazer segundo movimento para regularizar a diferen�a
        LMovAbert.CodCaixa := LNovoCaixa.CodCaixa;
        LMovAbert.DatMov := Now;
        LMovAbert.DscObs := 'Saldo abertura divergente do �ltimo fechamento';
        LMovAbert.CodMeioPagto := pagDinheiro;
        LMovAbert.VrMov := Abs(LNovoCaixa.VrAbert - LVrDin);

        if LNovoCaixa.VrAbert > LVrDin
        then begin
          LMovAbert.CodTipoMov := movEntrada;
          LMovAbert.CodOrigMov := orgReforco;
        end
        else
        begin
          LMovAbert.CodTipoMov := movSaida;
          LMovAbert.CodOrigMov := orgSangria;
        end;

        var Mov2 := TLojaModelBoFactory.New(FEnvRules).Caixa.CriarMovimentoCaixa(LMovAbert);
        Mov2.Free;
      end;
    finally
      LMovAbert.Free;
      LResumo.Free;
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

      var LMovimento := TLojaModelBoFactory.New(FEnvRules).Caixa.CriarMovimentoCaixa(LMovAbert);
      LMovimento.Free;
    finally
      LMovAbert.Free;
    end;
  end;

  Result := LNovoCaixa;
end;

constructor TLojaModelCaixa.Create(AEnvRules: ILojaEnvironmentRuler);
begin
  FEnvRules := AEnvRules;
end;

function TLojaModelCaixa.CriarReforcoCaixa(
  AMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
begin
  AMovimento.CodMeioPagto := pagDinheiro;
  AMovimento.CodOrigMov := orgReforco;

  Result := TLojaModelBoFactory.New(FEnvRules).Caixa.CriarMovimentoCaixa(AMovimento);
end;

function TLojaModelCaixa.CriarSangriaCaixa(
  AMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
begin
  AMovimento.CodMeioPagto := pagDinheiro;
  AMovimento.CodOrigMov := orgSangria;

  Result := TLojaModelBoFactory.New(FEnvRules).Caixa.CriarMovimentoCaixa(AMovimento);
end;

destructor TLojaModelCaixa.Destroy;
begin

  inherited;
end;

function TLojaModelCaixa.FechamentoCaixa(
  AFechamento: TLojaModelDtoReqCaixaFechamento): TLojaModelEntityCaixaCaixa;
begin
  if AFechamento.CodCaixa <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O c�digo de caixa informado � inv�lido');

  var LCaixa := TLojaModelDaoFactory.New(FEnvRules).Caixa
    .Caixa
    .ObterCaixaPorCodigo(AFechamento.CodCaixa);

  if LCaixa = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('O c�digo de caixa informado n�o existe');
  LCaixa.Free;

  var LResumo := ObterResumoCaixa(AFechamento.CodCaixa);
  try
    if LResumo.CodSit = sitFechado
    then raise EHorseException.New
      .Status(THTTPStatus.PreconditionFailed)
      .&Unit(Self.UnitName)
      .Error('Este caixa j� se encontra fechado');

    for var LMeioPagto in LResumo.MeiosPagto
    do begin
      if LMeioPagto.VrTotal <> AFechamento.MeiosPagto.Get(LMeioPagto.CodMeioPagto).VrTotal
      then raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(Self.UnitName)
        .Error(Format('O valor informado para o meio de pagamento "%s" n�o confere. Verifique novamente',
          [LMeioPagto.CodMeioPagto.Name]));
    end;

    Result := TLojaModelDaoFactory.New(FEnvRules).Caixa
      .Caixa
      .AtualizarFechamentoCaixa(AFechamento.CodCaixa, Now, LResumo.VrSaldo);

  finally
    LResumo.Free;
  end;
end;

class function TLojaModelCaixa.New(AEnvRules: ILojaEnvironmentRuler): ILojaModelCaixa;
begin
  Result := Self.Create(AEnvRules);
end;

function TLojaModelCaixa.ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
begin
  Result := TLojaModelBoFactory.New(FEnvRules).Caixa
    .ObterCaixaAberto;
end;

function TLojaModelCaixa.ObterCaixaPorCodigo(
  ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
begin
  if ACodCaixa <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O c�digo de caixa informado � inv�lido');

  Result := TLojaModelDaoFactory.New(FEnvRules).Caixa
    .Caixa
    .ObterCaixaPorCodigo(ACodCaixa);
end;

function TLojaModelCaixa.ObterCaixasPorDataAbertura(ADatIni,
  ADatFim: TDate): TLojaModelEntityCaixaCaixaLista;
begin
  if ADatIni > ADatFim
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('A data inicial deve ser inferior � data final em pelo menos 1 dia');

  Result := TLojaModelDaoFactory.New(FEnvRules).Caixa
    .Caixa
    .ObterCaixasPorDataAbertura(ADatIni, ADatFim);
end;

function TLojaModelCaixa.ObterMovimentoCaixa(
  ACodCaixa: Integer): TLojaModelEntityCaixaMovimentoLista;
begin
  if ACodCaixa <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O c�digo de caixa informado � inv�lido');

  var LCaixa := TLojaModelDaoFactory.New(FEnvRules).Caixa
    .Caixa
    .ObterCaixaPorCodigo(ACodCaixa);

  if LCaixa = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('O c�digo de caixa informado n�o existe');
  LCaixa.Free;

  Result := TLojaModelDaoFactory.New(FEnvRules).Caixa
    .Movimento
    .ObterMovimentoPorCaixa(ACodCaixa);
end;

function TLojaModelCaixa.ObterResumoCaixa(
  ACodCaixa: Integer): TLojaModelDtoRespCaixaResumoCaixa;
begin
  var LMovimentos := ObterMovimentoCaixa(ACodCaixa);
  var LCaixa := TLojaModelDaoFactory.New(FEnvRules).Caixa
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

    Result.MeiosPagto.Get(LMovimento.CodMeioPagto).VrTotal :=
      Result.MeiosPagto.Get(LMovimento.CodMeioPagto).VrTotal + LVrMov;
  end;

  LMovimentos.Free;
  LCaixa.Free;
end;

end.
