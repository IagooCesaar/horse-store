unit Loja.Model.Dao.Preco.Factory.InMemory;

interface

uses
  System.SysUtils,
  Loja.Model.Dao.Preco.Interfaces;

type
  TLojaModelDaoPrecoFactoryInMemory = class(TNoRefCountObject, ILojaModelDaoPrecoFactory)
  private
    class var FFactory: TLojaModelDaoPrecoFactoryInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoPrecoFactory;
    class destructor UnInitialize;

    { ILojaModelDaoPrecoFactory }
    function Venda: ILojaModelDaoPrecoVenda;
  end;

implementation

uses
  Loja.Model.Dao.Preco.Venda.InMemory;

{ TLojaModelDaoPrecoFactoryInMemory }

constructor TLojaModelDaoPrecoFactoryInMemory.Create;
begin

end;

destructor TLojaModelDaoPrecoFactoryInMemory.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoPrecoFactoryInMemory.GetInstance: ILojaModelDaoPrecoFactory;
begin
  if FFactory = nil
  then FFactory := TLojaModelDaoPrecoFactoryInMemory.Create;
  Result := FFactory;
end;

class destructor TLojaModelDaoPrecoFactoryInMemory.UnInitialize;
begin
  if FFactory <> nil
  then FreeAndNil(FFactory);
end;

function TLojaModelDaoPrecoFactoryInMemory.Venda: ILojaModelDaoPrecoVenda;
begin
  Result := TLojaModelDaoPrecoVendaInMemory.GetInstance;
end;

end.
