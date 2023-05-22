program loja_server_vcl;

{$R *.dres}

uses
  Vcl.Forms,
  ufrmPrinc in 'ufrmPrinc.pas' {frmPrinc},
  App in 'src\App.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrinc, frmPrinc);
  Application.Run;
end.
