unit Loja.View.Itens;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloMdi,

  Loja.Controller.Itens, Data.DB;

type
  TViewItens = class(TViewModeloMdi)
    dsItens: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FController: TControllerItens;
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TViewItens.FormCreate(Sender: TObject);
begin
  inherited;
  FController := TControllerItens.Create(Self);
//  dsItens.DataSe
end;

procedure TViewItens.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(FController);
end;

end.
