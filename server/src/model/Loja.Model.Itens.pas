unit Loja.Model.Itens;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Itens.Item;

type
  TLojaModelItens = class(TInterfacedObject, ILojaModelItens)
  private
  public
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelItens;

    { ILojaModelItens }
    function ObterPorCodigo(ACodItem: Integer): TLojaModelEntityItensItem;
    function ObterPorNumCodBarr(ANumCodBarr: string): TLojaModelEntityItensItem;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Factory;

{ TLojaModelItens }

constructor TLojaModelItens.Create;
begin

end;

destructor TLojaModelItens.Destroy;
begin

  inherited;
end;

class function TLojaModelItens.New: ILojaModelItens;
begin
  Result := Self.Create;
end;

function TLojaModelItens.ObterPorCodigo(
  ACodItem: Integer): TLojaModelEntityItensItem;
begin
  var LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorCodigo(ACodItem);

  if not Assigned(LItem)
  then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('Não foi possível encontrar o item pelo código informado');

  Result := LItem;
end;

function TLojaModelItens.ObterPorNumCodBarr(
  ANumCodBarr: string): TLojaModelEntityItensItem;
begin
  var LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorNumCodBarr(ANumCodBarr);

  if not Assigned(LItem)
  then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('Não foi possível encontrar o item pelo código de barras informado');
end;

end.
