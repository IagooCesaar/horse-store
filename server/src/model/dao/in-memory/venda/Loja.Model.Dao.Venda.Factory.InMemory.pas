unit Loja.Model.Dao.Venda.Factory.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Venda.Interfaces;

type
  TLojaModelDaoVendaFactoryInMemory = class(TNoRefCountObject, ILojaModelDaoVendaFactory)
  private
    class var FFactory: TLojaModelDaoVendaFactoryInMemory;
  public
    destructor Destroy; override;
    class function GetInstance: ILojaModelDaoVendaFactory;
    class destructor UnInitialize; // FreeAndNil(FFactory);

    { ILojaModelDaoVendaFactory }
    function Venda: ILojaModelDaoVendaVenda;
    function Item: ILojaModelDaoVendaItem;
    function MeioPagto: ILojaModelDaoVendaMeioPagto;

  end;

implementation

uses
  Loja.Model.Dao.Venda.Venda.InMemory,
  Loja.Model.Dao.Venda.Item.InMemory,
  Loja.Model.Dao.Venda.MeioPagto.InMemory;

{ TLojaModelDaoVendaFactoryInMemory }

destructor TLojaModelDaoVendaFactoryInMemory.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoVendaFactoryInMemory.GetInstance: ILojaModelDaoVendaFactory;
begin
  if FFactory = nil
  then FFactory := TLojaModelDaoVendaFactoryInMemory.Create;
  Result := FFactory;
end;

function TLojaModelDaoVendaFactoryInMemory.Item: ILojaModelDaoVendaItem;
begin
  Result := TLojaModelDaoVendaItemInMemory.GetInstance;
end;

function TLojaModelDaoVendaFactoryInMemory.MeioPagto: ILojaModelDaoVendaMeioPagto;
begin
  Result := TLojaModelDaoVendaMeioPagtoInMemory.GetInstance;
end;

class destructor TLojaModelDaoVendaFactoryInMemory.UnInitialize;
begin
  if FFactory <> nil
  then FreeAndNil(FFactory);
end;

function TLojaModelDaoVendaFactoryInMemory.Venda: ILojaModelDaoVendaVenda;
begin
  Result := TLojaModelDaoVendaVendaInMemory.GetInstance;
end;

end.
