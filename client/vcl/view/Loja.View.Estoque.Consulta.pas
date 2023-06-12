unit Loja.View.Estoque.Consulta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloModal, Vcl.StdCtrls,
  Vcl.CategoryButtons, Vcl.ExtCtrls,

  Loja.Controller.Estoque.Saldo,
  Loja.Controller.Itens, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Mask, Vcl.DBCtrls;

type
  TViewEstoqueConsulta = class(TViewModeloModal)
    dsItem: TDataSource;
    dsSaldo: TDataSource;
    pItem: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    dbCOD_ITEM: TDBEdit;
    dbNOM_ITEM: TDBEdit;
    dbNUM_COD_BARR: TDBEdit;
    dsMovimentos: TDataSource;
    GroupBox1: TGroupBox;
    dbgSaldo: TDBGrid;
    Label4: TLabel;
    dbQTD_SALDO_ATU: TDBEdit;
    dsFechamento: TDataSource;
    GroupBox2: TGroupBox;
    DBGrid1: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FControllerItens: TControllerItens;
    FControllerSaldo: TControllerEstoqueSaldo;
    FCodItem: Integer;
  public
    { Public declarations }
    class function Exibir(AOwner: TComponent; ACodItem: Integer): Integer;
  end;


implementation

{$R *.dfm}

class function TViewEstoqueConsulta.Exibir(AOwner: TComponent; ACodItem: Integer): Integer;
begin
  var ViewConsultaEstoque := TViewEstoqueConsulta.Create(AOwner);
  try
    ViewConsultaEstoque.FCodItem := ACodItem;
    Result := ViewConsultaEstoque.ShowModal();
  finally
    FreeAndNil(ViewConsultaEstoque);
  end;
end;

procedure TViewEstoqueConsulta.FormCreate(Sender: TObject);
begin
  inherited;
  FControllerItens := TControllerItens.Create(Self);
  FControllerSaldo := TControllerEstoqueSaldo.Create(Self);

  dsItem.DataSet := FControllerItens.mtDados;
  dsSaldo.DataSet := FControllerSaldo.mtDados;
  dsMovimentos.DataSet := FControllerSaldo.mtMovimentos;
  dsFechamento.DataSet := FControllerSaldo.mtUltFecha;
end;

procedure TViewEstoqueConsulta.FormShow(Sender: TObject);
begin
  inherited;
  FControllerItens.ObterItem(FCodItem);
  FControllerSaldo.ObterSaldo(FCodItem);
end;

end.
