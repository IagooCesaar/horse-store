unit Loja.Controller.Estoque.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,

  Loja.Model.Dto.Resp.Itens.Item;

type
  [TestFixture]
  TLojaControllerEstoqueTest = class
  private
    FBaseURL, FUsarname, FPassword: String;

    function CriarItem: TLojaModelDtoRespItensItem;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure Test_CriarAcertoEstoque;

    [Test]
    procedure Test_NaoCriarAcertoEstoque_BodyVazio;

    [Test]
    procedure Test_ObterHistoricoMovimento;

    [Test]
    procedure Test_ObterHistoricoMovimento_Vazio;

    [Test]
    procedure Test_ObterFechamentosSaldo;

    [Test]
    procedure Test_ObterFechamentosSaldo_Vazio;

    [Test]
    procedure Test_ObterSaldoAtual;


  end;

implementation

uses
  RESTRequest4D,
  Horse,
  Horse.JsonInterceptor.Helpers,

  System.DateUtils,

  Loja.Controller.Api.Test,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Estoque.AcertoEstoque,
  Loja.Model.Dto.Resp.Estoque.SaldoItem;

{ TLojaControllerEstoqueTest }

function TLojaControllerEstoqueTest.CriarItem: TLojaModelDtoRespItensItem;
var LNovoItem : TLojaModelDtoReqItensCriarItem;
begin
  try
    LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
    LNovoItem.NomItem := 'Novo Item Cadastrado Via Teste Integração';
    LNovoItem.NumCodBarr := '';

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

procedure TLojaControllerEstoqueTest.SetupFixture;
begin
  FBaseURL := TLojaControllerApiTest.GetInstance.BaseURL;
  FUsarname := TLojaControllerApiTest.GetInstance.UserName;
  FPassword := TLojaControllerApiTest.GetInstance.Password;
end;

procedure TLojaControllerEstoqueTest.TearDownFixture;
begin

end;

procedure TLojaControllerEstoqueTest.Test_CriarAcertoEstoque;
begin
  var LItem := CriarItem;
  var LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  LAcerto.CodItem := LItem.CodItem;
  LACerto.QtdSaldoReal := 1;
  LAcerto.DscMot := 'Implantação Teste';

  var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/estoque/{cod_item}/acerto-de-estoque')
      .AddUrlSegment('cod_item', LItem.CodItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LAcerto))
      .Post();

  Assert.AreEqual(201, LResponse.StatusCode);

  LAcerto.Free;
  LItem.Free;
end;

procedure TLojaControllerEstoqueTest.Test_NaoCriarAcertoEstoque_BodyVazio;
begin
  var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/estoque/{cod_item}/acerto-de-estoque')
      .AddUrlSegment('cod_item', '1')
      .AddBody('')
      .Post();

  Assert.AreEqual(400, LResponse.StatusCode);
end;

procedure TLojaControllerEstoqueTest.Test_ObterFechamentosSaldo;
begin
  var LItem := CriarItem;
  var LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  LAcerto.CodItem := LItem.CodItem;
  LACerto.QtdSaldoReal := 1;
  LAcerto.DscMot := 'Implantação Teste';

  var LResponseAcerto := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/estoque/{cod_item}/acerto-de-estoque')
      .AddUrlSegment('cod_item', LItem.CodItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LAcerto))
      .Post();

  Assert.AreEqual(201, LResponseAcerto.StatusCode);

  var LDatIni := StartOfTheMonth(IncMonth(Now, -1));
  var LDatFim := EndOfTheMonth(Now);

  var LResponse:= TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/estoque/{cod_item}/fechamentos-saldo')
      .AddUrlSegment('cod_item', LItem.CodItem.ToString)
      .AddParam('dat_ini', FormatDateTime('yyyy-mm-dd', LDatIni))
      .AddParam('dat_fim', FormatDateTime('yyyy-mm-dd', LDatFim))
      .Get();

  Assert.AreEqual(200, LResponse.StatusCode);

  LAcerto.Free;
  LItem.Free;
end;

procedure TLojaControllerEstoqueTest.Test_ObterFechamentosSaldo_Vazio;
begin
  var LItem := CriarItem;

  var LDatIni := StartOfTheMonth(IncMonth(Now, -1));
  var LDatFim := EndOfTheMonth(Now);

  var LResponse:= TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/estoque/{cod_item}/fechamentos-saldo')
      .AddUrlSegment('cod_item', LItem.CodItem.ToString)
      .AddParam('dat_ini', FormatDateTime('yyyy-mm-dd', LDatIni))
      .AddParam('dat_fim', FormatDateTime('yyyy-mm-dd', LDatFim))
      .Get();

  Assert.AreEqual(204, LResponse.StatusCode);

  LItem.Free;
end;

procedure TLojaControllerEstoqueTest.Test_ObterHistoricoMovimento;
begin
  var LItem := CriarItem;
  var LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  LAcerto.CodItem := LItem.CodItem;
  LACerto.QtdSaldoReal := 1;
  LAcerto.DscMot := 'Implantação Teste';

  var LResponseAcerto := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/estoque/{cod_item}/acerto-de-estoque')
      .AddUrlSegment('cod_item', LItem.CodItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LAcerto))
      .Post();

  Assert.AreEqual(201, LResponseAcerto.StatusCode);

  var LResponse:= TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/estoque/{cod_item}/historico-movimento')
      .AddUrlSegment('cod_item', LItem.CodItem.ToString)
      .AddParam('dat_ini', FormatDateTime('yyyy-mm-dd', Now))
      .AddParam('dat_fim', FormatDateTime('yyyy-mm-dd', Now))
      .Get();

  Assert.AreEqual(200, LResponse.StatusCode);

  LAcerto.Free;
  LItem.Free;
end;

procedure TLojaControllerEstoqueTest.Test_ObterHistoricoMovimento_Vazio;
begin
  var LItem := CriarItem;

  var LResponse:= TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/estoque/{cod_item}/historico-movimento')
      .AddUrlSegment('cod_item', LItem.CodItem.ToString)
      .AddParam('dat_ini', FormatDateTime('yyyy-mm-dd', Now))
      .AddParam('dat_fim', FormatDateTime('yyyy-mm-dd', Now))
      .Get();

  Assert.AreEqual(204, LResponse.StatusCode);

  LItem.Free;
end;

procedure TLojaControllerEstoqueTest.Test_ObterSaldoAtual;
begin
  var LItem := CriarItem;
  var LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  LAcerto.CodItem := LItem.CodItem;
  LACerto.QtdSaldoReal := 1;
  LAcerto.DscMot := 'Implantação Teste';

  var LResponseAcerto := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/estoque/{cod_item}/acerto-de-estoque')
      .AddUrlSegment('cod_item', LItem.CodItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LAcerto))
      .Post();

  Assert.AreEqual(201, LResponseAcerto.StatusCode);

  var LResponse:= TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/estoque/{cod_item}/saldo-atual')
      .AddUrlSegment('cod_item', LItem.CodItem.ToString)
      .Get();

  Assert.AreEqual(200, LResponse.StatusCode);

  var LSaldo := TJson.ClearJsonAndConvertToObject<TLojaModelDtoRespEstoqueSaldoItem>
    (LResponse.Content);

  Assert.AreEqual(1, LSaldo.QtdSaldoAtu);

  LAcerto.Free;
  LItem.Free;
  LSaldo.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerEstoqueTest);

end.
