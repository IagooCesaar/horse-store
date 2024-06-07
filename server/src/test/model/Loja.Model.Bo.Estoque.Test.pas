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

    [Test]
    procedure Test_CriarFechamentosSaldo_PreencheLacunas;

    [Test]
    procedure Test_CriarFechamentosSaldo_PreencheLacunasMesmoSemMov;

    [Test]
    procedure Test_NaoCriarFechamentosSaldo_DataRepetida;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  Horse,
  Horse.Exception,

  Loja.Environment.Interfaces,
  Loja.Model.Factory,
  Loja.Model.Dao.Factory,
  Loja.Model.Bo.Factory,

  Loja.Model.Entity.Estoque.Types,
  Loja.Model.Dto.Req.Estoque.CriarMovimento,
  Loja.Model.Dto.Req.Itens.CriarItem;

{ TLojaModelBoEstoqueTest }

function InMemory: ILojaEnvironmentRuler;
begin
  Result := TLojaModelFactory.InMemory.Ruler;
end;

function TLojaModelBoEstoqueTest.CriarItem: TLojaModelEntityItensItem;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
  LDTONovoItem: TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'TLojaModelBoEstoqueTest.CriarItem';
    Result := TLojaModelDaoFactory.New(InMemory).Itens.Item.CriarItem(LDTONovoItem);
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelBoEstoqueTest.SetupFixture;
begin

end;

procedure TLojaModelBoEstoqueTest.TearDownFixture;
begin

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

    var M1 := TLojaModelDaoFactory.New(InMemory).Estoque.Movimento.CriarNovoMovimento(LDTOMovimento);
    M1.Free;

    LDTOMovimento.DatMov := EncodeDate(2023, 02, 09);
    LDTOMovimento.QtdMov := 2;
    LDTOMovimento.CodTipoMov := movSaida;
    LDTOMovimento.CodOrigMov := orgVenda;

    var M2 := TLojaModelDaoFactory.New(InMemory).Estoque.Movimento.CriarNovoMovimento(LDTOMovimento);
    M2.Free;

    LDTOMovimento.DatMov := EncodeDate(2023, 02, 25);
    LDTOMovimento.QtdMov := 3;
    LDTOMovimento.CodTipoMov := movSaida;
    LDTOMovimento.CodOrigMov := orgVenda;

    var M3 := TLojaModelDaoFactory.New(InMemory).Estoque.Movimento.CriarNovoMovimento(LDTOMovimento);
    M3.Free;

    LDTOMovimento.DatMov := EncodeDate(2023, 04, 10);
    LDTOMovimento.QtdMov := 12;
    LDTOMovimento.CodTipoMov := movEntrada;
    LDTOMovimento.CodOrigMov := orgCompra;

    var M4 := TLojaModelDaoFactory.New(InMemory).Estoque.Movimento.CriarNovoMovimento(LDTOMovimento);
    M4.Free;

    LDTOMovimento.DatMov := EncodeDate(2023, 05, 09);
    LDTOMovimento.QtdMov := 8;
    LDTOMovimento.CodTipoMov := movSaida;
    LDTOMovimento.CodOrigMov := orgVenda;

    var M5 := TLojaModelDaoFactory.New(InMemory).Estoque.Movimento.CriarNovoMovimento(LDTOMovimento);
    M5.Free;

    TLojaModelBoFactory.New(InMemory).Estoque.FechamentoSaldo.FecharSaldoMensalItem(LDTOMovimento.CodItem);

    //Obter lista de fechamentos de um item
    var LFechamentos := TLojaModelDaoFactory.New(InMemory).Estoque.Saldo.ObterFechamentosItem(
      LDTOMovimento.CodItem,
      EndOfTheMonth(EncodeDate(2023, 01, 15)),
      EndOfTheMonth(EncodeDate(2023, 05, 09))
    );

    Assert.AreEqual(NativeInt(5), LFechamentos.Count);
    Assert.AreEqual(NativeInt(9), LFechamentos.Last.QtdSaldo);

    LFechamentos.Free;

  finally
    LDTOMovimento.Free;
  end;
end;

procedure TLojaModelBoEstoqueTest.Test_CriarFechamentosSaldo_PreencheLacunas;
var LDatMov, LDatPrimFecha : TDateTime;
begin
  LDatMov := IncMonth(Now, -3);
  LDatPrimFecha := EndOfTheMonth(LDatMov);

  var LItem := CriarItem;
  var LDTOMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  LDTOMovimento.CodItem := LItem.CodItem;
  LItem.Free;

  try
    LDTOMovimento.DatMov := LDatMov;
    LDTOMovimento.QtdMov := 10;
    LDTOMovimento.CodTipoMov := movEntrada;
    LDTOMovimento.CodOrigMov := orgCompra;
    LDTOMovimento.DscMot := '';

    var M1 := TLojaModelDaoFactory.New(InMemory).Estoque.Movimento.CriarNovoMovimento(LDTOMovimento);
    M1.Free;

    var F1 := TLojaModelDaoFactory.New(InMemory).Estoque.Saldo.CriarFechamentoSaldoItem(
      LDTOMovimento.CodItem,
      EndOfTheMonth(LDTOMovimento.DatMov),
      LDTOMovimento.QtdMov
    );
    F1.Free;

    LDatMov := IncMonth(Now, -1);

    LDTOMovimento.DatMov := LDatMov;
    LDTOMovimento.QtdMov := 2;
    LDTOMovimento.CodTipoMov := movSaida;
    LDTOMovimento.CodOrigMov := orgVenda;

    var M2 := TLojaModelDaoFactory.New(InMemory).Estoque.Movimento.CriarNovoMovimento(LDTOMovimento);
    M2.Free;

    TLojaModelBoFactory.New(InMemory).Estoque.FechamentoSaldo.FecharSaldoMensalItem(LDTOMovimento.CodItem);

    LDatMov := EndOfTheMonth(LDatMov);

    //Obter lista de fechamentos de um item
    var LFechamentos := TLojaModelDaoFactory.New(InMemory).Estoque.Saldo.ObterFechamentosItem(
      LDTOMovimento.CodItem,
      LDatPrimFecha,
      LDatMov
    );

    Assert.AreEqual(NativeInt(3), LFechamentos.Count);
    Assert.AreEqual(8, LFechamentos.Last.QtdSaldo);

    LFechamentos.Free;

  finally
    LDTOMovimento.Free;
  end;
end;

procedure TLojaModelBoEstoqueTest.Test_CriarFechamentosSaldo_PreencheLacunasMesmoSemMov;
var LDatUltFecha, LDatPrimFecha : TDateTime;
begin
  LDatPrimFecha := EndOfTheMonth(IncMonth(Now, -3));
  LDatUltFecha := EndOfTheMonth(IncMonth(Now, -1));

  var LItem := CriarItem;
  try
    var F1 := TLojaModelDaoFactory.New(InMemory).Estoque.Saldo.CriarFechamentoSaldoItem(
      LItem.CodItem,
      LDatPrimFecha,
      10
    );
    F1.Free;

    TLojaModelBoFactory.New(InMemory).Estoque.FechamentoSaldo.FecharSaldoMensalItem(LItem.CodItem);

    //Obter lista de fechamentos de um item
    var LFechamentos := TLojaModelDaoFactory.New(InMemory).Estoque.Saldo.ObterFechamentosItem(
      LItem.CodItem,
      LDatPrimFecha,
      LDatUltFecha
    );

    Assert.AreEqual(NativeInt(3), LFechamentos.Count);
    Assert.AreEqual(10, LFechamentos.Last.QtdSaldo);

    LFechamentos.Free;
  finally
    LItem.Free;
  end;
end;

procedure TLojaModelBoEstoqueTest.Test_NaoCriarFechamentosSaldo_DataRepetida;
begin
  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelBoFactory.New(InMemory).Estoque
        .FechamentoSaldo
          .CriarNovoFechamento(-1, EndOfTheDay(EncodeDate(2023, 05, 31)), 0)
          .&EndFechamentoSaldo
        .FechamentoSaldo
          .CriarNovoFechamento(-1,EndOfTheDay(EncodeDate(2023, 05, 31)), 0);
    end,
    EHorseException,
    'Já existe um fechamento de saldo para o item'
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelBoEstoqueTest);

end.
