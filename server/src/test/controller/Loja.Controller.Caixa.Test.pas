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

    [Test]
    procedure Test_ObterCaixa_PorCodigo;

    [Test]
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
  var LResponseAberto := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/caixa-aberto')
    .Get();

  Assert.AreEqual(THttpStatus.Ok, THttpStatus(LResponseAberto.StatusCode));


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
