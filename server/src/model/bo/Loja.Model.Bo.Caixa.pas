unit Loja.Model.Bo.Caixa;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Environment.Interfaces,
  Loja.Model.Bo.Interfaces,

  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Movimento,
  Loja.Model.Dto.Req.Caixa.CriarMovimento;

type
  TLojaModelBoCaixa = class(TInterfacedObject, ILojaModelBoCaixa)
  private
    FEnvRules: ILojaEnvironmentRuler;
  public
    constructor Create(AEnvRules: ILojaEnvironmentRuler);
    destructor Destroy; override;
    class function New(AEnvRules: ILojaEnvironmentRuler): ILojaModelBoCaixa;

    { ILojaModelBoCaixa }
    function ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
    function CriarMovimentoCaixa(AMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
  end;

implementation

uses
  Horse,
  Horse.Exception,
  System.Math,

  Loja.Model.Dao.Factory,
  Loja.Model.Bo.Factory;

{ TLojaModelBoCaixa }


constructor TLojaModelBoCaixa.Create(AEnvRules: ILojaEnvironmentRuler);
begin
  FEnvRules := AEnvRules;
end;

function TLojaModelBoCaixa.CriarMovimentoCaixa(
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

  var LCaixa := TLojaModelDaoFactory.New(FEnvRules).Caixa
    .Caixa
    .ObterCaixaPorCodigo(AMovimento.CodCaixa);

  if LCaixa = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('O código de caixa informado não existe');

  try
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

      var LMovimentos := TLojaModelDaoFactory.New(FEnvRules).Caixa
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

    var LNovoMovimento := TLojaModelDaoFactory.New(FEnvRules).Caixa
      .Movimento
      .CriarNovoMovimento(AMovimento);
    Result := LNovoMovimento;

  finally
    LCaixa.Free;
  end;
end;

destructor TLojaModelBoCaixa.Destroy;
begin

  inherited;
end;

class function TLojaModelBoCaixa.New(AEnvRules: ILojaEnvironmentRuler): ILojaModelBoCaixa;
begin
  Result := Self.Create(AEnvRules);
end;

function TLojaModelBoCaixa.ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
begin
  Result := TLojaModelDaoFactory.New(FEnvRules).Caixa
    .Caixa
    .ObterCaixaAberto;
end;

end.
