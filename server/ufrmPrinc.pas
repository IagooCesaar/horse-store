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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acIniciarAPIExecute(Sender: TObject);
    procedure acPararAPIExecute(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  private
    FApp: TApp;
  public
    { Public declarations }
  end;

var
  frmPrinc: TfrmPrinc;

implementation

{$R *.dfm}

procedure TfrmPrinc.acIniciarAPIExecute(Sender: TObject);
begin
  FApp.Start(StrToInt(edtPorta.Text));
end;

procedure TfrmPrinc.acPararAPIExecute(Sender: TObject);
begin
  FApp.Stop;
end;

procedure TfrmPrinc.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  if not Assigned(FApp)
  then begin
    acIniciarAPI.Enabled := False;
    acPararAPI.Enabled := False;
  end else begin
    acIniciarAPI.Enabled := not FApp.EmExecucao;
    acPararAPI.Enabled := FApp.EmExecucao;
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
