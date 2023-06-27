unit Loja.Model.Caixa.Test;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TLojaModelCaixaTest = class
  public
    [SetupFixture]
    procedure SetupFixture;
    [TearDownFixture]
    procedure TearDownFixture;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Interfaces,
  Loja.Model.Dao.Factory;

{ TLojaModelCaixaTest }

procedure TLojaModelCaixaTest.SetupFixture;
begin
  TLojaModelDaoFactory.InMemory := True;
end;

procedure TLojaModelCaixaTest.TearDownFixture;
begin
  TLojaModelDaoFactory.InMemory := False;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelCaixaTest);

end.
