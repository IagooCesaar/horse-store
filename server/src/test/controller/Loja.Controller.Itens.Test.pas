unit Loja.Controller.Itens.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,

  Loja.Model.Dto.Resp.Itens.Item;

type
  [TestFixture]
  TLojaControllerItensTest = class
  private
    FBaseURL, FUsarname, FPassword: String;
    function CriarItem(ANome, ACodBarr: string): TLojaModelDtoRespItensItem;
  public
    [SetupFixture]
    procedure SetupFixture;

    [Test]
    procedure Test_ObterUmItem_PorCodigo;

    [Test]
    procedure Test_NaoObterUmItem_CodigoNegativo;

    [Test]
    procedure Test_ObterUmItem_PorCodigoDeBarras;

    [Test]
    [TestCase('Nome contenha "Teste"', 'nom_item,contains,Teste')]
    [TestCase('Nome Igual a "Novo Item Cadastrado Via Teste Integração" (default)', 'nom_item,eq,Novo Item Cadastrado Via Teste Integração')]
    [TestCase('Nome inicie com "Novo"', 'nom_item,startsWith,Novo')]
    [TestCase('Nome finalize com "Integração"', 'nom_item,endsWith,Integração')]
    [TestCase('Código de Barras contenha com "456"', 'num_cod_barr,contains,456')]
    [TestCase('Código de Barras igual a "0123456789"  (default)', 'num_cod_barr,eq,0123456789')]
    [TestCase('Código de Barras inicie com "0123"', 'num_cod_barr,startsWith,0123')]
    [TestCase('Código de Barras finalize com "789"', 'num_cod_barr,endsWith,789')]
    procedure Test_ObterVariosItens(AParametro, ATipoFiltro, AValor: String);

    [Test]
    procedure Test_NaoObtemItens;

    [Test]
    procedure Test_CriarNovoItem;

    [Test]
    procedure Test_NaoCriarNovoItem_BodyVazio;

    [Test]
    procedure Test_AtualizarNovoItem;

    [Test]
    procedure Test_NaoAtualizarNovoItem_BodyVazio;

    [Test]
    procedure Test_NaoAtualizarNovoItem_CodigoNegativo;

  end;

implementation

uses
  RESTRequest4D,
  Horse,
  Horse.JsonInterceptor.Helpers,

  Loja.Controller.Api.Test,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.infra.Utils.Funcoes;

{ TLojaControllerItensTest }

function TLojaControllerItensTest.CriarItem(ANome, ACodBarr: string): TLojaModelDtoRespItensItem;
var LNovoItem : TLojaModelDtoReqItensCriarItem;
begin
  try
    LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
    LNovoItem.NomItem := ANome;
    LNovoItem.NumCodBarr := ACodBarr;

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/itens')
      .AddBody(TJson.ObjectToClearJsonString(LNovoItem))
      .Post();

    Result := TJson.ClearJsonAndConvertToObject<TLojaModelDtoRespItensItem>
      (LResponse.Content);
  finally
    FreeAndNil(LNovoItem);
  end;
end;

procedure TLojaControllerItensTest.SetupFixture;
begin
  FBaseURL := TLojaControllerApiTest.GetInstance.BaseURL;
  FUsarname := TLojaControllerApiTest.GetInstance.UserName;
  FPassword := TLojaControllerApiTest.GetInstance.Password;

  CriarItem('Teste', '0123456789').Free;
  CriarItem('Novo Item Cadastrado Via Teste Integração', '').Free;
end;

procedure TLojaControllerItensTest.Test_AtualizarNovoItem;
var LDTO : TLojaModelDtoReqItensCriarItem;
begin
  try
    LDTO := TLojaModelDtoReqItensCriarItem.Create;
    LDTO.NomItem := 'Novo Item Cadastrado Via Teste Integração';
    LDTO.NumCodBarr := TLojaInfraUtilsFuncoes.GeraStringRandomica(14,1);

    var LResponseCriar := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/itens')
      .AddBody(TJson.ObjectToClearJsonString(LDTO))
      .Post();

    Assert.AreEqual(201, LResponseCriar.StatusCode);

    var LItemCriado := TJson.ClearJsonAndConvertToObject<TLojaModelDtoRespItensItem>
      (LResponseCriar.Content);

    Assert.AreEqual(LDTO.NomItem, LItemCriado.NomItem);
    Assert.AreEqual(LDTO.NumCodBarr, LItemCriado.NumCodBarr);

    LDTO.NomItem := 'Nome atualizado';
    LDTO.NumCodBarr := TLojaInfraUtilsFuncoes.GeraStringRandomica(14,1);
    LDTO.FlgPermSaldNeg := not LItemCriado.FlgPermSaldNeg;
    LDTO.FlgTabPreco := not LItemCriado.FlgTabPreco;

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/itens/{cod_item}')
      .AddUrlSegment('cod_item', LItemCriado.CodItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDTO))
      .Put();

    Assert.AreEqual(200, LResponse.StatusCode);

    var LItemAtualizado := TJson.ClearJsonAndConvertToObject<TLojaModelDtoRespItensItem>
      (LResponse.Content);

    Assert.AreEqual(LDTO.NomItem, LItemAtualizado.NomItem);
    Assert.AreEqual(LDTO.NumCodBarr, LItemAtualizado.NumCodBarr);
    Assert.IsTrue(LItemAtualizado.FlgPermSaldNeg);
    Assert.IsFalse(LItemAtualizado.FlgTabPreco);

    LItemCriado.Free;
    LItemAtualizado.Free;
  finally
    FreeAndNil(LDTO);
  end;
end;

procedure TLojaControllerItensTest.Test_CriarNovoItem;
var LNovoItem : TLojaModelDtoReqItensCriarItem;
begin
  try
    LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
    LNovoItem.NomItem := 'Novo Item Cadastrado Via Teste Integração';
    LNovoItem.NumCodBarr := TLojaInfraUtilsFuncoes.GeraStringRandomica(14,1);

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/itens')
      .AddBody(TJson.ObjectToClearJsonString(LNovoItem))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode);

    var LItem := TJson.ClearJsonAndConvertToObject<TLojaModelDtoRespItensItem>
      (LResponse.Content);
    Assert.AreEqual(LNovoItem.NomItem, LItem.NomItem);
    Assert.AreEqual(LNovoItem.NumCodBarr, LItem.NumCodBarr);
    Assert.IsFalse(LItem.FlgPermSaldNeg);
    Assert.IsTrue(LItem.FlgTabPreco);
    LItem.Free;
  finally
    FreeAndNil(LNovoItem);
  end;
end;

procedure TLojaControllerItensTest.Test_NaoAtualizarNovoItem_BodyVazio;
var LDTO : TLojaModelDtoReqItensCriarItem;
begin
  try
    LDTO := TLojaModelDtoReqItensCriarItem.Create;
    LDTO.NomItem := 'Novo Item Cadastrado Via Teste Integração';
    LDTO.NumCodBarr := '';

    var LResponseCriar := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/itens')
      .AddBody(TJson.ObjectToClearJsonString(LDTO))
      .Post();

    Assert.AreEqual(201, LResponseCriar.StatusCode);

    var LItemCriado := TJson.ClearJsonAndConvertToObject<TLojaModelDtoRespItensItem>
      (LResponseCriar.Content);

    Assert.AreEqual(LDTO.NomItem, LItemCriado.NomItem);
    Assert.AreEqual(LDTO.NumCodBarr, LItemCriado.NumCodBarr);


    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/itens/{cod_item}')
      .AddUrlSegment('cod_item', LItemCriado.CodItem.ToString)
      .AddBody('')
      .Put();

    Assert.AreEqual(400, LResponse.StatusCode);

    LItemCriado.Free;
  finally
    FreeAndNil(LDTO);
  end;
end;

procedure TLojaControllerItensTest.Test_NaoAtualizarNovoItem_CodigoNegativo;
var LDTO : TLojaModelDtoReqItensCriarItem;
begin
  try
    LDTO := TLojaModelDtoReqItensCriarItem.Create;
    LDTO.NomItem := 'Novo Item Cadastrado Via Teste Integração';
    LDTO.NumCodBarr := '';

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/itens/{cod_item}')
      .AddUrlSegment('cod_item', '-1')
      .AddBody(TJson.ObjectToClearJsonString(LDTO))
      .Put();

    Assert.AreEqual(400, LResponse.StatusCode);
  finally
    FreeAndNil(LDTO);
  end;
end;

procedure TLojaControllerItensTest.Test_NaoCriarNovoItem_BodyVazio;
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/itens')
    .AddBody('')
    .Post();

  Assert.AreEqual(400, LResponse.StatusCode);
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

procedure TLojaControllerItensTest.Test_NaoObterUmItem_CodigoNegativo;
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/itens/{cod_item}')
    .AddUrlSegment('cod_item', '-1')
    .Get();

  Assert.AreEqual(400, LResponse.StatusCode);
end;

procedure TLojaControllerItensTest.Test_ObterUmItem_PorCodigo;
begin
  var LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
  LNovoItem.NomItem := 'Novo Item Cadastrado Via Teste Integração';
  LNovoItem.NumCodBarr := '';

  var LResponseCriar := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/itens')
    .AddBody(TJson.ObjectToClearJsonString(LNovoItem))
    .Post();

  Assert.AreEqual(201, LResponseCriar.StatusCode);
  var LItemCriado := TJson.ClearJsonAndConvertToObject<TLojaModelDtoRespItensItem>
    (LResponseCriar.Content);

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/itens/{cod_item}')
    .AddUrlSegment('cod_item', LItemCriado.CodItem.ToString)
    .Get();

  Assert.AreEqual(200, LResponse.StatusCode);

  var LItem := TJson.ClearJsonAndConvertToObject<TLojaModelDtoRespItensItem>
    (LResponse.Content);
  Assert.AreEqual(LItemCriado.CodItem, LItem.CodItem);

  LNovoItem.Free;
  LItemCriado.Free;
  LItem.Free;
end;

procedure TLojaControllerItensTest.Test_ObterUmItem_PorCodigoDeBarras;
var LItem : TLojaModelDtoRespItensItem;
begin
  var LItemCriado := CriarItem(
    'TLojaControllerItensTest.Test_ObterUmItem_PorCodigoDeBarras',
    TLojaInfraUtilsFuncoes.GeraStringRandomica(14,1));

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/itens/codigo-barras/{num_cod_barr}')
    .AddUrlSegment('num_cod_barr', LItemCriado.NumCodBarr)
    .Get();

  Assert.AreEqual(200, LResponse.StatusCode);
  try
    LItem := TJson.ClearJsonAndConvertToObject<TLojaModelDtoRespItensItem>
      (LResponse.Content);
    Assert.AreEqual(LItemCriado.NumCodBarr, LItem.NumCodBarr);
  finally
    if LItem <> nil
    then FreeAndNil(LItem);

    if LItemCriado <> nil
    then FreeAndNil(LItemCriado);
  end;
end;

procedure TLojaControllerItensTest.Test_ObterVariosItens(AParametro, ATipoFiltro, AValor: String);
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/itens')
    .AddParam(Format('%s[%s]',[AParametro, ATipoFiltro]), AValor)
    .Get();

  Assert.AreEqual(200, LResponse.StatusCode, LResponse.StatusText);

  var LItens := TJson.ClearJsonAndConvertToObject<TLojaModelDtoRespItensItemLista>
    (LResponse.Content);
  Assert.IsTrue(LItens.Count>0);

  FreeAndNil(LItens);
end;


initialization
  TDUnitX.RegisterTestFixture(TLojaControllerItensTest);

end.
