unit Loja.View.Caixa.Fechamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloModal, Vcl.StdCtrls,
  Vcl.CategoryButtons, Vcl.ExtCtrls,

  Loja.Model.Caixa.Fechamento;

type
  TViewCaixaFechamento = class(TViewModeloModal)
  private
    FFechamento: TLojaModelCaixaFechamento;
  public
    class function Exibir(AOwner: TComponent): TLojaModelCaixaFechamento;
  end;

implementation

{$R *.dfm}

{ TViewCaixaFechamento }

class function TViewCaixaFechamento.Exibir(
  AOwner: TComponent): TLojaModelCaixaFechamento;
begin
  var ViewCaixaFechamento := TViewCaixaFechamento.Create(AOwner);
  try
    ViewCaixaFechamento.ShowModal();
    Result := ViewCaixaFechamento.FFechamento;
  finally
    FreeAndNil(ViewCaixaFechamento);
  end;
end;

end.
