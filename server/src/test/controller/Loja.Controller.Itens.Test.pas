unit Loja.Controller.Itens.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils;

type
  [TestFixture]
  TLojaControllerItensTest = class
  private
    FBaseURL: String;
  public
    [SetupFixture]
    procedure SetupFixture;

    [Test]
    procedure Test_ObterUmItem;
  end;

implementation

uses
  RESTRequest4D,
  Horse,
  Horse.JsonInterceptor.Helpers,

  Loja.Controller.Api.Test,
  Loja.Model.Entity.Itens.Item;

{ TLojaControllerItensTest }

procedure TLojaControllerItensTest.SetupFixture;
begin
  FBaseURL := TLojaControllerApiTest.GetInstance.BaseURL;
end;

procedure TLojaControllerItensTest.Test_ObterUmItem;
var LItem : TLojaModelEntityItensItem;
begin
  var LResponse := TRequest.New
    .BaseURL(FBaseURL)
    .Resource('/itens/{cod_item}')
    .AddUrlSegment('cod_item', '1')
    .Get();

  Assert.AreEqual(200, LResponse.StatusCode);
  try
    LItem := TJson.ClearJsonAndConvertToObject<TLojaModelEntityItensItem>
      (LResponse.Content);
    Assert.AreEqual(1, LItem.CodItem);
  finally
    if LItem <> nil
    then FreeAndNil(LItem);
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerItensTest);

end.
