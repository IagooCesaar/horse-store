unit Loja.Controller.Venda.Test;

interface

uses
  DUnitX.TestFramework,

  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Dto.Req.Caixa.Abertura,
  Loja.Model.Dto.Req.Caixa.Fechamento,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto,

  Loja.Model.Dto.Resp.Itens.Item,
  Loja.Model.Entity.Preco.Venda;

type
  [TestFixture]
  TLojaControllerVendaTest = class
  private
    FCaixa: TLojaModelEntityCaixaCaixa;

    FBaseURL, FUsarname, FPassword: String;

    function CriarItem(ANome, ACodBarr: String;
      ATabPreco: Boolean = True; APermSaldNeg: Boolean = False): TLojaModelDtoRespItensItem;

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
    procedure Test_NaoInserirItemVenda_BodyInvalido;

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

    [Test]
    procedure Test_NaoAtualizarItemVenda_BodyInvalido;

    [Test]
    procedure Test_ObterItensVenda;

    [Test]
    procedure Test_NaoObterItensVenda_VendaInexistente;

    [Test]
    procedure Test_NaoObterItensVenda_VendaSemItens;

    [Test]
    procedure Test_ObterVendas;

    [Test]
    procedure Test_NaoObterVendas_SemVendasNoPeriodo;

    [Test]
    procedure Test_NaoObterVendas_PeriodoInvalido;

    [Test]
    procedure Test_NaoObterVendas_SemFiltroSituacao;

    [Test]
    procedure Test_DefinirMeiosPagamento;

    [Test]
    procedure Test_DefinirMeiosPagamento_RemoverTodos;

    [Test]
    procedure Test_NaoDefinirMeiosPagamento_MeiosNaoInformados;

    [Test]
    procedure Test_NaoDefinirMeiosPagamento_BodyInvalido;

    [Test]
    procedure Test_ObterMeiosPagamento;

    [Test]
    procedure Test_NaoObterMeiosPagamento_SemDefinicao;

    [Test]
    procedure Test_EfetivarVenda;

    [Test]
    procedure Test_EfetivarVenda_ItemGenerico;

    [Test]
    procedure Test_NaoEfetivarVenda_SemItens;

    [Test]
    procedure Test_NaoEfetivarVenda_SemItensAtivos;

    [Test]
    procedure Test_NaoEfetivarVenda_ItemSaldoInsuficiente;

    [Test]
    procedure Test_NaoEfetivarVenda_ValorTotalZero;

    [Test]
    procedure Test_NaoEfetivarVenda_PrecoUnitarioZero;

    [Test]
    procedure Test_NaoEfetivarVenda_SemMeiosPagto;

    [Test]
    procedure Test_NaoEfetivarVenda_MeiosPagtoInsuficiente;
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
  Loja.Model.Entity.Venda.MeioPagto,
  Loja.Model.Dto.Req.Venda.Item,
  Loja.Model.Dto.Resp.Venda.Item,

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
  ACodBarr: String; ATabPreco: Boolean = True; APermSaldNeg: Boolean = False): TLojaModelDtoRespItensItem;
var LNovoItem : TLojaModelDtoReqItensCriarItem;
begin
  try
    LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
    LNovoItem.NomItem := ANome;
    LNovoItem.NumCodBarr := ACodBarr;
    LNovoItem.FlgTabPreco := ATabPreco;
    LNovoItem.FlgPermSaldNeg := APermSaldNeg;

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/itens')
      .AddBody(TJson.ObjectToClearJsonString(LNovoItem))
      .Post();

    if LResponse.StatusCode <> 201
    then raise Exception.Create(Format('Falha ao criar item para teste: %s',[LResponse.Content]));

    Result := TJson.ClearJsonAndConvertToObject<TLojaModelDtoRespItensItem>
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

procedure TLojaControllerVendaTest.Test_DefinirMeiosPagamento;
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
    LDto.VrDesc := 4;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LDtoPagto := TLojaModelEntityVendaMeioPagtoLista.Create;
    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagDinheiro;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 16;

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDtoPagto))
      .Post();

    Assert.AreEqual(201, LResponse.StatusCode, LResponse.Content);

    var LMeiosPagto := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityVendaMeioPagtoLista>(LResponse.Content);

    Assert.IsTrue(LMeiosPagto.Count = 1);
    Assert.AreEqual(1, LMeiosPagto.First.NumSeqMeioPagto);

    LDto.Free;
    LDtoPagto.Free;
    LMeiosPagto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_DefinirMeiosPagamento_RemoverTodos;
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
    LDto.VrDesc := 4;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LDtoPagto := TLojaModelEntityVendaMeioPagtoLista.Create;
    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagDinheiro;
    LDtoPagto.Last.QtdParc := 0;
    LDtoPagto.Last.VrTotal := 0;

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDtoPagto))
      .Post();

    Assert.AreEqual(Integer(THTTPStatus.NoContent), LResponse.StatusCode, LResponse.Content);


    LDto.Free;
    LDtoPagto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_EfetivarVenda;
begin
  var LResponseVenda := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  var LNovaVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponseVenda.Content);

  var LItem := CriarItem('Teste inserir na venda','');
  var LPreco := CriarPrecoVenda(LITem.CodItem, 12, Now);
  RealizarAcertoEstoque(LItem.CodItem, 10);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 10;
    LDto.VrDesc := 0;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LDtoPagto := TLojaModelEntityVendaMeioPagtoLista.Create;

    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagPix;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 20;

    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagDinheiro;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 20;

    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagCartaoCredito;
    LDtoPagto.Last.QtdParc := 2;
    LDtoPagto.Last.VrTotal := 20;

    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagCartaoDebito;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 20;

    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagVoucher;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 20;

    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagCheque;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 20;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDtoPagto))
      .Post();


    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/efetivar')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Patch();

    Assert.AreEqual(200, LResponse.StatusCode, LResponse.Content);

    var LVendaEfet := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityVendaVenda>(LResponse.Content);

    Assert.AreEqual(TLojaModelEntityVendaSituacao.sitEfetivada, LVendaEfet.CodSit);
    Assert.AreEqual(Double(120), Double(LVendaEfet.VrTotal));

    LDto.Free;
    LDtoPagto.Free;
    LVendaEfet.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_EfetivarVenda_ItemGenerico;
begin
  var LResponseVenda := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  var LNovaVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponseVenda.Content);

  var LItem := CriarItem('Item Genérico para venda '+LNovaVenda.NumVnda.ToString,
    '', False, True);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 10;
    LDto.VrDesc := 0;
    LDto.VrPrecoUnit := 1.50;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LDtoPagto := TLojaModelEntityVendaMeioPagtoLista.Create;

    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagPix;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 10;

    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagDinheiro;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 5;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDtoPagto))
      .Post();

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/efetivar')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Patch();

    Assert.AreEqual(200, LResponse.StatusCode, LResponse.Content);

    var LVendaEfet := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityVendaVenda>(LResponse.Content);

    Assert.AreEqual(TLojaModelEntityVendaSituacao.sitEfetivada, LVendaEfet.CodSit);
    Assert.AreEqual(Double(15), Double(LVendaEfet.VrTotal));

    LDto.Free;
    LDtoPagto.Free;
    LVendaEfet.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
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
    LDto.VrDesc := 4;

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

    Assert.AreEqual(Double(16), Double(LItemVenda.VrTotal));
    Assert.AreEqual(TLojaModelEntityVendaItemSituacao.sitAtivo.ToString,
      LItemVenda.CodSit.ToString);
    Assert.AreEqual(1, LItemVenda.NumSeqItem);
    Assert.AreEqual(Double(4), Double(LItemVenda.VrDesc));

    var LResponseVendaAtu :=  TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Get();

    var LVendaAtu := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityVendaVenda>(LResponseVendaAtu.Content);

    Assert.AreEqual(Double(16), Double(LVendaAtu.VrTotal));

    LDto.Free;
    LItemVenda.Free;
    LVendaAtu.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoAtualizarItemVenda_BodyInvalido;
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
      .AddUrlSegment('num_seq_item', LItemVenda.NumSeqItem.ToString)
      .AddBody('')
      .Put();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('O body não estava no formato esperado',
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

procedure TLojaControllerVendaTest.Test_NaoDefinirMeiosPagamento_BodyInvalido;
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
    LDto.VrDesc := 4;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody('')
      .Post();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('O body não estava no formato esperado',
      LError.error);

    LDto.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoDefinirMeiosPagamento_MeiosNaoInformados;
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
    LDto.VrDesc := 4;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LDtoPagto := TLojaModelEntityVendaMeioPagtoLista.Create;
    {LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagDinheiro;
    LDtoPagto.Last.QtdParc := 0;
    LDtoPagto.Last.VrTotal := 0;}

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDtoPagto))
      .Post();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('É necessário informar ao menos um meio de pagamento',
      LError.error);

    LDto.Free;
    LDtoPagto.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoEfetivarVenda_ItemSaldoInsuficiente;
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
  RealizarAcertoEstoque(LItem.CodItem, 1);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 2;
    LDto.VrDesc := 0;

    var LResponseItem := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LDtoPagto := TLojaModelEntityVendaMeioPagtoLista.Create;

    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagPix;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 10;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDtoPagto))
      .Post();

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/efetivar')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Patch();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.StartsWith('Não há saldo disponível para o item', LError.error);

    LDtoPagto.Free;
    LError.Free;
    LDto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoEfetivarVenda_MeiosPagtoInsuficiente;
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
  RealizarAcertoEstoque(LItem.CodItem, 1);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 1;
    LDto.VrDesc := 0;

    var LResponseItem := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LDtoPagto := TLojaModelEntityVendaMeioPagtoLista.Create;

    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagPix;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 9.99;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDtoPagto))
      .Post();

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/efetivar')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Patch();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.StartsWith('Os valores informados nos meios de pagamentos', LError.error);

    LDtoPagto.Free;
    LError.Free;
    LDto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoEfetivarVenda_PrecoUnitarioZero;
begin
  var LResponseVenda := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  var LNovaVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponseVenda.Content);
  var LItemGen := CriarItem('Item Genérico','', False, True);

  var LItem := CriarItem('Teste inserir na venda','');
  var LPreco := CriarPrecoVenda(LITem.CodItem, 12, Now);
  RealizarAcertoEstoque(LItem.CodItem, 10);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 1;
    LDto.VrDesc := 0;

    var LResponseItem := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    LDto.CodItem := LItemGen.CodItem;
    LDto.QtdItem := 2;
    LDto.VrDesc := 0;

    LResponseItem := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/efetivar')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Patch();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('Todos os itens da venda deverão possuir preço unitário superior a zero', LError.error);

    LError.Free;
    LDto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
    LItemGen.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoEfetivarVenda_SemItens;
begin
  var LResponseVenda := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  var LNovaVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponseVenda.Content);
  try
    var LDtoPagto := TLojaModelEntityVendaMeioPagtoLista.Create;

    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagPix;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 10;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDtoPagto))
      .Post();

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/efetivar')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Patch();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('Não há itens na venda', LError.error);

    LDtoPagto.Free;
    LError.Free;
  finally
    LNovaVenda.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoEfetivarVenda_SemItensAtivos;
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
  RealizarAcertoEstoque(LItem.CodItem, 10);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 10;
    LDto.VrDesc := 0;

    var LResponseItem := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LItemVenda := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItem>(LResponseItem.Content);

    LDto.CodSit := TLojaModelEntityVendaItemSituacao.sitRemovido;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens/{num_seq_item}')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddUrlSegment('num_seq_item', LItemVenda.NumSeqItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Put();

    var LDtoPagto := TLojaModelEntityVendaMeioPagtoLista.Create;

    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagPix;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 10;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDtoPagto))
      .Post();

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/efetivar')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Patch();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('Não há itens ativos na venda', LError.error);

    LDtoPagto.Free;
    LError.Free;
    LItemVenda.Free;
    LDto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoEfetivarVenda_SemMeiosPagto;
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
  RealizarAcertoEstoque(LItem.CodItem, 1);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 1;
    LDto.VrDesc := 0;

    var LResponseItem := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/efetivar')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Patch();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('Não há meios de pagamento definidos na venda', LError.error);

    LError.Free;
    LDto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoEfetivarVenda_ValorTotalZero;
begin
  var LResponseVenda := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  var LNovaVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponseVenda.Content);
  var LItem := CriarItem('Item Genérico','', False, True);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 1;
    LDto.VrDesc := 2;
    LDto.VrPrecoUnit := 2;

    var LResponseItem := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/efetivar')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Patch();

    Assert.AreEqual(400, LResponse.StatusCode);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponse.Content);

    Assert.AreEqual('O valor total da venda deve ser superior a zero', LError.error);

    LError.Free;
    LDto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
  end;
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

procedure TLojaControllerVendaTest.Test_NaoInserirItemVenda_BodyInvalido;
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
    var LResponseItemVenda := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody('')
      .Post();

    Assert.AreEqual(400, LResponseItemVenda.StatusCode, LResponseItemVenda.Content);

    var LError := TJson.ClearJsonAndConvertToObject
      <TLojaModelDTORespApiError>(LResponseItemVenda.Content);

    Assert.AreEqual('O body não estava no formato esperado', LError.error);

    LError.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
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

procedure TLojaControllerVendaTest.Test_NaoObterItensVenda_VendaInexistente;
begin
  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda/{num_vnda}/itens')
    .AddUrlSegment('num_vnda', MaxInt.ToString)
    .Get();

  Assert.AreEqual(404, LResponse.StatusCode);
end;

procedure TLojaControllerVendaTest.Test_NaoObterItensVenda_VendaSemItens;
begin
  var LResponseVenda := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .Post();

  var LNovaVenda := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVenda>(LResponseVenda.Content);

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda/{num_vnda}/itens')
    .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
    .Get();

  Assert.AreEqual(204, LResponse.StatusCode);

  LNovaVenda.Free;
end;

procedure TLojaControllerVendaTest.Test_NaoObterMeiosPagamento_SemDefinicao;
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
    LDto.VrDesc := 4;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Get();

    Assert.AreEqual(204, LResponse.StatusCode, LResponse.Content);

    LDto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_NaoObterVendas_PeriodoInvalido;
var LDatIni, LDatFim : TDate;
begin
  LDatIni := Trunc(Now);
  LDatFim := Trunc(Now-1);

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .AddParam('dat_incl_ini', FormatDateTime('yyy-mm-dd', LDatIni))
    .AddParam('dat_incl_fim', FormatDateTime('yyy-mm-dd', LDatFim))
    .AddParam('cod_sit', TLojaModelEntityVendaSituacao.sitPendente.Name)
    .Get();

  Assert.AreEqual(400, LResponse.StatusCode);

  var LError := TJson.ClearJsonAndConvertToObject<TLojaModelDTORespApiError>(LResponse.Content);

  Assert.AreEqual('A data inicial deve ser inferior à data final em pelo menos 1 dia',
    LError.error);

  LError.Free;
end;

procedure TLojaControllerVendaTest.Test_NaoObterVendas_SemFiltroSituacao;
var LDatIni, LDatFim : TDate;
begin
  LDatIni := Trunc(Now);
  LDatFim := Trunc(Now+1);

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .AddParam('dat_incl_ini', FormatDateTime('yyy-mm-dd', LDatIni))
    .AddParam('dat_incl_fim', FormatDateTime('yyy-mm-dd', LDatFim))
    .AddParam('cod_sit', 'Pendente')
    .Get();

  Assert.AreEqual(400, LResponse.StatusCode);

  var LError := TJson.ClearJsonAndConvertToObject<TLojaModelDTORespApiError>(LResponse.Content);

  Assert.AreEqual('O código de situação informado é inválido',
    LError.error);

  LError.Free;
end;

procedure TLojaControllerVendaTest.Test_NaoObterVendas_SemVendasNoPeriodo;
var LDatIni, LDatFim : TDate;
begin
  LDatIni := Trunc(Now+1);
  LDatFim := Trunc(Now+2);

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .AddParam('dat_incl_ini', FormatDateTime('yyy-mm-dd', LDatIni))
    .AddParam('dat_incl_fim', FormatDateTime('yyy-mm-dd', LDatFim))
    .AddParam('cod_sit', TLojaModelEntityVendaSituacao.sitPendente.Name)
    .Get();

  Assert.AreEqual(204, LResponse.StatusCode);
end;

procedure TLojaControllerVendaTest.Test_ObterItensVenda;
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
    LDto.VrDesc := 2;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Get();

    Assert.AreEqual(200, LResponse.StatusCode);

    var LItens := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoRespVendaItemLista>(LResponse.Content);

    Assert.AreEqual(NativeInt(2), LItens.Count);

    LDto.Free;
    LItens.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_ObterMeiosPagamento;
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
    LDto.VrDesc := 4;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

    var LDtoPagto := TLojaModelEntityVendaMeioPagtoLista.Create;
    LDtoPagto.Add(TLojaModelEntityVendaMeioPagto.Create);
    LDtoPagto.Last.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.pagDinheiro;
    LDtoPagto.Last.QtdParc := 1;
    LDtoPagto.Last.VrTotal := 16;

    TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDtoPagto))
      .Post();

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', LNovaVenda.NumVnda.ToString)
      .Get();

    Assert.AreEqual(200, LResponse.StatusCode, LResponse.Content);

    var LMeiosPagto := TJson.ClearJsonAndConvertToObject
      <TLojaModelEntityVendaMeioPagtoLista>(LResponse.Content);

    Assert.IsTrue(LMeiosPagto.Count = 1);
    Assert.AreEqual(1, LMeiosPagto.First.NumSeqMeioPagto);

    LDto.Free;
    LDtoPagto.Free;
    LMeiosPagto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaControllerVendaTest.Test_ObterVendas;
var LDatIni, LDatFim : TDate;
begin
  // Insere pelo menos uma venda
  Test_IniciarVenda;
  Test_CancelarVenda;
  //Test_EfetivarVenda;

  LDatIni := Trunc(Now);
  LDatFim := Trunc(Now+1);

  var LResponse1 := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .AddParam('dat_incl_ini', FormatDateTime('yyy-mm-dd', LDatIni))
    .AddParam('dat_incl_fim', FormatDateTime('yyy-mm-dd', LDatFim))
    .AddParam('cod_sit', TLojaModelEntityVendaSituacao.sitPendente.Name)
    .Get();
  Assert.AreEqual(200, LResponse1.StatusCode);
  var LVendas := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVendaLista>(LResponse1.Content);
  Assert.IsTrue(LVendas.Count >= 1);
  LVendas.Free;

  var LResponse2 := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/venda')
    .AddParam('dat_incl_ini', FormatDateTime('yyy-mm-dd', LDatIni))
    .AddParam('dat_incl_fim', FormatDateTime('yyy-mm-dd', LDatFim))
    .AddParam('cod_sit', TLojaModelEntityVendaSituacao.sitCancelada.Name)
    .Get();
  Assert.AreEqual(200, LResponse2.StatusCode);
  LVendas := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityVendaVendaLista>(LResponse1.Content);
  Assert.IsTrue(LVendas.Count >= 1);
  LVendas.Free;

//  var LResponse3 := TRequest.New
//    .BasicAuthentication(FUsarname, FPassword)
//    .BaseURL(FBaseURL)
//    .Resource('/venda')
//    .AddParam('dat_incl_ini', FormatDateTime('yyy-mm-dd', LDatIni))
//    .AddParam('dat_incl_fim', FormatDateTime('yyy-mm-dd', LDatFim))
//    .AddParam('cod_sit', TLojaModelEntityVendaSituacao.sitEfetivada.Name)
//    .Get();
//  Assert.AreEqual(200, LResponse3.StatusCode);
//  LVendas := TJson.ClearJsonAndConvertToObject
//    <TLojaModelEntityVendaVendaLista>(LResponse1.Content);
//  Assert.IsTrue(LVendas.Count >= 1);
//  LVendas.Free;

end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerVendaTest);

end.
