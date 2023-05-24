program loja_server_console;

{$APPTYPE CONSOLE}

{$R *.res}

{$R *.dres}

uses
  System.SysUtils,
  App in 'src\App.pas',
  Database.Conexao in 'src\infra\database\Database.Conexao.pas',
  Database.Factory in 'src\infra\database\Database.Factory.pas',
  Database.Interfaces in 'src\infra\database\Database.Interfaces.pas',
  Database.SQL in 'src\infra\database\Database.SQL.pas',
  Database.Tipos in 'src\infra\database\Database.Tipos.pas';

begin
  var App := TApp.Create;
  try
    try
      App.Start(9000);
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    FreeAndNil(App)
  end;
end.
