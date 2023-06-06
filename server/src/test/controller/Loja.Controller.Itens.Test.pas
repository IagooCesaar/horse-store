unit Loja.Controller.Itens.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils;

type
  [TestFixture]
  TLojaControllerItensTest = class
  private
    FBaseURL, FUsarname, FPassword: String;
  public
    [SetupFixture]
    procedure SetupFixture;

    [Test]
    procedure Test_ObterUmItem;

    [Test]
    [TestCase('Nome contenha "Teste"','nom_item,contains,Teste')]
    [TestCase('Nome inicie com "Novo"','nom_item,startsWith,Novo')]
    [TestCase('Nome finalize com "Integração"','nom_item,endsWith,Integração')]
    procedure Test_ObterVariosItens_PorNome(AParametro, ATipoFiltro, AValor: String);

    [Test]
    procedure Test_ObterVariosItens_PorNumCodBarr;


    //procedure Test2(const AValue1 : Integer;const AValue2 : Integer);


    [Test]
    procedure Test_NaoObtemItens;

    [Test]
    procedure Test_CriarNovoItem;
  end;

implementation

uses
  RESTRequest4D,
  Horse,
  Horse.JsonInterceptor.Helpers,

  Loja.Controller.Api.Test,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem;

{ TLojaControllerItensTest }

procedure TLojaControllerItensTest.SetupFixture;
begin
  FBaseURL := TLojaControllerApiTest.GetInstance.BaseURL;
  FUsarname := TLojaControllerApiTest.GetInstance.UserName;
  FPassword := TLojaControllerApiTest.GetInstance.Password;
end;

procedure TLojaControllerItensTest.Test_CriarNovoItem;
var LNovoItem : TLojaModelDtoReqItensCriarItem;
begin
  try
    LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
    LNovoItem.NomItem := 'Novo Item Cadastrado Via Teste Integração';
    LNovoItem.NumCodBarr := '0123456789';

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/itens')
      .AddBody(TJson.ObjectToClearJsonString(LNovoItem))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);
  finally
    FreeAndNil(LNovoItem);
  end;
end;

procedure TLojaControllerItensTest.Test_NaoObtemItens;
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/itens')
    .AddParam('nom_item[contains]', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
    .Get();

  Assert.AreEqual(204, LResponse.StatusCode);
end;

procedure TLojaControllerItensTest.Test_ObterUmItem;
var LItem : TLojaModelEntityItensItem;
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
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

procedure TLojaControllerItensTest.Test_ObterVariosItens_PorNome(AParametro, ATipoFiltro, AValor: String);
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/itens')
    .AddParam(Format('%s[%s]',[AParametro, ATipoFiltro]), AValor)
    .Get();

  Assert.AreEqual(200, LResponse.StatusCode);

  var LItens := TJson.ClearJsonAndConvertToObject<TLojaModelEntityItensItemLista>
    (LResponse.Content);
  Assert.IsTrue(LItens.Count>0);

  FreeAndNil(LItens);
end;

procedure TLojaControllerItensTest.Test_ObterVariosItens_PorNumCodBarr;
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/itens')
    .AddParam('num_cod_barr[contains]', '123')
    .Get();

  Assert.AreEqual(200, LResponse.StatusCode);

  var LItens := TJson.ClearJsonAndConvertToObject<TLojaModelEntityItensItemLista>
    (LResponse.Content);
  Assert.IsTrue(LItens.Count>0);
  FreeAndNil(LItens);
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerItensTest);

end.
