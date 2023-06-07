unit Loja.Controller.Infra.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils;

type
  [TestFixture]
  TLojaControllerInfraTest = class
  private
    FBaseURL, FUsarname, FPassword: String;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure Test_HealthCheck;
  public
  end;

implementation

uses
  RESTRequest4D,
  Horse,
  Horse.JsonInterceptor.Helpers,

  Loja.Controller.Api.Test;

{ TLojaControllerInfraTest }

procedure TLojaControllerInfraTest.SetupFixture;
begin
  FBaseURL := TLojaControllerApiTest.GetInstance.BaseURL;
  FUsarname := TLojaControllerApiTest.GetInstance.UserName;
  FPassword := TLojaControllerApiTest.GetInstance.Password;
end;

procedure TLojaControllerInfraTest.TearDownFixture;
begin

end;

procedure TLojaControllerInfraTest.Test_HealthCheck;
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/healthcheck')
    .Get();

  Assert.AreEqual(200, LResponse.StatusCode);
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerInfraTest);

end.
