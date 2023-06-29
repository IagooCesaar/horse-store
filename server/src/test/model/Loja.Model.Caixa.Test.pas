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
    procedure Test_CriarMovimento_SangriaCaixa_Total;

    [Test]
    procedure Test_NaoCriarMovimento_CaixaInvalido;

    [Test]
    procedure Test_NaoCriarMovimento_CaixaInexistente;

    [Test]
    procedure Test_NaoCriarMovimento_CaixaFechado;

    [Test]
    procedure Test_NaoCriarMovimento_SemObservacao;

    [Test]
    procedure Test_NaoCriarMovimento_ObservacaoPequena;

    [Test]
    procedure Test_NaoCriarMovimento_ObservacaoGrande;

    [Test]
    procedure Test_NaoCriarMovimento_MovimentoNegativo;

    [Test]
    procedure Test_NaoCriarMovimento_SaldoInsuficiente;

    [Test]
    procedure Test_ObterCaixa_PorCodigo;

    [Test]
    procedure Test_ObterCaixa_Aberto;

    [Test]
    procedure Test_NaoObterCaixa_CodigoInvalido;

    [Test]
    procedure Test_NaoObterCaixa_CodigoInexistente;

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
  Sleep(1000);

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
  // Mov 2: Ajuste pois novo caixa está abrindo com saldo <> do saldo do último fechamento
  Assert.AreEqual(2, LMovimentos.Count);

  // Como novo caixa abriu com valor diferente do ultimo fechamento,
  // fará 2 movimentos para corrigir a diferença, neste caso com sangria

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
  // Mov 2: Ajuste pois novo caixa está abrindo com saldo <> do saldo do último fechamento
  Assert.AreEqual(2, LMovimentos.Count);

  // Como novo caixa abriu com valor diferente do ultimo fechamento,
  // fará 2 movimentos para corrigir a diferença, neste caso com sangria
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
  LDtoMov.DscObs := 'Reforço de Caixa';

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

procedure TLojaModelCaixaTest.Test_CriarMovimento_SangriaCaixa_Total;
begin
  var LResumo := TLojaModelFactory.New.Caixa.ObterResumoCaixa(FCaixa.CodCaixa);
  var VrSaldo := LResumo.VrSaldo;
  LResumo.Free;

  if VrSaldo = 0
  then raise Exception.Create('Saldo igual a zero');

  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := FCaixa.CodCaixa;
  LDtoMov.VrMov := VrSaldo;
  LDtoMov.DscObs := 'Sangria de Caixa';

  var LMovimento := TLojaModelFactory.New.Caixa.CriarSangriaCaixa(LDtoMov);

  Assert.IsTrue(LMovimento.CodTipoMov = movSaida);
  Assert.IsTrue(LMovimento.CodOrigMov = orgSangria);
  Assert.IsTrue(LMovimento.CodMeioPagto = pagDinheiro);
  Assert.AreEqual(Double(LDtoMov.VrMov), Double(LMovimento.VrMov));

  LResumo := TLojaModelFactory.New.Caixa.ObterResumoCaixa(FCaixa.CodCaixa);
  Assert.AreEqual(Double(0), Double(LResumo.VrSaldo));

  LDtoMov.Free;
  LMovimento.Free;
  LResumo.Free;
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
    'O caixa informado não está na stuação "Aberto"'
  );

  LDtoMov.Free;
  LCaixaFechado.Free;
end;

procedure TLojaModelCaixaTest.Test_NaoCriarMovimento_CaixaInexistente;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := FCaixa.CodCaixa * 10;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := 'Teste Caixa Invalido';

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Caixa.CriarReforcoCaixa(LDtoMov);
    end,
    EHorseException,
    'O código de caixa informado não existe'
  );

  LDtoMov.Free;
end;

procedure TLojaModelCaixaTest.Test_NaoCriarMovimento_CaixaInvalido;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := -1;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := 'Teste Caixa Invalido';

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Caixa.CriarReforcoCaixa(LDtoMov);
    end,
    EHorseException,
    'O código de caixa informado é inválido'
  );

  LDtoMov.Free;
end;

procedure TLojaModelCaixaTest.Test_NaoCriarMovimento_MovimentoNegativo;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := FCaixa.CodCaixa;
  LDtoMov.VrMov := -20.00;
  LDtoMov.DscObs := 'Valor negativo';

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Caixa.CriarSangriaCaixa(LDtoMov);
    end,
    EHorseException,
    'O valor do movimento deverá ser superior a zero'
  );

  LDtoMov.Free;
end;

procedure TLojaModelCaixaTest.Test_NaoCriarMovimento_ObservacaoGrande;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := FCaixa.CodCaixa;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := '0123456789012345678901234567890123456789012345678901234567890';

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Caixa.CriarReforcoCaixa(LDtoMov);
    end,
    EHorseException,
    'A observação deverá ter no máximo'
  );

  LDtoMov.Free;
end;

procedure TLojaModelCaixaTest.Test_NaoCriarMovimento_ObservacaoPequena;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := FCaixa.CodCaixa;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := '012';

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Caixa.CriarReforcoCaixa(LDtoMov);
    end,
    EHorseException,
    'A observação deverá ter no mínimo'
  );

  LDtoMov.Free;
end;

procedure TLojaModelCaixaTest.Test_NaoCriarMovimento_SaldoInsuficiente;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := FCaixa.CodCaixa;
  LDtoMov.DscObs := 'Saldo Insuficiente';

  var LResumo := TLojaModelFactory.New.Caixa.ObterResumoCaixa(FCaixa.CodCaixa);
  LDtoMov.VrMov := LResumo.VrSaldo + 1;
  LResumo.Free;

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Caixa.CriarSangriaCaixa(LDtoMov);
    end,
    EHorseException,
    'Não há saldo disponível em dinheiro para realizar este tipo de movimento'
  );

  LDtoMov.Free;
end;

procedure TLojaModelCaixaTest.Test_NaoCriarMovimento_SemObservacao;
begin
  var LDtoMov := TLojaModelDtoReqCaixaCriarMovimento.Create;
  LDtoMov.CodCaixa := FCaixa.CodCaixa;
  LDtoMov.VrMov := 20.00;
  LDtoMov.DscObs := '';

  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Caixa.CriarReforcoCaixa(LDtoMov);
    end,
    EHorseException,
    'Você deverá informar uma observação para este tipo de movimento'
  );

  LDtoMov.Free;
end;


procedure TLojaModelCaixaTest.Test_NaoObterCaixa_CodigoInexistente;
begin
  var LCaixa := TLojaModelFactory.New.Caixa.ObterCaixaPorCodigo(FCaixa.CodCaixa+1);
  Assert.IsNull(LCaixa);
end;

procedure TLojaModelCaixaTest.Test_NaoObterCaixa_CodigoInvalido;
begin
  Assert.WillRaiseWithMessageRegex(
    procedure begin
      TLojaModelFactory.New.Caixa.ObterCaixaPorCodigo(-1);
    end,
    EHorseException,
    'O código de caixa informado é inválido'
  );
end;

procedure TLojaModelCaixaTest.Test_ObterCaixa_Aberto;
begin
  var LCaixa := TLojaModelFactory.New.Caixa.ObterCaixaAberto;
  Assert.IsTrue(LCaixa <> nil);
  LCaixa.Free;
end;

procedure TLojaModelCaixaTest.Test_ObterCaixa_PorCodigo;
begin
  var LCaixa := TLojaModelFactory.New.Caixa.ObterCaixaPorCodigo(FCaixa.CodCaixa);
  Assert.AreEqual(FCaixa.CodCaixa, LCaixa.CodCaixa);
  LCaixa.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelCaixaTest);

end.
