unit ufrmPrinc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  App, Vcl.WinXCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList, Vcl.AppEvnts,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TfrmPrinc = class(TForm)
    aclPrinc: TActionList;
    acIniciarAPI: TAction;
    acPararAPI: TAction;
    ApplicationEvents1: TApplicationEvents;
    acDefinirSenha: TAction;
    acSwagger: TAction;
    pcPrinc: TPageControl;
    tsAPI: TTabSheet;
    Label1: TLabel;
    edtPorta: TEdit;
    btnIniciar: TButton;
    btnParar: TButton;
    grpAutenticacao: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    btnDefinirSenha: TButton;
    btnSwagger: TButton;
    tsBancoDados: TTabSheet;
    trayPrinc: TTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acIniciarAPIExecute(Sender: TObject);
    procedure acPararAPIExecute(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure acDefinirSenhaExecute(Sender: TObject);
    procedure acSwaggerExecute(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure trayPrincDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

procedure TfrmPrinc.ApplicationEvents1Minimize(Sender: TObject);
begin
  Hide();
  Self.WindowState := wsMinimized;
  trayPrinc.Visible := True;
end;

procedure TfrmPrinc.FormCreate(Sender: TObject);
begin
  FApp := TApp.Create;
end;

procedure TfrmPrinc.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FApp);
end;

procedure TfrmPrinc.FormShow(Sender: TObject);
begin
  pcPrinc.ActivePage := tsAPI;
end;

procedure TfrmPrinc.trayPrincDblClick(Sender: TObject);
begin
  Show();
  trayPrinc.Visible := False;
end;

end.
