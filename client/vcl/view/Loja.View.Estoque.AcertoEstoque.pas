unit Loja.View.Estoque.AcertoEstoque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloModal, Vcl.StdCtrls,
  Vcl.CategoryButtons, Vcl.ExtCtrls;

type
  TViewAcertoEstoque = class(TViewModeloModal)
    Label1: TLabel;
    Label2: TLabel;
    edtSaldoReal: TEdit;
    edtMotivo: TEdit;
    procedure btnModeloOkClick(Sender: TObject);
  private
    FCodItem: Integer;
  public
    class function Exibir(AOwner: TComponent; ACodItem: Integer): Integer;
  end;

implementation

uses
  Loja.Controller.Estoque.Saldo,
  Loja.Model.Estoque.AcertoEstoque;

{$R *.dfm}

procedure TViewAcertoEstoque.btnModeloOkClick(Sender: TObject);
begin
  inherited;
  if  edtSaldoReal.Text = ''
  then raise Exception.Create('Você deve informar o saldo real');

  if edtMotivo.Text = ''
  then raise Exception.Create('Você deve informar o motivo para o acerto de estoque');

  var LController := TControllerEstoqueSaldo.Create(Self);
  var LAcerto := TLojaModelEstoqueAcertoEstoque.Create;
  try
    LAcerto.QtdSaldoReal := StrToIntDef(edtSaldoReal.Text, 0);
    LAcerto.DscMot := edtMotivo.Text;

    LController.RealizarAcertoEstoque(FCodItem, LAcerto);
    Self.ModalResult := mrOk;
  finally
    LController.Free;
    LAcerto.Free;
  end;
end;

class function TViewAcertoEstoque.Exibir(AOwner: TComponent;
  ACodItem: Integer): Integer;
begin
  var ViewAcerto := TViewAcertoEstoque.Create(AOwner);
  try
    ViewAcerto.FCodItem := ACodItem;
    Result := ViewAcerto.ShowModal();
  finally
    FreeAndNil(ViewAcerto);
  end;
end;

end.
