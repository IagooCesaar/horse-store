unit Loja.Controller.Venda.Test;

interface

uses
  DUnitX.TestFramework,

  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Dto.Req.Caixa.Abertura,
  Loja.Model.Dto.Req.Caixa.Fechamento,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto,

  Loja.Model.Entity.Itens.Item,
  Loja.Model.Entity.Preco.Venda;

type
  [TestFixture]
  TLojaControllerVendaTest = class
  private
    FCaixa: TLojaModelEntityCaixaCaixa;

    FBaseURL, FUsarname, FPassword: String;

    function CriarItem(ANome, ACodBarr: String): TLojaModelEntityItensItem;

    function CriarPrecoVenda(ACodItem: Integer; AVrVnda: Currency;
      ADatIni: TDateTime): TLojaModelEntityPrecoVenda;

    procedure RealizarAcertoEstoque(ACodItem: Integer; AQtdSaldoReal: Integer);

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

    [Test]
    procedure Test_InserirItemVenda;
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
  Loja.Model.Dto.Req.Venda.Item,
  Loja.Model.Dto.Resp.Venda.Item,
  Loja.Model.Dto.Req.Venda.MeioPagto,

  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda,
  Loja.Model.Dto.Req.Estoque.AcertoEstoque,

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

function TLojaControllerVendaTest.CriarItem(ANome,
  ACodBarr: String): TLojaModelEntityItensItem;
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

    Result := TJson.ClearJsonAndConvertToObject<TLojaModelEntityItensItem>
      (LResponse.Content);
  finally
    FreeAndNil(LNovoItem);
  end;
end;

function TLojaControllerVendaTest.CriarPrecoVenda(ACodItem: Integer;
  AVrVnda: Currency; ADatIni: TDateTime): TLojaModelEntityPrecoVenda;
begin
  var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
  LDto.CodItem := ACodItem;
  LDto.DatIni := ADatIni;
  LDto.VrVnda := AVrVnda;
  try
    var LResponse := TRequest.New
        .BasicAuthentication(FUsarname, FPassword)
        .BaseURL(FBaseURL)
        .Resource('/preco-venda/{cod_item}')
        .AddUrlSegment('cod_item', ACodItem.ToString)
        .AddBody(TJson.ObjectToClearJsonString(LDto))
        .Post();

    Result := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityPrecoVenda>(LResponse.Content);
  finally
    LDto.Free;
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

procedure TLojaControllerVendaTest.RealizarAcertoEstoque(ACodItem,
  AQtdSaldoReal: Integer);
begin
  var LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  LACerto.QtdSaldoReal := AQtdSaldoReal;
  LAcerto.DscMot := 'Implantação Teste';
  try
    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/estoque/{cod_item}/acerto-de-estoque')
      .AddUrlSegment('cod_item', ACodItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LAcerto))
      .Post();

  finally
    LAcerto.Free;
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

procedure TLojaControllerVendaTest.Test_InserirItemVenda;
begin
  var LResponseVenda := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  var LNovaVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponseVenda.Content);

  var LItem := CriarItem('Teste inserir na venda','');
  var LPreco := CriarPrecoVenda(LITem.CodItem, 10, Now);
  RealizarAcertoEstoque(LItem.CodItem, 2);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 2;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    Assert.AreEqual(THTTPStatus.Created, THTTPStatus(LResponseItemVenda.StatusCode));

    var LItemVenda := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItemVenda.Content);

    Assert.AreEqual(Double(20), Double(LItemVenda.VrTotal));
    Assert.AreEqual(TLojaModelEntityVendaItemSituacao.sitAtivo.ToString,
      LItemVenda.CodSit.ToString);
    Assert.AreEqual(1, LItemVenda.NumSeqItem);

    var LResponseVendaAtu :=  TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Get();

    var LVendaAtu := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityVendaVenda>(LResponseVendaAtu.Content);

    Assert.AreEqual(Double(20), Double(LVendaAtu.VrTotal));

    LDto.Free;
    LItemVenda.Free;
    LVendaAtu.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
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
