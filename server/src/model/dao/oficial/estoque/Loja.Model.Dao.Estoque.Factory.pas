unit Loja.Model.Dao.Estoque.Factory;

interface
uses
  Loja.Model.Dao.Estoque.Interfaces;

type
  TLojaModelDaoEstoqueFactory = class(TInterfacedObject, ILojaModelDaoEstoqueFactory)
  private
  public
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelDaoEstoqueFactory;

    { ILojaModelDaoEstoqueFactory }
    function Movimento: ILojaModelDaoEstoqueMovimento;
    function Saldo: ILojaModelDaoEstoqueSaldo;
  end;

implementation

uses
  Loja.Model.Dao.Estoque.Saldo,
  Loja.Model.Dao.Estoque.Movimento;

{ TLojaModelDaoItensFactory }

constructor TLojaModelDaoEstoqueFactory.Create;
begin

end;

destructor TLojaModelDaoEstoqueFactory.Destroy;
begin

  inherited;
end;

function TLojaModelDaoEstoqueFactory.Movimento: ILojaModelDaoEstoqueMovimento;
begin
  Result := TLojaModelDaoEstoqueMovimento.New;
end;

class function TLojaModelDaoEstoqueFactory.New: ILojaModelDaoEstoqueFactory;
begin
  Result := Self.Create;
end;

function TLojaModelDaoEstoqueFactory.Saldo: ILojaModelDaoEstoqueSaldo;
begin
  Result := TLojaModelDaoEstoqueSaldo.New;
end;

end.
