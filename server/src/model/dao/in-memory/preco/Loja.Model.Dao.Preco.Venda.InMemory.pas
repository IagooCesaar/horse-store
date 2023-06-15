unit Loja.Model.Dao.Preco.Venda.InMemory;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,

  Loja.Model.Dao.Preco.Interfaces,
  Loja.Model.Entity.Preco.Venda;

type
  TLojaModelDaoPrecoVendaInMemory = class(TNoRefCountObject, ILojaModelDaoPrecoVenda)
  private
    FRepository: TLojaModelEntityPrecoVendaLista;
    function Clone(ASource: TLojaModelEntityPrecoVenda): TLojaModelEntityPrecoVenda;

    class var FDao: TLojaModelDaoPrecoVendaInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoPrecoVenda;
    class destructor UnInitialize;

    { ILojaModelDaoItensItem }
  end;

implementation

{ TLojaModelDaoPrecoVendaInMemory }

function TLojaModelDaoPrecoVendaInMemory.Clone(
  ASource: TLojaModelEntityPrecoVenda): TLojaModelEntityPrecoVenda;
begin
  Result := TLojaModelEntityPrecoVenda.Create;
  Result.CodItem := ASource.CodItem;
  Result.DatIni := ASource.DatIni;
  Result.VrVnda := ASource.VrVnda;
end;

constructor TLojaModelDaoPrecoVendaInMemory.Create;
begin
  FRepository := TLojaModelEntityPrecoVendaLista.Create;
end;

destructor TLojaModelDaoPrecoVendaInMemory.Destroy;
begin
  FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoPrecoVendaInMemory.GetInstance: ILojaModelDaoPrecoVenda;
begin
  if FDao = nil
  then FDao := TLojaModelDaoPrecoVendaInMemory.Create;
  Result := FDao;
end;

class destructor TLojaModelDaoPrecoVendaInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNil(FDao);
end;

end.
