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
    grpPesquisa: TGroupBox;
    Label4: TLabel;
    edtFiltroCodigo: TEdit;
    pFiltroDescricao: TPanel;
    Label5: TLabel;
    rbtFiltroDescricaoContenha: TRadioButton;
    rbtFiltroDescricaoInicie: TRadioButton;
    rbtFiltroDescricaoFinalize: TRadioButton;
    edtFiltroDescricao: TEdit;
    btnPesquisar: TButton;
    rbtFiltroDescricaoNaoFiltrar: TRadioButton;
    Panel1: TPanel;
    Label6: TLabel;
    rbtFiltroCodBarrasContenha: TRadioButton;
    rbtFiltroCodBarrasInicie: TRadioButton;
    rbtFiltroCodBarrasFinalize: TRadioButton;
    Edit1: TEdit;
    rbtFiltroCodBarrasNaoFiltrar: TRadioButton;
    pGrid: TPanel;
    pManut: TPanel;
    dbgrdItens: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    dbCOD_ITEM: TDBEdit;
    dbNOM_ITEM: TDBEdit;
    dbNUM_COD_BARR: TDBEdit;
    dbnItens: TDBNavigator;
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
var LFiltroNome, LFiltroCodBarras: TLhsBracketFilter;
begin
  inherited;
  LFiltroNome.Valor := edtFiltroDescricao.Text;
  if rbtFiltroDescricaoContenha.Checked
  then LFiltroNome.Tipo := TLhsBracketsType.Contains
  else
  if rbtFiltroDescricaoInicie.Checked
  then LFiltroNome.Tipo := TLhsBracketsType.StartsWith
  else
  if rbtFiltroDescricaoFinalize.Checked
  then LFiltroNome.Tipo := TLhsBracketsType.EndsWith;

  FController.ObterItens(StrToIntDef(edtFiltroCodigo.Text, 0),
    LFiltroNome, LFiltroCodBarras);

  if FController.mtDados.IsEmpty
  then ShowMessage('A consulta não retornou dados');
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
