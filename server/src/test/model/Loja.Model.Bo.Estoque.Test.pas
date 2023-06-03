unit Loja.Model.Bo.Estoque.Test;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TLojaModelBoEstoqueTest = class
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
  Loja.Model.Dto.Req.Estoque.CriarMovimento;

{ TLojaModelBoEstoqueTest }

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
  // Criar um fechamento para cada m�s, com o saldo esperado, at� "hoje"
  // Gerar movimentos em meses diferentes e ent�o mandar gerar o fechamento
  // dever� haver um fechamento para cada m�s entre o 1� e o �ltimo movimento
  // se �ltimo movimento for no m�s atual, o �ltimo fechamento ser� no m�s anterior

  var LDTOMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTOMovimento.CodItem := 1;
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
      LDTOMovimento.CodItem, EncodeDate(2023, 01, 15), EncodeDate(2023, 05, 09)
    );

    Assert.AreEqual(5, LFechamentos.Count);
    LFechamentos.Free;

  finally
    LDTOMovimento.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelBoEstoqueTest);

end.
