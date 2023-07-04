unit Loja.Model.Dao.Venda.MeioPagto.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Venda.Interfaces,
  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Venda.MeioPagto;

type
  TLojaModelDaoVendaMeioPagtoInMemory = class(TNoRefCountObject, ILojaModelDaoVendaMeioPagto)
  private
    FRepository: TLojaModelEntityVendaMeioPagtoLista;
    function Clone(ASource: TLojaModelEntityVendaMeioPagto): TLojaModelEntityVendaMeioPagto;

    class var FDao: TLojaModelDaoVendaMeioPagtoInMemory;
  public
    constructor Create;
    destructor Destroy; override;
    class function GetInstance: ILojaModelDaoVendaMeioPagto;
    class destructor UnInitialize;

    { ILojaModelDaoVendaMeioPagto }

  end;

implementation

{ TLojaModelDaoVendaMeioPagtoInMemory }


function TLojaModelDaoVendaMeioPagtoInMemory.Clone(
  ASource: TLojaModelEntityVendaMeioPagto): TLojaModelEntityVendaMeioPagto;
begin

end;

constructor TLojaModelDaoVendaMeioPagtoInMemory.Create;
begin
  FRepository := TLojaModelEntityVendaMeioPagtoLista.Create;
end;

destructor TLojaModelDaoVendaMeioPagtoInMemory.Destroy;
begin
  if FRepository <> nil
  then FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoVendaMeioPagtoInMemory.GetInstance: ILojaModelDaoVendaMeioPagto;
begin
  if FDao = nil
  then FDao := TLojaModelDaoVendaMeioPagtoInMemory.Create;
  Result := FDao;
end;

class destructor TLojaModelDaoVendaMeioPagtoInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNil(FDao);
end;

end.
