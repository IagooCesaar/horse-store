unit Loja.Model.Itens.Test;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TLojaModelItensTest = class
  public
    [SetupFixture]
    procedure SetupFixture;
    [TearDownFixture]
    procedure TearDownFixture;

    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test_ObterItemPorCodigo;

    [Test]
    procedure Test_ObterItemPorCodigoBarras;

    [Test]
    procedure Test_NaoObterItemInexistente;

    [Test]
    procedure Test_NaoObterItemNumCodBarInexistente;

    [Test]
    procedure Test_NaoObterItemCriterioInsuficiente;

    [Test]
    procedure Test_CriarUmNovoItem;

    [Test]
    procedure Test_NaoCriarItemComDescricaoPequena;

    [Test]
    procedure Test_NaoCriarItemComDescricaoGrande;

    [Test]
    procedure Test_NaoCriarItemComCodigoBarrasGrande;

    [Test]
    procedure Test_ObterItensCadastrados;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Interfaces,
  Loja.Model.Dao.Factory,

  Loja.Model.Itens,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Itens.FiltroItens;

procedure TLojaModelItensTest.Setup;
begin

end;

procedure TLojaModelItensTest.SetupFixture;
begin
  TLojaModelDaoFactory.InMemory := True;
end;

procedure TLojaModelItensTest.TearDown;
begin
end;

procedure TLojaModelItensTest.TearDownFixture;
begin
  TLojaModelDaoFactory.InMemory := False;
end;


procedure TLojaModelItensTest.Test_CriarUmNovoItem;
var LDTONovoItem : TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'Novo Item';
    LDTONovoItem.NumCodBarr := '123456789';

    var LItem := TLojaModelItens.New
      .CriarItem(LDTONovoItem);

    Assert.IsTrue(LItem <> nil);
    Assert.AreEqual(LDTONovoItem.NomItem, LItem.NomItem, 'O nome não coincide');
    Assert.AreEqual(LDTONovoItem.NumCodBarr, Litem.NumCodBarr, 'O código de barras não coincide');

    LItem.Free;
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoCriarItemComCodigoBarrasGrande;
var LDTONovoItem : TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'abc123';
    LDTONovoItem.NumCodBarr := '0123456789012345';
    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelItens.New
          .CriarItem(LDTONovoItem);
      end,
      EHorseException,
      'O código de barras deverá ter no máximo'
    );
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoCriarItemComDescricaoGrande;
var LDTONovoItem : TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := '01234567890123456789012345678901234567890123456789'+
      '01234567890123456789012345678901234567890123456789AAAAAA';
    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelItens.New
          .CriarItem(LDTONovoItem);
      end,
      EHorseException,
      'O nome do item deverá ter no máximo'
    );
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoCriarItemComDescricaoPequena;
var LDTONovoItem : TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'abc';
    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelItens.New
          .CriarItem(LDTONovoItem);
      end,
      EHorseException,
      'O nome do item deverá ter no mínimo'
    );
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoObterItemCriterioInsuficiente;
begin
  var LFiltro := TLojaModelDtoReqItensFiltroItens.Create;
  LFiltro.NomItem := '';
  LFiltro.NumCodBarr := '';
  try
    Assert.WillRaiseWithMessage(
      procedure begin
        TLojaModelItens.New.ObterItens(LFiltro);
      end,
      EHorseException,
      'Você deve informar um critério para filtro'
    );
  finally
    LFiltro.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoObterItemInexistente;
begin
  Assert.WillRaiseWithMessage(
    procedure begin
      TLojaModelItens.New
        .ObterPorCodigo(0);
    end,
    EHorseException,
    'Não foi possível encontrar o item pelo código informado'
  );
end;

procedure TLojaModelItensTest.Test_NaoObterItemNumCodBarInexistente;
begin
  Assert.WillRaiseWithMessage(
    procedure begin
      TLojaModelItens.New
        .ObterPorNumCodBarr('9182,456');
    end,
    EHorseException,
    'Não foi possível encontrar o item pelo código de barras informado'
  );
end;

procedure TLojaModelItensTest.Test_ObterItemPorCodigo;
var LDTONovoItem : TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'Novo Item';
    LDTONovoItem.NumCodBarr := '1919191919';

    var LItemCriado := TLojaModelDaoFactory.New.Itens
      .Item
      .CriarItem(LDTONovoItem);

    var LItem := TLojaModelItens.New
      .ObterPorCodigo(LItemCriado.CodItem);

    Assert.IsTrue(Assigned(LItem), 'Não foi possível encontrar o item código 1');
    Assert.AreEqual(LDTONovoItem.NomItem, LItem.NomItem);

    LItemCriado.Free;
    LItem.Free;
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelItensTest.Test_ObterItemPorCodigoBarras;
var LDTONovoItem : TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'Novo Item';
    LDTONovoItem.NumCodBarr := '987654321';

    var LItemCriado := TLojaModelDaoFactory.New.Itens
      .Item
      .CriarItem(LDTONovoItem);

    var LItem := TLojaModelItens.New
      .ObterPorNumCodBarr(LItemCriado.NumCodBarr);

    Assert.IsTrue(Assigned(LItem), 'Não foi possível encontrar o item');
    Assert.AreEqual(LDTONovoItem.NomItem, LItem.NomItem);

    LItemCriado.Free;
    LItem.Free;
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelItensTest.Test_ObterItensCadastrados;
var
  LDTONovoItem : TLojaModelDtoReqItensCriarItem;
  LDTOFiltro: TLojaModelDtoReqItensFiltroItens;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'Pesquisar Item';
    LDTONovoItem.NumCodBarr := '1919191919';

    var LItemCriado := TLojaModelDaoFactory.New.Itens
      .Item
      .CriarItem(LDTONovoItem);

    LDTOFiltro := TLojaModelDtoReqItensFiltroItens.Create;
    try
      LDTOFiltro.NomItem := 'Pesq';

      var LItens := TLojaModelItens.New
        .ObterItens(LDTOFiltro);

      Assert.IsTrue(Assigned(LItens));
      Assert.IsTrue(LItens.Count>0);
      LItens.Free;
    finally
      LDTOFiltro.Free;
    end;

    LDTOFiltro := TLojaModelDtoReqItensFiltroItens.Create;
    try
      LDTOFiltro.NumCodBarr := '19';

      var LItens := TLojaModelItens.New
        .ObterItens(LDTOFiltro);

      Assert.IsTrue(Assigned(LItens));
      Assert.IsTrue(LItens.Count>0);
      LItens.Free;
    finally
      LDTOFiltro.Free;
    end;
    LItemCriado.Free;
  finally
    LDTONovoItem.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelItensTest);

end.
