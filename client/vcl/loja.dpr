program loja;

uses
  Vcl.Forms,
  Loja.View.Principal in 'view\Loja.View.Principal.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
