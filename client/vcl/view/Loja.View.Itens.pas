unit Loja.View.Itens;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloMdi,

  Loja.Controller.Itens, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TViewItens = class(TViewModeloMdi)
    dbCOD_ITEM: TDBEdit;
    dbgrdItens: TDBGrid;
    dbNOM_ITEM: TDBEdit;
    dbNUM_COD_BARR: TDBEdit;
    dsItens: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    grpPesquisa: TGroupBox;
    Label4: TLabel;
    edtFiltroCodigo: TEdit;
    Panel1: TPanel;
    Label5: TLabel;
    rbtFiltroDescricaoContenha: TRadioButton;
    rbtFiltroDescricaoInicie: TRadioButton;
    rbtFiltroDescricaoFinalize: TRadioButton;
    edtFiltroDescricao: TEdit;
    btnPesquisar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
  private
    { Private declarations }
    FController: TControllerItens;
  public
    { Public declarations }
  end;


implementation

uses
  Loja.Model.Infra.Types;

{$R *.dfm}

procedure TViewItens.btnPesquisarClick(Sender: TObject);
var LNomeFiltro: TLhsBracketFilter;
begin
  inherited;
  LNomeFiltro.Valor := edtFiltroDescricao.Text;
  if rbtFiltroDescricaoContenha.Checked
  then LNomeFiltro.Tipo := TLhsBracketsType.Contains
  else
  if rbtFiltroDescricaoInicie.Checked
  then LNomeFiltro.Tipo := TLhsBracketsType.StartsWith
  else
  if rbtFiltroDescricaoFinalize.Checked
  then LNomeFiltro.Tipo := TLhsBracketsType.EndsWith;

  FController.ObterItens(LNomeFiltro);

  LNomeFiltro := Default(TLhsBracketFilter);
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
