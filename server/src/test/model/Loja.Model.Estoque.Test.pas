unit Loja.Model.Estoque.Test;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TLojaModelEstoqueTest = class
  public
    [SetupFixture]
    procedure SetupFixture;
    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure Test_CriarNovoMovimentoEstoque;
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
begin
  TLojaModelDaoFactory.InMemory := True;
end;

procedure TLojaModelEstoqueTest.TearDownFixture;
begin
  TLojaModelDaoFactory.InMemory := False;
end;

procedure TLojaModelEstoqueTest.Test_CriarNovoMovimentoEstoque;
var
  LDTONovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
  LDTONovoItem: TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  LDTONovoItem.NomItem := 'Criar movimento';

  var LItem := TLojaModelDaoFactory.New.Itens.Item.CriarItem(LDTONovoItem);
  LDTONovoItem.Free;

  LDTONovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LDTONovoMovimento.CodItem := LItem.CodItem;
    LDTONovoMovimento.QtdMov := 10;
    LDTONovoMovimento.DatMov := Now;
    LDTONovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LDTONovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgAcerto;
    LDTONovoMovimento.DscMot := '';

    var LMovimento := TLojaModelFactory.New
      .Estoque
      .CriarNovoMovimento(LDTONovoMovimento);

    LItem.Free;
    LMovimento.Free;
  finally
    LDTONovoMovimento.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelEstoqueTest);

end.
