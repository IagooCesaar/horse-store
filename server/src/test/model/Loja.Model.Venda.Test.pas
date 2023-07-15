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
  AbrirCaixa(0);
end;

procedure TLojaModelVendaTest.TearDownFixture;
begin
  FecharCaixaAtual;

  TLojaModelDaoFactory.InMemory := False;
end;

procedure TLojaModelVendaTest.Test_AtualizarItemVenda;
begin
  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem := CriarItem('Teste atualizar na venda','');
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

    LDto.NumSeqItem := LItemVenda.NumSeqItem;
    LDto.QtdItem := 3;

    var LItemAtualizado := TLojaModelFactory.New.Venda.AtualizarItemVenda(LDto);
    Assert.AreEqual(Double(30), Double(LItemAtualizado.VrTotal));
    Assert.AreEqual(TLojaModelEntityVendaItemSituacao.sitAtivo.ToString,
      LItemAtualizado.CodSit.ToString);

    var LVendaAtualizada := TLojaModelFactory.New.Venda.ObterVenda(LNovaVenda.NumVnda);
    Assert.AreEqual(Double(30), Double(LVendaAtualizada.VrTotal));

    LDto.Free;
    LItemVenda.Free;
    LVenda.Free;
    LItemAtualizado.Free;
    LVendaAtualizada.Free;

  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_AtualizarItemVenda_RemoverItem;
begin
  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem := CriarItem('Teste atualizar na venda','');
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

    LDto.NumSeqItem := LItemVenda.NumSeqItem;
    LDto.QtdItem := 3;
    LDto.CodSit := TLojaModelEntityVendaItemSituacao.sitRemovido;

    var LItemAtualizado := TLojaModelFactory.New.Venda.AtualizarItemVenda(LDto);
    Assert.AreEqual(Double(30), Double(LItemAtualizado.VrTotal));
    Assert.AreEqual(TLojaModelEntityVendaItemSituacao.sitRemovido.ToString,
      LItemAtualizado.CodSit.ToString);

    var LVendaAtualizada := TLojaModelFactory.New.Venda.ObterVenda(LNovaVenda.NumVnda);
    Assert.AreEqual(Double(0), Double(LVendaAtualizada.VrTotal));

    LDto.Free;
    LItemVenda.Free;
    LVenda.Free;
    LItemAtualizado.Free;
    LVendaAtualizada.Free;

  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_CancelarVenda;
begin
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
  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  Assert.IsNotNull(LNovaVenda);
  Assert.AreEqual(TLojaModelEntityVendaSituacao.sitPendente.ToString, LNovaVenda.CodSit.ToString);
  LNovaVenda.Free;
end;

procedure TLojaModelVendaTest.Test_InserirItemVenda;
begin
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

procedure TLojaModelVendaTest.Test_NaoAtualizarItemVenda_ItemInexistente;
begin
  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem := CriarItem('Teste atualizar na venda','');
  var LPreco := CriarPrecoVenda(LITem.CodItem, 10, Now);
  RealizarAcertoEstoque(LItem.CodItem, 2);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 2;

    var LItemVenda := TLojaModelFactory.New.Venda.InserirItemVenda(LDto);
    var LVenda := TLojaModelFactory.New.Venda.ObterVenda(LNovaVenda.NumVnda);

    LDto.NumSeqItem := LItemVenda.NumSeqItem;
    LDto.CodItem := MaxInt;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.AtualizarItemVenda(LDto);
      end,
      EHorseException,
      'N�o foi poss�vel encontrar o item informado'
    );

    LDto.Free;
    LItemVenda.Free;
    LVenda.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoAtualizarItemVenda_ItemNaoInserido;
begin
  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem := CriarItem('Teste atualizar na venda','');
  var LPreco := CriarPrecoVenda(LITem.CodItem, 10, Now);
  RealizarAcertoEstoque(LItem.CodItem, 2);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 2;
    LDto.NumSeqItem := MaxInt;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.AtualizarItemVenda(LDto);
      end,
      EHorseException,
      'N�o foi poss�vel encontrar item deste sequencial na venda informada'
    );

    LDto.Free;

  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoAtualizarItemVenda_ItemRemovido;
begin
  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem := CriarItem('Teste atualizar na venda','');
  var LPreco := CriarPrecoVenda(LITem.CodItem, 10, Now);
  RealizarAcertoEstoque(LItem.CodItem, 2);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 2;

    var LItemVenda := TLojaModelFactory.New.Venda.InserirItemVenda(LDto);
    var LVenda := TLojaModelFactory.New.Venda.ObterVenda(LNovaVenda.NumVnda);

    LDto.NumSeqItem := LItemVenda.NumSeqItem;
    LDto.QtdItem := 3;
    LDto.CodSit := TLojaModelEntityVendaItemSituacao.sitRemovido;

    var LItemAtualizado := TLojaModelFactory.New.Venda.AtualizarItemVenda(LDto);
    var LVendaAtualizada := TLojaModelFactory.New.Venda.ObterVenda(LNovaVenda.NumVnda);

    LDto.QtdItem := 1;
    LDto.CodSit := TLojaModelEntityVendaItemSituacao.sitAtivo;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.AtualizarItemVenda(LDto);
      end,
      EHorseException,
      'Este item foi removido da venda, portanto n�o pode ser alterado'
    );

    LDto.Free;
    LItemVenda.Free;
    LVenda.Free;
    LItemAtualizado.Free;
    LVendaAtualizada.Free;

  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoAtualizarItemVenda_QuantidadeInvalida;
begin
  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem := CriarItem('Teste atualizar na venda','');
  var LPreco := CriarPrecoVenda(LITem.CodItem, 10, Now);
  RealizarAcertoEstoque(LItem.CodItem, 2);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 2;

    var LItemVenda := TLojaModelFactory.New.Venda.InserirItemVenda(LDto);
    var LVenda := TLojaModelFactory.New.Venda.ObterVenda(LNovaVenda.NumVnda);

    LDto.NumSeqItem := LItemVenda.NumSeqItem;
    LDto.QtdItem := -1;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.AtualizarItemVenda(LDto);
      end,
      EHorseException,
      'A quantidade do item vendido dever� ser superior a zero'
    );

    LDto.Free;
    LItemVenda.Free;
    LVenda.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
    LPreco.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoAtualizarItemVenda_SemPrecoImplantado;
begin
  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem1 := CriarItem('Teste atualizar na venda','');
  var LItem2 := CriarItem('Teste atualizar na venda sem pre�o','');
  var LPreco := CriarPrecoVenda(LItem1.CodItem, 10, Now);
  RealizarAcertoEstoque(LItem1.CodItem, 2);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem1.CodItem;
    LDto.QtdItem := 2;

    var LItemVenda := TLojaModelFactory.New.Venda.InserirItemVenda(LDto);
    var LVenda := TLojaModelFactory.New.Venda.ObterVenda(LNovaVenda.NumVnda);

    LDto.NumSeqItem := LItemVenda.NumSeqItem;
    LDto.CodItem := LItem2.CodItem;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.AtualizarItemVenda(LDto);
      end,
      EHorseException,
      'N�o h� pre�o de venda implantado para o item'
    );

    LDto.Free;
    LItemVenda.Free;
    LVenda.Free;
  finally
    LNovaVenda.Free;
    LItem1.Free;
    LItem2.Free;
    LPreco.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoAtualizarItemVenda_ValorTotalNegativo;
begin
  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  var LItem := CriarItem('Teste atualizar na venda','');
  var LPreco := CriarPrecoVenda(LITem.CodItem, 10, Now);
  RealizarAcertoEstoque(LItem.CodItem, 2);

  try
    var LDto := TLojaModelDtoReqVendaItem.Create;
    LDto.NumVnda := LNovaVenda.NumVnda;
    LDto.CodItem := LItem.CodItem;
    LDto.QtdItem := 2;

    var LItemVenda := TLojaModelFactory.New.Venda.InserirItemVenda(LDto);
    var LVenda := TLojaModelFactory.New.Venda.ObterVenda(LNovaVenda.NumVnda);

    LDto.NumSeqItem := LItemVenda.NumSeqItem;
    LDto.VrDesc := 100;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.AtualizarItemVenda(LDto);
      end,
      EHorseException,
      'O valor total do item n�o pode ser negativo'
    );

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
    'N�o foi poss�vel encontrar a venda pelo n�mero informado'
  );
end;

procedure TLojaModelVendaTest.Test_NaoCancelarVenda_NaoPendente;
begin
  var LNovaVenda := TLojaModelFactory.New.Venda.NovaVenda;
  try
    var LCancelada := TLojaModelFactory.New.Venda.CancelarVenda(LNovaVenda.NumVnda);
    LCancelada.Free;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New.Venda.CancelarVenda(LNovaVenda.NumVnda);
      end,
      EHorseException,
      'A venda informada n�o est� Pendente'
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
    'O n�mero de venda informado � inv�lido'
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
    'N�o h� caixa aberto'
  );

  AbrirCaixa(0);
end;

procedure TLojaModelVendaTest.Test_NaoInserirItemVenda_ItemInexistente;
begin
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
      'N�o foi poss�vel encontrar o item informado'
    );

    LDto.Free;
  finally
    LNovaVenda.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoInserirItemVenda_QuantidadeInvalida;
begin
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
      'A quantidade do item vendido dever� ser superior a zero'
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
      'N�o h� pre�o de venda implantado para o item'
    );

    LDto.Free;
  finally
    LNovaVenda.Free;
    LItem.Free;
  end;
end;

procedure TLojaModelVendaTest.Test_NaoInserirItemVenda_ValorTotalNegativo;
begin
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
      'O valor total do item n�o pode ser negativo'
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
      'A venda informada n�o est� Pendente'
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
