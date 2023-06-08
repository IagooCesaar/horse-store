unit Loja.View.Configuracoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloModal, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TViewConfiguracoes = class(TViewModeloModal)
    cmbTemas: TComboBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmbTemasSelect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Vcl.Themes;

{$R *.dfm}

procedure TViewConfiguracoes.cmbTemasSelect(Sender: TObject);
begin
  inherited;
  TStyleManager.SetStyle(cmbTemas.Text);
end;

procedure TViewConfiguracoes.FormCreate(Sender: TObject);
begin
  inherited;
  cmbTemas.Clear;
  for var LTema in TStyleManager.StyleNames
  do cmbTemas.Items.Add(LTema);

  cmbTemas.Sorted := True;

  for var idx := 0 to Pred(cmbTemas.Items.Count)
  do if cmbTemas.Items[idx] = TStyleManager.ActiveStyle.Name
     then begin
       cmbTemas.ItemIndex := idx;
       Break;
     end;
end;

end.
