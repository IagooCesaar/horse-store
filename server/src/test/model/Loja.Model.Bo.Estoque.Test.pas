unit Loja.Model.Bo.Estoque.Test;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TLojaModelBoEstoqueTest = class
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;
  end;

implementation

uses
  Loja.Model.Dao.Factory,
  Loja.Model.Bo.Factory;

{ TLojaModelBoEstoqueTest }

procedure TLojaModelBoEstoqueTest.SetupFixture;
begin
  TLojaModelDaoFactory.InMemory := True;
end;

procedure TLojaModelBoEstoqueTest.TearDownFixture;
begin
  TLojaModelDaoFactory.InMemory := False;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelBoEstoqueTest);

end.
