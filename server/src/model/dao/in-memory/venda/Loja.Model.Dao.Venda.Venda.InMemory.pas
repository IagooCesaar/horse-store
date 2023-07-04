unit Loja.Model.Dao.Venda.Venda.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Venda.Interfaces,
  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Venda.Venda;

type
  TLojaModelDaoVendaVendaInMemory = class(TNoRefCountObject, ILojaModelDaoVendaVenda)
  private
    FRepository: TLojaModelEntityVendaVendaLista;
    function Clone(ASource: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;

    class var FDao: TLojaModelDaoVendaVendaInMemory;
  public
    constructor Create;
    destructor Destroy; override;
    class function GetInstance: ILojaModelDaoVendaVenda;
    class destructor UnInitialize;

    { ILojaModelDaoVendaVenda }

  end;

implementation

{ TLojaModelDaoVendaVendaInMemory }

function TLojaModelDaoVendaVendaInMemory.Clone(
  ASource: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;
begin

end;

constructor TLojaModelDaoVendaVendaInMemory.Create;
begin
  FRepository := TLojaModelEntityVendaVendaLista.Create;
end;

destructor TLojaModelDaoVendaVendaInMemory.Destroy;
begin
  if FRepository <> nil
  then FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoVendaVendaInMemory.GetInstance: ILojaModelDaoVendaVenda;
begin
  if FDao = nil
  then FDao := TLojaModelDaoVendaVendaInMemory.Create;
  Result := FDao;
end;

class destructor TLojaModelDaoVendaVendaInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNil(FDao);
end;

end.
