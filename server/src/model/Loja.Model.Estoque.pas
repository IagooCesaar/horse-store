unit Loja.Model.Estoque;

interface

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  System.Generics.Defaults,
  System.Generics.Collections,

  Loja.Environment.Interfaces,
  Loja.Model.Interfaces,
  Loja.Model.Entity.Estoque.Movimento,
  Loja.Model.Entity.Estoque.Saldo,
  Loja.Model.Dto.Req.Estoque.CriarMovimento,
  Loja.Model.Dto.Req.Estoque.AcertoEstoque,
  Loja.Model.Dto.Resp.Estoque.SaldoItem;

type
  TLojaModelEstoque = class(TinterfacedObject, ILojaModelEstoque)
  private
    FEnvRules: ILojaEnvironmentRuler;
    procedure RealizarFechamentoSaldo(ACodItem: Integer);
  public
    constructor Create(AEnvRules: ILojaEnvironmentRuler);
	  destructor Destroy; override;
	  class function New(AEnvRules: ILojaEnvironmentRuler): ILojaModelEstoque;

    { ILojaModelEstoque }
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
    function CriarAcertoEstoque(AAcertoEstoque: TLojaModelDtoReqEstoqueAcertoEstoque): TLojaModelEntityEstoqueMovimento;
    function ObterHistoricoMovimento(ACodItem: Integer; ADatIni, ADatFim: TDateTime): TLojaModelEntityEstoqueMovimentoLista;
    function ObterFechamentosSaldo(ACodItem: Integer; ADatIni, ADatFim: TDateTime): TLojaModelEntityEstoqueSaldoLista;
    function ObterSaldoAtualItem(ACodItem: Integer): TLojaModelDtoRespEstoqueSaldoItem;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Bo.Factory,
  Loja.Model.Dao.Factory,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Entity.Estoque.Types;

{ TLojaModelEstoque }

constructor TLojaModelEstoque.Create(AEnvRules: ILojaEnvironmentRuler);
begin
  FEnvRules := AEnvRules;
end;

function TLojaModelEstoque.CriarAcertoEstoque(
  AAcertoEstoque: TLojaModelDtoReqEstoqueAcertoEstoque): TLojaModelEntityEstoqueMovimento;
const C_MOT_MIN = 4; C_MOT_MAX = 60;
var
  LItem: TLojaModelEntityItensItem;
  LSaldo: Integer;
  LMovimento: TLojaModelDtoReqEstoqueCriarMovimento;
begin
  Result := nil;
  if AAcertoEstoque.DscMot = ''
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('A descri��o do motivo � obrigat�ria para acerto de estoque');

  if AAcertoEstoque.QtdSaldoReal < 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('N�o � permitido estoque negativo');

  LItem := TLojaModelDaoFactory.New(FEnvRules)
    .Itens.Item.ObterPorCodigo(AAcertoEstoque.CodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('O item informado n�o existe');
  LItem.Free;

  var LSaldoAtual := ObterSaldoAtualItem(AAcertoEstoque.CodItem);
  LSaldo := LSaldoAtual.QtdSaldoAtu;
  LSaldoAtual.Free;

  if LSaldo = AAcertoEstoque.QtdSaldoReal
  then raise EHorseException.New
    .Status(THTTPStatus.ExpectationFailed)
    .&Unit(Self.UnitName)
    .Error('O saldo atual do item j� est� conforme o acerto informado');

  LMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LMovimento.CodItem := AAcertoEstoque.CodItem;
    LMovimento.DatMov := Now;
    LMovimento.QtdMov := Abs(AAcertoEstoque.QtdSaldoReal - LSaldo);
    if AAcertoEstoque.QtdSaldoReal <  LSaldo
    then LMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movSaida
    else LMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgAcerto;
    LMovimento.DscMot := AAcertoEstoque.DscMot;

    Result := CriarNovoMovimento(LMovimento);
  finally
    LMovimento.Free;
  end;
end;

function TLojaModelEstoque.CriarNovoMovimento(
  ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
const C_MOT_MIN = 4; C_MOT_MAX = 60;
var
  LItem: TLojaModelEntityItensItem;
  LSaldo: Integer;
  LMovimento: TLojaModelDtoReqEstoqueCriarMovimento;
begin
  Result := nil;

  if ANovoMovimento.DscMot <> ''
  then begin
    if Length(ANovoMovimento.DscMot) < C_MOT_MIN
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error(Format('A descri��o do motivo para realiza��o do acerto dever� ter no m�nimo %d caracteres', [ C_MOT_MIN ]));

    if Length(ANovoMovimento.DscMot) > C_MOT_MAX
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error(Format('A descri��o do motivo para realiza��o do acerto dever� ter no m�ximo %d caracteres', [ C_MOT_MAX ]));
  end
  else
  if ANovoMovimento.CodOrigMov = orgAcerto
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('� obrigat�rio informar o motivo do acerto de estoque');

  case ANovoMovimento.CodTipoMov of
    movEntrada:
      if not(ANovoMovimento.CodOrigMov in ESTOQUE_MOVIMENTOS_ENTRADA)
      then raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(Self.UnitName)
        .Error('A origem do movimento de estoque n�o � do tipo de movimento de Entrada');

    movSaida:
      if not(ANovoMovimento.CodOrigMov in ESTOQUE_MOVIMENTOS_SAIDA)
      then raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(Self.UnitName)
        .Error('A origem do movimento de estoque n�o � do tipo de movimento de Sa�da');

  {else
    raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('N�o foi poss�vel reconhecer o tipo de movimento de estoque');}
  end;

  LItem := TLojaModelDaoFactory.New(FEnvRules).Itens.Item.ObterPorCodigo(ANovoMovimento.CodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('O item informado n�o existe');
  LItem.Free;

  Result := TLojaModelDaoFactory.New(FEnvRules).Estoque
    .Movimento
    .CriarNovoMovimento(ANovoMovimento);
end;

destructor TLojaModelEstoque.Destroy;
begin

  inherited;
end;

class function TLojaModelEstoque.New(AEnvRules: ILojaEnvironmentRuler): ILojaModelEstoque;
begin
  Result := Self.Create(AEnvRules);
end;

function TLojaModelEstoque.ObterFechamentosSaldo(ACodItem: Integer; ADatIni,
  ADatFim: TDateTime): TLojaModelEntityEstoqueSaldoLista;
begin
  Result := nil;
  ADatIni := StartOfTheDay(ADatIni);
  ADatFim := EndOfTheDay(ADatFim);

  if ADatIni > ADatFim
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('A data inicial deve ser inferior � data final em pelo menos 1 dia');

  var LItem := TLojaModelDaoFactory.New(FEnvRules).Itens.Item.ObterPorCodigo(ACodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('O item informado n�o existe');
  LItem.Free;

  Result := TLojaModelDaoFactory.New(FEnvRules).Estoque
    .Saldo
    .ObterFechamentosItem(ACodItem, ADatIni, ADatFim);
end;

function TLojaModelEstoque.ObterHistoricoMovimento(ACodItem: Integer; ADatIni,
  ADatFim: TDateTime): TLojaModelEntityEstoqueMovimentoLista;
begin
  Result := nil;
  ADatIni := StartOfTheDay(ADatIni);
  ADatFim := EndOfTheDay(ADatFim);

  if ADatIni > ADatFim
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('A data inicial deve ser inferior � data final em pelo menos 1 dia');

  var LItem := TLojaModelDaoFactory.New(FEnvRules).Itens.Item.ObterPorCodigo(ACodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('O item informado n�o existe');
  LItem.Free;

  var LMovimentos := TLojaModelDaoFactory.New(FEnvRules).Estoque
        .Movimento
        .ObterMovimentoItemEntreDatas(ACodItem, ADatIni, ADatFim);

  Result := LMovimentos;
end;

function TLojaModelEstoque.ObterSaldoAtualItem(
  ACodItem: Integer): TLojaModelDtoRespEstoqueSaldoItem;
var
  LUltSaldo: Integer;
  LDatIni, LDatFim : TDateTime;
begin
  var LItem := TLojaModelDaoFactory.New(FEnvRules).Itens.Item.ObterPorCodigo(ACodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('O item informado n�o existe');
  LItem.Free;

  RealizarFechamentoSaldo(ACodItem);

  Result := TLojaModelDtoRespEstoqueSaldoItem.Create;
  Result.CodItem := ACodItem;
  Result.UltimoFechamento := TLojaModelDaoFactory.New(FEnvRules).Estoque
    .Saldo
    .ObterUltimoFechamentoItem(ACodItem);

  if Result.UltimoFechamento <> nil
  then begin
    LDatIni := Trunc(Result.UltimoFechamento.DatSaldo)+1;
    LUltSaldo := Result.UltimoFechamento.QtdSaldo;
  {end else
  begin
    LDatIni := EncodeDate(1900,01,01);
    LUltSaldo := 0;}
  end;

  LDatIni := StartOfTheDay(LDatIni);
  LDatFim := EndOfTheDay(Now);

  Result.UltimosMovimentos := TLojaModelDaoFactory.New(FEnvRules).Estoque
    .Movimento
    .ObterMovimentoItemEntreDatas(ACodItem, LDatIni, LDatFim);

  if (Result.UltimosMovimentos <> nil) and (Result.UltimosMovimentos.Count > 0)
  then begin
    for var LMovimento in Result.UltimosMovimentos do
    begin
      case LMovimento.CodTipoMov of
        movEntrada:
          Inc(LUltSaldo, LMovimento.QtdMov);
        movSaida:
          Dec(LUltSaldo, LMovimento.QtdMov);
      end;
    end;
  end;

  Result.QtdSaldoAtu := LUltSaldo;
end;

procedure TLojaModelEstoque.RealizarFechamentoSaldo(ACodItem: Integer);
begin
  TLojaModelBoFactory.New(FEnvRules).Estoque
    .FechamentoSaldo
    .FecharSaldoMensalItem(ACodItem);
end;

end.
