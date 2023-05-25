unit Loja.Model.Dao.Factory;

interface

uses
  System.Classes,
  System.SysUtils,
  Loja.Model.Dao.Interfaces,
  Loja.Model.Dao.Itens.Interfaces;

type
  TLojaModelDaoFactory = class(TNoRefCountObject, ILojaModelDaoFactory)
  private
    FInMemory: Boolean;
    class var FFactory: TLojaModelDaoFactory;
  public
    constructor Create(AInMemory: Boolean);
	  destructor Destroy; override;
	  class function New(AInMemory: Boolean = false): ILojaModelDaoFactory;
    class destructor UnInitialize;

    { ILojaModelDaoFactory }
    function Itens: ILojaModelDaoItensItemFactory;
  end;


implementation

uses
  Loja.Model.Dao.Itens.Factory,
  Loja.Model.Dao.Itens.Factory.InMemory;

{ TLojaModelDaoFactory }

constructor TLojaModelDaoFactory.Create(AInMemory: Boolean);
begin
  FInMemory := AInMemory;
end;

destructor TLojaModelDaoFactory.Destroy;
begin

  inherited;
end;

function TLojaModelDaoFactory.Itens: ILojaModelDaoItensItemFactory;
begin
  if not FInMemory
  then Result := TLojaModelDaoItensFactory.New
  else Result := TLojaModelDaoItensFactoryInMemory.GetInstance;
end;

class function TLojaModelDaoFactory.New(AInMemory: Boolean): ILojaModelDaoFactory;
begin
  if not Assigned(FFactory)
  then FFactory := TLojaModelDaoFactory.Create(AInMemory);
  Result := FFactory;
end;

class destructor TLojaModelDaoFactory.UnInitialize;
begin
  if Assigned(FFactory)
  then FreeAndNil(FFactory);
end;

end.
