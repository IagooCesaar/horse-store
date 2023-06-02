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
    procedure acVenderExecute(Sender: TObject);
    procedure acItensExecute(Sender: TObject);
    procedure acComprarExecute(Sender: TObject);
    procedure acSairExecute(Sender: TObject);
    procedure acConfiguracoesExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

uses
  Loja.DM.Imagens,
  Loja.View.ModeloModal;

{$R *.dfm}

procedure TViewPrincipal.acComprarExecute(Sender: TObject);
begin
  ShowMessage('Comprar');
  var ViewModeloModal := TViewModeloModal.Create(Self);
  try
    ViewModeloModal.ShowModal;
  finally
    ViewModeloModal.Free;
  end;
end;

procedure TViewPrincipal.acConfiguracoesExecute(Sender: TObject);
begin
  ShowMessage('Configurações');
end;

procedure TViewPrincipal.acItensExecute(Sender: TObject);
begin
  ShowMessage('Itens');
end;

procedure TViewPrincipal.acSairExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TViewPrincipal.acVenderExecute(Sender: TObject);
begin
  ShowMessage('Vender');
end;

end.
