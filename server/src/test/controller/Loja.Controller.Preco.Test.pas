unit Loja.Controller.Preco.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils;

type
  [TestFixture]
  TLojaControllerPrecoTest = class
  private
    FBaseURL, FUsarname, FPassword: String;
  public
    [SetupFixture]
    procedure SetupFixture;
  public
  end;

implementation

uses
  RESTRequest4D,
  Horse,
  Horse.JsonInterceptor.Helpers,

  Loja.Controller.Api.Test,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.infra.Utils.Funcoes;

{ TLojaControllerPrecoTest }

procedure TLojaControllerPrecoTest.SetupFixture;
begin
  FBaseURL := TLojaControllerApiTest.GetInstance.BaseURL;
  FUsarname := TLojaControllerApiTest.GetInstance.UserName;
  FPassword := TLojaControllerApiTest.GetInstance.Password;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerPrecoTest);

end.
