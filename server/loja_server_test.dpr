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
  Loja.Model.Dao.Itens.Item in 'src\model\dao\oficial\itens\Loja.Model.Dao.Itens.Item.pas',
  Loja.Model.Dao.Itens.Factory.InMemory in 'src\model\dao\in-memory\itens\Loja.Model.Dao.Itens.Factory.InMemory.pas',
  Loja.Model.Dao.Itens.Item.InMemory in 'src\model\dao\in-memory\itens\Loja.Model.Dao.Itens.Item.InMemory.pas',
  Loja.Controller.Itens in 'src\controllers\Loja.Controller.Itens.pas',
  Loja.Controller.Registry in 'src\controllers\Loja.Controller.Registry.pas',
  Database.Conexao in 'src\infra\database\Database.Conexao.pas',
  Database.Factory in 'src\infra\database\Database.Factory.pas',
  Database.Interfaces in 'src\infra\database\Database.Interfaces.pas',
  Database.SQL in 'src\infra\database\Database.SQL.pas',
  Database.Tipos in 'src\infra\database\Database.Tipos.pas',
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
  Loja.Model.Dao.Itens.Interfaces in 'src\model\dao\Loja.Model.Dao.Itens.Interfaces.pas';

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
    runner.FailsOnNoAsserts := False;

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
