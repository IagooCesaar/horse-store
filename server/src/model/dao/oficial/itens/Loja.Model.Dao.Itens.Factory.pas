unit Loja.Model.Dao.Itens.Factory;

interface

uses
  Loja.Model.Dao.Itens.Interfaces;

type
  TLojaModelDaoItensFactory = class(TInterfacedObject, ILojaModelDaoItensItemFactory)
  private
  public
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelDaoItensItemFactory;

    { ILojaModelDaoItensItemFactory }
    function Item: ILojaModelDaoItensItem;
  end;

implementation

uses
  Loja.Model.Dao.Itens.Item;

{ TLojaModelDaoItensFactory }

constructor TLojaModelDaoItensFactory.Create;
begin

end;

destructor TLojaModelDaoItensFactory.Destroy;
begin

  inherited;
end;

function TLojaModelDaoItensFactory.Item: ILojaModelDaoItensItem;
begin
  Result := TLojaModelDaoItensItem.New;
end;

class function TLojaModelDaoItensFactory.New: ILojaModelDaoItensItemFactory;
begin
  Result := Self.Create;
end;

end.
