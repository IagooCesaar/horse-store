unit ufrmPrinc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  App, Vcl.WinXCtrls, Vcl.StdCtrls;

type
  TfrmPrinc = class(TForm)
    Label1: TLabel;
    edtPorta: TEdit;
    btnIniciar: TButton;
    btnParar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnIniciarClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
  private
    FApp: TApp;
  public
    { Public declarations }
  end;

var
  frmPrinc: TfrmPrinc;

implementation

{$R *.dfm}

procedure TfrmPrinc.btnIniciarClick(Sender: TObject);
begin
  FApp.Start(StrToInt(edtPorta.Text));
end;

procedure TfrmPrinc.btnPararClick(Sender: TObject);
begin
  FApp.Stop;
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
