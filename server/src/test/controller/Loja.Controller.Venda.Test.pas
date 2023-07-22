unit Loja.Controller.Venda.Test;

interface

uses
  DUnitX.TestFramework,

  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Dto.Req.Caixa.Abertura,
  Loja.Model.Dto.Req.Caixa.Fechamento,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto;

type
  [TestFixture]
  TLojaControllerVendaTest = class
  private
    FCaixa: TLojaModelEntityCaixaCaixa;

    FBaseURL, FUsarname, FPassword: String;

    procedure AbrirCaixa(AVrAbert: Currency);
    procedure FecharCaixaAtual;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure Test_IniciarVenda;

    [Test]
    procedure Test_NaoIniciarVenda_SemCaixaAberto;

    [Test]
    procedure Test_NaoIniciarVenda_SemCaixaHoje;

    [Test]
    procedure Test_CancelarVenda;

    [Test]
    procedure Test_NaoCancelarVenda_NumeroInvalido;

    [Test]
    procedure Test_NaoCancelarVenda_Inexistente;

    [Test]
    procedure Test_NaoCancelarVenda_NaoPendente;
  end;

implementation

uses
  RESTRequest4D,
  Horse,
  Horse.JsonInterceptor.Helpers,

  System.DateUtils,
  System.SysUtils,

  Loja.Controller.Api.Test,
  Loja.Model.Dto.Resp.ApiError,

  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Venda.Venda,

  Loja.Model.Entity.Caixa.Types,

  Database.Factory,
  Database.Interfaces;

{ TLojaControllerVendaTest }

procedure TLojaControllerVendaTest.AbrirCaixa(AVrAbert: Currency);
begin
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  try
    LAbertura.VrAbert := AVrAbert;

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/caixa/abrir-caixa')
      .AddBody(TJson.ObjectToClearJsonString(LAbertura))
      .Post();

    FCaixa := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityCaixaCaixa>(LResponse.Content);
  finally
    LAbertura.Free;
  end;
end;

procedure TLojaControllerVendaTest.FecharCaixaAtual;
begin
   var LResponseAberto := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/caixa/caixa-aberto')
    .Get();

  var LCaixaAberto := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityCaixaCaixa>(LResponseAberto.Content);
  if LCaixaAberto = nil
  then Exit;
  try
    var LResponseResumo := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/caixa/{cod_caixa}/resumo')
      .AddUrlSegment('cod_caixa', LCaixaAberto.CodCaixa.ToString)
      .Get();

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
      .AddUrlSegment('cod_caixa', LCaixaAberto.CodCaixa.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LFechamento))
      .Patch();

    LResumo.Free;
    LFechamento.Free;
  finally
    if FCaixa <> nil
    then FreeAndNil(FCaixa);

    LCaixaAberto.Free;
  end;
end;

procedure TLojaControllerVendaTest.SetupFixture;
begin
  FBaseURL := TLojaControllerApiTest.GetInstance.BaseURL;
  FUsarname := TLojaControllerApiTest.GetInstance.UserName;
  FPassword := TLojaControllerApiTest.GetInstance.Password;
end;

procedure TLojaControllerVendaTest.TearDownFixture;
begin
  FecharCaixaAtual;
end;

procedure TLojaControllerVendaTest.Test_CancelarVenda;
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  var LVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponse.Content);
  try

    var LResponseCancelar := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/cancelar')
      .AddUrlSegment('num_vnda', LVenda.NumVnda.ToString)
      .Patch();

    Assert.AreEqual(200, LResponseCancelar.StatusCode);

    var LCancelada := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityVendaVenda>(LResponseCancelar.Content);

    Assert.AreEqual(TLojaModelEntityVendaSituacao.sitCancelada,
      LCancelada.CodSit);

    LCancelada.Free;
  finally
    LVenda.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_IniciarVenda;
begin
  FecharCaixaAtual;
  AbrirCaixa(0);

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  Assert.AreEqual(201, LResponse.StatusCode);

  var LVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponse.Content);

  Assert.AreEqual(Double(0), Double(LVenda.VrTotal));
  Assert.AreEqual(TLojaModelEntityVendaSituacao.sitPendente, LVenda.CodSit);

  LVenda.Free;
end;

procedure TLojaControllerVendaTest.Test_NaoCancelarVenda_Inexistente;
begin
  var LResponseCancelar := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/cancelar')
      .AddUrlSegment('num_vnda', MaxInt.ToString)
      .Patch();

  Assert.AreEqual(THTTPStatus.NotFound, THTTPStatus(LResponseCancelar.StatusCode));

  var LError := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseCancelar.Content);

  Assert.AreEqual('Não foi possível encontrar a venda pelo número informado', LError.error);

  LError.Free;
end;

procedure TLojaControllerVendaTest.Test_NaoCancelarVenda_NaoPendente;
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  var LVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponse.Content);
  try
    // Cancela a primeira vez
    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/cancelar')
      .AddUrlSegment('num_vnda', LVenda.NumVnda.ToString)
      .Patch();

    // Não consegue cancelar pois não está pendente
    var LResponseCancelar := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/cancelar')
      .AddUrlSegment('num_vnda', LVenda.NumVnda.ToString)
      .Patch();

    Assert.AreEqual(THTTPStatus.BadRequest, THTTPStatus(LResponseCancelar.StatusCode));

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponseCancelar.Content);

    Assert.AreEqual('A venda informada não está Pendente', LError.error);

    LError.Free;
  finally
    LVenda.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoCancelarVenda_NumeroInvalido;
begin
  var LResponseCancelar := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/cancelar')
      .AddUrlSegment('num_vnda', '-1')
      .Patch();

  Assert.AreEqual(THTTPStatus.BadRequest, THTTPStatus(LResponseCancelar.StatusCode));

  var LError := TJson.ClearJsonAndConvertToObject
    <TLojaModelDTORespApiError>(LResponseCancelar.Content);

  Assert.AreEqual('O número de venda informado é inválido', LError.error);

  LError.Free;
end;

procedure TLojaControllerVendaTest.Test_NaoIniciarVenda_SemCaixaAberto;
begin
  FecharCaixaAtual;
  try
    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda')
      .Post();

    Assert.AreEqual(THTTPStatus.PreconditionRequired, THTTPStatus(LResponse.StatusCode));

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('Não há caixa aberto', LError.error);

    LError.Free;
  finally
    AbrirCaixa(0);
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoIniciarVenda_SemCaixaHoje;
var LAbertura: TDateTime;
begin
  FecharCaixaAtual;
  AbrirCaixa(0);

  LAbertura := FCaixa.DatAbert;

  FCaixa.DatAbert := LAbertura - 1;

  var LSql := #13#10
  + 'update caixa set '
  + '  dat_abert = :dat_abert '
  + 'where cod_caixa = :cod_caixa '
  ;

  TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('cod_caixa', FCaixa.CodCaixa)
      .AddDateTime('dat_abert', FCaixa.DatAbert)
      .&End
    .ExecSQL;

  try
    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda')
      .Post();

    Assert.AreEqual(THTTPStatus.PreconditionRequired, THTTPStatus(LResponse.StatusCode));

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('O caixa atual não foi aberto hoje. Realize o fechamento e uma nova abertura',
     LError.error);

    LError.Free;
  finally
    TDatabaseFactory.New.SQL
      .SQL(LSql)
      .ParamList
        .AddInteger('cod_caixa', FCaixa.CodCaixa)
        .AddDateTime('dat_abert', LAbertura)
        .&End
      .ExecSQL;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerVendaTest);

end.
