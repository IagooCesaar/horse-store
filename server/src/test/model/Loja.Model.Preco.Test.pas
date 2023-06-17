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

    [Test]
    procedure Test_ObterPrecoVendaAtual;

    [Test]
    procedure Test_NaoObterPrecoVendaAtual_ItemInexistente;

    [Test]
    procedure Test_ObterHistoricoPrecoVenda;

    [Test]
    procedure Test_NaoObterHistoricoPrecoVenda_ItemInexistente;
  end;

implementation

uses
  Horse,
  Horse.Exception,
  System.DateUtils,

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

procedure TLojaModelPrecoTest.Test_NaoObterHistoricoPrecoVenda_ItemInexistente;
begin
  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New
        .Preco
        .ObterHistoricoPrecoVendaItem(-1, Now);
    end,
    EHorseException,
    'Não foi possível encontrar o item pelo código informado'
  );
end;

procedure TLojaModelPrecoTest.Test_NaoObterPrecoVendaAtual_ItemInexistente;
begin
  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New
        .Preco
        .ObterPrecoVendaAtual(-1);
    end,
    EHorseException,
    'Não foi possível encontrar o item pelo código informado'
  );
end;

procedure TLojaModelPrecoTest.Test_ObterHistoricoPrecoVenda;
var LDat1, LDat2, LDat3, LDat4: TDateTime;

  procedure CriarPrecoVenda(ACodItem: Integer; ADatIni: TDateTime; AVr: Currency);
  begin
    var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
    LDto.CodItem := ACodItem;
    LDto.DatIni := ADatIni;
    LDto.VrVnda := AVr;

    var LPreco := TLojaModelFactory.New
      .Preco
      .CriarPrecoVendaItem(LDto);

    LDto.Free;
    LPreco.Free;
  end;

begin
  LDat1 := IncDay(Now, -7);
  LDat2 := IncDay(Now, -5);
  LDat3 := IncDay(Now,  0);
  LDat4 := IncDay(Now, +5);

  var LItemCriado := CriarItem('TLojaModelPrecoTest.Test_CriarPrecoVenda', '');

  CriarPrecoVenda(LItemCriado.CodItem, LDat4, 8.99);
  CriarPrecoVenda(LItemCriado.CodItem, LDat3, 5.99);

  CriarPrecoVenda(LItemCriado.CodItem, LDat1, 1.99);
  CriarPrecoVenda(LItemCriado.CodItem, LDat2, 2.99);

  var LHistorico1 := TLojaModelFactory.New
    .Preco
    .ObterHistoricoPrecoVendaItem(LItemCriado.CodItem, IncDay(LDat1,1) );

  Assert.AreEqual(4, LHistorico1.Count);
  Assert.AreEqual(Double(1.99), Double(LHistorico1.First.VrVnda));
  Assert.AreEqual(Double(8.99), Double(LHistorico1.Last.VrVnda));

  var LHistorico2 := TLojaModelFactory.New
    .Preco
    .ObterHistoricoPrecoVendaItem(LItemCriado.CodItem, IncDay(LDat2,1) );

  Assert.AreEqual(3, LHistorico2.Count);
  Assert.AreEqual(Double(2.99), Double(LHistorico2.First.VrVnda));
  Assert.AreEqual(Double(8.99), Double(LHistorico2.Last.VrVnda));

  LItemCriado.Free;
  LHistorico1.Free;
  LHistorico2.Free;
end;

procedure TLojaModelPrecoTest.Test_ObterPrecoVendaAtual;
begin
  var LItemCriado := CriarItem('TLojaModelPrecoTest.Test_CriarPrecoVenda', '');
  var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
  LDto.CodItem := LItemCriado.CodItem;
  LDto.DatIni := IncDay(Now, -7);
  LDto.VrVnda := 1.99;

  var LPreco1 := TLojaModelFactory.New
    .Preco
    .CriarPrecoVendaItem(LDto);

  Assert.AreEqual(LDto.VrVnda, LPreco1.VrVnda);
  Assert.AreEqual(LDto.DatIni, LPreco1.DatIni);

  LDto.DatIni := IncDay(Now, +7);
  LDto.VrVnda := 2.99;

  var LPreco2 := TLojaModelFactory.New
    .Preco
    .CriarPrecoVendaItem(LDto);

  Assert.AreEqual(LDto.VrVnda, LPreco2.VrVnda);
  Assert.AreEqual(LDto.DatIni, LPreco2.DatIni);

  var LPrecoAtual := TLojaModelFactory.New
    .Preco
    .ObterPrecoVendaAtual(LItemCriado.CodItem);

  Assert.AreEqual(LPreco1.VrVnda, LPrecoAtual.VrVnda);

  LPreco1.Free;
  LPreco2.Free;
  LDto.Free;
  LItemCriado.Free;
  LPrecoAtual.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelPrecoTest);

end.
