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
    Label2: TLabel;
    edtUrl: TEdit;
    Label3: TLabel;
    edtTimeout: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure cmbTemasSelect(Sender: TObject);
    procedure btnModeloOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Vcl.Themes,

  Loja.Model.Infra.Configuracoes;

{$R *.dfm}

procedure TViewConfiguracoes.btnModeloOkClick(Sender: TObject);
begin
  inherited;
  with TLojaModelInfraConfiguracoes.GetInstance
  do begin
    Tema := cmbTemas.Text;
    APIUrl := edtUrl.Text;
    APITimeout := StrToIntDef(edtTimeout.Text, 3000);
  end;
  Self.ModalResult := mrOk;
end;

procedure TViewConfiguracoes.cmbTemasSelect(Sender: TObject);
begin
  inherited;
  TLojaModelInfraConfiguracoes.GetInstance.Tema := cmbTemas.Text;
end;

procedure TViewConfiguracoes.FormCreate(Sender: TObject);
begin
  inherited;
  cmbTemas.Clear;
  for var LTema in TStyleManager.StyleNames
  do cmbTemas.Items.Add(LTema);

  cmbTemas.Sorted := True;

  for var idx := 0 to Pred(cmbTemas.Items.Count)
  do if cmbTemas.Items[idx] = TLojaModelInfraConfiguracoes.GetInstance.Tema
     then begin
       cmbTemas.ItemIndex := idx;
       Break;
     end;

  with TLojaModelInfraConfiguracoes.GetInstance do
  begin
    edtUrl.Text := APIUrl;
    edtTimeout.Text := APITimeout.ToString;
  end;
end;

end.
