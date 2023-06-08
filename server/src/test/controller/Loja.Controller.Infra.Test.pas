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

    [Test]
    procedure Test_Swagger;

    [Test]
    procedure Test_Autenticacao;
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

procedure TLojaControllerInfraTest.Test_Autenticacao;
begin
  var LResponseOk := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/validar-logon')
    .Get();

  Assert.AreEqual(200, LResponseOk.StatusCode);

  var LResponseNot := TRequest.New
    .BaseURL(FBaseURL)
    .Resource('/validar-logon')
    .Get();

  Assert.AreEqual(401, LResponseNot.StatusCode);
end;
procedure TLojaControllerInfraTest.Test_HealthCheck;
begin
  var LResponse := TRequest.New
    //.BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/healthcheck')
    .Get();

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TLojaControllerInfraTest.Test_Swagger;
begin
  var LResponse := TRequest.New
    //.BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL.Replace('/api', ''))
    .Resource('/swagger-ui')
    .Get();

  Assert.AreEqual(200, LResponse.StatusCode);
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerInfraTest);

end.
