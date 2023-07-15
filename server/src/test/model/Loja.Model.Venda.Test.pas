unit Loja.Model.Venda.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,

  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem,

  Loja.Model.Entity.Preco.Venda,
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda,

  Loja.Model.Dto.Req.Estoque.AcertoEstoque,

  Loja.Model.Dto.Req.Caixa.Abertura,
  Loja.Model.Entity.Caixa.Caixa;

type
  [TestFixture]
  TLojaModelVendaTest = class
  private
    FCaixa: TLojaModelEntityCaixaCaixa;

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
    procedure Test_NaoIniciarVenda_SemCaixa;

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

  end;


implementation

uses
  Horse,
  Horse.Exception,
  System.DateUtils,

  Loja.Model.Factory,
  Loja.Model.Dao.Factory,

  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Venda.Venda,
  Loja.Model.Entity.Venda.Item,
  Loja.Model.Entity.Venda.MeioPagto,

  Loja.Model.Dto.Req.Venda.MeioPagto,
  Loja.Model.Dto.Req.Venda.Item,

  Loja.Model.Entity.Caixa.Types,

  Loja.Model.Dto.Req.Caixa.Fechamento,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto;

{ TLojaModelVendaTest }

procedure TLojaModelVendaTest.AbrirCaixa(
  AVrAbert: Currency);
begin
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  try
    LAbertura.VrAbert := AVrAbert;
    FCaixa := TLojaModelFactory.New.Caixa.AberturaCaixa(LAbertura);
  finally
    LAbertura.Free;
  end;
end;

function TLojaModelVendaTest.CriarItem(ANome,
  ACodBarr: String): TLojaModelEntityItensItem;
var LDTONovoItem: TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := ANome;
    LDTONovoItem.NumCodBarr := ACodBarr;
    Result := TLojaModelDaoFactory.New.Itens.Item.CriarItem(LDTONovoItem);
  finally
    LDTONovoItem.Free;
  end;
end;

function TLojaModelVendaTest.CriarPrecoVenda(ACodItem: Integer;
  AVrVnda: Currency; ADatIni: TDateTime): TLojaModelEntityPrecoVenda;
begin
  var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
  try
    LDto.CodItem := ACodItem;
    LDto.DatIni := ADatIni;
    LDto.VrVnda := AVrVnda;

    Result := TLojaModelFactory.New
      .Preco
      .CriarPrecoVendaItem(LDto);
  finally
    LDto.Free;
  end;
end;

procedure TLojaModelVendaTest.FecharCaixaAtual;
begin
  var LCaixaAberto := TLojaModelFactory.New.Caixa.ObterCaixaAberto;
  if LCaixaAberto = nil
  then Exit;

  try
    var LResumo := TLojaModelFactory.New.Caixa.ObterResumoCaixa(LCaixaAberto.CodCaixa);

    var LFechamento := TLojaModelDtoReqCaixaFechamento.Create;
    LFechamento.CodCaixa := LCaixaAberto.CodCaixa;
    LFechamento.MeiosPagto := TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista.Create;

    for var LMeioPagto in LResumo.MeiosPagto
    do begin
      LFechamento.MeiosPagto.Get(LMeioPagto.CodMeioPagto).VrTotal :=
        LMeioPagto.VrTotal;
    end;

    try
      var LCaixaFechado := TLojaModelFactory.New.Caixa.FechamentoCaixa(LFechamento);
      LCaixaFechado.Free;
    finally
      LResumo.Free;
      LFechamento.Free;
    end;
  finally
    LCaixaAberto.Free;

    if FCaixa <> nil
    then FreeAndNil(FCaixa);
  end;
end;

procedure TLojaModelVendaTest.RealizarAcertoEstoque(ACodItem,
  AQtdSaldoReal: Integer);
begin
  var LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  try
    LAcerto.CodItem := ACodItem;
    LAcerto.QtdSaldoReal := AQtdSaldoReal;
    LAcerto.DscMot := 'TLojaModelVendaTest';

    var LMovimento := TLojaModelFactory.New
      .Estoque
      .CriarAcertoEstoque(LAcerto);
    LMovimento.Free;
  finally
    LAcerto.Free;
  end;
end;

procedure TLojaModelVendaTest.SetupFixture;
begin
  TLojaModelDaoFactory.InMemory := True;

  FCaixa := nil;
  FecharCaixaAtual;
end;

procedure TLojaModelVendaTest.TearDownFixture;
begin
  FecharCaixaAtual;

  TLojaModelDaoFactory.InMemory := False;
end;

procedure TLojaModelVendaTest.Test_CancelarVenda;
begin
  FecharCaixaAtual;
  AbrirCaixa(0);
  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  try
    var LCancelada := TLojaModelFactory.New.Venda.CancelarVenda(LNovaVenda.NumVnda);
    Assert.AreEqual(TLojaModelEntityVendaSituacao.sitCancelada.ToString, LCancelada.CodSit.ToString);
    LCancelada.Free;
  finally
    LNovaVenda.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_IniciarVenda;
begin
  FecharCaixaAtual;
  AbrirCaixa(0);

  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  Assert.IsNotNull(LNovaVenda);
  Assert.AreEqual(TLojaModelEntityVendaSituacao.sitPendente.ToString, LNovaVenda.CodSit.ToString);
  LNovaVenda.Free;
end;

procedure TLojaModelVendaTest.Test_InserirItemVenda;
begin
  FecharCaixaAtual;
  AbrirCaixa(0);

  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem := CriarItem('Teste inserir na venda','');
  var LPreco := CriarPrecoVenda(LITem.CodItem, 10, Now);
  RealizarAcertoEstoque(LItem.CodItem, 2);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 2;

    var LItemVenda := TLojaModelFactory.New.Venda.InserirItemVenda(LDto);

    Assert.AreEqual(Double(20), Double(LItemVenda.VrTotal));
    Assert.AreEqual(TLojaModelEntityVendaItemSituacao.sitAtivo.ToString,
      LItemVenda.CodSit.ToString);

    var LVenda := TLojaModelFactory.New.Venda.ObterVenda(LNovaVenda.NumVnda);

    Assert.AreEqual(Double(20), Double(LVenda.VrTotal));

    LDto.Free;
    LItemVenda.Free;
    LVenda.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoCancelarVenda_Inexistente;
begin
  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Venda.CancelarVenda(MaxInt);
    end,
    EHorseException,
    'Não foi possível encontrar a venda pelo número informado'
  );
end;

procedure TLojaModelVendaTest.Test_NaoCancelarVenda_NaoPendente;
begin
  FecharCaixaAtual;
  AbrirCaixa(0);

  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  try
    var LCancelada := TLojaModelFactory.New.Venda.CancelarVenda(LNovaVenda.NumVnda);
    LCancelada.Free;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.CancelarVenda(LNovaVenda.NumVnda);
      end,
      EHorseException,
      'A venda informada não está Pendente'
    );
  finally
    LNovaVenda.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoCancelarVenda_NumeroInvalido;
begin
  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Venda.CancelarVenda(-1);
    end,
    EHorseException,
    'O número de venda informado é inválido'
  );
end;

procedure TLojaModelVendaTest.Test_NaoIniciarVenda_SemCaixa;
begin
  FecharCaixaAtual;

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Venda.NovaVenda;
    end,
    EHorseException,
    'Não há caixa aberto'
  );
end;

procedure TLojaModelVendaTest.Test_NaoInserirItemVenda_ItemInexistente;
begin
  FecharCaixaAtual;
  AbrirCaixa(0);

  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := MaxInt;
    LDto.QtdItem := 1;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.InserirItemVenda(LDto);
      end,
      EHorseException,
      'Não foi possível encontrar o item informado'
    );

    LDto.Free;
  finally
    LNovaVenda.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoInserirItemVenda_QuantidadeInvalida;
begin
  FecharCaixaAtual;
  AbrirCaixa(0);

  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem := CriarItem('Teste inserir na venda','');
  var LPreco := CriarPrecoVenda(LITem.CodItem, 10, Now);
  RealizarAcertoEstoque(LItem.CodItem, 2);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := -1;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.InserirItemVenda(LDto);
      end,
      EHorseException,
      'A quantidade do item vendido deverá ser superior a zero'
    );

    LDto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoInserirItemVenda_SemPrecoImplantado;
begin
  FecharCaixaAtual;
  AbrirCaixa(0);

  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem := CriarItem('Teste inserir na venda','');

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 1;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.InserirItemVenda(LDto);
      end,
      EHorseException,
      'Não há preço de venda implantado para o item'
    );

    LDto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoInserirItemVenda_ValorTotalNegativo;
begin
  FecharCaixaAtual;
  AbrirCaixa(0);

  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem := CriarItem('Teste inserir na venda','');
  var LPreco := CriarPrecoVenda(LITem.CodItem, 10, Now);
  RealizarAcertoEstoque(LItem.CodItem, 2);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 1;
    LDto.VrDesc := 100;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.InserirItemVenda(LDto);
      end,
      EHorseException,
      'O valor total do item não pode ser negativo'
    );

    LDto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoInserirItemVenda_VendaNaoPendente;
begin
  FecharCaixaAtual;
  AbrirCaixa(0);

  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem := CriarItem('Teste inserir na venda','');
  var LPreco := CriarPrecoVenda(LITem.CodItem, 10, Now);
  RealizarAcertoEstoque(LItem.CodItem, 2);

  var LCancelada := TLojaModelFactory.New.Venda.CancelarVenda(LNovaVenda.NumVnda);
  LCancelada.Free;

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 1;
    LDto.VrDesc := 0;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.InserirItemVenda(LDto);
      end,
      EHorseException,
      'A venda informada não está Pendente'
    );

    LDto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelVendaTest);

end.
