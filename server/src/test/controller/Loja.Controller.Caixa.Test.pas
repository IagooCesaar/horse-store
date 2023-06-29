unit Loja.Controller.Caixa.Test;

interface

uses
  DUnitX.TestFramework,

  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Movimento;

type
  [TestFixture]
  TLojaControllerCaixaTest = class
  private
    FBaseURL, FUsarname, FPassword: String;
  public
    [SetupFixture]
    procedure SetupFixture;

    [Test]
    procedure Test_AberturaDeCaixa;

    //[Test]
    procedure Test_NaoAbrirCaixa_ValorNegativo;

    //[Test]
    procedure Test_NaoAbrirCaixa_ExiteCaixaAberto;

    //[Test]
    procedure Test_AberturaDeCaixa_NovaAbertura_ComSangria;

    //[Test]
    procedure Test_AberturaDeCaixa_NovaAbertura_ComReforco;

    //[Test]
    procedure Test_CriarMovimento_ReforcoCaixa;

    //[Test]
    procedure Test_CriarMovimento_SangriaCaixa;

    //[Test]
    procedure Test_CriarMovimento_SangriaCaixa_Total;

    //[Test]
    procedure Test_NaoCriarMovimento_CaixaInvalido;

    //[Test]
    procedure Test_NaoCriarMovimento_CaixaInexistente;

    //[Test]
    procedure Test_NaoCriarMovimento_CaixaFechado;

    //[Test]
    procedure Test_NaoCriarMovimento_SemObservacao;

    //[Test]
    procedure Test_NaoCriarMovimento_ObservacaoPequena;

    //[Test]
    procedure Test_NaoCriarMovimento_ObservacaoGrande;

    //[Test]
    procedure Test_NaoCriarMovimento_MovimentoNegativo;

    //[Test]
    procedure Test_NaoCriarMovimento_SaldoInsuficiente;

    //[Test]
    procedure Test_ObterCaixa_PorCodigo;

    //[Test]
    procedure Test_ObterCaixa_Aberto;

    //[Test]
    procedure Test_NaoObterCaixa_CodigoInvalido;

    //[Test]
    procedure Test_NaoObterCaixa_CodigoInexistente;

    //[Test]
    procedure Test_NaoObterCaixa_Aberto;

    //[Test]
    procedure Test_NaoObterMovimento_CaixaInvalido;

    //[Test]
    procedure Test_NaoObterMovimento_CaixaInexistente;

    //[Test]
    procedure Test_NaoFecharCaixa_CaixaInvalido;

    //[Test]
    procedure Test_NaoFecharCaixa_CaixaInexistente;

    //[Test]
    procedure Test_NaoFecharCaixa_ValorNaoConfere;

    //[Test]
    procedure Test_NaoFecharCaixa_CaixaFechado;

    //[Test]
    procedure Test_FecharCaixa;
  end;

implementation

uses
  RESTRequest4D,
  Horse,
  Horse.JsonInterceptor.Helpers,

  Loja.Controller.Api.Test,

  Loja.Model.Dto.Req.Caixa.Abertura,
  Loja.Model.Dto.Req.Caixa.Fechamento,
  Loja.Model.Dto.Req.Caixa.CriarMovimento,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto;

{ TLojaControllerCaixaTest }

procedure TLojaControllerCaixaTest.SetupFixture;
begin
  FBaseURL := TLojaControllerApiTest.GetInstance.BaseURL;
  FUsarname := TLojaControllerApiTest.GetInstance.UserName;
  FPassword := TLojaControllerApiTest.GetInstance.Password;
end;

procedure TLojaControllerCaixaTest.Test_AberturaDeCaixa;
begin
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.VrAbert := 10.00;

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/abrir-caixa')
    .AddBody(TJson.ObjectToClearJsonString(LAbertura))
    .Post();

  Assert.AreEqual(201, LResponse.StatusCode);

  var LCaixa := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaCaixa>(LResponse.Content);

  Assert.AreEqual(Double(LAbertura.VrAbert), Double(LCaixa.VrAbert));
  Assert.AreEqual(sitAberto, LCaixa.CodSit);

  LCaixa.Free;
  LAbertura.Free;
end;

procedure TLojaControllerCaixaTest.Test_AberturaDeCaixa_NovaAbertura_ComReforco;
begin

end;

procedure TLojaControllerCaixaTest.Test_AberturaDeCaixa_NovaAbertura_ComSangria;
begin

end;

procedure TLojaControllerCaixaTest.Test_CriarMovimento_ReforcoCaixa;
begin

end;

procedure TLojaControllerCaixaTest.Test_CriarMovimento_SangriaCaixa;
begin

end;

procedure TLojaControllerCaixaTest.Test_CriarMovimento_SangriaCaixa_Total;
begin

end;

procedure TLojaControllerCaixaTest.Test_FecharCaixa;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoAbrirCaixa_ExiteCaixaAberto;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoAbrirCaixa_ValorNegativo;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_CaixaFechado;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_CaixaInexistente;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_CaixaInvalido;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_MovimentoNegativo;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_ObservacaoGrande;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_ObservacaoPequena;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_SaldoInsuficiente;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_SemObservacao;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoFecharCaixa_CaixaFechado;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoFecharCaixa_CaixaInexistente;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoFecharCaixa_CaixaInvalido;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoFecharCaixa_ValorNaoConfere;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoObterCaixa_Aberto;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoObterCaixa_CodigoInexistente;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoObterCaixa_CodigoInvalido;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoObterMovimento_CaixaInexistente;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoObterMovimento_CaixaInvalido;
begin

end;

procedure TLojaControllerCaixaTest.Test_ObterCaixa_Aberto;
begin

end;

procedure TLojaControllerCaixaTest.Test_ObterCaixa_PorCodigo;
begin

end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerCaixaTest);

end.
