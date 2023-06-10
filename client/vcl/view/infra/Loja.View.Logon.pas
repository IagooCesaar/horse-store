unit Loja.View.Logon;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TViewLogon = class(TForm)
    Panel1: TPanel;
    pLogin: TPanel;
    Label2: TLabel;
    lbl1: TLabel;
    edtLogin: TEdit;
    edtSenha: TEdit;
    pBotoes: TPanel;
    btnEntrar: TButton;
    btnSair: TButton;
    pMetodoConexao: TPanel;
    sbConfig: TSpeedButton;
    procedure btnEntrarClick(Sender: TObject);
    procedure sbConfigClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses
  Loja.View.Configuracoes,
  Loja.Model.Infra.Usuario,
  Loja.Controller.Infra;

{$R *.dfm}

procedure TViewLogon.btnEntrarClick(Sender: TObject);
begin
  TLojaModelInfraUsuario.GetInstance.Login := edtLogin.Text;
  TLojaModelInfraUsuario.GetInstance.Senha := edtSenha.Text;

  var Controller := TControllerInfra.Create(Self);
  try
    if not Controller.ValidarLogon
    then raise Exception.Create('Credenciais inválidas');
  finally
    FreeAndNil(Controller);
  end;

  Self.ModalResult := mrOk;
end;

procedure TViewLogon.btnSairClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
  Application.Terminate;
end;

procedure TViewLogon.FormActivate(Sender: TObject);
begin
  if edtLogin.CanFocus
  then edtLogin.SetFocus;
end;

procedure TViewLogon.FormShow(Sender: TObject);
begin
  if edtLogin.CanFocus
  then edtLogin.SetFocus;
end;

procedure TViewLogon.sbConfigClick(Sender: TObject);
begin
  var ViewConfig := TViewConfiguracoes.Create(Self);
  try
    ViewConfig.ShowModal();
  finally
    FreeAndNil(ViewConfig);
  end;
end;

end.
