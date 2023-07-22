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

    [Test]
    procedure Test_NaoInserirItemVenda_QuantidadeInvalida;

    [Test]
    procedure Test_NaoInserirItemVenda_ItemInexistente;

    [Test]
    procedure Test_NaoInserirItemVenda_SemPrecoImplantado;

    [Test]
    procedure Test_NaoInserirItemVenda_ValorTotalNegativo;

    [Test]
    procedure Test_NaoInserirItemVenda_VendaNaoPendente;

    [Test]
    procedure Test_AtualizarItemVenda;

    [Test]
    procedure Test_AtualizarItemVenda_RemoverItem;

    [Test]
    procedure Test_NaoAtualizarItemVenda_ItemRemovido;

    [Test]
    procedure Test_NaoAtualizarItemVenda_QuantidadeInvalida;

    [Test]
    procedure Test_NaoAtualizarItemVenda_ItemInexistente;

    [Test]
    procedure Test_NaoAtualizarItemVenda_SemPrecoImplantado;

    [Test]
    procedure Test_NaoAtualizarItemVenda_ItemNaoInserido;

    [Test]
    procedure Test_NaoAtualizarItemVenda_ValorTotalNegativo;
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

    if LResponse.StatusCode <> 201
    then raise Exception.Create(Format('Falha ao criar item para teste: %s',[LResponse.Content]));

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

  if LResponseAberto.StatusCode = 204
  then Exit;

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

  FecharCaixaAtual;
  AbrirCaixa(0);
end;

procedure TLojaControllerVendaTest.TearDownFixture;
begin
  FecharCaixaAtual;
end;

procedure TLojaControllerVendaTest.Test_AtualizarItemVenda;
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
    LDto.QtdItem := 1;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LItemVenda := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItemVenda.Content);

    var LResponseVendaAtu :=  TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Get();

    var LVendaAtu := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityVendaVenda>(LResponseVendaAtu.Content);

    Assert.AreEqual(Double(10), Double(LVendaAtu.VrTotal));

    LDto.QtdItem := 2;
    var LResponseItemAtu := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens/{num_seq_item}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddUrlSegment('num_seq_item', LItemVenda.NumSeqItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Put();

    var LItemAtualizado := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItemAtu.Content);

    Assert.AreEqual(LDto.QtdItem, LItemAtualizado.QtdItem);
    Assert.AreEqual(Double(20), Double(LItemAtualizado.VrTotal));

    var LResponseVendaAtu2 :=  TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Get();

    var LVendaAtu2 := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityVendaVenda>(LResponseVendaAtu2.Content);

    Assert.AreEqual(Double(20), Double(LVendaAtu2.VrTotal));

    LDto.Free;
    LItemVenda.Free;
    LVendaAtu.Free;
    LItemAtualizado.Free;
    LVendaAtu2.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_AtualizarItemVenda_RemoverItem;
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
    LDto.QtdItem := 1;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LItemVenda := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItemVenda.Content);

    var LResponseVendaAtu :=  TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Get();

    var LVendaAtu := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityVendaVenda>(LResponseVendaAtu.Content);

    Assert.AreEqual(Double(10), Double(LVendaAtu.VrTotal));

    LDto.CodSit := TLojaModelEntityVendaItemSituacao.sitRemovido;

    var LResponseItemAtu := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens/{num_seq_item}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddUrlSegment('num_seq_item', LItemVenda.NumSeqItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Put();

    var LItemAtualizado := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItemAtu.Content);

    Assert.AreEqual(TLojaModelEntityVendaItemSituacao.sitRemovido, LItemAtualizado.CodSit);

    var LResponseVendaAtu2 :=  TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Get();

    var LVendaAtu2 := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityVendaVenda>(LResponseVendaAtu2.Content);

    Assert.AreEqual(Double(0), Double(LVendaAtu2.VrTotal));

    LDto.Free;
    LItemVenda.Free;
    LVendaAtu.Free;
    LItemAtualizado.Free;
    LVendaAtu2.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
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

    Assert.AreEqual(201, LResponseItemVenda.StatusCode, LResponseItemVenda.Content);

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

procedure TLojaControllerVendaTest.Test_NaoAtualizarItemVenda_ItemInexistente;
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
    LDto.QtdItem := 1;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LItemVenda := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItemVenda.Content);

    LDto.CodItem := MaxInt;

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens/{num_seq_item}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddUrlSegment('num_seq_item', LItemVenda.NumSeqItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Put();

    Assert.AreEqual(404, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('Não foi possível encontrar o item informado',
      LError.error);

    LDto.Free;
    LItemVenda.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoAtualizarItemVenda_ItemNaoInserido;
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
    LDto.QtdItem := 1;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LItemVenda := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItemVenda.Content);

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens/{num_seq_item}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddUrlSegment('num_seq_item', MaxInt.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Put();

    Assert.AreEqual(404, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('Não foi possível encontrar item deste sequencial na venda informada',
      LError.error);

    LDto.Free;
    LItemVenda.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoAtualizarItemVenda_ItemRemovido;
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
    LDto.QtdItem := 1;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LItemVenda := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItemVenda.Content);

    LDto.CodSit := TLojaModelEntityVendaItemSituacao.sitRemovido;

    var LResponseItemAtu := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens/{num_seq_item}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddUrlSegment('num_seq_item', LItemVenda.NumSeqItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Put();

    var LItemAtualizado := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItemAtu.Content);

    Assert.AreEqual(TLojaModelEntityVendaItemSituacao.sitRemovido, LItemAtualizado.CodSit);

    LDto.QtdItem := 2;

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens/{num_seq_item}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddUrlSegment('num_seq_item', LItemVenda.NumSeqItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Put();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject<TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('Este item foi removido da venda, portanto não pode ser alterado',
      LError.error);

    LDto.Free;
    LItemVenda.Free;
    LItemAtualizado.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoAtualizarItemVenda_QuantidadeInvalida;
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
    LDto.QtdItem := 1;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LItemVenda := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItemVenda.Content);

    LDto.QtdItem := -1;

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens/{num_seq_item}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddUrlSegment('num_seq_item', LItemVenda.NumSeqItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Put();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('A quantidade do item vendido deverá ser superior a zero',
      LError.error);

    LDto.Free;
    LItemVenda.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoAtualizarItemVenda_SemPrecoImplantado;
begin
  var LResponseVenda := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  var LNovaVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponseVenda.Content);

  var LItem1 := CriarItem('Teste inserir na venda 1','');
  var LPreco1 := CriarPrecoVenda(LItem1.CodItem, 10, Now);
  RealizarAcertoEstoque(LItem1.CodItem, 2);

  var LItem2 := CriarItem('Teste inserir na venda 2','');
  var LPreco2 := CriarPrecoVenda(LItem1.CodItem, 10, Now + 1);
  RealizarAcertoEstoque(LItem2.CodItem, 2);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem1.CodItem;
    LDto.QtdItem := 1;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LItemVenda := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItemVenda.Content);

    LDto.CodItem := LItem2.CodItem;

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens/{num_seq_item}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddUrlSegment('num_seq_item', LItemVenda.NumSeqItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Put();

    Assert.AreEqual(404, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('Não há preço de venda implantado para o item',
      LError.error);

    LDto.Free;
    LItemVenda.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
    LItem1.Free;
    LPreco1.Free;
    LItem2.Free;
    LPreco2.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoAtualizarItemVenda_ValorTotalNegativo;
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
    LDto.QtdItem := 1;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LItemVenda := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItemVenda.Content);

    LDto.VrDesc := 11;

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens/{num_seq_item}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddUrlSegment('num_seq_item', LItemVenda.NumSeqItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Put();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('O valor total do item não pode ser negativo',
      LError.error);

    LDto.Free;
    LItemVenda.Free;
    LError.Free;
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

procedure TLojaControllerVendaTest.Test_NaoInserirItemVenda_ItemInexistente;
begin
  var LResponseVenda := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  var LNovaVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponseVenda.Content);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := -1;
    LDto.QtdItem := 1;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    Assert.AreEqual(404, LResponseItemVenda.StatusCode, LResponseItemVenda.Content);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponseItemVenda.Content);

    Assert.AreEqual('Não foi possível encontrar o item informado', LError.error);

    LDto.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoInserirItemVenda_QuantidadeInvalida;
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
    LDto.QtdItem := -1;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    Assert.AreEqual(400, LResponseItemVenda.StatusCode, LResponseItemVenda.Content);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponseItemVenda.Content);

    Assert.AreEqual('A quantidade do item vendido deverá ser superior a zero', LError.error);

    LDto.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoInserirItemVenda_SemPrecoImplantado;
begin
  var LResponseVenda := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  var LNovaVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponseVenda.Content);

  var LItem := CriarItem('Item sem preço','');
  RealizarAcertoEstoque(LItem.CodItem, 2);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 1;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    Assert.AreEqual(404, LResponseItemVenda.StatusCode, LResponseItemVenda.Content);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponseItemVenda.Content);

    Assert.AreEqual('Não há preço de venda implantado para o item', LError.error);

    LDto.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoInserirItemVenda_ValorTotalNegativo;
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
    LDto.QtdItem := 1;
    LDto.VrDesc := 11;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    Assert.AreEqual(400, LResponseItemVenda.StatusCode, LResponseItemVenda.Content);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponseItemVenda.Content);

    Assert.AreEqual('O valor total do item não pode ser negativo', LError.error);

    LDto.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoInserirItemVenda_VendaNaoPendente;
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

   TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda/{num_vnda}/cancelar')
    .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
    .Patch();

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 1;

    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    Assert.AreEqual(400, LResponseItemVenda.StatusCode, LResponseItemVenda.Content);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponseItemVenda.Content);

    Assert.AreEqual('A venda informada não está Pendente', LError.error);

    LDto.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerVendaTest);

end.
