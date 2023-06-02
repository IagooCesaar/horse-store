unit Loja.View.Modelo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TViewModelo = class(TForm)
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    //Fun��es para TScrollBox
    procedure TScrollBoxMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TScrollBoxMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private

  public

  end;

implementation

uses
  StrUtils;

{$R *.dfm}

{ TViewModelo }
 
procedure TViewModelo.FormKeyPress(Sender: TObject; var Key: Char);
var sClasse : String;
begin
   sClasse := Screen.ActiveControl.ClassName;
   if AnsiIndexStr(sClasse,
      ['TButton','TSpeedButton',
      'TDBMemo','TMemo',
      'TSynMemo', 'TDBSynEdit','TWebBrowser']
   ) < 0 then
   If key = #13 then begin
      if TComponent(Sender) is TForm then
         TForm(TComponent(Sender)).Perform(WM_NextDlgCtl,0, 0)
      else
         TForm(TComponent(Sender).Owner).Perform(WM_NextDlgCtl,0, 0);
      Key := #0;
   end;
end;

procedure TViewModelo.TScrollBoxMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
   //fonte:http://www.planetadelphi.com.br/dica/7456/-wheel-(roda)-do-mouse-em-scrollbox-
   if (TScrollBox(Sender).VertScrollBar.Position <= (
      TScrollBox(Sender).VertScrollBar.Range - TScrollBox(Sender).VertScrollBar.Increment
   )) then
      TScrollBox(Sender).VertScrollBar.Position :=
         TScrollBox(Sender).VertScrollBar.Position + TScrollBox(Sender).VertScrollBar.Increment
   else
      TScrollBox(Sender).VertScrollBar.Position :=
          TScrollBox(Sender).VertScrollBar.Range - TScrollBox(Sender).VertScrollBar.Increment;
end;

procedure TViewModelo.TScrollBoxMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
   //fonte:http://www.planetadelphi.com.br/dica/7456/-wheel-(roda)-do-mouse-em-scrollbox-
   if (TScrollBox(Sender).VertScrollBar.Position >= TScrollBox(Sender).VertScrollBar.Increment) then
      TScrollBox(Sender).VertScrollBar.Position :=
         TScrollBox(Sender).VertScrollBar.Position - TScrollBox(Sender).VertScrollBar.Increment
   else
      TScrollBox(Sender).VertScrollBar.Position := 0;
end;

end.
