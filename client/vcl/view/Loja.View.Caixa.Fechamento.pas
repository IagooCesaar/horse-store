unit Loja.View.Caixa.Fechamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloModal, Vcl.StdCtrls,
  Vcl.CategoryButtons, Vcl.ExtCtrls,

  Loja.Model.Caixa.Types,
  Loja.Model.Caixa.Fechamento,
  Loja.Model.Caixa.ResumoMeioPagto,
  Loja.Controller.Caixa;

type
  TViewCaixaFechamento = class(TViewModeloModal)
    pAviso: TPanel;
    Label1: TLabel;
    edtDinheiro: TEdit;
    lbAviso: TLabel;
    Label2: TLabel;
    edtPix: TEdit;
    Label3: TLabel;
    edtCartaoCredito: TEdit;
    Label4: TLabel;
    edtCartaoDebito: TEdit;
    Label5: TLabel;
    edtCheque: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnModeloOkClick(Sender: TObject);
  private
    FCodCaixa: Integer;
    FFechamento: TLojaModelCaixaFechamento;
    FController: TControllerCaixa;
  public
    class function Exibir(AOwner: TComponent; ACodCaixa: Integer; AControllerCaixa: TControllerCaixa): Integer;
  end;

implementation

{$R *.dfm}

{ TViewCaixaFechamento }

procedure TViewCaixaFechamento.btnModeloOkClick(Sender: TObject);
begin
  inherited;
  var LDinheiro := StrToFloatDef(edtDinheiro.Text, 0);
  var LPix := StrToFloatDef(edtPix.Text, 0);
  var LCartaoCredito := StrToFloatDef(edtCartaoCredito.Text, 0);
  var LCartaoDebito := StrToFloatDef(edtCartaoDebito.Text, 0);
  var LCheque := StrToFloatDef(edtCheque.Text, 0);

  edtDinheiro.Text := FloatToStr(LDinheiro);
  edtPix.Text := FloatToStr(LPix);
  edtCartaoCredito.Text := FloatToStr(LCartaoCredito);
  edtCartaoDebito.Text := FloatToStr(LCartaoDebito);
  edtCheque.Text := FloatToStr(LCheque);

  FFechamento.MeiosPagto.Get(pagDinheiro).VrTotal := LDinheiro;
  FFechamento.MeiosPagto.Get(pagPix).VrTotal := LPix;
  FFechamento.MeiosPagto.Get(pagCartaoCredito).VrTotal := LCartaoCredito;
  FFechamento.MeiosPagto.Get(pagCartaoDebito).VrTotal := LCartaoDebito;
  FFechamento.MeiosPagto.Get(pagCheque).VrTotal := LCheque;

  FController.FecharCaixa(FCodCaixa, FFechamento);
  Self.ModalResult := mrOk;
end;

class function TViewCaixaFechamento.Exibir(
  AOwner: TComponent; ACodCaixa: Integer;
  AControllerCaixa: TControllerCaixa): Integer;
begin
  var ViewCaixaFechamento := TViewCaixaFechamento.Create(AOwner);
  try
    ViewCaixaFechamento.FCodCaixa := ACodCaixa;
    ViewCaixaFechamento.FController := AControllerCaixa;
    Result := ViewCaixaFechamento.ShowModal();
  finally
    FreeAndNil(ViewCaixaFechamento);
  end;
end;

procedure TViewCaixaFechamento.FormCreate(Sender: TObject);
begin
  inherited;
  FFechamento := TLojaModelCaixaFechamento.Create;
  FFechamento.MeiosPagto := TLojaModelCaixaResumoMeioPagtoLista.Create;
end;

procedure TViewCaixaFechamento.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(FFechamento);
end;

end.
