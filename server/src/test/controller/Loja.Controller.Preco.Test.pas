unit Loja.Controller.Preco.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,

  Loja.Model.Entity.Itens.Item;

type
  [TestFixture]
  TLojaControllerPrecoTest = class
  private
    FBaseURL, FUsarname, FPassword: String;

    function CriarItem(ANome, ACodBarr: string): TLojaModelEntityItensItem;
  public
    [SetupFixture]
    procedure SetupFixture;

    [Test]
    procedure Test_CriarPrecoVenda;

    [Test]
    procedure Test_NaoCriarPrecoVenda_ItemInexiste;

    [Test]
    procedure Test_NaoCriarPrecoVenda_ValorNegativo;

    [Test]
    procedure Test_NaoCriarPrecoVenda_PrecoJaExistente;

    [Test]
    procedure Test_ObterPrecoVendaAtual;

    [Test]
    procedure Test_NaoObterPrecoVendaAtual_ItemInexistente;

    [Test]
    procedure Test_ObterHistoricoPrecoVenda;

    [Test]
    procedure Test_NaoObterHistoricoPrecoVenda_ItemInexistente;
  public
  end;

implementation

uses
  RESTRequest4D,
  Horse,
  Horse.JsonInterceptor.Helpers,

  System.DateUtils,

  Loja.Controller.Api.Test,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda,
  Loja.Model.Entity.Preco.Venda;

{ TLojaControllerPrecoTest }

function TLojaControllerPrecoTest.CriarItem(ANome, ACodBarr: string): TLojaModelEntityItensItem;
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

procedure TLojaControllerPrecoTest.SetupFixture;
begin
  FBaseURL := TLojaControllerApiTest.GetInstance.BaseURL;
  FUsarname := TLojaControllerApiTest.GetInstance.UserName;
  FPassword := TLojaControllerApiTest.GetInstance.Password;
end;

procedure TLojaControllerPrecoTest.Test_CriarPrecoVenda;
begin
  var LItemCriado := CriarItem('Criar Preço Venda', '');
  var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
  LDto.CodItem := LItemCriado.CodItem;
  LDto.DatIni := Now;
  LDto.VrVnda := 1.99;

  var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/preco-venda/{cod_item}')
      .AddUrlSegment('cod_item', LItemCriado.CodItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

  Assert.AreEqual(201, LResponse.StatusCode);

  LDto.Free;
  LItemCriado.Free;
end;

procedure TLojaControllerPrecoTest.Test_NaoCriarPrecoVenda_ItemInexiste;
begin
  var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
  LDto.CodItem :=-1;
  LDto.DatIni := Now;
  LDto.VrVnda := 1.99;

  var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/preco-venda/{cod_item}')
      .AddUrlSegment('cod_item', (-1).ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

  Assert.AreEqual(404, LResponse.StatusCode);

  LDto.Free;
end;

procedure TLojaControllerPrecoTest.Test_NaoCriarPrecoVenda_PrecoJaExistente;
begin
  var LItemCriado := CriarItem('Criar Preço Venda', '');
  var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
  LDto.CodItem := LItemCriado.CodItem;
  LDto.DatIni := Now;
  LDto.VrVnda := 1.99;

  var LResponse1 := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/preco-venda/{cod_item}')
      .AddUrlSegment('cod_item', LItemCriado.CodItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

  Assert.AreEqual(201, LResponse1.StatusCode);

  LDto.VrVnda := 2.99;

  var LResponse2 := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/preco-venda/{cod_item}')
      .AddUrlSegment('cod_item', LItemCriado.CodItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

  Assert.AreEqual(400, LResponse2.StatusCode);

  LDto.Free;
  LItemCriado.Free;
end;

procedure TLojaControllerPrecoTest.Test_NaoCriarPrecoVenda_ValorNegativo;
begin
  var LItemCriado := CriarItem('Criar Preço Venda', '');
  var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
  LDto.CodItem := LItemCriado.CodItem;
  LDto.DatIni := Now;
  LDto.VrVnda := -1.99;

  var LResponse1 := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/preco-venda/{cod_item}')
      .AddUrlSegment('cod_item', LItemCriado.CodItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LDto))
      .Post();

  Assert.AreEqual(400, LResponse1.StatusCode);

  LDto.Free;
  LItemCriado.Free;
end;

procedure TLojaControllerPrecoTest.Test_NaoObterHistoricoPrecoVenda_ItemInexistente;
begin
  var LResponse1 := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/preco-venda/{cod_item}/historico')
      .AddUrlSegment('cod_item', (-1).ToString)
      .AddParam('dat_ref', FormatDateTime('yyyy-mm-dd', Now))
      .Get();

  Assert.AreEqual(404, LResponse1.StatusCode);
end;

procedure TLojaControllerPrecoTest.Test_NaoObterPrecoVendaAtual_ItemInexistente;
begin
  var LResponse1 := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/preco-venda/{cod_item}')
      .AddUrlSegment('cod_item', (-1).ToString)
      .Get();

  Assert.AreEqual(404, LResponse1.StatusCode);
end;

procedure TLojaControllerPrecoTest.Test_ObterHistoricoPrecoVenda;
var LDat1, LDat2, LDat3, LDat4: TDateTime;

  procedure CriarPrecoVenda(ACodItem: Integer; ADatIni: TDateTime; AVr: Currency);
  begin
    var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
    LDto.CodItem := ACodItem;
    LDto.DatIni := ADatIni;
    LDto.VrVnda := AVr;

    var LResponse := TRequest.New
        .BasicAuthentication(FUsarname, FPassword)
        .BaseURL(FBaseURL)
        .Resource('/preco-venda/{cod_item}')
        .AddUrlSegment('cod_item', ACodItem.ToString)
        .AddBody(TJson.ObjectToClearJsonString(LDto))
        .Post();

    Assert.AreEqual(201, LResponse.StatusCode);

    LDto.Free;
  end;

begin
  LDat1 := IncDay(Now, -7);
  LDat2 := IncDay(Now, -5);
  LDat3 := IncDay(Now,  0);
  LDat4 := IncDay(Now, +5);

  var LItemCriado := CriarItem('Criar Preço Venda', '');

  CriarPrecoVenda(LItemCriado.CodItem, LDat4, 8.99);
  CriarPrecoVenda(LItemCriado.CodItem, LDat3, 5.99);

  CriarPrecoVenda(LItemCriado.CodItem, LDat1, 1.99);
  CriarPrecoVenda(LItemCriado.CodItem, LDat2, 2.99);

  var LResponse1 := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/preco-venda/{cod_item}/historico')
    .AddParam('dat_ref', FormatDateTime('yyyy-mm-dd', IncDay(LDat1,1)))
    .AddUrlSegment('cod_item', LItemCriado.CodItem.ToString)
    .Get();

  Assert.AreEqual(200, LResponse1.StatusCode);

  var LHistorico1 := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityPrecoVendaLista>(LResponse1.Content);

  Assert.AreEqual(4, LHistorico1.Count);
  Assert.AreEqual(Double(1.99), Double(LHistorico1.First.VrVnda));
  Assert.AreEqual(Double(8.99), Double(LHistorico1.Last.VrVnda));

  var LResponse2 := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/preco-venda/{cod_item}/historico')
    .AddUrlSegment('cod_item', LItemCriado.CodItem.ToString)
    .AddParam('dat_ref', FormatDateTime('yyyy-mm-dd', IncDay(LDat2,1)))
    .Get();

  Assert.AreEqual(200, LResponse2.StatusCode);
  var LHistorico2 := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityPrecoVendaLista>(LResponse2.Content);

  Assert.AreEqual(3, LHistorico2.Count);
  Assert.AreEqual(Double(2.99), Double(LHistorico2.First.VrVnda));
  Assert.AreEqual(Double(8.99), Double(LHistorico2.Last.VrVnda));

  LItemCriado.Free;
  LHistorico1.Free;
  LHistorico2.Free;
end;

procedure TLojaControllerPrecoTest.Test_ObterPrecoVendaAtual;

  procedure CriarPrecoVenda(ACodItem: Integer; ADatIni: TDateTime; AVr: Currency);
  begin
    var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
    LDto.CodItem := ACodItem;
    LDto.DatIni := ADatIni;
    LDto.VrVnda := AVr;

    var LResponse := TRequest.New
        .BasicAuthentication(FUsarname, FPassword)
        .BaseURL(FBaseURL)
        .Resource('/preco-venda/{cod_item}')
        .AddUrlSegment('cod_item', ACodItem.ToString)
        .AddBody(TJson.ObjectToClearJsonString(LDto))
        .Post();

    Assert.AreEqual(201, LResponse.StatusCode);

    LDto.Free;
  end;

begin
  var LItemCriado := CriarItem('Criar preço venda', '');

  CriarPrecoVenda(LItemCriado.CodItem, IncDay(Now, +7), 3.99);
  CriarPrecoVenda(LItemCriado.CodItem, IncDay(Now, -7), 1.99);
  CriarPrecoVenda(LItemCriado.CodItem, IncDay(Now, -1), 2.99);

  var LResponse := TRequest.New
    .BasicAuthentication(FUsarname, FPassword)
    .BaseURL(FBaseURL)
    .Resource('/preco-venda/{cod_item}')
    .AddUrlSegment('cod_item', LItemCriado.CodItem.ToString)
    .Get();

  Assert.AreEqual(200, LResponse.StatusCode);

  var LPrecoAtual := TJson.ClearJsonAndConvertToObject
    <TLojaModelEntityPrecoVenda>(LResponse.Content);

  Assert.AreEqual(Double(2.99), Double(LPrecoAtual.VrVnda));

  LItemCriado.Free;
  LPrecoAtual.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerPrecoTest);

end.
