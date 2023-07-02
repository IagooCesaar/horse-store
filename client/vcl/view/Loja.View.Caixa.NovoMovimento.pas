unit Loja.View.Caixa.NovoMovimento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloModal, Vcl.StdCtrls,
  Vcl.CategoryButtons, Vcl.ExtCtrls,


  Loja.Model.Caixa.NovoMovimento;

type
  TViewCaixaNovoMovimento = class(TViewModeloModal)
    Label1: TLabel;
    edtValor: TEdit;
    edtObservacao: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnModeloOkClick(Sender: TObject);
  private
    FMovimento: TLojaModelCaixaNovoMovimento;
  public
    class function Exibir(AOwner: TComponent): TLojaModelCaixaNovoMovimento;
  end;


implementation

{$R *.dfm}

procedure TViewCaixaNovoMovimento.btnModeloOkClick(Sender: TObject);
begin
  inherited;

  FMovimento := TLojaModelCaixaNovoMovimento.Create;
  FMovimento.VrMov := StrToFloat(edtValor.Text);
  FMovimento.DscObs := edtObservacao.Text;

  Self.ModalResult := mrOk;
end;

class function TViewCaixaNovoMovimento.Exibir(
  AOwner: TComponent): TLojaModelCaixaNovoMovimento;
begin
  var ViewCaixaNovoMovimento := TViewCaixaNovoMovimento.Create(AOwner);
  try
    ViewCaixaNovoMovimento.ShowModal();
    Result := ViewCaixaNovoMovimento.FMovimento;
  finally
    FreeAndNil(ViewCaixaNovoMovimento);
  end;
end;

procedure TViewCaixaNovoMovimento.FormCreate(Sender: TObject);
begin
  inherited;
  FMovimento := nil;
end;

end.
