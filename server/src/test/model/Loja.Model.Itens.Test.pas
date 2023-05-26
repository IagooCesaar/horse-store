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
