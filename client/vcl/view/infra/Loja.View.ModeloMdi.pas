unit Loja.View.ModeloMdi;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.Modelo, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TViewModeloMdi = class(TViewModelo)
    pModeloClient: TPanel;
    pModeloTop: TPanel;
    bvlModeloLinha: TBevel;
    lbModeloTitulo: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TViewModeloMdi.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

end.
