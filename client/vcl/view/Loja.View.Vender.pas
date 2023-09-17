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
    dbNUM_VNDA: TDBEdit;
    dsVenda: TDataSource;
    Label6: TLabel;
    dbCOD_SIT: TDBEdit;
    Label7: TLabel;
    dbDAT_INCL: TDBEdit;
    Label8: TLabel;
    dbDAT_CONCL: TDBEdit;
    Label9: TLabel;
    dbVR_BRUTO1: TDBEdit;
    Label10: TLabel;
    dbVR_DESC1: TDBEdit;
    Label11: TLabel;
    dbVR_TOTAL1: TDBEdit;
    Label12: TLabel;
    dbNUM_SEQ_ITEM: TDBEdit;
    dsItens: TDataSource;
    Label13: TLabel;
    dbCOD_SIT1: TDBEdit;
    Label14: TLabel;
    dbCOD_ITEM: TDBEdit;
    Label15: TLabel;
    dbNOM_ITEM: TDBEdit;
    Label16: TLabel;
    dbQTD_ITEM: TDBEdit;
    Label17: TLabel;
    dbVR_PRECO_UNIT: TDBEdit;
    Label18: TLabel;
    dbVR_BRUTO: TDBEdit;
    Label19: TLabel;
    dbVR_DESC: TDBEdit;
    Label20: TLabel;
    dbVR_TOTAL: TDBEdit;
    Label21: TLabel;
    dbNUM_VNDA1: TDBEdit;
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

    procedure mtItensBeforePost(DataSet: TDataSet);
    procedure mtItensBeforeDelete(DataSet: TDataSet);
    procedure mtItensAfterScroll(DataSet: TDataSet);

    procedure dbgMeiosPagtoDblClick(Sender: TObject);
    procedure dbQTD_ITEMKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FControllerVendas: TControllerVendas;
    FControllerItens: TControllerItens;
    function PermiteEditar: Boolean;
  public
    procedure AbrirDetalhesVenda(ANumVnda: Integer);
  end;

implementation

uses
  Loja.View.Venda.InserirMeioPagto,
  Loja.View.Preco.ConsultaPreco,
  Loja.Model.Venda.Types,
  Loja.Model.Caixa.Types;

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

  if FControllerVendas.mtVendas.IsEmpty
  then ShowMessage('A consulta não retornou dados');

end;

procedure TViewVender.dbgMeiosPagtoDblClick(Sender: TObject);
begin
  inherited;

  var LMeioPagto := TLojaModelCaixaMeioPagamento.Create(
    FControllerVendas.mtMeiosPagtoCOD_MEIO_PAGTO.AsString);

  TViewVendaInserirMeioPagto.Exibir(Self,
    FControllerVendas,
    FControllerVendas.mtDadosNUM_VNDA.AsInteger,
    LMeioPagto, False);
end;

procedure TViewVender.dbgVendasDblClick(Sender: TObject);
begin
  inherited;
  if FControllerVendas.mtVendas.IsEmpty
  then Exit;

  AbrirDetalhesVenda(FControllerVendas.mtVendasNUM_VNDA.AsInteger);
end;

procedure TViewVender.dbQTD_ITEMKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if  (Key = VK_RETURN)
  and (FControllerVendas.mtItens.State in [dsInsert, dsEdit])
  then begin
    FControllerVendas.mtItens.Post;

    if edtPesquisa.CanFocus
    then edtPesquisa.SetFocus;
  end;
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
var LMeioPagto: TLojaModelCaixaMeioPagamento;
begin
  inherited;
  if not PermiteEditar
  then Exit;

  if TButton(Sender) = btnMeioPagtoDN
  then LMeioPagto := pagDinheiro
  else
  if TButton(Sender) = btnMeioPagtoPIX
  then LMeioPagto := pagPix
  else
  if TButton(Sender) = btnMeioPagtoCC
  then LMeioPagto := pagCartaoCredito
  else
  if TButton(Sender) = btnMeioPagtoCD
  then LMeioPagto := pagCartaoDebito
  else
  if TButton(Sender) = btnMeioPagtoVO
  then LMeioPagto := pagVoucher
  else
  if TButton(Sender) = btnMeioPagtoCH
  then LMeioPagto := pagCheque;

  TViewVendaInserirMeioPagto.Exibir(Self,
    FControllerVendas,
    FControllerVendas.mtDadosNUM_VNDA.AsInteger,
    LMeioPagto, True);

end;

procedure TViewVender.btnCancelarClick(Sender: TObject);
begin
  inherited;
  if not PermiteEditar
  then Exit;

  if FControllerVendas.mtItens.State in [dsInsert, dsEdit]
  then raise Exception.Create('Termine de editar o item selecionado');

  if FControllerVendas.mtMeiosPagto.State in [dsInsert, dsEdit]
  then raise Exception.Create('Termine de editar o meio de pagamento selecionado');

  FControllerVendas.CancelarVenda(FControllerVendas.mtDadosNUM_VNDA.AsInteger);
  AbrirDetalhesVenda(FControllerVendas.mtDadosNUM_VNDA.AsInteger);

  ShowMessage('A venda foi cancelada!');
end;

procedure TViewVender.btnEfetivarClick(Sender: TObject);
begin
  inherited;
  if not PermiteEditar
  then Exit;

  if FControllerVendas.mtItens.State in [dsInsert, dsEdit]
  then raise Exception.Create('Termine de editar o item selecionado');

  if FControllerVendas.mtMeiosPagto.State in [dsInsert, dsEdit]
  then raise Exception.Create('Termine de editar o meio de pagamento selecionado');

  FControllerVendas.EfetivarVenda(FControllerVendas.mtDadosNUM_VNDA.AsInteger);
  AbrirDetalhesVenda(FControllerVendas.mtDadosNUM_VNDA.AsInteger);

  ShowMessage('A venda foi efetivada com sucesso!');

  sbNovaVenda.Down := True;
end;

procedure TViewVender.btnMeioPagtoRemoverClick(Sender: TObject);
begin
  inherited;
  if not PermiteEditar
  then Exit;

  FControllerVendas.mtMeiosPagto.Edit;
  FControllerVendas.mtMeiosPagtoQTD_PARC.AsInteger := 0;
  FControllerVendas.mtMeiosPagtoVR_TOTAL.AsFloat := 0;
  FControllerVendas.mtMeiosPagto.Post;
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

  FControllerVendas.mtItens.BeforeDelete := mtItensBeforeDelete;
  FControllerVendas.mtItens.BeforePost := mtItensBeforePost;
  FControllerVendas.mtItens.AfterScroll := mtItensAfterScroll;

  FControllerVendas.CriarDatasets;
end;

procedure TViewVender.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FControllerVendas);
  FreeAndNil(FControllerItens);
  inherited;
end;

procedure TViewVender.mtItensAfterScroll(DataSet: TDataSet);
begin
  FControllerVendas.mtItensAfterScroll(DataSet);
  dbVR_PRECO_UNIT.Enabled := not FControllerVendas.mtItensFLG_TAB_PRECO.AsBoolean;
  dbVR_PRECO_UNIT.ReadOnly := FControllerVendas.mtItensFLG_TAB_PRECO.AsBoolean;
end;

procedure TViewVender.mtItensBeforeDelete(DataSet: TDataSet);
begin
  FControllerVendas.mtItensBeforeDelete(DataSet);
  FControllerVendas.ObterVenda(FControllerVendas.mtDadosNUM_VNDA.AsInteger);
end;

procedure TViewVender.mtItensBeforePost(DataSet: TDataSet);
begin
  FControllerVendas.mtItensBeforePost(DataSet);
  FControllerVendas.ObterVenda(FControllerVendas.mtDadosNUM_VNDA.AsInteger);
end;

function TViewVender.PermiteEditar: Boolean;
begin
  Result := TLojaModelVendaSituacao.CreateByName(
    FControllerVendas.mtDadosCOD_SIT.AsString) = sitPendente;
end;

procedure TViewVender.sbBuscarClick(Sender: TObject);
begin
  inherited;
  if Trim(edtPesquisa.Text) = ''
  then Exit;

  var LQtd := 1;
  var LChave := '';
  if Pos('*', edtPesquisa.Text) > 0
  then begin
    LQtd := StrToIntDef(PegaSeq(edtPesquisa.Text, 1, '*').Trim, 1);
    LChave := PegaSeq(edtPesquisa.Text, 2, '*').Trim;
  end
  else LChave := Trim(edtPesquisa.Text);

  if sbInserirItem.Down
  then begin
    if FControllerVendas.mtDados.IsEmpty
    then begin
      FControllerVendas.NovaVenda;
      AbrirDetalhesVenda(FControllerVendas.mtDadosNUM_VNDA.AsInteger);
    end
    else
    if not PermiteEditar
    then Exit;

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

    try
      FControllerVendas.mtItens.Append;
      FControllerVendas.mtItensNUM_VNDA.AsInteger := FControllerVendas.mtDadosNUM_VNDA.AsInteger;
      FControllerVendas.mtItensCOD_ITEM.AsInteger := FControllerItens.mtDadosCOD_ITEM.AsInteger;
      FControllerVendas.mtItensQTD_ITEM.AsInteger := LQtd;
      FControllerVendas.mtItensVR_DESC.AsFloat := 0;
      FControllerVendas.mtItens.Post;

      FControllerVendas.ObterVenda(FControllerVendas.mtDadosNUM_VNDA.AsInteger);
    except
      FControllerVendas.mtItens.Cancel;
      raise;
    end;

    edtPesquisa.Clear;

    if FControllerItens.mtDadosFLG_TAB_PRECO.AsBoolean = false
    then if dbVR_PRECO_UNIT.CanFocus
         then dbVR_PRECO_UNIT.SetFocus;
  end
  else
  if sbNovaVenda.Down then
  begin
    try
      // Criar uma nova venda e então inserir item
      FControllerVendas.NovaVenda;
      AbrirDetalhesVenda(FControllerVendas.mtDadosNUM_VNDA.AsInteger);
    finally
      sbInserirItem.Down := True;
      sbBuscar.Click;
    end;
  end
  else
  if sbConsultaPreco.Down
  then begin
    // Identificar o item e consultar preço
    FControllerItens.ObterItem(StrToIntDef(LChave, -1));
    try
      TViewConsultaPrecoVenda.Exibir(Self, FControllerItens.mtDadosCOD_ITEM.AsInteger);
    finally
      sbInserirItem.Down := True;
    end;
  end;
end;

end.
