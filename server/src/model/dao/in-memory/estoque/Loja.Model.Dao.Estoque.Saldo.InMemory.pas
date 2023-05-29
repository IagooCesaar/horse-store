unit Loja.Model.Dao.Estoque.Saldo.InMemory;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,

  Loja.Model.Dao.Estoque.Interfaces,
  Loja.Model.Dto.Req.Estoque.CriarMovimento,
  Loja.Model.Entity.Estoque.Movimento;

type
  TLojaModelDaoEstoqueSaldoInMemory = class(TNoRefCountObject, ILojaModelDaoEstoqueSaldo)
  private
    FRepository: TLojaModelEntityEstoqueMovimentoLista;

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

constructor TLojaModelDaoEstoqueSaldoInMemory.Create;
begin
  FRepository := TLojaModelEntityEstoqueMovimentoLista.Create;
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
