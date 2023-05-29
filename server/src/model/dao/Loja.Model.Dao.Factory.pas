unit Loja.Model.Dao.Factory;

interface

uses
  System.Classes,
  System.SysUtils,
  Loja.Model.Dao.Interfaces,
  Loja.Model.Dao.Itens.Interfaces,
  Loja.Model.Dao.Estoque.Interfaces;

type
  TLojaModelDaoFactory = class(TNoRefCountObject, ILojaModelDaoFactory)
  private
    class var FFactory: TLojaModelDaoFactory;
  public
    constructor Create;
	  destructor Destroy; override;

    class var InMemory: Boolean;
	  class function New: ILojaModelDaoFactory;
    class destructor UnInitialize;

    { ILojaModelDaoFactory }
    function Itens: ILojaModelDaoItensItemFactory;
    function Estoque: ILojaModelDaoEstoqueFactory;
  end;


implementation

uses
  Loja.Model.Dao.Itens.Factory,
  Loja.Model.Dao.Itens.Factory.InMemory;

{ TLojaModelDaoFactory }

constructor TLojaModelDaoFactory.Create;
begin

end;

destructor TLojaModelDaoFactory.Destroy;
begin

  inherited;
end;

function TLojaModelDaoFactory.Estoque: ILojaModelDaoEstoqueFactory;
begin

end;

function TLojaModelDaoFactory.Itens: ILojaModelDaoItensItemFactory;
begin
  if not InMemory
  then Result := TLojaModelDaoItensFactory.New
  else Result := TLojaModelDaoItensFactoryInMemory.GetInstance;
end;

class function TLojaModelDaoFactory.New: ILojaModelDaoFactory;
begin
  if not Assigned(FFactory)
  then FFactory := TLojaModelDaoFactory.Create;

  Result := FFactory;
end;

class destructor TLojaModelDaoFactory.UnInitialize;
begin
  if Assigned(FFactory)
  then FreeAndNil(FFactory);
end;

initialization
  TLojaModelDaoFactory.InMemory := False;

end.


