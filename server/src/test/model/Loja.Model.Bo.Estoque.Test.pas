unit Loja.Model.Bo.Estoque.Test;

interface

uses
  DUnitX.TestFramework,

  Loja.Model.Entity.Itens.Item;

type
  [TestFixture]
  TLojaModelBoEstoqueTest = class
  private
    function CriarItem: TLojaModelEntityItensItem;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure Test_CriarFechamentosSaldo;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,

  Loja.Model.Dao.Factory,
  Loja.Model.Bo.Factory,

  Loja.Model.Entity.Estoque.Types,
  Loja.Model.Dto.Req.Estoque.CriarMovimento,
  Loja.Model.Dto.Req.Itens.CriarItem;

{ TLojaModelBoEstoqueTest }

function TLojaModelBoEstoqueTest.CriarItem: TLojaModelEntityItensItem;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
  LDTONovoItem: TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'TLojaModelBoEstoqueTest.CriarItem';
    Result := TLojaModelDaoFactory.New.Itens.Item.CriarItem(LDTONovoItem);
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelBoEstoqueTest.SetupFixture;
begin
  TLojaModelDaoFactory.InMemory := True;
end;

procedure TLojaModelBoEstoqueTest.TearDownFixture;
begin
  TLojaModelDaoFactory.InMemory := False;
end;

procedure TLojaModelBoEstoqueTest.Test_CriarFechamentosSaldo;
begin
  // Criar um fechamento para cada mês, com o saldo esperado, até "hoje"
  // Gerar movimentos em meses diferentes e então mandar gerar o fechamento
  // deverá haver um fechamento para cada mês entre o 1º e o último movimento
  // se último movimento for no mês atual, o último fechamento será no mês anterior

  var LItem := CriarItem;
  var LDTOMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  LDTOMovimento.CodItem := LItem.CodItem;
  LItem.Free;
  try
    LDTOMovimento.DatMov := EncodeDate(2023, 01, 15);
    LDTOMovimento.QtdMov := 10;
    LDTOMovimento.CodTipoMov := movEntrada;
    LDTOMovimento.CodOrigMov := orgCompra;
    LDTOMovimento.DscMot := '';

    var M1 := TLojaModelDaoFactory.New.Estoque.Movimento.CriarNovoMovimento(LDTOMovimento);
    M1.Free;

    LDTOMovimento.DatMov := EncodeDate(2023, 02, 09);
    LDTOMovimento.QtdMov := 2;
    LDTOMovimento.CodTipoMov := movSaida;
    LDTOMovimento.CodOrigMov := orgVenda;

    var M2 := TLojaModelDaoFactory.New.Estoque.Movimento.CriarNovoMovimento(LDTOMovimento);
    M2.Free;

    LDTOMovimento.DatMov := EncodeDate(2023, 02, 25);
    LDTOMovimento.QtdMov := 3;
    LDTOMovimento.CodTipoMov := movSaida;
    LDTOMovimento.CodOrigMov := orgVenda;

    var M3 := TLojaModelDaoFactory.New.Estoque.Movimento.CriarNovoMovimento(LDTOMovimento);
    M3.Free;

    LDTOMovimento.DatMov := EncodeDate(2023, 04, 10);
    LDTOMovimento.QtdMov := 12;
    LDTOMovimento.CodTipoMov := movEntrada;
    LDTOMovimento.CodOrigMov := orgCompra;

    var M4 := TLojaModelDaoFactory.New.Estoque.Movimento.CriarNovoMovimento(LDTOMovimento);
    M4.Free;

    LDTOMovimento.DatMov := EncodeDate(2023, 05, 09);
    LDTOMovimento.QtdMov := 8;
    LDTOMovimento.CodTipoMov := movSaida;
    LDTOMovimento.CodOrigMov := orgVenda;

    var M5 := TLojaModelDaoFactory.New.Estoque.Movimento.CriarNovoMovimento(LDTOMovimento);
    M5.Free;

    TLojaModelBoFactory.New.Estoque.FechamentoSaldo.FecharSaldoMensalItem(LDTOMovimento.CodItem);

    //Obter lista de fechamentos de um item
    var LFechamentos := TLojaModelDaoFactory.New.Estoque.Saldo.ObterFechamentosItem(
      LDTOMovimento.CodItem,
      EndOfTheMonth(EncodeDate(2023, 01, 15)),
      EndOfTheMonth(EncodeDate(2023, 05, 09))
    );

    Assert.AreEqual(5, LFechamentos.Count);
    Assert.AreEqual(9, LFechamentos.Last.QtdSaldo);

    LFechamentos.Free;

  finally
    LDTOMovimento.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelBoEstoqueTest);

end.
