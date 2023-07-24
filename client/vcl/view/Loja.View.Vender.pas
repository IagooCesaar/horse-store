unit Loja.View.Vender;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloMdi, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls,

  Loja.DM.Imagens,
  Loja.Controller.Vendas, Vcl.CategoryButtons;

type
  TViewVender = class(TViewModeloMdi)
    pcPrinc: TPageControl;
    tsVenda: TTabSheet;
    tsPesquisa: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    edtPesquisa: TEdit;
    sbInserirItem: TSpeedButton;
    sbConsultaPreco: TSpeedButton;
    sbNovaVenda: TSpeedButton;
    dsVenda: TDataSource;
    dsItens: TDataSource;
    dsMeiosPagto: TDataSource;
    dsVendas: TDataSource;
    sbBuscar: TSpeedButton;
    pVendasGrid: TPanel;
    Panel4: TPanel;
    Label3: TLabel;
    dbgVendas: TDBGrid;
    Panel5: TPanel;
    Label2: TLabel;
    Label4: TLabel;
    edtDatIni: TDateTimePicker;
    edtDatFim: TDateTimePicker;
    btnPesquisar: TButton;
    rbtVendaPend: TRadioButton;
    rbtVendaCanc: TRadioButton;
    rbtVendaEfet: TRadioButton;
    GroupBox1: TGroupBox;
    dbgItens: TDBGrid;
    Panel3: TPanel;
    DBNavigator1: TDBNavigator;
    pBottom: TPanel;
    GroupBox3: TGroupBox;
    p1: TPanel;
    GroupBox2: TGroupBox;
    dbgMeiosPagto: TDBGrid;
    btnMeioPagtoCH: TButton;
    btnMeioPagtoVO: TButton;
    btnMeioPagtoCD: TButton;
    btnMeioPagtoCC: TButton;
    btnMeioPagtoPIX: TButton;
    btnMeioPagtoDN: TButton;
    btnMeioPagtoRemover: TButton;
    pModeloBotoes: TCategoryButtons;
    btnEfetivar: TButton;
    btnCancelar: TButton;
    procedure edtPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbBuscarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnAdicionarMeioPagtoClick(Sender: TObject);
    procedure dbgVendasDblClick(Sender: TObject);
  private
    FControllerVendas: TControllerVendas;
  public
    procedure AbrirDetalhesVenda(ANumVnda: Integer);
  end;

implementation

uses
  Loja.View.Preco.ConsultaPreco,
  Loja.Model.Venda.Types;

{$R *.dfm}

procedure TViewVender.btnPesquisarClick(Sender: TObject);
begin
  inherited;
  if rbtVendaPend.Checked
  then FControllerVendas.ObterVendas(edtDatIni.Date, edtDatFim.Date, TLojaModelVendaSituacao.sitPendente)
  else
  if rbtVendaCanc.Checked
  then FControllerVendas.ObterVendas(edtDatIni.Date, edtDatFim.Date, TLojaModelVendaSituacao.sitCancelada)
  else
  if rbtVendaEfet.Checked
  then FControllerVendas.ObterVendas(edtDatIni.Date, edtDatFim.Date, TLojaModelVendaSituacao.sitEfetivada);
end;

procedure TViewVender.dbgVendasDblClick(Sender: TObject);
begin
  inherited;
  if FControllerVendas.mtVendas.IsEmpty
  then Exit;

  AbrirDetalhesVenda(FControllerVendas.mtVendasNUM_VNDA.AsInteger);
end;

procedure TViewVender.AbrirDetalhesVenda(ANumVnda: Integer);
begin
  FControllerVendas.ObterVenda(ANumVnda);
  FControllerVendas.ObterItensVenda(ANumVnda);
  FControllerVendas.ObterMeiosPagtoVenda(ANumVnda);

  pcPrinc.ActivePage := tsVenda;
end;

procedure TViewVender.btnAdicionarMeioPagtoClick(Sender: TObject);
begin
  inherited;
  //
end;

procedure TViewVender.edtPesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN
  then sbBuscar.Click;
end;

procedure TViewVender.FormCreate(Sender: TObject);
begin
  inherited;
  edtDatIni.Date := Trunc(Now - 30);
  edtDatFim.Date := Trunc(Now);

  FControllerVendas := TControllerVendas.Create(Self);
  dsVenda.DataSet := FControllerVendas.mtDados;
  dsVendas.DataSet := FControllerVendas.mtVendas;
  dsItens.DataSet := FControllerVendas.mtItens;
  dsMeiosPagto.DataSet:= FControllerVendas.mtMeiosPagto;

  FControllerVendas.CriarDatasets;
end;

procedure TViewVender.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FControllerVendas);
  inherited;
end;

procedure TViewVender.sbBuscarClick(Sender: TObject);
begin
  inherited;
  if sbInserirItem.Down
  then begin
    // Identificar o item e quantidade, inserir um novo com Desconto = 0
  end
  else
  if sbNovaVenda.Down then
  begin
    try
     // Criar uma nova venda e então inserir item
    finally
      sbInserirItem.Down := True;
      sbBuscar.Click;
    end;
  end
  else
  if sbConsultaPreco.Down
  then begin
    // Identificar o item e consultar preço
    try
      TViewConsultaPrecoVenda.Exibir(Self, 1);
    finally
      sbInserirItem.Down := True;
    end;
  end;
end;

end.
