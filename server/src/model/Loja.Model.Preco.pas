unit Loja.Model.Preco;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Preco.Venda,
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda;

type
  TLojaModelPreco = class(TInterfacedObject, ILojaModelPreco)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelPreco;

    { ILojaModelPreco }
    function CriarPrecoVendaItem(ANovoPreco: TLojaModelDtoReqPrecoCriarPrecoVenda): TLojaModelEntityPrecoVenda;
    function ObterHistoricoPrecoVendaItem(ACodItem: Integer; ADatRef: TDateTime): TLojaModelEntityPrecoVendaLista;
    function ObterPrecoVendaAtual(ACodItem: Integer): TLojaModelEntityPrecoVenda;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Factory;

{ TLojaModelPreco }

constructor TLojaModelPreco.Create;
begin

end;

function TLojaModelPreco.CriarPrecoVendaItem(
  ANovoPreco: TLojaModelDtoReqPrecoCriarPrecoVenda): TLojaModelEntityPrecoVenda;
begin
  Result := nil;

  if ANovoPreco.VrVnda <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O valor de venda deve ser maior que zero');

  var LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorCodigo(ANovoPreco.CodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('Não foi possível encontrar o item pelo código informado');
  LItem.Free;

  var LPrecoVigente := TLojaModelDaoFactory.New.Preco
    .Venda.
    ObterPrecoVendaVigente(ANovoPreco.CodItem, ANovoPreco.DatIni);
  if LPrecoVigente <> nil
  then try
    if ANovoPreco.DatIni = LPrecoVigente.DatIni
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('Já existe um preço configurado para inicar na data informada');
  finally
    LPrecoVigente.Free;
  end;

  var LPreco := TLojaModelDaoFactory.New.Preco
    .Venda
    .CriarPrecoVendaItem(ANovoPreco);

  Result := LPreco;

end;

destructor TLojaModelPreco.Destroy;
begin

  inherited;
end;

class function TLojaModelPreco.New: ILojaModelPreco;
begin
  Result := Self.Create;
end;

function TLojaModelPreco.ObterHistoricoPrecoVendaItem(ACodItem: Integer;
  ADatRef: TDateTime): TLojaModelEntityPrecoVendaLista;
begin
  Result := nil;

  var LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorCodigo(ACodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('Não foi possível encontrar o item pelo código informado');
  LItem.Free;

  var LHistorico := TLojaModelDaoFactory.New.Preco
    .Venda.
    ObterHistoricoPrecoVendaItem(ACodItem, ADatRef);

  Result := LHistorico;
end;

function TLojaModelPreco.ObterPrecoVendaAtual(
  ACodItem: Integer): TLojaModelEntityPrecoVenda;
begin
  Result := Nil;

  var LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorCodigo(ACodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('Não foi possível encontrar o item pelo código informado');
  LItem.Free;

  var LPrecoVigente := TLojaModelDaoFactory.New.Preco
    .Venda
    .ObterPrecoVendaAtual(ACodItem);

  Result := LPrecoVigente;
end;

end.
