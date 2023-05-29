unit Loja.Model.Dao.Itens.Factory;

interface

uses
  Loja.Model.Dao.Itens.Interfaces;

type
  TLojaModelDaoItensFactory = class(TInterfacedObject, ILojaModelDaoItensFactory)
  private
  public
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelDaoItensFactory;

    { ILojaModelDaoItensFactory }
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

class function TLojaModelDaoItensFactory.New: ILojaModelDaoItensFactory;
begin
  Result := Self.Create;
end;

end.
