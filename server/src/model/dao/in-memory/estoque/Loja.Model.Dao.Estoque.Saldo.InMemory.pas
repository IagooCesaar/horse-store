unit Loja.Model.Dao.Estoque.Saldo.InMemory;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,

  Loja.Model.Dao.Estoque.Interfaces,
  Loja.Model.Entity.Estoque.Saldo;

type
  TLojaModelDaoEstoqueSaldoInMemory = class(TNoRefCountObject, ILojaModelDaoEstoqueSaldo)
  private
    FRepository: TLojaModelEntityEstoqueSaldoLista;
    function Clone(ASource: TLojaModelEntityEstoqueSaldo): TLojaModelEntityEstoqueSaldo;

    class var FDao: TLojaModelDaoEstoqueSaldoInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoEstoqueSaldo;
    class destructor UnInitialize;

    { ILojaModelDaoEstoqueSaldo }

  end;

implementation

{ TLojaModelDaoEstoqueMovimentoInMemory }

function TLojaModelDaoEstoqueSaldoInMemory.Clone(
  ASource: TLojaModelEntityEstoqueSaldo): TLojaModelEntityEstoqueSaldo;
begin
  Result := TLojaModelEntityEstoqueSaldo.Create;
  Result.CodFechSaldo := ASource.CodFechSaldo;
  Result.CodItem := ASource.CodItem;
  Result.DatSaldo := ASource.DatSaldo;
end;

constructor TLojaModelDaoEstoqueSaldoInMemory.Create;
begin
  FRepository := TLojaModelEntityEstoqueSaldoLista.Create;
end;

destructor TLojaModelDaoEstoqueSaldoInMemory.Destroy;
begin
  FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoEstoqueSaldoInMemory.GetInstance: ILojaModelDaoEstoqueSaldo;
begin
  if not Assigned(FDao)
  then FDao := Self.Create;
  Result := FDao;
end;


class destructor TLojaModelDaoEstoqueSaldoInMemory.UnInitialize;
begin
  if Assigned(FDao)
  then FreeAndNil(FDao);
end;

end.
