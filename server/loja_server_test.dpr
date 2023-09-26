program loja_server_test;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
{$R *.dres}

uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  Loja.Model.Itens.Test in 'src\test\model\Loja.Model.Itens.Test.pas',
  App in 'src\App.pas',
  Loja.Model.Entity.Itens.Item in 'src\model\entity\itens\Loja.Model.Entity.Itens.Item.pas',
  Loja.Model.Dao.Itens.Factory in 'src\model\dao\oficial\itens\Loja.Model.Dao.Itens.Factory.pas',
  Loja.Model.Dao.Itens.Factory.InMemory in 'src\model\dao\in-memory\itens\Loja.Model.Dao.Itens.Factory.InMemory.pas',
  Loja.Model.Dao.Itens.Item.InMemory in 'src\model\dao\in-memory\itens\Loja.Model.Dao.Itens.Item.InMemory.pas',
  Loja.Controller.Itens in 'src\controllers\Loja.Controller.Itens.pas',
  Loja.Controller.Registry in 'src\controllers\Loja.Controller.Registry.pas',
  Loja.Controller.Itens.Test in 'src\test\controller\Loja.Controller.Itens.Test.pas',
  Loja.Controller.Api.Test in 'src\test\controller\Loja.Controller.Api.Test.pas',
  Loja.Model.Estoque in 'src\model\Loja.Model.Estoque.pas',
  Loja.Model.Factory in 'src\model\Loja.Model.Factory.pas',
  Loja.Model.Interfaces in 'src\model\Loja.Model.Interfaces.pas',
  Loja.Model.Itens in 'src\model\Loja.Model.Itens.pas',
  Loja.Model.Entity.Estoque.Movimento in 'src\model\entity\estoque\Loja.Model.Entity.Estoque.Movimento.pas',
  Loja.Model.Entity.Estoque.Saldo in 'src\model\entity\estoque\Loja.Model.Entity.Estoque.Saldo.pas',
  Loja.Model.Entity.Estoque.Types in 'src\model\entity\estoque\Loja.Model.Entity.Estoque.Types.pas',
  Loja.Model.Dto.Req.Estoque.AcertoEstoque in 'src\model\dto\Loja.Model.Dto.Req.Estoque.AcertoEstoque.pas',
  Loja.Model.Dto.Req.Estoque.CriarMovimento in 'src\model\dto\Loja.Model.Dto.Req.Estoque.CriarMovimento.pas',
  Loja.Model.Dto.Req.Itens.CriarItem in 'src\model\dto\Loja.Model.Dto.Req.Itens.CriarItem.pas',
  Loja.Model.Dto.Req.Itens.FiltroItens in 'src\model\dto\Loja.Model.Dto.Req.Itens.FiltroItens.pas',
  Loja.Model.Dao.Estoque.Factory in 'src\model\dao\oficial\estoque\Loja.Model.Dao.Estoque.Factory.pas',
  Loja.Model.Dao.Estoque.Movimento in 'src\model\dao\oficial\estoque\Loja.Model.Dao.Estoque.Movimento.pas',
  Loja.Model.Dao.Estoque.Saldo in 'src\model\dao\oficial\estoque\Loja.Model.Dao.Estoque.Saldo.pas',
  Loja.Model.Dao.Estoque.Factory.InMemory in 'src\model\dao\in-memory\estoque\Loja.Model.Dao.Estoque.Factory.InMemory.pas',
  Loja.Model.Dao.Estoque.Movimento.InMemory in 'src\model\dao\in-memory\estoque\Loja.Model.Dao.Estoque.Movimento.InMemory.pas',
  Loja.Model.Dao.Estoque.Saldo.InMemory in 'src\model\dao\in-memory\estoque\Loja.Model.Dao.Estoque.Saldo.InMemory.pas',
  Loja.Model.Dao.Estoque.Interfaces in 'src\model\dao\Loja.Model.Dao.Estoque.Interfaces.pas',
  Loja.Model.Dao.Factory in 'src\model\dao\Loja.Model.Dao.Factory.pas',
  Loja.Model.Dao.Interfaces in 'src\model\dao\Loja.Model.Dao.Interfaces.pas',
  Loja.Model.Dao.Itens.Interfaces in 'src\model\dao\Loja.Model.Dao.Itens.Interfaces.pas',
  Loja.Model.Estoque.Test in 'src\test\model\Loja.Model.Estoque.Test.pas',
  Loja.Controller.Estoque.Test in 'src\test\controller\Loja.Controller.Estoque.Test.pas',
  Loja.Controller.Estoque in 'src\controllers\Loja.Controller.Estoque.pas',
  Loja.Model.Bo.Factory in 'src\model\bo\Loja.Model.Bo.Factory.pas',
  Loja.Model.Bo.Interfaces in 'src\model\bo\Loja.Model.Bo.Interfaces.pas',
  Loja.Model.Bo.Estoque in 'src\model\bo\Loja.Model.Bo.Estoque.pas',
  Loja.Model.Dto.Resp.Estoque.SaldoItem in 'src\model\dto\Loja.Model.Dto.Resp.Estoque.SaldoItem.pas',
  Loja.Model.Bo.Estoque.Test in 'src\test\model\Loja.Model.Bo.Estoque.Test.pas',
  Loja.Controller.Infra.Test in 'src\test\controller\Loja.Controller.Infra.Test.pas',
  Loja.Model.Dao.Itens.Item in 'src\model\dao\oficial\itens\Loja.Model.Dao.Itens.Item.pas',
  Loja.Model.Dto.Resp.ApiError in 'src\model\dto\Loja.Model.Dto.Resp.ApiError.pas',
  Loja.infra.Utils.Funcoes in 'src\infra\utils\Loja.infra.Utils.Funcoes.pas',
  Loja.Model.Preco in 'src\model\Loja.Model.Preco.pas',
  Loja.Model.Entity.Preco.Venda in 'src\model\entity\preco\Loja.Model.Entity.Preco.Venda.pas',
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda in 'src\model\dto\Loja.Model.Dto.Req.Preco.CriarPrecoVenda.pas',
  Loja.Model.Dao.Preco.Interfaces in 'src\model\dao\Loja.Model.Dao.Preco.Interfaces.pas',
  Loja.Model.Dao.Preco.Factory.InMemory in 'src\model\dao\in-memory\preco\Loja.Model.Dao.Preco.Factory.InMemory.pas',
  Loja.Model.Dao.Preco.Venda.InMemory in 'src\model\dao\in-memory\preco\Loja.Model.Dao.Preco.Venda.InMemory.pas',
  Loja.Model.Dao.Preco.Factory in 'src\model\dao\oficial\preco\Loja.Model.Dao.Preco.Factory.pas',
  Loja.Model.Dao.Preco.Venda in 'src\model\dao\oficial\preco\Loja.Model.Dao.Preco.Venda.pas',
  Loja.Controller.Preco in 'src\controllers\Loja.Controller.Preco.pas',
  Loja.Model.Preco.Test in 'src\test\model\Loja.Model.Preco.Test.pas',
  Loja.Controller.Preco.Test in 'src\test\controller\Loja.Controller.Preco.Test.pas',
  Loja.Model.Entity.Caixa.Types in 'src\model\entity\caixa\Loja.Model.Entity.Caixa.Types.pas',
  Loja.Model.Entity.Caixa.Movimento in 'src\model\entity\caixa\Loja.Model.Entity.Caixa.Movimento.pas',
  Loja.Model.Entity.Caixa.Caixa in 'src\model\entity\caixa\Loja.Model.Entity.Caixa.Caixa.pas',
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa in 'src\model\dto\Loja.Model.Dto.Resp.Caixa.ResumoCaixa.pas',
  Loja.Model.Caixa in 'src\model\Loja.Model.Caixa.pas',
  Loja.Model.Dao.Caixa.Factory in 'src\model\dao\oficial\caixa\Loja.Model.Dao.Caixa.Factory.pas',
  Loja.Model.Dao.Caixa.Factory.InMemory in 'src\model\dao\in-memory\caixa\Loja.Model.Dao.Caixa.Factory.InMemory.pas',
  Loja.Model.Dao.Caixa.Caixa in 'src\model\dao\oficial\caixa\Loja.Model.Dao.Caixa.Caixa.pas',
  Loja.Model.Dao.Caixa.Movimento in 'src\model\dao\oficial\caixa\Loja.Model.Dao.Caixa.Movimento.pas',
  Loja.Model.Dao.Caixa.Movimento.InMemory in 'src\model\dao\in-memory\caixa\Loja.Model.Dao.Caixa.Movimento.InMemory.pas',
  Loja.Model.Dao.Caixa.Caixa.InMemory in 'src\model\dao\in-memory\caixa\Loja.Model.Dao.Caixa.Caixa.InMemory.pas',
  Loja.Model.Bo.Caixa in 'src\model\bo\Loja.Model.Bo.Caixa.pas',
  Loja.Controller.Caixa in 'src\controllers\Loja.Controller.Caixa.pas',
  Loja.Model.Dto.Req.Caixa.Abertura in 'src\model\dto\Loja.Model.Dto.Req.Caixa.Abertura.pas',
  Loja.Model.Dto.Req.Caixa.Fechamento in 'src\model\dto\Loja.Model.Dto.Req.Caixa.Fechamento.pas',
  Loja.Model.Dto.Req.Caixa.CriarMovimento in 'src\model\dto\Loja.Model.Dto.Req.Caixa.CriarMovimento.pas',
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto in 'src\model\dto\Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto.pas',
  Loja.Model.Caixa.Test in 'src\test\model\Loja.Model.Caixa.Test.pas',
  Loja.Controller.Caixa.Test in 'src\test\controller\Loja.Controller.Caixa.Test.pas',
  Loja.Model.Venda in 'src\model\Loja.Model.Venda.pas',
  Loja.Model.Dao.Venda.Factory.InMemory in 'src\model\dao\in-memory\venda\Loja.Model.Dao.Venda.Factory.InMemory.pas',
  Loja.Model.Dao.Venda.Item.InMemory in 'src\model\dao\in-memory\venda\Loja.Model.Dao.Venda.Item.InMemory.pas',
  Loja.Model.Dao.Venda.MeioPagto.InMemory in 'src\model\dao\in-memory\venda\Loja.Model.Dao.Venda.MeioPagto.InMemory.pas',
  Loja.Model.Dao.Venda.Venda.InMemory in 'src\model\dao\in-memory\venda\Loja.Model.Dao.Venda.Venda.InMemory.pas',
  Loja.Model.Dao.Venda.Factory in 'src\model\dao\oficial\venda\Loja.Model.Dao.Venda.Factory.pas',
  Loja.Model.Dao.Venda.Item in 'src\model\dao\oficial\venda\Loja.Model.Dao.Venda.Item.pas',
  Loja.Model.Dao.Venda.MeioPagto in 'src\model\dao\oficial\venda\Loja.Model.Dao.Venda.MeioPagto.pas',
  Loja.Model.Dao.Venda.Venda in 'src\model\dao\oficial\venda\Loja.Model.Dao.Venda.Venda.pas',
  Loja.Model.Entity.Venda.Item in 'src\model\entity\venda\Loja.Model.Entity.Venda.Item.pas',
  Loja.Model.Entity.Venda.MeioPagto in 'src\model\entity\venda\Loja.Model.Entity.Venda.MeioPagto.pas',
  Loja.Model.Entity.Venda.Types in 'src\model\entity\venda\Loja.Model.Entity.Venda.Types.pas',
  Loja.Model.Entity.Venda.Venda in 'src\model\entity\venda\Loja.Model.Entity.Venda.Venda.pas',
  Loja.Model.Dao.Caixa.Interfaces in 'src\model\dao\Loja.Model.Dao.Caixa.Interfaces.pas',
  Loja.Model.Dao.Venda.Interfaces in 'src\model\dao\Loja.Model.Dao.Venda.Interfaces.pas',
  Loja.Controller.Venda in 'src\controllers\Loja.Controller.Venda.pas',
  Loja.Model.Dto.Req.Venda.EfetivaVenda in 'src\model\dto\Loja.Model.Dto.Req.Venda.EfetivaVenda.pas',
  Loja.Model.Dto.Req.Venda.Item in 'src\model\dto\Loja.Model.Dto.Req.Venda.Item.pas',
  Loja.Model.Dto.Resp.Venda.Item in 'src\model\dto\Loja.Model.Dto.Resp.Venda.Item.pas',
  Loja.Controller.Venda.Test in 'src\test\controller\Loja.Controller.Venda.Test.pas',
  Loja.Model.Venda.Test in 'src\test\model\Loja.Model.Venda.Test.pas',
  Loja.Model.Dto.Resp.Itens.Item in 'src\model\dto\Loja.Model.Dto.Resp.Itens.Item.pas';

{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}

  {$IFDEF MSWINDOWS}
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //When true, Assertions must be made during tests;
    runner.FailsOnNoAsserts := True;

    //tell the runner how we will log things
    //Log to the console window if desired
    if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
    begin
      logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      runner.AddLogger(logger);
    end;
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
end.
