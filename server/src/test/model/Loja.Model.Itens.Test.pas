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
    procedure Test_NaoObterItemInexistente;

    [Test]
    procedure Test_CriarUmNovoItem;

    [Test]
    procedure Test_NaoCriarItemComDescricaoPequena;

    [Test]
    procedure Test_NaoCriarItemComDescricaoGrande;

    [Test]
    procedure Test_NaoCriarItemComCodigoBarrasGrande;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Interfaces,
  Loja.Model.Dao.Factory,

  Loja.Model.Itens,
  Loja.Model.Dto.Req.Itens.CriarItem;

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
var LNovoItem : TLojaModelDtoReqItensCriarItem;
begin
  LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LNovoItem.NomItem := 'Novo Item';
    LNovoItem.NumCodBarr := '123456789';

    var LItem := TLojaModelItens.New
      .CriarItem(LNovoItem);

    Assert.IsTrue(LItem <> nil);
    Assert.AreEqual(LNovoItem.NomItem, LItem.NomItem, 'O nome não coincide');
    Assert.AreEqual(LNovoItem.NumCodBarr, Litem.NumCodBarr, 'O código de barras não coincide');
  finally
    LNovoItem.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoCriarItemComCodigoBarrasGrande;
var LNovoItem : TLojaModelDtoReqItensCriarItem;
begin
  LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LNovoItem.NomItem := 'abc123';
    LNovoItem.NumCodBarr := '0123456789012345';
    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelItens.New
          .CriarItem(LNovoItem);
      end,
      EHorseException,
      'O código de barras deverá ter no máximo'
    );
  finally
    LNovoItem.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoCriarItemComDescricaoGrande;
var LNovoItem : TLojaModelDtoReqItensCriarItem;
begin
  LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LNovoItem.NomItem := '01234567890123456789012345678901234567890123456789'+
      '01234567890123456789012345678901234567890123456789AAAAAA';
    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelItens.New
          .CriarItem(LNovoItem);
      end,
      EHorseException,
      'O nome do item deverá ter no máximo'
    );
  finally
    LNovoItem.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoCriarItemComDescricaoPequena;
var LNovoItem : TLojaModelDtoReqItensCriarItem;
begin
  LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LNovoItem.NomItem := 'abc';
    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelItens.New
          .CriarItem(LNovoItem);
      end,
      EHorseException,
      'O nome do item deverá ter no mínimo'
    );
  finally
    LNovoItem.Free;
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

procedure TLojaModelItensTest.Test_ObterItemPorCodigo;
var LNovoItem : TLojaModelDtoReqItensCriarItem;
begin
  LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LNovoItem.NomItem := 'Novo Item';
    LNovoItem.NumCodBarr := '1919191919';

    TLojaModelDaoFactory.New.Itens
      .Item
      .CriarItem(LNovoItem);


    var LItem := TLojaModelItens.New
      .ObterPorCodigo(1);

    Assert.IsTrue(Assigned(LItem), 'Não foi possível encontrar o item código 1');
    Assert.AreEqual(LNovoItem.NomItem, LItem.NomItem);
  finally
    LNovoItem.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelItensTest);

end.
