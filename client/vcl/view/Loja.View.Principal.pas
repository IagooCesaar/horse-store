unit Loja.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    aclPrinc: TActionList;
    btnVender: TToolButton;
    acVender: TAction;
    procedure acVenderExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.acVenderExecute(Sender: TObject);
begin
  ShowMessage('Vender');
end;

end.
