unit Loja.Model.Caixa.Test;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TLojaModelCaixaTest = class
  public
    [SetupFixture]
    procedure SetupFixture;
    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure Test_AberturaDeCaixa;
  end;

implementation

uses
  Horse,
  Horse.Exception,
  System.SysUtils,
  System.DateUtils,

  Loja.Model.Factory,
  Loja.Model.Dao.Interfaces,
  Loja.Model.Dao.Factory,

  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Movimento,
  Loja.Model.Dto.Req.Caixa.Abertura,
  Loja.Model.Dto.Req.Caixa.Fechamento,
  Loja.Model.Dto.Req.Caixa.CriarMovimento,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto;

{ TLojaModelCaixaTest }

procedure TLojaModelCaixaTest.SetupFixture;
begin
  TLojaModelDaoFactory.InMemory := True;
end;

procedure TLojaModelCaixaTest.TearDownFixture;
begin
  TLojaModelDaoFactory.InMemory := False;
end;

procedure TLojaModelCaixaTest.Test_AberturaDeCaixa;
begin
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.DatAbert := Now;
  LAbertura.VrAbert := 10;

  var LCaixa := TLojaModelFactory.New.Caixa.AberturaCaixa(LAbertura);

  Assert.AreEqual(LAbertura.VrAbert, LCaixa.VrAbert);
  Assert.AreEqual(LAbertura.DatAbert, LCaixa.DatAbert);

  LAbertura.Free;
  LCaixa.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelCaixaTest);

end.
