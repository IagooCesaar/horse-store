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
    FCaixa: TLojaModelEntityCaixaCaixa;
  public
    [SetupFixture]
    procedure SetupFixture;
    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure Test_AberturaDeCaixa;

    [Test]
    procedure Test_NaoAbrirCaixa_ValorNegativo;

    [Test]
    procedure Test_NaoAbrirCaixa_ExiteCaixaAberto;

    [Test]
    procedure Test_NaoAbrirCaixa_SemBody;

    [Test]
    procedure Test_AberturaDeCaixa_NovaAbertura_ComSangria;

    [Test]
    procedure Test_AberturaDeCaixa_NovaAbertura_ComReforco;

    [Test]
    procedure Test_CriarMovimento_ReforcoCaixa;

    [Test]
    procedure Test_CriarMovimento_SangriaCaixa;

    [Test]
    procedure Test_CriarMovimento_SangriaCaixa_Total;

    [Test]
    procedure Test_ObterMovimentos;

    [Test]
    procedure Test_ObterResumo;

    [Test]
    procedure Test_CaixasAbertos;

    [Test]
    procedure Test_NaoObterCaixasAbertos_SemRegistros;

    [Test]
    procedure Test_NaoObterCaixasAbertos_DataInvalida;

    [Test]
    procedure Test_NaoCriarMovimento_CaixaInvalido;

    [Test]
    procedure Test_NaoCriarMovimento_CaixaInexistente;

    [Test]
    procedure Test_NaoCriarMovimento_CaixaFechado;

    [Test]
    procedure Test_NaoCriarMovimento_SemObservacao;

    [Test]
    procedure Test_NaoCriarMovimento_ObservacaoPequena;

    [Test]
    procedure Test_NaoCriarMovimento_ObservacaoGrande;

    [Test]
    procedure Test_NaoCriarMovimento_MovimentoNegativo;

    [Test]
    procedure Test_NaoCriarMovimento_SaldoInsuficiente;

    [Test]
    procedure Test_NaoCriarMovimento_SangriaSemBody;

    [Test]
    procedure Test_NaoCriarMovimento_ReforcoSemBody;

    [Test]
    procedure Test_ObterCaixa_PorCodigo;

    [Test]
    procedure Test_ObterCaixa_Aberto;

    //[Test]
    procedure Test_NaoObterCaixa_CodigoInvalido;

    [Test]
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

    [Test]
    procedure Test_NaoFecharCaixa_ValorNaoConfere;

    [Test]
    procedure Test_NaoFecharCaixa_CaixaFechado;

    [Test]
    procedure Test_NaoFecharCaixa_SemBody;

    [Test]
    procedure Test_FecharCaixa;
  end;

implementation

uses
  System.SysUtils,
  RESTRequest4D,
  Horse,
  Horse.JsonInterceptor.Helpers,

  Loja.Controller.Api.Test,
  Loja.Model.Dto.Resp.ApiError,

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

procedure TLojaControllerCaixaTest.TearDownFixture;
begin
  if FCaixa <> nil
  then FreeAndNil(FCaixa);
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

  Assert.AreEqual(THttpStatus.Created, THttpStatus(LResponse.StatusCode));

  FCaixa := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaCaixa>(LResponse.Content);

  Assert.AreEqual(Double(LAbertura.VrAbert), Double(FCaixa.VrAbert));
  Assert.AreEqual(sitAberto, FCaixa.CodSit);

  LAbertura.Free;
end;

procedure TLojaControllerCaixaTest.Test_AberturaDeCaixa_NovaAbertura_ComReforco;
begin
  // Obtêm resumo do caixa atual
  var LResponseResumo := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseResumo.StatusCode));

  var LResumo := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoRespCaixaResumoCaixa>(LResponseResumo.Content);

  var VrFecha := LResumo.VrSaldo;
  var VrDif := 4.00;

  //Realiza fechamento do caixa atual para abrir um novo
  var LFechamento := TLojaModelDtoReqCaixaFechamento.Create;
  LFechamento.MeiosPagto := TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista.Create;

  for var LMeioPagto in LResumo.MeiosPagto
  do begin
    LFechamento.MeiosPagto.Get(LMeioPagto.CodMeioPagto).VrTotal :=
      LMeioPagto.VrTotal;
  end;

  var LResponseFecharCaixa := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/fechar-caixa')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LFechamento))
    .Patch();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseFecharCaixa.StatusCode), LResponseFecharCaixa.StatusText);

  //Prepara nova abertura
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.VrAbert := VrFecha + VrDif;

  var LResponseAbertura := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/abrir-caixa')
    .AddBody(TJson.ObjectToClearJsonString(LAbertura))
    .Post();

  Assert.AreEqual(THttpStatus.Created, THttpStatus(LResponseAbertura.StatusCode));

  FCaixa.Free;
  FCaixa := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaCaixa>(LResponseAbertura.Content);

  Assert.AreEqual(Double(LAbertura.VrAbert), Double(FCaixa.VrAbert));
  Assert.AreEqual(sitAberto, FCaixa.CodSit);

  var LResponseMovimentos := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THttpStatus.Ok, THttpStatus(LResponseMovimentos.StatusCode));

  var LMovimentos := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaMovimentoLista>(LResponseMovimentos.Content);

  Assert.AreEqual(2, LMovimentos.Count);
  Assert.AreEqual(Double(VrDif), Double(LMovimentos[1].VrMov));
  Assert.IsTrue(LMovimentos[1].CodTipoMov = movEntrada);
  Assert.IsTrue(LMovimentos[1].CodOrigMov = orgReforco);

  LAbertura.Free;
  LResumo.Free;
  LFechamento.Free;
  LMovimentos.Free;
end;

procedure TLojaControllerCaixaTest.Test_AberturaDeCaixa_NovaAbertura_ComSangria;
begin
  // Obtêm resumo do caixa atual
  var LResponseResumo := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseResumo.StatusCode));

  var LResumo := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoRespCaixaResumoCaixa>(LResponseResumo.Content);

  var VrFecha := LResumo.VrSaldo;
  var VrDif := 2.00;

  //Realiza fechamento do caixa atual para abrir um novo
  var LFechamento := TLojaModelDtoReqCaixaFechamento.Create;
  LFechamento.MeiosPagto := TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista.Create;

  for var LMeioPagto in LResumo.MeiosPagto
  do begin
    LFechamento.MeiosPagto.Get(LMeioPagto.CodMeioPagto).VrTotal :=
      LMeioPagto.VrTotal;
  end;

  var LResponseFecharCaixa := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/fechar-caixa')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LFechamento))
    .Patch();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseFecharCaixa.StatusCode), LResponseFecharCaixa.StatusText);

  //Prepara nova abertura
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.VrAbert := VrFecha - VrDif;

  var LResponseAbertura := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/abrir-caixa')
    .AddBody(TJson.ObjectToClearJsonString(LAbertura))
    .Post();

  Assert.AreEqual(THttpStatus.Created, THttpStatus(LResponseAbertura.StatusCode));

  FCaixa.Free;
  FCaixa := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaCaixa>(LResponseAbertura.Content);

  Assert.AreEqual(Double(LAbertura.VrAbert), Double(FCaixa.VrAbert));
  Assert.AreEqual(sitAberto, FCaixa.CodSit);

  var LResponseMovimentos := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THttpStatus.Ok, THttpStatus(LResponseMovimentos.StatusCode));

  var LMovimentos := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaMovimentoLista>(LResponseMovimentos.Content);

  Assert.AreEqual(2, LMovimentos.Count);
  Assert.AreEqual(Double(VrDif), Double(LMovimentos[1].VrMov));
  Assert.IsTrue(LMovimentos[1].CodTipoMov = movSaida);
  Assert.IsTrue(LMovimentos[1].CodOrigMov = orgSangria);

  LAbertura.Free;
  LResumo.Free;
  LFechamento.Free;
  LMovimentos.Free;
end;

procedure TLojaControllerCaixaTest.Test_CaixasAbertos;
var LDatIni, LDatFim: TDate;
begin
  LDatIni := Trunc(Now-1);
  LDatFim := Trunc(Now+1);

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa')
    .AddParam('dat_ini', FormatDateTime('yyyy-mm-dd', LDatIni))
    .AddParam('dat_fim', FormatDateTime('yyyy-mm-dd', LDatFim))
    .Get();

  Assert.AreEqual(THTTPStatus.Ok, THTTPStatus(LResponse.StatusCode));

  var LCaixas := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaCaixaLista>(LResponse.Content);

  Assert.IsTrue(LCaixas.Count > 0);

  LCaixas.Free;
end;

procedure TLojaControllerCaixaTest.Test_CriarMovimento_ReforcoCaixa;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := FCaixa.CodCaixa;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := 'Reforço de Caixa';

  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/reforco')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LDtoMov))
    .Post();

  Assert.AreEqual(THTTPStatus.Created, THTTPStatus(LResponseMovimento.StatusCode));

  var LMovimento := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaMovimento>(LResponseMovimento.Content);

  Assert.IsTrue(LMovimento.CodTipoMov = movEntrada);
  Assert.IsTrue(LMovimento.CodOrigMov = orgReforco);
  Assert.IsTrue(LMovimento.CodMeioPagto = pagDinheiro);
  Assert.AreEqual(Double(LDtoMov.VrMov), Double(LMovimento.VrMov));

  LDtoMov.Free;
  LMovimento.Free;
end;

procedure TLojaControllerCaixaTest.Test_CriarMovimento_SangriaCaixa;
begin
  var LResponseResumo := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseResumo.StatusCode));

  var LResumo := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoRespCaixaResumoCaixa>(LResponseResumo.Content);
  var VrSaldo := LResumo.VrSaldo;
  LResumo.Free;

  if VrSaldo = 0
  then raise Exception.Create('Saldo igual a zero');

  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := FCaixa.CodCaixa;
  LDtoMov.VrMov := 0.50;
  LDtoMov.DscObs := 'Sangria de Caixa';

  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/sangria')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LDtoMov))
    .Post();

  Assert.AreEqual(THTTPStatus.Created, THTTPStatus(LResponseMovimento.StatusCode));

  var LMovimento := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaMovimento>(LResponseMovimento.Content);

  Assert.IsTrue(LMovimento.CodTipoMov = movSaida);
  Assert.IsTrue(LMovimento.CodOrigMov = orgSangria);
  Assert.IsTrue(LMovimento.CodMeioPagto = pagDinheiro);
  Assert.AreEqual(Double(LDtoMov.VrMov), Double(LMovimento.VrMov));

  LMovimento.Free;
  LDtoMov.Free;
end;

procedure TLojaControllerCaixaTest.Test_CriarMovimento_SangriaCaixa_Total;
begin
  var LResponseResumo := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseResumo.StatusCode));

  var LResumo := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoRespCaixaResumoCaixa>(LResponseResumo.Content);
  var VrSaldo := LResumo.VrSaldo;
  LResumo.Free;

  if VrSaldo = 0
  then raise Exception.Create('Saldo igual a zero');

  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := FCaixa.CodCaixa;
  LDtoMov.VrMov := VrSaldo;
  LDtoMov.DscObs := 'Sangria Total de Caixa';

  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/sangria')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LDtoMov))
    .Post();

  Assert.AreEqual(THTTPStatus.Created, THTTPStatus(LResponseMovimento.StatusCode));

  var LMovimento := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaMovimento>(LResponseMovimento.Content);

  Assert.IsTrue(LMovimento.CodTipoMov = movSaida);
  Assert.IsTrue(LMovimento.CodOrigMov = orgSangria);
  Assert.IsTrue(LMovimento.CodMeioPagto = pagDinheiro);
  Assert.AreEqual(Double(LDtoMov.VrMov), Double(LMovimento.VrMov));

  LResponseResumo := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseResumo.StatusCode));

  LResumo := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoRespCaixaResumoCaixa>(LResponseResumo.Content);

  Assert.AreEqual(Double(0), Double(LResumo.VrSaldo));

  LMovimento.Free;
  LDtoMov.Free;
  LResumo.Free;
end;

procedure TLojaControllerCaixaTest.Test_FecharCaixa;
begin
  // Obtêm resumo do caixa atual
  var LResponseResumo := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseResumo.StatusCode));

  var LResumo := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoRespCaixaResumoCaixa>(LResponseResumo.Content);
  var VrFecha := LResumo.VrSaldo;

  //Realiza fechamento do caixa atual para abrir um novo
  var LFechamento := TLojaModelDtoReqCaixaFechamento.Create;
  LFechamento.MeiosPagto := TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista.Create;

  for var LMeioPagto in LResumo.MeiosPagto
  do begin
    LFechamento.MeiosPagto.Get(LMeioPagto.CodMeioPagto).VrTotal :=
      LMeioPagto.VrTotal;
  end;

  var LResponseFecharCaixa := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/fechar-caixa')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LFechamento))
    .Patch();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseFecharCaixa.StatusCode), LResponseFecharCaixa.StatusText);

  //Prepara nova abertura
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.VrAbert := VrFecha +15;

  var LResponseAbertura := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/abrir-caixa')
    .AddBody(TJson.ObjectToClearJsonString(LAbertura))
    .Post();

  Assert.AreEqual(THttpStatus.Created, THttpStatus(LResponseAbertura.StatusCode));

  FCaixa.Free;
  FCaixa := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaCaixa>(LResponseAbertura.Content);

  LAbertura.Free;
  LFechamento.Free;
  LResumo.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoAbrirCaixa_ExiteCaixaAberto;
begin
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.VrAbert := 11;

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/abrir-caixa')
    .AddBody(TJson.ObjectToClearJsonString(LAbertura))
    .Post();

  Assert.AreEqual(THTTPStatus.PreconditionFailed, THTTPStatus(LResponse.StatusCode));

  var LError := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponse.Content);

  Assert.StartsWith('Há um caixa aberto', LError.error);

  LError.Free;
  LAbertura.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoAbrirCaixa_SemBody;
begin
  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/abrir-caixa')
    .AddBody('')
    .Post();

  Assert.AreEqual(THTTPStatus.BadRequest, THTTPStatus(LResponseMovimento.StatusCode));

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseMovimento.Content);

  ASsert.AreEqual('O body não estava no formato esperado', LErro.error);
  LErro.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoAbrirCaixa_ValorNegativo;
begin
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.VrAbert := -1;

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/abrir-caixa')
    .AddBody(TJson.ObjectToClearJsonString(LAbertura))
    .Post();

  Assert.AreEqual(THTTPStatus.BadRequest, THTTPStatus(LResponse.StatusCode));

  var LError := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponse.Content);

  Assert.AreEqual('O caixa não poderá ser aberto com valor negativo', LError.error);

  LError.Free;
  LAbertura.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_CaixaFechado;
begin
  // Obtêm resumo do caixa atual
  var LResponseResumo := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseResumo.StatusCode));

  var LResumo := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoRespCaixaResumoCaixa>(LResponseResumo.Content);

  //Realiza fechamento do caixa atual para abrir um novo
  var LFechamento := TLojaModelDtoReqCaixaFechamento.Create;
  LFechamento.MeiosPagto := TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista.Create;

  for var LMeioPagto in LResumo.MeiosPagto
  do begin
    LFechamento.MeiosPagto.Get(LMeioPagto.CodMeioPagto).VrTotal :=
      LMeioPagto.VrTotal;
  end;

  var LResponseFecharCaixa := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/fechar-caixa')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LFechamento))
    .Patch();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseFecharCaixa.StatusCode), LResponseFecharCaixa.StatusText);

  var LIdCaixaFechado := FCaixa.CodCaixa;

  //Prepara nova abertura
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.VrAbert := LResumo.VrSaldo;

  var LResponseAbertura := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/abrir-caixa')
    .AddBody(TJson.ObjectToClearJsonString(LAbertura))
    .Post();

  Assert.AreEqual(THttpStatus.Created, THttpStatus(LResponseAbertura.StatusCode));

  FCaixa.Free;
  FCaixa := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaCaixa>(LResponseAbertura.Content);

  // Tenta realizar movimento em um caixa fechado
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := 'Caixa fechado';

  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/reforco')
    .AddUrlSegment('cod_caixa', LIdCaixaFechado.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LDtoMov))
    .Post();

  Assert.AreEqual(THTTPStatus.PreconditionFailed, THTTPStatus(LResponseMovimento.StatusCode));

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseMovimento.Content);

  Assert.AreEqual('O caixa informado não está na stuação "Aberto"', LErro.error);

  LErro.Free;
  LDtoMov.Free;
  LAbertura.Free;
  LFechamento.Free;
  LResumo.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_CaixaInexistente;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := 'Caixa inválido';

  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/reforco')
    .AddUrlSegment('cod_caixa', (FCaixa.CodCaixa + 1).ToString)
    .AddBody(TJson.ObjectToClearJsonString(LDtoMov))
    .Post();

  Assert.AreEqual(THTTPStatus.NotFound, THTTPStatus(LResponseMovimento.StatusCode));

  LDtoMov.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_CaixaInvalido;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := 'Caixa inválido';

  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/reforco')
    .AddUrlSegment('cod_caixa', (-1).ToString)
    .AddBody(TJson.ObjectToClearJsonString(LDtoMov))
    .Post();

  Assert.AreEqual(THTTPStatus.PreconditionFailed, THTTPStatus(LResponseMovimento.StatusCode));

  LDtoMov.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_MovimentoNegativo;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.VrMov := -20.00;
  LDtoMov.DscObs := 'Movimento Negativo';

  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/reforco')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LDtoMov))
    .Post();

  Assert.AreEqual(THTTPStatus.PreconditionFailed, THTTPStatus(LResponseMovimento.StatusCode));

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseMovimento.Content);

  Assert.AreEqual('O valor do movimento deverá ser superior a zero', LErro.error);

  LErro.Free;
  LDtoMov.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_ObservacaoGrande;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := '0123456789012345678901234567890123456789012345678901234567890';

  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/reforco')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LDtoMov))
    .Post();

  Assert.AreEqual(THTTPStatus.PreconditionFailed, THTTPStatus(LResponseMovimento.StatusCode));

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseMovimento.Content);

  Assert.StartsWith('A observação deverá ter no máximo', LErro.error);

  LErro.Free;
  LDtoMov.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_ObservacaoPequena;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := '123';

  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/reforco')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LDtoMov))
    .Post();

  Assert.AreEqual(THTTPStatus.PreconditionFailed, THTTPStatus(LResponseMovimento.StatusCode));

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseMovimento.Content);

  Assert.StartsWith('A observação deverá ter no mínimo', LErro.error);

  LErro.Free;
  LDtoMov.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_ReforcoSemBody;
begin
  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/reforco')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody('')
    .Post();

  Assert.AreEqual(THTTPStatus.BadRequest, THTTPStatus(LResponseMovimento.StatusCode));

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseMovimento.Content);

  Assert.AreEqual('O body não estava no formato esperado', LErro.error);
  LErro.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_SaldoInsuficiente;
begin
  var LResponseResumo := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseResumo.StatusCode));

  var LResumo := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoRespCaixaResumoCaixa>(LResponseResumo.Content);

  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.VrMov := LResumo.VrSaldo + 10.00;
  LDtoMov.DscObs := 'Saldo insuficiente';

  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/sangria')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LDtoMov))
    .Post();

  Assert.AreEqual(THTTPStatus.PreconditionFailed, THTTPStatus(LResponseMovimento.StatusCode));

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseMovimento.Content);

  Assert.AreEqual('Não há saldo disponível em dinheiro para realizar este tipo de movimento', LErro.error);

  LErro.Free;
  LDtoMov.Free;
  LResumo.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_SangriaSemBody;
begin
  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/sangria')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody('')
    .Post();

  Assert.AreEqual(THTTPStatus.BadRequest, THTTPStatus(LResponseMovimento.StatusCode));

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseMovimento.Content);

  ASsert.AreEqual('O body não estava no formato esperado', LErro.error);
  LErro.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoCriarMovimento_SemObservacao;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := '';

  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento/reforco')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LDtoMov))
    .Post();

  Assert.AreEqual(THTTPStatus.PreconditionFailed, THTTPStatus(LResponseMovimento.StatusCode));

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseMovimento.Content);

  Assert.AreEqual('Você deverá informar uma observação para este tipo de movimento', LErro.error);

  LErro.Free;
  LDtoMov.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoFecharCaixa_CaixaFechado;
begin
  // Obtêm resumo do caixa atual
  var LResponseResumo := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseResumo.StatusCode));

  var LResumo := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoRespCaixaResumoCaixa>(LResponseResumo.Content);
  var VrFecha := LResumo.VrSaldo;

  //Realiza fechamento do caixa atual
  var LFechamento := TLojaModelDtoReqCaixaFechamento.Create;
  LFechamento.MeiosPagto := TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista.Create;

  for var LMeioPagto in LResumo.MeiosPagto
  do begin
    LFechamento.MeiosPagto.Get(LMeioPagto.CodMeioPagto).VrTotal :=
      LMeioPagto.VrTotal;
  end;

  var LResponseFecharCaixa1 := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/fechar-caixa')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LFechamento))
    .Patch();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseFecharCaixa1.StatusCode), LResponseFecharCaixa1.StatusText);

  // Tenta fechar o mesmo caixa novamente
  var LResponseFecharCaixa2 := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/fechar-caixa')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LFechamento))
    .Patch();

  Assert.AreEqual(THTTPStatus.PreconditionFailed, THTTPStatus(LResponseFecharCaixa2.StatusCode), LResponseFecharCaixa2.StatusText);

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseFecharCaixa2.Content);

  Assert.AreEqual('Este caixa já se encontra fechado', LErro.error);

  //Prepara nova abertura
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.VrAbert := VrFecha + 10;

  var LResponseAbertura := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/abrir-caixa')
    .AddBody(TJson.ObjectToClearJsonString(LAbertura))
    .Post();

  Assert.AreEqual(THttpStatus.Created, THttpStatus(LResponseAbertura.StatusCode));

  FCaixa.Free;
  FCaixa := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaCaixa>(LResponseAbertura.Content);

  LAbertura.Free;
  LFechamento.Free;
  LResumo.Free;
  LErro.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoFecharCaixa_CaixaInexistente;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoFecharCaixa_CaixaInvalido;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoFecharCaixa_SemBody;
begin
  var LResponseMovimento := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/fechar-caixa')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody('')
    .Patch();

  Assert.AreEqual(THTTPStatus.BadRequest, THTTPStatus(LResponseMovimento.StatusCode), LResponseMovimento.StatusText);

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseMovimento.Content);

  Assert.AreEqual('O body não estava no formato esperado', LErro.error);
  LErro.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoFecharCaixa_ValorNaoConfere;
begin
  // Obtêm resumo do caixa atual
  var LResponseResumo := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseResumo.StatusCode));

  var LResumo := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoRespCaixaResumoCaixa>(LResponseResumo.Content);

  //Realiza fechamento do caixa atual para abrir um novo
  var LFechamento := TLojaModelDtoReqCaixaFechamento.Create;
  LFechamento.MeiosPagto := TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista.Create;

  for var LMeioPagto in LResumo.MeiosPagto
  do begin
    LFechamento.MeiosPagto.Get(LMeioPagto.CodMeioPagto).VrTotal :=
      LMeioPagto.VrTotal + 1.00;
  end;

  var LResponseFecharCaixa := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/fechar-caixa')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LFechamento))
    .Patch();

  Assert.AreEqual(THTTPStatus.BadRequest, THTTPStatus(LResponseFecharCaixa.StatusCode), LResponseFecharCaixa.StatusText);

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseFecharCaixa.Content);

  Assert.EndsWith('não confere. Verifique novamente', LErro.error);

  LResumo.Free;
  LFechamento.Free;
  LErro.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoObterCaixasAbertos_DataInvalida;
var LDatIni, LDatFim: TDate;
begin
  LDatIni := Trunc(Now+1);
  LDatFim := Trunc(Now-1);

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa')
    .AddParam('dat_ini', FormatDateTime('yyyy-mm-dd', LDatIni))
    .AddParam('dat_fim', FormatDateTime('yyyy-mm-dd', LDatFim))
    .Get();

  Assert.AreEqual(THTTPStatus.BadRequest, THTTPStatus(LResponse.StatusCode));

  var LErro := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponse.Content);

  Assert.AreEqual('A data inicial deve ser inferior à data final em pelo menos 1 dia', LErro.error);
  LErro.Free;
end;

procedure TLojaControllerCaixaTest.Test_NaoObterCaixasAbertos_SemRegistros;
var LDatIni, LDatFim: TDate;
begin
  LDatIni := Trunc(Now+1);
  LDatFim := Trunc(Now+2);

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa')
    .AddParam('dat_ini', FormatDateTime('yyyy-mm-dd', LDatIni))
    .AddParam('dat_fim', FormatDateTime('yyyy-mm-dd', LDatFim))
    .Get();

  Assert.AreEqual(THTTPStatus.NoContent, THTTPStatus(LResponse.StatusCode));
end;

procedure TLojaControllerCaixaTest.Test_NaoObterCaixa_Aberto;
begin

end;

procedure TLojaControllerCaixaTest.Test_NaoObterCaixa_CodigoInexistente;
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}')
    .AddUrlSegment('cod_caixa', (FCaixa.CodCaixa + 10).ToString)
    .Get();

  Assert.AreEqual(THttpStatus.NoContent, THttpStatus(LResponse.StatusCode));
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
  var LResponseAberto := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/caixa-aberto')
    .Get();

  Assert.AreEqual(THttpStatus.Ok, THttpStatus(LResponseAberto.StatusCode));

  // Obtêm resumo do caixa atual
  var LResponseResumo := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseResumo.StatusCode));

  var LResumo := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoRespCaixaResumoCaixa>(LResponseResumo.Content);
  var VrFecha := LResumo.VrSaldo;

  //Realiza fechamento do caixa atual para abrir um novo
  var LFechamento := TLojaModelDtoReqCaixaFechamento.Create;
  LFechamento.MeiosPagto := TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista.Create;

  for var LMeioPagto in LResumo.MeiosPagto
  do begin
    LFechamento.MeiosPagto.Get(LMeioPagto.CodMeioPagto).VrTotal :=
      LMeioPagto.VrTotal;
  end;

  var LResponseFecharCaixa := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/fechar-caixa')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .AddBody(TJson.ObjectToClearJsonString(LFechamento))
    .Patch();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseFecharCaixa.StatusCode), LResponseFecharCaixa.StatusText);

  //Tenta obter caixa aberto, porém não há
  var LResponseFechado := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/caixa-aberto')
    .Get();

  Assert.AreEqual(THttpStatus.NoContent, THttpStatus(LResponseFechado.StatusCode));

  //Prepara nova abertura
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.VrAbert := VrFecha;

  var LResponseAbertura := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/abrir-caixa')
    .AddBody(TJson.ObjectToClearJsonString(LAbertura))
    .Post();

  Assert.AreEqual(THttpStatus.Created, THttpStatus(LResponseAbertura.StatusCode));

  FCaixa.Free;
  FCaixa := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaCaixa>(LResponseAbertura.Content);

  LAbertura.Free;
  LFechamento.Free;
  LResumo.Free;
end;

procedure TLojaControllerCaixaTest.Test_ObterCaixa_PorCodigo;
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THttpStatus.Ok, THttpStatus(LResponse.StatusCode));
end;

procedure TLojaControllerCaixaTest.Test_ObterMovimentos;
begin
  var LResponseMovimentos := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/movimento')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THttpStatus.Ok, THttpStatus(LResponseMovimentos.StatusCode));

  var LMovimentos := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityCaixaMovimentoLista>(LResponseMovimentos.Content);

  Assert.IsTrue(LMovimentos.Count > 0);

  LMovimentos.Free;
end;

procedure TLojaControllerCaixaTest.Test_ObterResumo;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  for var I := 1 to 5
  do begin
    LDtoMov.CodCaixa := FCaixa.CodCaixa;
    LDtoMov.VrMov := 10.00 * I;
    LDtoMov.DscObs := 'Reforço de Caixa '+I.ToString;

    var LResponseMovimento := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/caixa/{cod_caixa}/movimento/reforco')
      .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDtoMov))
      .Post();

    Assert.AreEqual(THTTPStatus.Created, THTTPStatus(LResponseMovimento.StatusCode));
  end;

  var LResponseResumo := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', FCaixa.CodCaixa.ToString)
    .Get();

  Assert.AreEqual(THTTPStatus.OK, THTTPStatus(LResponseResumo.StatusCode));

  var LResumo := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoRespCaixaResumoCaixa>(LResponseResumo.Content);

  Assert.IsTrue(LResumo.VrSaldo > 0);
  Assert.AreEqual(
    Integer(High(TLojaModelEntityCaixaMeioPagamento))+1,
    LResumo.MeiosPagto.Count);

  LResumo.Free;
  LDtoMov.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerCaixaTest);

end.
