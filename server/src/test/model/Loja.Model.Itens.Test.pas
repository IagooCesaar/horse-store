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
    procedure Test_NaoCriarItemComCodigoBarrasRepetido;

    [Test]
    procedure Test_ObterItensCadastrados;

    [Test]
    procedure Test_AtualizarUmNovoItem;

    [Test]
    procedure Test_NaoAtualizarItemComDescricaoPequena;

    [Test]
    procedure Test_NaoAtualizarItemComDescricaoGrande;

    [Test]
    procedure Test_NaoAtualizarItemComCodigoBarrasGrande;

    [Test]
    procedure Test_NaoAtualizarItem_ItemInexistente;

    [Test]
    procedure Test_NaoAtualizarItem_CodigoBarrasRepetido;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Interfaces,
  Loja.Model.Dao.Factory,

  Loja.Model.Itens,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Itens.FiltroItens,
  Loja.infra.Utils.Funcoes;

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


procedure TLojaModelItensTest.Test_AtualizarUmNovoItem;
var LDto : TLojaModelDtoReqItensCriarItem;
begin
  LDto := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDto.NomItem := 'Novo Item';
    LDto.NumCodBarr := '192837645';

    var LItemCriado := TLojaModelItens.New
      .CriarItem(LDto);

    Assert.IsTrue(LItemCriado <> nil);
    Assert.AreEqual(LDto.NomItem, LItemCriado.NomItem, 'O nome n�o coincide');
    Assert.AreEqual(LDto.NumCodBarr, LItemCriado.NumCodBarr, 'O c�digo de barras n�o coincide');

    LDto.NomItem := 'Nome atualizado';
    LDto.NumCodBarr := '73826142851';
    LDto.CodItem := LItemCriado.CodItem;

    var LItemAtualizado := TLojaModelItens.New
      .AtualizarItem(LDto);

    Assert.IsTrue(LItemAtualizado <> nil);
    Assert.AreEqual(LDto.NomItem, LItemAtualizado.NomItem, 'O nome n�o coincide');
    Assert.AreEqual(LDto.NumCodBarr, LItemAtualizado.NumCodBarr, 'O c�digo de barras n�o coincide');

    LItemCriado.Free;
    LItemAtualizado.Free;
  finally
    LDto.Free;
  end;
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
    Assert.AreEqual(LDTONovoItem.NomItem, LItem.NomItem, 'O nome n�o coincide');
    Assert.AreEqual(LDTONovoItem.NumCodBarr, Litem.NumCodBarr, 'O c�digo de barras n�o coincide');
    Assert.IsFalse(LItem.FlgPermSaldNeg);
    Assert.IsTrue(LItem.FlgTabPreco);

    LItem.Free;
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoAtualizarItemComCodigoBarrasGrande;
var LDto : TLojaModelDtoReqItensCriarItem;
begin
  LDto := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDto.NomItem := 'Novo Item';
    LDto.NumCodBarr := '164379285';

    var LItemCriado := TLojaModelItens.New
      .CriarItem(LDto);

    Assert.IsTrue(LItemCriado <> nil);
    Assert.AreEqual(LDto.NomItem, LItemCriado.NomItem, 'O nome n�o coincide');
    Assert.AreEqual(LDto.NumCodBarr, LItemCriado.NumCodBarr, 'O c�digo de barras n�o coincide');

    LDto.NomItem := 'abc123';
    LDto.NumCodBarr := '987654321987654321987654321';
    LDto.CodItem := LItemCriado.CodItem;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelItens.New
          .AtualizarItem(LDto);
      end,
      EHorseException,
      'O c�digo de barras dever� ter no m�ximo'
    );

    LItemCriado.Free;
  finally
    LDto.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoAtualizarItemComDescricaoGrande;
var LDto : TLojaModelDtoReqItensCriarItem;
begin
  LDto := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDto.NomItem := 'Novo Item';
    LDto.NumCodBarr := '794613825';

    var LItemCriado := TLojaModelItens.New
      .CriarItem(LDto);

    Assert.IsTrue(LItemCriado <> nil);
    Assert.AreEqual(LDto.NomItem, LItemCriado.NomItem, 'O nome n�o coincide');
    Assert.AreEqual(LDto.NumCodBarr, LItemCriado.NumCodBarr, 'O c�digo de barras n�o coincide');

    LDto.NomItem := '01234567890123456789012345678901234567890123456789'+
      '01234567890123456789012345678901234567890123456789AAAAAA';
    LDto.NumCodBarr := '794613285';
    LDto.CodItem := LItemCriado.CodItem;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelItens.New
          .AtualizarItem(LDto);
      end,
      EHorseException,
      'O nome do item dever� ter no m�ximo'
    );

    LItemCriado.Free;
  finally
    LDto.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoAtualizarItemComDescricaoPequena;
var LDto : TLojaModelDtoReqItensCriarItem;
begin
  LDto := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDto.NomItem := 'Novo Item';
    LDto.NumCodBarr := '147258369';

    var LItemCriado := TLojaModelItens.New
      .CriarItem(LDto);

    Assert.IsTrue(LItemCriado <> nil);
    Assert.AreEqual(LDto.NomItem, LItemCriado.NomItem, 'O nome n�o coincide');
    Assert.AreEqual(LDto.NumCodBarr, LItemCriado.NumCodBarr, 'O c�digo de barras n�o coincide');

    LDto.NomItem := 'abc';
    LDto.NumCodBarr := '963852741';
    LDto.CodItem := LItemCriado.CodItem;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelItens.New
          .AtualizarItem(LDto);
      end,
      EHorseException,
      'O nome do item dever� ter no m�nimo'
    );

    LItemCriado.Free;
  finally
    LDto.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoAtualizarItem_CodigoBarrasRepetido;
var LDTONovoItem : TLojaModelDtoReqItensCriarItem;
begin
  var LNumCodBarr := TLojaInfraUtilsFuncoes.GeraStringRandomica(14,1);
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'Novo Item 1';
    LDTONovoItem.NumCodBarr := LNumCodBarr;

    var LItem1 := TLojaModelItens.New.CriarItem(LDTONovoItem);
    Assert.IsTrue(LItem1 <> nil);
    LItem1.Free;

    LDTONovoItem.NomItem := 'Novo Item 2';
    LDTONovoItem.NumCodBarr := '';

    var LItem2 := TLojaModelItens.New.CriarItem(LDTONovoItem);
    Assert.IsTrue(LItem2 <> nil);

    LDTONovoItem.CodItem := LItem2.CodItem;
    LDTONovoItem.NumCodBarr := LNumCodBarr;

    try
      Assert.WillRaiseWithMessageRegex(
        procedure begin
          TLojaModelItens.New
            .AtualizarItem(LDTONovoItem);
        end,
        EHorseException,
        'J� existe um item cadastrado com este c�digo de barras'
      );
    finally
      LItem2.Free;
    end;
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoAtualizarItem_ItemInexistente;
var LDto : TLojaModelDtoReqItensCriarItem;
begin
  LDto := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDto.NomItem := 'Novo Item';
    LDto.NumCodBarr := '739182465';

    var LItemCriado := TLojaModelItens.New
      .CriarItem(LDto);

    Assert.IsTrue(LItemCriado <> nil);
    Assert.AreEqual(LDto.NomItem, LItemCriado.NomItem, 'O nome n�o coincide');
    Assert.AreEqual(LDto.NumCodBarr, LItemCriado.NumCodBarr, 'O c�digo de barras n�o coincide');

    LDto.NomItem := 'abc123';
    LDto.NumCodBarr := '1234567890';
    LDto.CodItem := -1;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelItens.New
          .AtualizarItem(LDto);
      end,
      EHorseException,
      'N�o foi poss�vel encontrar o item pelo c�digo informado'
    );

    LItemCriado.Free;
  finally
    LDto.Free;
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
      'O c�digo de barras dever� ter no m�ximo'
    );
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelItensTest.Test_NaoCriarItemComCodigoBarrasRepetido;
var LDTONovoItem : TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'Novo Item';
    LDTONovoItem.NumCodBarr := TLojaInfraUtilsFuncoes.GeraStringRandomica(14,1);

    var LItem := TLojaModelItens.New.CriarItem(LDTONovoItem);
    Assert.IsTrue(LItem <> nil);

    try
      Assert.WillRaiseWithMessageRegex(
        procedure begin
          TLojaModelItens.New
            .CriarItem(LDTONovoItem);
        end,
        EHorseException,
        'J� existe um item cadastrado com este c�digo de barras'
      );
    finally
      LItem.Free;
    end;
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
      'O nome do item dever� ter no m�ximo'
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
      'O nome do item dever� ter no m�nimo'
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
      'Voc� deve informar um crit�rio para filtro'
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
    'N�o foi poss�vel encontrar o item pelo c�digo informado'
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
    'N�o foi poss�vel encontrar o item pelo c�digo de barras informado'
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

    Assert.IsTrue(Assigned(LItem), 'N�o foi poss�vel encontrar o item c�digo 1');
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

    Assert.IsTrue(Assigned(LItem), 'N�o foi poss�vel encontrar o item');
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
