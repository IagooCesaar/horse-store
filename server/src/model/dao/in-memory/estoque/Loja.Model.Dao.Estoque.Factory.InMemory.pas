unit Loja.Model.Dao.Estoque.Factory.InMemory;

interface

uses
  System.Classes,
  System.SysUtils,
  Loja.Model.Dao.Estoque.Interfaces;

type
  TLojaModelDaoEstoqueFactoryInMemory = class(TNoRefCountObject, ILojaModelDaoEstoqueFactory)
  private
    class var FFactory: TLojaModelDaoEstoqueFactoryInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoEstoqueFactory;
    class destructor UnInitialize;

    { ILojaModelDaoEstoqueFactory }
    function Movimento: ILojaModelDaoEstoqueMovimento;
    function Saldo: ILojaModelDaoEstoqueSaldo;

  end;

implementation

uses
  Loja.Model.Dao.Estoque.Movimento.InMemory,
  Loja.Model.Dao.Estoque.Saldo.InMemory;

{ TLojaModelDalEstoqueFactoryInMemory }

constructor TLojaModelDaoEstoqueFactoryInMemory.Create;
begin

end;

destructor TLojaModelDaoEstoqueFactoryInMemory.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoEstoqueFactoryInMemory.GetInstance: ILojaModelDaoEstoqueFactory;
begin
  if not Assigned(FFactory)
  then FFactory := Self.Create;

  Result := FFactory;
end;

function TLojaModelDaoEstoqueFactoryInMemory.Movimento: ILojaModelDaoEstoqueMovimento;
begin
  Result := TLojaModelDaoEstoqueMovimentoInMemory.GetInstance;
end;

function TLojaModelDaoEstoqueFactoryInMemory.Saldo: ILojaModelDaoEstoqueSaldo;
begin
  Result := TLojaModelDaoEstoqueSaldoInMemory.GetInstance;
end;

class destructor TLojaModelDaoEstoqueFactoryInMemory.UnInitialize;
begin
  if Assigned(FFactory)
  then FreeAndNil(FFactory);
end;
end.
