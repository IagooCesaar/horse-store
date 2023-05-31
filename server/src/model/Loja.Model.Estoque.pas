unit Loja.Model.Estoque;

interface

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  System.Generics.Defaults,
  System.Generics.Collections,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Estoque.Movimento,
  Loja.Model.Entity.Estoque.Saldo,
  Loja.Model.Dto.Req.Estoque.CriarMovimento,
  Loja.Model.Dto.Req.Estoque.AcertoEstoque;

type
  TLojaModelEstoque = class(TinterfacedObject, ILojaModelEstoque)
  private
    function SaldoAtualItem(ACodItem: Integer): Integer;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelEstoque;

    { ILojaModelEstoque }
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
    function CriarAcertoEstoque(AAcertoEstoque: TLojaModelDtoReqEstoqueAcertoEstoque): TLojaModelEntityEstoqueMovimento;
    function ObterHistoricoMovimento(ACodItem: Integer; ADatIni, ADatFim: TDateTime): TLojaModelEntityEstoqueMovimentoLista;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Factory,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Entity.Estoque.Types;

{ TLojaModelEstoque }

constructor TLojaModelEstoque.Create;
begin

end;

function TLojaModelEstoque.CriarAcertoEstoque(
  AAcertoEstoque: TLojaModelDtoReqEstoqueAcertoEstoque): TLojaModelEntityEstoqueMovimento;
const C_MOT_MIN = 4; C_MOT_MAX = 40;
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
    .Error('A descrição do motivo é obrigatória para acerto de estoque');

  if AAcertoEstoque.QtdSaldoReal < 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('Não é permitido estoque negativo');

  LItem := TLojaModelDaoFactory.New.Itens.Item.ObterPorCodigo(AAcertoEstoque.CodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O item informado não existe');
  LItem.Free;


  LSaldo := SaldoAtualItem(AAcertoEstoque.CodItem);
  if LSaldo = AAcertoEstoque.QtdSaldoReal
  then raise EHorseException.New
    .Status(THTTPStatus.ExpectationFailed)
    .&Unit(Self.UnitName)
    .Error('O saldo atual do item já está conforme o acerto informado');

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
const C_MOT_MIN = 4; C_MOT_MAX = 40;
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
      .Error(Format('A descrição do motivo para realização do acerto deverá ter no mínimo %d caracteres', [ C_MOT_MIN ]));

    if Length(ANovoMovimento.DscMot) > C_MOT_MAX
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error(Format('A descrição do motivo para realização do acerto deverá ter no máximo %d caracteres', [ C_MOT_MAX ]));
  end
  else
  if ANovoMovimento.CodOrigMov = orgAcerto
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('É obrigatório informar o motivo do acerto de estoque');

  case ANovoMovimento.CodTipoMov of
    movEntrada:
      if not(ANovoMovimento.CodOrigMov in ESTOQUE_MOVIMENTOS_ENTRADA)
      then raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(Self.UnitName)
        .Error('A origem do movimento de estoque não é do tipo de movimento de Entrada');

    movSaida:
      if not(ANovoMovimento.CodOrigMov in ESTOQUE_MOVIMENTOS_SAIDA)
      then raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(Self.UnitName)
        .Error('A origem do movimento de estoque não é do tipo de movimento de Saída');

  else
    raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('Não foi possível reconhecer o tipo de movimento de estoque');
  end;

  LItem := TLojaModelDaoFactory.New.Itens.Item.ObterPorCodigo(ANovoMovimento.CodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O item informado não existe');
  LItem.Free;

  Result := TLojaModelDaoFactory.New.Estoque
    .Movimento
    .CriarNovoMovimento(ANovoMovimento);
end;

destructor TLojaModelEstoque.Destroy;
begin

  inherited;
end;

class function TLojaModelEstoque.New: ILojaModelEstoque;
begin
  Result := Self.Create;
end;

function TLojaModelEstoque.ObterHistoricoMovimento(ACodItem: Integer; ADatIni,
  ADatFim: TDateTime): TLojaModelEntityEstoqueMovimentoLista;
begin
  Result := nil;
end;

function TLojaModelEstoque.SaldoAtualItem(ACodItem: Integer): Integer;
var
  LUltSaldo: Integer;
  LDatIni, LDatFim : TDateTime;
  LUltFechamento: TLojaModelEntityEstoqueSaldo;
  LMovimentos: TLojaModelEntityEstoqueMovimentoLista;
begin
  Result := 0;
  (*
    - Obter último fechamento de saldo do item
    - Realizar fechamento de saldo até "ontem"
    - Somar saldo de "ontem" o as movimentações do dia
  *)
  try
    LUltFechamento := TLojaModelDaoFactory.New.Estoque
      .Saldo
      .ObterUltimoFechamentoItem(ACodItem);

    if LUltFechamento <> nil
    then begin
      LDatIni := Trunc(LUltFechamento.DatSaldo)+1;
      LUltSaldo := LUltFechamento.QtdSaldo;
    end else
    begin
      LDatIni := EncodeDate(1900,01,01);
      LUltSaldo := 0;
    end;

    LDatFim := Trunc(Now)-1;

    // Ajustar para loop incrementando datas pois nem todo dia tem movimento

    if LDatIni <= LDatFim then
    begin
      LMovimentos := TLojaModelDaoFactory.New.Estoque
        .Movimento
        .ObterMovimentoItemEntreDatas(ACodItem, LDatIni, LDatFim);
      if (LMovimentos <> nil) and (LMovimentos.Count > 0)
      then begin
        //Ordenar pela data de movimentação
        LMovimentos.Sort(
          TComparer<TLojaModelEntityEstoqueMovimento>.Construct(
          function (const L, R: TLojaModelEntityEstoqueMovimento): Integer
          begin
            if Trunc(L.DatMov) > Trunc(R.DatMov)
            then Result := 1
            else
            if Trunc(L.DatMov) < Trunc(R.DatMov)
            then Result := -1
            else Result := 0;
          end)
        );

        LDatIni := LMovimentos.First.DatMov;

        for var LMovimento in LMovimentos do
        begin
          if LDatIni <> LMovimento.DatMov
          then begin
            var LFecha := TLojaModelDaoFactory.New.Estoque
              .Saldo
              .CriarFechamentoSaldoItem(ACodItem, LDatIni, LUltSaldo);
            LFecha.Free;
          end;

          LDatIni := LMovimento.DatMov;

          case LMovimento.CodTipoMov of
            movEntrada:
              Inc(LUltSaldo, LMovimento.QtdMov);
            movSaida:
              Dec(LUltSaldo, LMovimento.QtdMov);
          end;
        end;
        var LFecha := TLojaModelDaoFactory.New.Estoque
          .Saldo
          .CriarFechamentoSaldoItem(ACodItem, LDatIni, LUltSaldo);
        LFecha.Free;

      end
      else
      begin
        // Se não houve movimentos, criar um fechamento com saldo zero "ontem"
        var LFecha := TLojaModelDaoFactory.New.Estoque
          .Saldo
          .CriarFechamentoSaldoItem(ACodItem, LDatFim, LUltSaldo);
        LFecha.Free;
      end;
    end;

  finally
    if LUltFechamento <> nil
    then FreeAndNil(LUltFechamento);

    if LMovimentos <> nil
    then FreeAndNil(LMovimentos);
  end;
  // neste ponto, LUltSaldo tem o Saldo de Ontem
  try
    LMovimentos := TLojaModelDaoFactory.New.Estoque
      .Movimento
      .ObterMovimentoItemEntreDatas(ACodItem, Now, Now);
    if (LMovimentos <> nil) and (LMovimentos.Count > 0)
    then begin
      for var LMovimento in LMovimentos do
        case LMovimento.CodTipoMov of
          movEntrada:
            Inc(LUltSaldo, LMovimento.QtdMov);
          movSaida:
            Dec(LUltSaldo, LMovimento.QtdMov);
        end;
    end;
  finally
    if LMovimentos <> nil
    then FreeAndNil(LMovimentos);
  end;
  Result := LUltSaldo;
end;

end.
