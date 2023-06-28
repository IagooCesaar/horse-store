unit Loja.Model.Caixa.Test;

interface

uses
  DUnitX.TestFramework,
  System.SyncObjs,

  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Movimento;

type
  [TestFixture]
  TLojaModelCaixaTest = class
  private
    FCaixa: TLojaModelEntityCaixaCaixa;
    FCritical: TCriticalSection;
  public
    [SetupFixture]
    procedure SetupFixture;
    [TearDownFixture]
    procedure TearDownFixture;

    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test_AberturaDeCaixa;

    [Test]
    procedure Test_NaoAbrirCaixa_ValorNegativo;

    [Test]
    procedure Test_NaoAbrirCaixa_ExiteCaixaAberto;

    [Test]
    procedure Test_AberturaDeCaixa_NovaAbertura_ComSangria;

    [Test]
    procedure Test_AberturaDeCaixa_NovaAbertura_ComReforco;

    [Test]
    procedure Test_CriarMovimento_ReforcoCaixa;

    [Test]
    procedure Test_CriarMovimento_SangriaCaixa;

    [Test]
    procedure Test_NaoCriarMovimento_CaixaInvalido;

    [Test]
    procedure Test_NaoCriarMovimento_CaixaInexistente;

    [Test]
    procedure Test_NaoCriarMovimento_CaixaFechado;

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

procedure TLojaModelCaixaTest.Setup;
begin
  FCritical.Acquire;
end;

procedure TLojaModelCaixaTest.SetupFixture;
begin
  TLojaModelDaoFactory.InMemory := True;
  FCritical := TCriticalSection.Create;
end;

procedure TLojaModelCaixaTest.TearDown;
begin
  FCritical.Release;
end;

procedure TLojaModelCaixaTest.TearDownFixture;
begin
  FCaixa.Free;
  FCritical.Free;
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

procedure TLojaModelCaixaTest.Test_AberturaDeCaixa_NovaAbertura_ComReforco;
begin
  var LResumo := TLojaModelFactory.New.Caixa.ObterResumoCaixa(FCaixa.CodCaixa);
  var VrFecha := LResumo.VrSaldo;
  var VrDif := 4.00;
  LResumo.Free;

  WriteLn(Format('Valor Fechamento: %8.2f', [VrFecha] ));

  var LCaixaFechado := TLojaModelDaoFactory.New.Caixa.Caixa.AtualizarFechamentoCaixa(
    FCaixa.CodCaixa,
    Now,
    VrFecha
  );

  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.DatAbert := Now;
  LAbertura.VrAbert := VrFecha + VrDif;

  FCaixa.Free;
  FCaixa := TLojaModelFactory.New.Caixa.AberturaCaixa(LAbertura);

  WriteLn(Format('Valor Abertura: %8.2f / Caixa: %d', [FCaixa.VrAbert, FCaixa.CodCaixa] ));

  Assert.AreEqual(LAbertura.VrAbert, FCaixa.VrAbert);
  Assert.AreEqual(LAbertura.DatAbert, FCaixa.DatAbert);

  var LMovimentos := TLojaModelFactory.New.Caixa.ObterMovimentoCaixa(FCaixa.CodCaixa);

  // Mov 1: Saldo de fechamento do caixa anterior
  // Mov 2: Ajuste pois novo caixa est� abrindo com saldo <> do saldo do �ltimo fechamento
  Assert.AreEqual(2, LMovimentos.Count);

  // Como novo caixa abriu com valor diferente do ultimo fechamento,
  // far� 2 movimentos para corrigir a diferen�a, neste caso com sangria

  WriteLn(Format('Segundo movimento: %8.2f tipo %s', [LMovimentos[1].VrMov, LMovimentos[1].CodTipoMov.ToString] ));

  Assert.AreEqual(Double(VrDif), Double(LMovimentos[1].VrMov));
  Assert.IsTrue(LMovimentos[1].CodTipoMov = movEntrada);
  Assert.IsTrue(LMovimentos[1].CodOrigMov = orgReforco);

  LAbertura.Free;
  LMovimentos.Free;

  LCaixaFechado.Free;
end;

procedure TLojaModelCaixaTest.Test_AberturaDeCaixa_NovaAbertura_ComSangria;
begin
  var LResumo := TLojaModelFactory.New.Caixa.ObterResumoCaixa(FCaixa.CodCaixa);
  var VrFecha := LResumo.VrSaldo;
  var VrDif := 2.00;
  LResumo.Free;

  var LCaixaFechado := TLojaModelDaoFactory.New.Caixa.Caixa.AtualizarFechamentoCaixa(
    FCaixa.CodCaixa,
    Now,
    VrFecha
  );

  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.DatAbert := Now;
  LAbertura.VrAbert := VrFecha - VrDif;

  FCaixa.Free;
  FCaixa := TLojaModelFactory.New.Caixa.AberturaCaixa(LAbertura);

  Assert.AreEqual(LAbertura.VrAbert, FCaixa.VrAbert);
  Assert.AreEqual(LAbertura.DatAbert, FCaixa.DatAbert);

  var LMovimentos := TLojaModelFactory.New.Caixa.ObterMovimentoCaixa(FCaixa.CodCaixa);

  // Mov 1: Saldo de fechamento do caixa anterior
  // Mov 2: Ajuste pois novo caixa est� abrindo com saldo <> do saldo do �ltimo fechamento
  Assert.AreEqual(2, LMovimentos.Count);

  // Como novo caixa abriu com valor diferente do ultimo fechamento,
  // far� 2 movimentos para corrigir a diferen�a, neste caso com sangria
  Assert.AreEqual(Double(VrDif), Double(LMovimentos[1].VrMov));
  Assert.IsTrue(LMovimentos[1].CodTipoMov = movSaida);
  Assert.IsTrue(LMovimentos[1].CodOrigMov = orgSangria);

  LAbertura.Free;
  LMovimentos.Free;

  LCaixaFechado.Free;
end;

procedure TLojaModelCaixaTest.Test_CriarMovimento_ReforcoCaixa;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := FCaixa.CodCaixa;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := 'Refor�o de Caixa';

  var LMovimento := TLojaModelFactory.New.Caixa.CriarReforcoCaixa(LDtoMov);

  Assert.IsTrue(LMovimento.CodTipoMov = movEntrada);
  Assert.IsTrue(LMovimento.CodOrigMov = orgReforco);
  Assert.IsTrue(LMovimento.CodMeioPagto = pagDinheiro);
  Assert.AreEqual(Double(LDtoMov.VrMov), Double(LMovimento.VrMov));

  LDtoMov.Free;
  LMovimento.Free;
end;

procedure TLojaModelCaixaTest.Test_CriarMovimento_SangriaCaixa;
begin
  var LResumo := TLojaModelFactory.New.Caixa.ObterResumoCaixa(FCaixa.CodCaixa);
  var VrSaldo := LResumo.VrSaldo;
  LResumo.Free;

  if VrSaldo = 0
  then raise Exception.Create('Saldo igual a zero');

  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := FCaixa.CodCaixa;
  LDtoMov.VrMov := 0.50;
  LDtoMov.DscObs := 'Sangria de Caixa';

  var LMovimento := TLojaModelFactory.New.Caixa.CriarSangriaCaixa(LDtoMov);

  Assert.IsTrue(LMovimento.CodTipoMov = movSaida);
  Assert.IsTrue(LMovimento.CodOrigMov = orgSangria);
  Assert.IsTrue(LMovimento.CodMeioPagto = pagDinheiro);
  Assert.AreEqual(Double(LDtoMov.VrMov), Double(LMovimento.VrMov));

  LDtoMov.Free;
  LMovimento.Free;
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
    'H� um caixa aberto'
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
    'O caixa n�o poder� ser aberto com valor negativo'
  );

  LAbertura.Free;
end;

procedure TLojaModelCaixaTest.Test_NaoCriarMovimento_CaixaFechado;
begin
  var LResumo := TLojaModelFactory.New.Caixa.ObterResumoCaixa(FCaixa.CodCaixa);
  var VrFecha := LResumo.VrSaldo;
  LResumo.Free;

  var LCaixaFechado := TLojaModelDaoFactory.New.Caixa.Caixa.AtualizarFechamentoCaixa(
    FCaixa.CodCaixa,
    Now,
    VrFecha
  );

  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  LAbertura.DatAbert := Now;
  LAbertura.VrAbert := VrFecha;

  FCaixa.Free;
  FCaixa := TLojaModelFactory.New.Caixa.AberturaCaixa(LAbertura);
  LAbertura.Free;


  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := LCaixaFechado.CodCaixa;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := 'Teste Caixa Fechado';

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Caixa.CriarReforcoCaixa(LDtoMov);
    end,
    EHorseException,
    'O caixa informado n�o est� na stua��o "Aberto"'
  );

  LDtoMov.Free;
  LCaixaFechado.Free;
end;

procedure TLojaModelCaixaTest.Test_NaoCriarMovimento_CaixaInexistente;
begin

end;

procedure TLojaModelCaixaTest.Test_NaoCriarMovimento_CaixaInvalido;
begin

end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelCaixaTest);

end.
