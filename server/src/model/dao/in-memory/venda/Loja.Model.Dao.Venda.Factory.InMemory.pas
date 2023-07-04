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

end;

function TLojaModelDaoVendaFactoryInMemory.MeioPagto: ILojaModelDaoVendaMeioPagto;
begin

end;

class destructor TLojaModelDaoVendaFactoryInMemory.UnInitialize;
begin
  if FFactory <> nil
  then FreeAndNil(FFactory);
end;

function TLojaModelDaoVendaFactoryInMemory.Venda: ILojaModelDaoVendaVenda;
begin

end;

end.
