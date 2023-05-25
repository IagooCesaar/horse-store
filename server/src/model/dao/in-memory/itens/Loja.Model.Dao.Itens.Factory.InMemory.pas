unit Loja.Model.Dao.Itens.Factory.InMemory;

interface

uses
  System.Classes,
  System.SysUtils,
  Loja.Model.Dao.Itens.Interfaces;

type
  TLojaModelDaoItensFactoryInMemory = class(TNoRefCountObject, ILojaModelDaoItensItemFactory)
  private
    class var FFactory: TLojaModelDaoItensFactoryInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoItensItemFactory;
    class destructor UnInitialize;

    { ILojaModelDaoItensItemFactory }
    function Item: ILojaModelDaoItensItem;
  end;

implementation

uses
  Loja.Model.Dao.Itens.Item.InMemory;

{ TLojaModelDaoItensFactory }

constructor TLojaModelDaoItensFactoryInMemory.Create;
begin

end;

destructor TLojaModelDaoItensFactoryInMemory.Destroy;
begin

  inherited;
end;

function TLojaModelDaoItensFactoryInMemory.Item: ILojaModelDaoItensItem;
begin
  Result := TLojaModelDaoItensItemInMemory.GetInstance;
end;

class destructor TLojaModelDaoItensFactoryInMemory.UnInitialize;
begin
  if Assigned(FFactory)
  then FreeAndNil(FFactory);
end;

class function TLojaModelDaoItensFactoryInMemory.GetInstance: ILojaModelDaoItensItemFactory;
begin
  if not Assigned(FFactory)
  then FFactory := Self.Create;

  Result := FFactory;
end;

end.
