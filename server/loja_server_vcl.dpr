program loja_server_vcl;

{$R *.dres}

uses
  Vcl.Forms,
  ufrmPrinc in 'ufrmPrinc.pas' {frmPrinc},
  App in 'src\App.pas',
  Database.Interfaces in 'src\infra\database\Database.Interfaces.pas',
  Database.Tipos in 'src\infra\database\Database.Tipos.pas',
  Database.Conexao in 'src\infra\database\Database.Conexao.pas',
  Database.Factory in 'src\infra\database\Database.Factory.pas',
  Database.SQL in 'src\infra\database\Database.SQL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrinc, frmPrinc);
  Application.Run;
end.
