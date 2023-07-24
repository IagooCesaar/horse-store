unit Loja.View.Vender;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloMdi, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls,
  Vcl.CategoryButtons, Vcl.Mask,

  Loja.DM.Imagens,
  Loja.Controller.Vendas,
  Loja.Controller.Itens;

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
    pControleItens: TPanel;
    dbnItens: TDBNavigator;
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
    Label5: TLabel;
    DBEdit1: TDBEdit;
    dsVenda: TDataSource;
    Label6: TLabel;
    DBEdit2: TDBEdit;
    Label7: TLabel;
    DBEdit3: TDBEdit;
    Label8: TLabel;
    DBEdit4: TDBEdit;
    Label9: TLabel;
    DBEdit5: TDBEdit;
    Label10: TLabel;
    DBEdit6: TDBEdit;
    Label11: TLabel;
    DBEdit7: TDBEdit;
    Label12: TLabel;
    DBEdit8: TDBEdit;
    dsItens: TDataSource;
    Label13: TLabel;
    DBEdit9: TDBEdit;
    Label14: TLabel;
    DBEdit10: TDBEdit;
    Label15: TLabel;
    DBEdit11: TDBEdit;
    Label16: TLabel;
    DBEdit12: TDBEdit;
    Label17: TLabel;
    DBEdit13: TDBEdit;
    Label18: TLabel;
    DBEdit14: TDBEdit;
    Label19: TLabel;
    DBEdit15: TDBEdit;
    Label20: TLabel;
    DBEdit16: TDBEdit;
    procedure edtPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbBuscarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnAdicionarMeioPagtoClick(Sender: TObject);
    procedure dbgVendasDblClick(Sender: TObject);
    procedure btnEfetivarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnMeioPagtoRemoverClick(Sender: TObject);
  private
    FControllerVendas: TControllerVendas;
    FControllerItens: TControllerItens;
    function PermiteEditar: Boolean;
  public
    procedure AbrirDetalhesVenda(ANumVnda: Integer);
  end;

implementation

uses
  Loja.View.Preco.ConsultaPreco,
  Loja.Model.Venda.Types;

{$R *.dfm}

function PegaSeq(Texto: String; posicao: Integer; sep: String = '|'): String;
var sl : TStringList;
begin
  try
    sl := TStringList.Create;
    sl.StrictDelimiter := True;
    sl.Delimiter       := Sep[1];
    sl.DelimitedText   := Texto;
    if (sl.Count) < posicao
    then Result := ''
    else Result := sl.Strings[Posicao-1];
  finally
    FreeAndNil(sl);
  end;
end;

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

  pControleItens.Enabled := PermiteEditar;
end;

procedure TViewVender.btnAdicionarMeioPagtoClick(Sender: TObject);
begin
  inherited;
  if not PermiteEditar
  then Exit;
end;

procedure TViewVender.btnCancelarClick(Sender: TObject);
begin
  inherited;
  if not PermiteEditar
  then Exit;
end;

procedure TViewVender.btnEfetivarClick(Sender: TObject);
begin
  inherited;
  if not PermiteEditar
  then Exit;

end;

procedure TViewVender.btnMeioPagtoRemoverClick(Sender: TObject);
begin
  inherited;
  if not PermiteEditar
  then Exit;
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
  pcPrinc.ActivePage := tsVenda;
  edtDatIni.Date := Trunc(Now - 30);
  edtDatFim.Date := Trunc(Now);

  FControllerItens := TControllerItens.Create(Self);

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
  FreeAndNil(FControllerItens);
  inherited;
end;

function TViewVender.PermiteEditar: Boolean;
begin
  Result := TLojaModelVendaSituacao.CreateByName(
    FControllerVendas.mtDadosCOD_SIT.AsString) = sitPendente;
end;

procedure TViewVender.sbBuscarClick(Sender: TObject);
begin
  inherited;
  if sbInserirItem.Down
  then begin
    if not PermiteEditar
    then Exit;
    // Identificar o item e quantidade, inserir um novo com Desconto = 0

    var LQtd := 1;
    var LChave := '';
    if Pos('*', edtPesquisa.Text) > 0
    then begin
      LQtd := StrToIntDef(PegaSeq(edtPesquisa.Text, 1, '*').Trim, 1);
      LChave := PegaSeq(edtPesquisa.Text, 2, '*').Trim;
    end
    else LChave := Trim(edtPesquisa.Text);

    var LEncontrou := False;

    try
      FControllerItens.ObterItem(StrToIntDef(LChave, -1));
      LEncontrou := True;
    except
      LEncontrou := False;
    end;

    if not LEncontrou
    then try
      FControllerItens.ObterItem(LChave);
      LEncontrou := True;
    except
      LEncontrou := False;
    end;

    if not LEncontrou
    then raise Exception.Create('Não foi possível encontrar o item informado');

    ShowMessage(FControllerItens.mtDadosNOM_ITEM.AsString + ' | QTD: '+LQtd.ToString);

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
