unit Loja.Controller.Caixa.Test;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TLojaControllerCaixaTest = class
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

  Loja.Controller.Api.Test;

{ TLojaControllerCaixaTest }

procedure TLojaControllerCaixaTest.SetupFixture;
begin
  FBaseURL := TLojaControllerApiTest.GetInstance.BaseURL;
  FUsarname := TLojaControllerApiTest.GetInstance.UserName;
  FPassword := TLojaControllerApiTest.GetInstance.Password;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerCaixaTest);

end.
