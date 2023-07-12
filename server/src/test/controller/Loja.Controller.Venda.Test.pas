unit Loja.Controller.Venda.Test;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TLojaControllerVendaTest = class
  private
    FBaseURL, FUsarname, FPassword: String;
  public
    [SetupFixture]
    procedure SetupFixture;
  end;

implementation

uses
  RESTRequest4D,
  Horse,
  Horse.JsonInterceptor.Helpers,

  System.DateUtils,

  Loja.Controller.Api.Test;

{ TLojaControllerVendaTest }

procedure TLojaControllerVendaTest.SetupFixture;
begin
  FBaseURL := TLojaControllerApiTest.GetInstance.BaseURL;
  FUsarname := TLojaControllerApiTest.GetInstance.UserName;
  FPassword := TLojaControllerApiTest.GetInstance.Password;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerVendaTest);

end.
