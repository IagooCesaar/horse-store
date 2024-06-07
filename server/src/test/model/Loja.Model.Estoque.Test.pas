unit Loja.Model.Estoque.Test;

interface

uses
  DUnitX.TestFramework,

  Loja.Model.Entity.Itens.Item;

type
  [TestFixture]
  TLojaModelEstoqueTest = class
  private
    FItem: TLojaModelEntityItensItem;
    function CriarItem: TLojaModelEntityItensItem;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure Test_CriarNovoMovimentoEstoque;

    [Test]
    procedure Test_NaoCriarNovoMovimentoEstoque_MotivoPequeno;

    [Test]
    procedure Test_NaoCriarNovoMovimentoEstoque_MotivoGrande;

    [Test]
    procedure Test_NaoCriarNovoMovimentoEstoque_AcertoSemMotivo;

    [Test]
    procedure Test_NaoCriarNovoMovimentoEstoque_MovEntradaOrigSaida;

    [Test]
    procedure Test_NaoCriarNovoMovimentoEstoque_MovSaidaOrigEntrada;

    [Test]
    procedure Test_NaoCriarNovoMovimentoEstoque_ItemInexistente;

    [Test]
    procedure Test_CriarAcertoEstoque;

    [Test]
    procedure Test_NaoCriarAcertoEstoque_SemMotivo;

    [Test]
    procedure Test_NaoCriarAcertoEstoque_SaldoRealNegativo;

    [Test]
    procedure Test_NaoCriarAcertoEstoque_ItemInexistente;

    [Test]
    procedure Test_NaoCriarAcertoEstoque_SaldoRealIgualAtual;

    [Test]
    procedure Test_ObterHistoricoMovimento;

    [Test]
    procedure Test_NaoObterHistoricoMovimento_InicioSuperiorFim;

    [Test]
    procedure Test_NaoObterHistoricoMovimento_ItemInexistente;

    [Test]
    procedure Test_ObterSaldoAtualItem;

    [Test]
    procedure Test_ObterSaldoAtualItem_SemFechamento;

    [Test]
    procedure Test_NaoObterSaldoAtualItem_ItemInexistente;

    [Test]
    procedure Test_ObterFechamentoSaldo;

    [Test]
    procedure Test_NaoObterFechamentoSaldo_ItemInexistente;

    [Test]
    procedure Test_NaoObterFechamentoSaldo_InicioSuperiorFim;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,

  Horse,
  Horse.Exception,

  Loja.Model.Dao.Interfaces,
  Loja.Model.Dao.Factory,

  Loja.Environment.Interfaces,
  Loja.Model.Factory,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Estoque.CriarMovimento,
  Loja.Model.Dto.Req.Estoque.AcertoEstoque,
  Loja.Model.Entity.Estoque.Types,
  Loja.Model.Entity.Estoque.Saldo,
  Loja.Model.Entity.Estoque.Movimento
  ;

{ TLojaModelEstoqueTest }

function InMemory: ILojaEnvironmentRuler;
begin
  Result := TLojaModelFactory.InMemory.Ruler;
end;

function TLojaModelEstoqueTest.CriarItem: TLojaModelEntityItensItem;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
  LDTONovoItem: TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'TLojaModelEstoqueTest.CriarItem';
    Result := TLojaModelDaoFactory.New(InMemory).Itens.Item.CriarItem(LDTONovoItem);
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelEstoqueTest.SetupFixture;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
  LDTONovoItem: TLojaModelDtoReqItensCriarItem;
begin

  FItem := CriarItem;
end;

procedure TLojaModelEstoqueTest.TearDownFixture;
begin


  FreeAndNil(FItem);
end;

procedure TLojaModelEstoqueTest.Test_CriarAcertoEstoque;
var LAcerto: TLojaModelDtoReqEstoqueAcertoEstoque;
begin
  LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  try
    LAcerto.CodItem := FItem.CodItem;
    LAcerto.QtdSaldoReal := 4;
    LAcerto.DscMot := 'Teste';

    var LMovimento := TLojaModelFactory.InMemory
      .Estoque
      .CriarAcertoEstoque(LAcerto);

    Assert.IsTrue(LMovimento <> nil);

    LMovimento.Free;
  finally
    LAcerto.Free;
  end;
end;

procedure TLojaModelEstoqueTest.Test_CriarNovoMovimentoEstoque;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
begin
  LDTONovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTONovoMovimento.CodItem := FItem.CodItem;
    LDTONovoMovimento.QtdMov := 10;
    LDTONovoMovimento.DatMov := Now;
    LDTONovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LDTONovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgAcerto;
    LDTONovoMovimento.DscMot := 'Teste';

    var LMovimento := TLojaModelFactory.InMemory
      .Estoque
      .CriarNovoMovimento(LDTONovoMovimento);

    Assert.IsTrue(LMovimento <> nil);

    LMovimento.Free;
  finally
    LDTONovoMovimento.Free;
  end;
end;

procedure TLojaModelEstoqueTest.Test_NaoCriarAcertoEstoque_ItemInexistente;
var LAcerto: TLojaModelDtoReqEstoqueAcertoEstoque;
begin
  LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  try
    LAcerto.CodItem := -1;
    LAcerto.QtdSaldoReal := 4;
    LAcerto.DscMot := 'Motivo';

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.InMemory
          .Estoque
          .CriarAcertoEstoque(LAcerto);
      end,
      EHorseException,
      'O item informado não existe'
    );
  finally
    LAcerto.Free;
  end;
end;

procedure TLojaModelEstoqueTest.Test_NaoCriarAcertoEstoque_SaldoRealIgualAtual;
var LAcerto: TLojaModelDtoReqEstoqueAcertoEstoque;
begin
  var LItem := CriarItem;
  LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  try
    LAcerto.CodItem := LItem.CodItem;
    LAcerto.QtdSaldoReal := 40;
    LAcerto.DscMot := 'Motivo';

    var LMovimento := TLojaModelFactory.InMemory
      .Estoque
      .CriarAcertoEstoque(LAcerto);
    LMovimento.Free;

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.InMemory
          .Estoque
          .CriarAcertoEstoque(LAcerto);
      end,
      EHorseException,
      'O saldo atual do item já está conforme o acerto informado'
    );
  finally
    LAcerto.Free;
    LItem.Free;
  end;
end;

procedure TLojaModelEstoqueTest.Test_NaoCriarAcertoEstoque_SaldoRealNegativo;
var LAcerto: TLojaModelDtoReqEstoqueAcertoEstoque;
begin
  LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  try
    LAcerto.CodItem := FItem.CodItem;
    LAcerto.QtdSaldoReal := -4;
    LAcerto.DscMot := 'Motivo';

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.InMemory
          .Estoque
          .CriarAcertoEstoque(LAcerto);
      end,
      EHorseException,
      'Não é permitido estoque negativo'
    );
  finally
    LAcerto.Free;
  end;
end;

procedure TLojaModelEstoqueTest.Test_NaoCriarAcertoEstoque_SemMotivo;
var LAcerto: TLojaModelDtoReqEstoqueAcertoEstoque;
begin
  LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  try
    LAcerto.CodItem := FItem.CodItem;
    LAcerto.QtdSaldoReal := 4;
    LAcerto.DscMot := '';

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.InMemory
          .Estoque
          .CriarAcertoEstoque(LAcerto);
      end,
      EHorseException,
      'A descrição do motivo é obrigatória para acerto de estoque'
    );
  finally
    LAcerto.Free;
  end;
end;

procedure TLojaModelEstoqueTest.Test_NaoCriarNovoMovimentoEstoque_AcertoSemMotivo;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
begin
  LDTONovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTONovoMovimento.CodItem := FItem.CodItem;
    LDTONovoMovimento.QtdMov := 10;
    LDTONovoMovimento.DatMov := Now;
    LDTONovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LDTONovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgAcerto;
    LDTONovoMovimento.DscMot := '';

    Assert.WillRaiseWithMessage(
      procedure begin
        TLojaModelFactory.InMemory
          .Estoque
          .CriarNovoMovimento(LDTONovoMovimento);
      end,
      EHorseException,
      'É obrigatório informar o motivo do acerto de estoque'
    );
  finally
    LDTONovoMovimento.Free;
  end;
end;

procedure TLojaModelEstoqueTest.Test_NaoCriarNovoMovimentoEstoque_ItemInexistente;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
begin
  LDTONovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTONovoMovimento.CodItem := -1;
    LDTONovoMovimento.QtdMov := 10;
    LDTONovoMovimento.DatMov := Now;
    LDTONovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LDTONovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgAcerto;
    LDTONovoMovimento.DscMot := '1234';

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.InMemory
          .Estoque
          .CriarNovoMovimento(LDTONovoMovimento);
      end,
      EHorseException,
      'O item informado não existe'
    );
  finally
    LDTONovoMovimento.Free;
  end;
end;

procedure TLojaModelEstoqueTest.Test_NaoCriarNovoMovimentoEstoque_MotivoGrande;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
begin
  LDTONovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTONovoMovimento.CodItem := FItem.CodItem;
    LDTONovoMovimento.QtdMov := 10;
    LDTONovoMovimento.DatMov := Now;
    LDTONovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LDTONovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgAcerto;
    LDTONovoMovimento.DscMot := '1234567890123456789012345678901234567890112345678901234567890123456789012345678901';

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.InMemory
          .Estoque
          .CriarNovoMovimento(LDTONovoMovimento);
      end,
      EHorseException,
      'A descrição do motivo para realização do acerto deverá ter no máximo'
    );
  finally
    LDTONovoMovimento.Free;
  end;
end;

procedure TLojaModelEstoqueTest.Test_NaoCriarNovoMovimentoEstoque_MotivoPequeno;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
begin
  LDTONovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTONovoMovimento.CodItem := FItem.CodItem;
    LDTONovoMovimento.QtdMov := 10;
    LDTONovoMovimento.DatMov := Now;
    LDTONovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LDTONovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgAcerto;
    LDTONovoMovimento.DscMot := 'a';

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.InMemory
          .Estoque
          .CriarNovoMovimento(LDTONovoMovimento);
      end,
      EHorseException,
      'A descrição do motivo para realização do acerto deverá ter no mínimo'
    );
  finally
    LDTONovoMovimento.Free;
  end;
end;

procedure TLojaModelEstoqueTest.Test_NaoCriarNovoMovimentoEstoque_MovEntradaOrigSaida;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
begin
  LDTONovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTONovoMovimento.CodItem := FItem.CodItem;
    LDTONovoMovimento.QtdMov := 10;
    LDTONovoMovimento.DatMov := Now;
    LDTONovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LDTONovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgVenda;
    LDTONovoMovimento.DscMot := '';

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.InMemory
          .Estoque
          .CriarNovoMovimento(LDTONovoMovimento);
      end,
      EHorseException,
      'A origem do movimento de estoque não é do tipo de movimento de Entrada'
    );
  finally
    LDTONovoMovimento.Free;
  end;
end;

procedure TLojaModelEstoqueTest.Test_NaoCriarNovoMovimentoEstoque_MovSaidaOrigEntrada;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
begin
  LDTONovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTONovoMovimento.CodItem := FItem.CodItem;
    LDTONovoMovimento.QtdMov := 10;
    LDTONovoMovimento.DatMov := Now;
    LDTONovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movSaida;
    LDTONovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgCompra;
    LDTONovoMovimento.DscMot := '';

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.InMemory
          .Estoque
          .CriarNovoMovimento(LDTONovoMovimento);
      end,
      EHorseException,
      'A origem do movimento de estoque não é do tipo de movimento de Saída'
    );
  finally
    LDTONovoMovimento.Free;
  end;
end;

procedure TLojaModelEstoqueTest.Test_NaoObterFechamentoSaldo_InicioSuperiorFim;
begin
  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.InMemory
        .Estoque
        .ObterFechamentosSaldo(-1, Now+1, Now);
    end,
    EHorseException,
    'A data inicial deve ser inferior à data final em pelo menos 1 dia'
  );
end;

procedure TLojaModelEstoqueTest.Test_NaoObterFechamentoSaldo_ItemInexistente;
begin
  var LDatIni := StartOfTheMonth(IncMonth(Now, -1));
  var LDatFim := EndOfTheMonth(Now);

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.InMemory
        .Estoque
        .ObterFechamentosSaldo(-1, LDatIni, LDatFim);
    end,
    EHorseException,
    'O item informado não existe'
  );
end;

procedure TLojaModelEstoqueTest.Test_NaoObterHistoricoMovimento_InicioSuperiorFim;
begin
  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.InMemory
        .Estoque
        .ObterHistoricoMovimento(1, Now+1, Now);
    end,
    EHorseException,
    'A data inicial deve ser inferior à data final em pelo menos 1 dia'
  );
end;

procedure TLojaModelEstoqueTest.Test_NaoObterHistoricoMovimento_ItemInexistente;
begin
  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.InMemory
        .Estoque
        .ObterHistoricoMovimento(-1, Now, Now);
    end,
    EHorseException,
    'O item informado não existe'
  );
end;

procedure TLojaModelEstoqueTest.Test_NaoObterSaldoAtualItem_ItemInexistente;
begin
  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.InMemory
        .Estoque
        .ObterSaldoAtualItem(-1);
    end,
    EHorseException,
    'O item informado não existe'
  );
end;

procedure TLojaModelEstoqueTest.Test_ObterFechamentoSaldo;
var LAcerto: TLojaModelDtoReqEstoqueAcertoEstoque;
begin
  var LItem := CriarItem;
  LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  try
    LAcerto.CodItem := LItem.CodItem;
    LAcerto.QtdSaldoReal := 4;
    LAcerto.DscMot := 'Teste';

    var LMovimento := TLojaModelFactory.InMemory
      .Estoque
      .CriarAcertoEstoque(LAcerto);

    LMovimento.Free;
  finally
    LAcerto.Free;
  end;

  var LDatIni := StartOfTheMonth(IncMonth(Now, -1));
  var LDatFim := EndOfTheMonth(Now);

  var LFechamentos := TLojaModelFactory.InMemory
    .Estoque
    .ObterFechamentosSaldo(LItem.CodItem, LDatIni, LDatFim);

  Assert.AreEqual(NativeInt(1), LFechamentos.Count);
  LFechamentos.Free;
  LItem.Free;
end;

procedure TLojaModelEstoqueTest.Test_ObterHistoricoMovimento;
var LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
begin
  var LItem := CriarItem;

  LDTONovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTONovoMovimento.CodItem := LItem.CodItem;
    LDTONovoMovimento.QtdMov := 10;
    LDTONovoMovimento.DatMov := Now;
    LDTONovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LDTONovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgCompra;
    LDTONovoMovimento.DscMot := 'Teste';

    var LMovimento := TLojaModelFactory.InMemory
      .Estoque
      .CriarNovoMovimento(LDTONovoMovimento);
    LMovimento.Free;
  finally
    LDTONovoMovimento.Free;
  end;

  LDTONovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTONovoMovimento.CodItem := LItem.CodItem;
    LDTONovoMovimento.QtdMov := 8;
    LDTONovoMovimento.DatMov := Now;
    LDTONovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movSaida;
    LDTONovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgVenda;
    LDTONovoMovimento.DscMot := 'Teste';

    var LMovimento := TLojaModelFactory.InMemory
      .Estoque
      .CriarNovoMovimento(LDTONovoMovimento);
    LMovimento.Free;
  finally
    LDTONovoMovimento.Free;
  end;

  var LMovimentos := TLojaModelFactory.InMemory
    .Estoque
    .ObterHistoricoMovimento(LItem.CodItem, Now, Now);

  Assert.AreEqual(NativeInt(2), LMovimentos.Count);
  LMovimentos.Free;
  LItem.Free;
end;

procedure TLojaModelEstoqueTest.Test_ObterSaldoAtualItem;
var LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
begin
  var LItem := CriarItem;

  LDTONovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTONovoMovimento.CodItem := LItem.CodItem;
    LDTONovoMovimento.QtdMov := 10;
    LDTONovoMovimento.DatMov := Now;
    LDTONovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LDTONovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgCompra;
    LDTONovoMovimento.DscMot := 'Teste';

    var LMovimento := TLojaModelFactory.InMemory
      .Estoque
      .CriarNovoMovimento(LDTONovoMovimento);
    LMovimento.Free;
  finally
    LDTONovoMovimento.Free;
  end;

  LDTONovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTONovoMovimento.CodItem := LItem.CodItem;
    LDTONovoMovimento.QtdMov := 8;
    LDTONovoMovimento.DatMov := Now;
    LDTONovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movSaida;
    LDTONovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgVenda;
    LDTONovoMovimento.DscMot := 'Teste';

    var LMovimento := TLojaModelFactory.InMemory
      .Estoque
      .CriarNovoMovimento(LDTONovoMovimento);
    LMovimento.Free;
  finally
    LDTONovoMovimento.Free;
  end;

  var LSaldo := TLojaModelFactory.InMemory
    .Estoque
    .ObterSaldoAtualItem(LItem.CodItem);

  Assert.AreEqual(2, LSaldo.QtdSaldoAtu);
  LSaldo.Free;
  LItem.Free;
end;

procedure TLojaModelEstoqueTest.Test_ObterSaldoAtualItem_SemFechamento;
begin
  var LItem := CriarItem;
  var LSaldo := TLojaModelFactory.InMemory
    .Estoque
    .ObterSaldoAtualItem(LItem.CodItem);

  Assert.AreEqual(0, LSaldo.QtdSaldoAtu);
  LSaldo.Free;
  LItem.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelEstoqueTest);

end.
