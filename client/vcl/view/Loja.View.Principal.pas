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
    tbAcoes: TToolBar;
    btnVender: TToolButton;
    menuPrinc: TMainMenu;
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
    acCaixa: TAction;
    btnCaixa: TToolButton;
    acSobre: TAction;
    mniSobre: TMenuItem;
    procedure acVenderExecute(Sender: TObject);
    procedure acItensExecute(Sender: TObject);
    procedure acComprarExecute(Sender: TObject);
    procedure acSairExecute(Sender: TObject);
    procedure acConfiguracoesExecute(Sender: TObject);
    procedure acLogonExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure acCaixaExecute(Sender: TObject);
    procedure acSobreExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  uFuncoes,
  Loja.DM.Imagens,

  Loja.View.Logon,
  Loja.View.Configuracoes,
  Loja.View.Sobre,

  Loja.Model.Infra.Configuracoes,
  Loja.Model.Infra.Usuario;

{$R *.dfm}

procedure TViewPrincipal.acCaixaExecute(Sender: TObject);
begin
  OpenChild('TViewCaixa');
end;

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

procedure TViewPrincipal.acSobreExecute(Sender: TObject);
begin
  var ViewSobre := TViewSobre.Create(Self);
  try
    ViewSobre.ShowModal();
  finally
    FreeAndNil(ViewSobre);
  end;
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

  // Completar caption com caracteres à esquerda para TToobar ajustar largura
//  var LTexto := '';
//  for var i := 1 to 20 do LTexto := LTexto + ' ';
//  btnVender.Caption := btnVender.Caption + LTexto;
end;

procedure TViewPrincipal.FormShow(Sender: TObject);
var sAux: string;
begin
  Funcoes.VersaoArquivo(ParamStr(0),sAux,False);
  Self.Caption := Self.Caption + ' {vs: '+sAux+'}';
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
