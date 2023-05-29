unit Loja.Model.Estoque;

interface

uses
  System.Classes,
  System.SysUtils,
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
const C_MOT_MIN = 4;
var
  LItem: TLojaModelEntityItensItem;
  LSaldo: Integer;
  LMovimento: TLojaModelDtoReqEstoqueCriarMovimento;
begin
  Result := nil;
  if Length(AAcertoEstoque.DscMotivo) < C_MOT_MIN
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error(Format('O motivo para realiza��o do acerto dever� ter no m�nimo %d caracteres', [ C_MOT_MIN ]));

  LItem := TLojaModelDaoFactory.New.Itens.Item.ObterPorCodigo(AAcertoEstoque.CodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O item informado n�o existe');
  LItem.Free;

  LSaldo := SaldoAtualItem(AAcertoEstoque.CodItem);
  if LSaldo = AAcertoEstoque.QtdSaldoReal
  then raise EHorseException.New
    .Status(THTTPStatus.ExpectationFailed)
    .&Unit(Self.UnitName)
    .Error('O saldo atual do item j� est� conforme o acerto informado');

  LMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LMovimento.CodItem := AAcertoEstoque.CodItem;
    LMovimento.QtdMov :=  Abs(AAcertoEstoque.QtdSaldoReal - LSaldo);
    if AAcertoEstoque.QtdSaldoReal <  LSaldo
    then LMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movSaida
    else LMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgAcerto;
    LMovimento.DscMot := AAcertoEstoque.DscMotivo;

    Result := CriarNovoMovimento(LMovimento);
  finally
    LMovimento.Free;
  end;
end;

function TLojaModelEstoque.CriarNovoMovimento(
  ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
begin
  Result := nil;
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
begin
  Result := 0;
end;

end.
