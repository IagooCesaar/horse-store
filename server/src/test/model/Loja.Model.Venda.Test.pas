unit Loja.Model.Venda.Test;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TLojaModelVendaTest = class
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
  System.DateUtils,

  Loja.Model.Factory,
  Loja.Model.Dao.Factory;

{ TLojaModelVendaTest }

procedure TLojaModelVendaTest.SetupFixture;
begin
  TLojaModelDaoFactory.InMemory := True;
end;

procedure TLojaModelVendaTest.TearDownFixture;
begin
  TLojaModelDaoFactory.InMemory := False;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelVendaTest);

end.
