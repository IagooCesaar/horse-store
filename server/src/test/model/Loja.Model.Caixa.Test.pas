unit Loja.Model.Caixa.Test;

interface

uses
  DUnitX.TestFramework,


  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Movimento;

type
  [TestFixture]
  TLojaModelCaixaTest = class
  private
    FCaixa: TLojaModelEntityCaixaCaixa;
  public
    [SetupFixture]
    procedure SetupFixture;
    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure Test_AberturaDeCaixa;

    [Test]
    procedure Test_NaoAbrirCaixa_ValorNegativo;

    [Test]
    procedure Test_NaoAbrirCaixa_ExiteCaixaAberto;

    [Test]
    procedure Test_AberturaDeCaixa_NovaAbertura;

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
  FCaixa.Free;
  TLojaModelDaoFactory.InMemory := False;
end;

procedure TLojaModelCaixaTest.Test_AberturaDeCaixa;
begin
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.DatAbert := Now;
  LAbertura.VrAbert := 10;

  FCaixa := TLojaModelFactory.New.Caixa.AberturaCaixa(LAbertura);

  Assert.AreEqual(LAbertura.VrAbert, FCaixa.VrAbert);
  Assert.AreEqual(LAbertura.DatAbert, FCaixa.DatAbert);

  var LMovimentos := TLojaModelFactory.New.Caixa.ObterMovimentoCaixa(FCaixa.CodCaixa);

  Assert.AreEqual(1, LMovimentos.Count);
  Assert.AreEqual(LAbertura.VrAbert, LMovimentos[0].VrMov);

  LAbertura.Free;
  LMovimentos.Free;
end;

procedure TLojaModelCaixaTest.Test_AberturaDeCaixa_NovaAbertura;
begin
  var LCaixaFechado := TLojaModelDaoFactory.New.Caixa.Caixa.AtualizarFechamentoCaixa(
    FCaixa.CodCaixa,
    Now,
    10
  );

  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.DatAbert := Now;
  LAbertura.VrAbert := 8;

  FCaixa.Free;
  FCaixa := TLojaModelFactory.New.Caixa.AberturaCaixa(LAbertura);

  Assert.AreEqual(LAbertura.VrAbert, FCaixa.VrAbert);
  Assert.AreEqual(LAbertura.DatAbert, FCaixa.DatAbert);

  var LMovimentos := TLojaModelFactory.New.Caixa.ObterMovimentoCaixa(FCaixa.CodCaixa);

  // Mov 1: Saldo de fechamento do caixa anterior
  // Mov 2: Ajuste pois novo caixa está abrindo com saldo <> do saldo do último fechamento
  Assert.AreEqual(2, LMovimentos.Count);

  // Como novo caixa abriu com valor diferente do ultimo fechamento,
  // fará 2 movimentos para corrigir a diferença, neste caso com sangria
  Assert.AreEqual(Double(2.00), Double(LMovimentos[1].VrMov));

  LAbertura.Free;
  LMovimentos.Free;

  LCaixaFechado.Free;
end;

procedure TLojaModelCaixaTest.Test_NaoAbrirCaixa_ExiteCaixaAberto;
begin
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.DatAbert := Now;
  LAbertura.VrAbert := 10;

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Caixa.AberturaCaixa(LAbertura);
    end,
    EHorseException,
    'Há um caixa aberto'
  );

  LAbertura.Free;
end;

procedure TLojaModelCaixaTest.Test_NaoAbrirCaixa_ValorNegativo;
begin
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.DatAbert := Now;
  LAbertura.VrAbert := -1;

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Caixa.AberturaCaixa(LAbertura);
    end,
    EHorseException,
    'O caixa não poderá ser aberto com valor negativo'
  );

  LAbertura.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelCaixaTest);

end.
