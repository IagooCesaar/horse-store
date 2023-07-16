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
    grpDBParams: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    edtDBParamServidor: TEdit;
    edtDBParamBanco: TEdit;
    Label6: TLabel;
    edtDBParamUsuario: TEdit;
    Label7: TLabel;
    edtDBParamSenha: TEdit;
    grpDBDriverParams: TGroupBox;
    Label9: TLabel;
    edtDBDriverPath: TEdit;
    grpDBPoolParams: TGroupBox;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edtDBPoolMaxItems: TEdit;
    edtedtDBPoolCleanup: TEdit;
    edtDBPoolExpire: TEdit;
    btnAplicarDBConfig: TButton;
    acAplicarDBConfig: TAction;
    tsOutros: TTabSheet;
    GroupBox1: TGroupBox;
    chbAutoIniciar: TCheckBox;
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
    procedure acAplicarDBConfigExecute(Sender: TObject);
    procedure chbAutoIniciarClick(Sender: TObject);
  private
    FApp: TApp;
  public
    { Public declarations }
  end;

var
  frmPrinc: TfrmPrinc;

implementation

uses
  Winapi.ShellAPI,
  Registry;

{$R *.dfm}

procedure TfrmPrinc.acAplicarDBConfigExecute(Sender: TObject);
begin
  FApp.DBParams.Server := edtDBParamServidor.Text;
  FApp.DBParams.Database := edtDBParamBanco.Text;
  FApp.DBParams.Password := edtDBParamSenha.Text;
  FApp.DBParams.UserName := edtDBParamUsuario.Text;
  FApp.DBDriverParams.VendorLib := edtDBDriverPath.Text;
  FApp.DBPoolParams.PoolMaximumItems := StrToInt(edtDBPoolMaxItems.Text);
  FApp.DBPoolParams.PoolCleanupTimeout := StrToInt(edtedtDBPoolCleanup.Text);
  FApp.DBPoolParams.PoolExpireTimeout := StrToInt(edtDBPoolExpire.Text);

  FApp.SaveDatabaseConfig;
end;

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
    acAplicarDBConfig.Enabled := False;

    grpDBParams.Enabled := True;
    grpDBDriverParams.Enabled := True;
    grpDBPoolParams.Enabled := True;
  end else begin
    acIniciarAPI.Enabled := not FApp.EmExecucao;
    acPararAPI.Enabled := FApp.EmExecucao;
    acDefinirSenha.Enabled := not FApp.EmExecucao;
    acAplicarDBConfig.Enabled := not FApp.EmExecucao;

    grpDBParams.Enabled := not FApp.EmExecucao;
    grpDBDriverParams.Enabled := not FApp.EmExecucao;
    grpDBPoolParams.Enabled := not FApp.EmExecucao;
  end;
end;

procedure TfrmPrinc.ApplicationEvents1Minimize(Sender: TObject);
begin
  Hide();
  Self.WindowState := wsMinimized;
  trayPrinc.Visible := True;
end;

procedure TfrmPrinc.chbAutoIniciarClick(Sender: TObject);
var LRegistro : TRegistry;
begin
   LRegistro := TRegistry.create;
   try
      LRegistro.RootKey := HKEY_LOCAL_MACHINE;
      LRegistro.Access  := LRegistro.Access or KEY_WOW64_64KEY;
      if LRegistro.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',True)
      then begin
         if not chbAutoIniciar.Checked
         then LRegistro.WriteString(Self.Caption,Application.ExeName)
         else LRegistro.DeleteValue(Self.Caption);
      end;
      LRegistro.CloseKey;
   finally
      LRegistro.Free;
   end;
end;

procedure TfrmPrinc.FormCreate(Sender: TObject);
begin
  FApp := TApp.Create;

  edtDBParamServidor.Text := FApp.DBParams.Server;
  edtDBParamBanco.Text := FApp.DBParams.Database;
  edtDBParamSenha.Text := FApp.DBParams.Password;
  edtDBParamUsuario.Text := FApp.DBParams.UserName;
  edtDBDriverPath.Text := FApp.DBDriverParams.VendorLib;
  edtDBPoolMaxItems.Text := IntToStr(FApp.DBPoolParams.PoolMaximumItems);
  edtedtDBPoolCleanup.Text := IntToStr(FApp.DBPoolParams.PoolCleanupTimeout);
  edtDBPoolExpire.Text := IntToStr(FApp.DBPoolParams.PoolExpireTimeout);

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
