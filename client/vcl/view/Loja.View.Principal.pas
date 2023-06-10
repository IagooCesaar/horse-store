unit Loja.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ActnCtrls, Vcl.Menus;

type
  TViewPrincipal = class(TForm)
    acmAcoes: TActionManager;
    acVender: TAction;
    ToolBar1: TToolBar;
    btnVender: TToolButton;
    MainMenu1: TMainMenu;
    acSair: TAction;
    mniSair: TMenuItem;
    acItens: TAction;
    acComprar: TAction;
    acConfiguracoes: TAction;
    btnItens: TToolButton;
    btnComprar: TToolButton;
    mniConfiguracoes: TMenuItem;
    acLogon: TAction;
    btnLogon: TToolButton;
    sbar1: TStatusBar;
    procedure acVenderExecute(Sender: TObject);
    procedure acItensExecute(Sender: TObject);
    procedure acComprarExecute(Sender: TObject);
    procedure acSairExecute(Sender: TObject);
    procedure acConfiguracoesExecute(Sender: TObject);
    procedure acLogonExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    procedure OpenChild(sClassName: string);
  public
    { Public declarations }
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

uses
  Loja.DM.Imagens,

  Loja.View.Logon,
  Loja.View.Configuracoes,
  Loja.View.ModeloModal,

  Loja.Model.Infra.Configuracoes,
  Loja.Model.Infra.Usuario;

{$R *.dfm}

procedure TViewPrincipal.acComprarExecute(Sender: TObject);
begin
  OpenChild('TViewComprar');
end;

procedure TViewPrincipal.acConfiguracoesExecute(Sender: TObject);
begin
  var ViewConfiguracoes := TViewConfiguracoes.Create(Self);
  try
    ViewConfiguracoes.ShowModal();
  finally
    FreeAndNil(ViewConfiguracoes);
  end;
end;

procedure TViewPrincipal.acItensExecute(Sender: TObject);
begin
  OpenChild('TViewItens');
end;

procedure TViewPrincipal.acLogonExecute(Sender: TObject);
begin
  var ViewLogon := TViewLogon.Create(Self);
  try
    ViewLogon.ShowModal;
  finally
    FreeAndNil(ViewLogon);
  end;
end;

procedure TViewPrincipal.acSairExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TViewPrincipal.acVenderExecute(Sender: TObject);
begin
  OpenChild('TViewVender');
end;

procedure TViewPrincipal.FormActivate(Sender: TObject);
begin
  while TLojaModelInfraUsuario.GetInstance.Login = ''
  do acLogon.Execute;
end;

procedure TViewPrincipal.FormCreate(Sender: TObject);
begin
  // Aplicar o tema definido nas configurações
  TLojaModelInfraConfiguracoes.GetInstance.Tema := TLojaModelInfraConfiguracoes.GetInstance.Tema;
end;

procedure TViewPrincipal.OpenChild(sClassName: string);
var
  i:integer;
  CRef : TPersistentClass;
begin
  for i := 0 to Application.MainForm.MDIChildCount-1 do
  begin
    if Application.MainForm.MDIChildren[i].ClassName = sClassName then
    begin
      if Application.MainForm.MDIChildren[i].Windowstate = wsMinimized
      then Application.MainForm.MDIChildren[i].Windowstate := wsNormal
      else Application.MainForm.MDIChildren[i].BringToFront;
      exit;
    end;
  end;
  CRef := GetClass(sClassName);

  if (not Assigned(CRef))
  then raise exception.create('Tela não registrada.:'+sClassName);

  TFormClass(CRef).Create(Application.MainForm);
end;

end.
