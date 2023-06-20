unit Loja.Model.Dao.Factory;

interface

uses
  System.Classes,
  System.SysUtils,
  Loja.Model.Dao.Interfaces,
  Loja.Model.Dao.Itens.Interfaces,
  Loja.Model.Dao.Estoque.Interfaces,
  Loja.Model.Dao.Preco.Interfaces,
  Loja.Model.Dao.Caixa.Interfaces;

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
    function Itens: ILojaModelDaoItensFactory;
    function Estoque: ILojaModelDaoEstoqueFactory;
    function Preco: ILojaModelDaoPrecoFactory;
    function Caixa: ILojaModelDaoCaixaFactory;
  end;


implementation

uses
  Loja.Model.Dao.Itens.Factory,
  Loja.Model.Dao.Itens.Factory.InMemory,
  Loja.Model.Dao.Estoque.Factory,
  Loja.Model.Dao.Estoque.Factory.InMemory,
  Loja.Model.Dao.Preco.Factory,
  Loja.Model.Dao.Preco.Factory.InMemory,
  Loja.Model.Dao.Caixa.Factory,
  Loja.Model.Dao.Caixa.Factory.InMemory;

{ TLojaModelDaoFactory }

function TLojaModelDaoFactory.Caixa: ILojaModelDaoCaixaFactory;
begin
  if not InMemory
  then Result := TLojaModelDaoCaixaFactory.New
  else Result := TLojaModelDaoCaixaFactoryInMemory.GetInstance;
end;

constructor TLojaModelDaoFactory.Create;
begin

end;

destructor TLojaModelDaoFactory.Destroy;
begin

  inherited;
end;

function TLojaModelDaoFactory.Estoque: ILojaModelDaoEstoqueFactory;
begin
  if not InMemory
  then Result := TLojaModelDaoEstoqueFactory.New
  else Result := TLojaModelDaoEstoqueFactoryInMemory.GetInstance;
end;

function TLojaModelDaoFactory.Itens: ILojaModelDaoItensFactory;
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

function TLojaModelDaoFactory.Preco: ILojaModelDaoPrecoFactory;
begin
  if not InMemory
  then Result := TLojaModelDaoPrecoFactory.New
  else Result := TLojaModelDaoPrecoFactoryInMemory.GetInstance;
end;

class destructor TLojaModelDaoFactory.UnInitialize;
begin
  if Assigned(FFactory)
  then FreeAndNil(FFactory);
end;

initialization
  TLojaModelDaoFactory.InMemory := False;

end.


