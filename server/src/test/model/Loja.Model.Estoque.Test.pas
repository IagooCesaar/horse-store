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
  LNovoMovimento : TLojaModelDtoReqEstoqueCriarMovimento;
  LNovoItem: TLojaModelDtoReqItensCriarItem;
begin
  LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
  LNovoItem.NomItem := 'Criar movimento';

  var LItem := TLojaModelDaoFactory.New.Itens.Item.CriarItem(LnovoItem);
  LNovoItem.Free;

  LNovoMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LNovoMovimento.CodItem := LItem.CodItem;
    LNovoMovimento.QtdMov := 10;
    LNovoMovimento.DatMov := Now;
    LNovoMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LNovoMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgAcerto;
    LNovoMovimento.DscMot := '';

    var LMovimento := TLojaModelFactory.New
      .Estoque
      .CriarNovoMovimento(LNovoMovimento);

  finally
    LNovoMovimento.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelEstoqueTest);

end.
