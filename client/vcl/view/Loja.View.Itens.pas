unit Loja.View.Itens;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloMdi,

  Loja.Controller.Itens, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TViewItens = class(TViewModeloMdi)
    dsItens: TDataSource;
    dbCOD_ITEM: TDBEdit;
    Label1: TLabel;
    dbNOM_ITEM: TDBEdit;
    Label2: TLabel;
    Label3: TLabel;
    dbNUM_COD_BARR: TDBEdit;
    Button1: TButton;
    dbgrdItens: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FController: TControllerItens;
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TViewItens.Button1Click(Sender: TObject);
begin
  inherited;
  FController.ObterItens('Teste');
end;

procedure TViewItens.FormCreate(Sender: TObject);
begin
  inherited;
  FController := TControllerItens.Create(Self);
  dsItens.DataSet := FController.mtDados;
end;

procedure TViewItens.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(FController);
end;

end.
