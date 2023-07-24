unit Loja.View.Vender;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloMdi, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls,

  Loja.DM.Imagens,
  Loja.Controller.Vendas;

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
    Panel2: TPanel;
    Panel3: TPanel;
    dbgItens: TDBGrid;
    DBNavigator1: TDBNavigator;
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
    procedure edtPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbBuscarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
  private
    FControllerVendas: TControllerVendas;
  public
    { Public declarations }
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
     // Criar uma nova venda e ent�o inserir item
    finally
      sbInserirItem.Down := True;
      sbBuscar.Click;
    end;
  end
  else
  if sbConsultaPreco.Down
  then begin
    // Identificar o item e consultar pre�o
    try
      TViewConsultaPrecoVenda.Exibir(Self, 1);
    finally
      sbInserirItem.Down := True;
    end;
  end;
end;

end.
