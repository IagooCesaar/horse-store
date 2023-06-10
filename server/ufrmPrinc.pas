unit ufrmPrinc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  App, Vcl.WinXCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList, Vcl.AppEvnts;

type
  TfrmPrinc = class(TForm)
    Label1: TLabel;
    edtPorta: TEdit;
    btnIniciar: TButton;
    btnParar: TButton;
    aclPrinc: TActionList;
    acIniciarAPI: TAction;
    acPararAPI: TAction;
    ApplicationEvents1: TApplicationEvents;
    acDefinirSenha: TAction;
    grpAutenticacao: TGroupBox;
    edtUsuario: TEdit;
    Label2: TLabel;
    edtSenha: TEdit;
    Label3: TLabel;
    btnDefinirSenha: TButton;
    btnSwagger: TButton;
    acSwagger: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acIniciarAPIExecute(Sender: TObject);
    procedure acPararAPIExecute(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure acDefinirSenhaExecute(Sender: TObject);
    procedure acSwaggerExecute(Sender: TObject);
  private
    FApp: TApp;
  public
    { Public declarations }
  end;

var
  frmPrinc: TfrmPrinc;

implementation

uses
  Winapi.ShellAPI;

{$R *.dfm}

procedure TfrmPrinc.acDefinirSenhaExecute(Sender: TObject);
begin
  FApp.Usuario := edtUsuario.Text;
  FApp.Senha := edtSenha.Text;
end;

procedure TfrmPrinc.acIniciarAPIExecute(Sender: TObject);
begin
  FApp.Start(StrToInt(edtPorta.Text));
end;

procedure TfrmPrinc.acPararAPIExecute(Sender: TObject);
begin
  FApp.Stop;
end;

procedure TfrmPrinc.acSwaggerExecute(Sender: TObject);
begin
  ShellExecute(Application.Handle,PChar('Open'),PChar (FApp.SwaggerURL), Nil,Nil,SW_SHOWNORMAL);
end;

procedure TfrmPrinc.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  if not Assigned(FApp)
  then begin
    acIniciarAPI.Enabled := False;
    acPararAPI.Enabled := False;
    acDefinirSenha.Enabled := False;
  end else begin
    acIniciarAPI.Enabled := not FApp.EmExecucao;
    acPararAPI.Enabled := FApp.EmExecucao;
    acDefinirSenha.Enabled := not FApp.EmExecucao;
  end;
end;

procedure TfrmPrinc.FormCreate(Sender: TObject);
begin
  FApp := TApp.Create;
end;

procedure TfrmPrinc.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FApp);
end;

end.
