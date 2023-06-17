unit Loja.Model.Preco.Test;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem;

type
  [TestFixture]
  TLojaModelPrecoTest = class
  private
    function CriarItem(ANome, ACodBarr: String): TLojaModelEntityItensItem;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure Test_CriarPrecoVenda;

    [Test]
    procedure Test_NaoCriarPrecoVenda_ItemInexiste;

    [Test]
    procedure Test_NaoCriarPrecoVenda_ValorNegativo;

    [Test]
    procedure Test_NaoCriarPrecoVenda_PrecoJaExistente;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Factory,
  Loja.Model.Dao.Factory,
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda;

{ TLojaModelPrecoTest }

function TLojaModelPrecoTest.CriarItem(ANome, ACodBarr: String): TLojaModelEntityItensItem;
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

procedure TLojaModelPrecoTest.SetupFixture;
begin
  TLojaModelDaoFactory.InMemory := True;
end;

procedure TLojaModelPrecoTest.TearDownFixture;
begin
  TLojaModelDaoFactory.InMemory := False;
end;

procedure TLojaModelPrecoTest.Test_CriarPrecoVenda;
begin
  var LItemCriado := CriarItem('TLojaModelPrecoTest.Test_CriarPrecoVenda', '');
  var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
  LDto.CodItem := LItemCriado.CodItem;
  LDto.DatIni := Now;
  LDto.VrVnda := 1.99;

  var LPreco := TLojaModelFactory.New
    .Preco
    .CriarPrecoVendaItem(LDto);

  Assert.AreEqual(LDto.VrVnda, LPreco.VrVnda);
  Assert.AreEqual(LDto.DatIni, LPreco.DatIni);

  LPreco.Free;
  LDto.Free;
  LItemCriado.Free;
end;

procedure TLojaModelPrecoTest.Test_NaoCriarPrecoVenda_ItemInexiste;
begin
  var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
  LDto.CodItem := -1;
  LDto.DatIni := Now;
  LDto.VrVnda := 1.99;

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New
        .Preco
        .CriarPrecoVendaItem(LDto);
    end,
    EHorseException,
    'Não foi possível encontrar o item pelo código informado'
  );

  LDto.Free;
end;

procedure TLojaModelPrecoTest.Test_NaoCriarPrecoVenda_PrecoJaExistente;
begin
  var LItemCriado := CriarItem('TLojaModelPrecoTest.Test_NaoCriarPrecoVenda_PrecoJaExistente', '');

  var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
  LDto.CodItem := LItemCriado.CodItem;
  LDto.DatIni := Now;
  LDto.VrVnda := 1.99;

  var LPreco := TLojaModelFactory.New
    .Preco
    .CriarPrecoVendaItem(LDto);

  LDto.VrVnda := 2.01;

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New
        .Preco
        .CriarPrecoVendaItem(LDto);
    end,
    EHorseException,
    'Já existe um preço configurado para inicar na data informada'
  );

  LDto.Free;
  LPreco.Free;
  LItemCriado.Free;
end;

procedure TLojaModelPrecoTest.Test_NaoCriarPrecoVenda_ValorNegativo;
begin
  var LItemCriado := CriarItem('TLojaModelPrecoTest.Test_NaoCriarPrecoVenda_ValorNegativo', '');

  var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
  LDto.CodItem := LItemCriado.CodItem;
  LDto.DatIni := Now;
  LDto.VrVnda := -0.01;

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New
        .Preco
        .CriarPrecoVendaItem(LDto);
    end,
    EHorseException,
    'O valor de venda deve ser maior que zero'
  );

  LDto.Free;
  LItemCriado.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelPrecoTest);

end.
