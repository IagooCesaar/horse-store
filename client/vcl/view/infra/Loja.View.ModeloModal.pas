unit Loja.View.ModeloModal;

interface

uses
  Loja.View.Modelo,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.CategoryButtons;

type
  TViewModeloModal = class(TViewModelo)
    pModeloClient: TPanel;
    pModeloBotoes: TCategoryButtons;
    btnModeloOk: TButton;
    btnModeloCancelar: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

end.
