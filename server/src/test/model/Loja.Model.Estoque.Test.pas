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
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,

  Horse,
  Horse.Exception,

  Loja.Model.Dao.Interfaces,
  Loja.Model.Dao.Factory,

  Loja.Model.Factory,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Estoque.CriarMovimento,
  Loja.Model.Dto.Req.Estoque.AcertoEstoque,
  Loja.Model.Entity.Estoque.Types,
  Loja.Model.Entity.Estoque.Saldo,
  Loja.Model.Entity.Estoque.Movimento
  ;

{ TLojaModelEstoqueTest }

procedure TLojaModelEstoqueTest.SetupFixture;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
  LDTONovoItem: TLojaModelDtoReqItensCriarItem;
begin
  TLojaModelDaoFactory.InMemory := True;

  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'Criar movimento';
    FItem := TLojaModelDaoFactory.New.Itens.Item.CriarItem(LDTONovoItem);
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelEstoqueTest.TearDownFixture;
begin
  TLojaModelDaoFactory.InMemory := False;

  FreeAndNil(FItem);
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

    var LMovimento := TLojaModelFactory.New
      .Estoque
      .CriarNovoMovimento(LDTONovoMovimento);

    LMovimento.Free;
  finally
    LDTONovoMovimento.Free;
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
        TLojaModelFactory.New
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
    LDTONovoMovimento.DscMot := '12345678901234567890123456789012345678901';

    Assert.WillRaiseWithMessageRegex(
      procedure begin
        TLojaModelFactory.New
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
        TLojaModelFactory.New
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
        TLojaModelFactory.New
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
        TLojaModelFactory.New
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

initialization
  TDUnitX.RegisterTestFixture(TLojaModelEstoqueTest);

end.
