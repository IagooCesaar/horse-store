unit Loja.View.Preco.ConsultaPreco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloModal, Vcl.StdCtrls,
  Vcl.CategoryButtons, Vcl.ExtCtrls,

  Loja.Controller.Preco.Venda,
  Loja.Controller.Itens, Data.DB, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TViewConsultaPrecoVenda = class(TViewModeloModal)
    dsItem: TDataSource;
    dsPrecoAtual: TDataSource;
    pItem: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    dbCOD_ITEM: TDBEdit;
    dbNOM_ITEM: TDBEdit;
    dbNUM_COD_BARR: TDBEdit;
    dbQTD_SALDO_ATU: TDBEdit;
    dsHistoricoPreco: TDataSource;
    pcPrecos: TPageControl;
    tsHistorico: TTabSheet;
    tsNovoPreco: TTabSheet;
    Panel1: TPanel;
    dbgHistorico: TDBGrid;
    Label5: TLabel;
    edtDatIniPrecoVenda: TDateTimePicker;
    dsNovoPreco: TDataSource;
    btnCadastrar: TButton;
    Label6: TLabel;
    Label7: TLabel;
    dbVR_VNDA: TDBEdit;
    edtDatIniVig: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtDatIniPrecoVendaChange(Sender: TObject);
    procedure btnCadastrarClick(Sender: TObject);
    procedure pcPrecosChange(Sender: TObject);
  private
    FCodItem: Integer;
    FControllerItens: TControllerItens;
    FControllerPrecoVenda: TControllerPrecoVenda;

    procedure AtualizarTela;
  public
    class function Exibir(AOwner: TComponent; ACodItem: Integer): Integer;
  end;



implementation

uses
  System.DateUtils,
  Loja.Model.Preco.PrecoVenda;

{$R *.dfm}

{ TViewConsultaPrecoVenda }

procedure TViewConsultaPrecoVenda.AtualizarTela;
begin
  FControllerItens.ObterItem(FCodItem);
  FControllerPrecoVenda.ObterPrecoVendaAtual(FCodItem);
  FControllerPrecoVenda.ObterHistoricoPrecoVenda(FCodItem, edtDatIniPrecoVenda.DateTime);
end;

procedure TViewConsultaPrecoVenda.btnCadastrarClick(Sender: TObject);
begin
  inherited;
  if FControllerPrecoVenda.mtNovoPrecoCOD_ITEM.AsInteger = 0
  then raise Exception.Create('Você deverá informar o valor de venda');

  FControllerPrecoVenda.mtNovoPrecoCOD_ITEM.AsInteger := FCodItem;
  FControllerPrecoVenda.mtNovoPrecoDAT_INI.AsDateTime := edtDatIniVig.DateTime;
  FControllerPrecoVenda.mtNovoPreco.Post;

  AtualizarTela;
  pcPrecos.ActivePage := tsHistorico;
end;

procedure TViewConsultaPrecoVenda.edtDatIniPrecoVendaChange(Sender: TObject);
begin
  inherited;
  FControllerPrecoVenda.ObterHistoricoPrecoVenda(FCodItem, edtDatIniPrecoVenda.DateTime);
end;

class function TViewConsultaPrecoVenda.Exibir(AOwner: TComponent;
  ACodItem: Integer): Integer;
begin
  var ViewConsultaPrecoVenda := TViewConsultaPrecoVenda.Create(AOwner);
  try
    ViewConsultaPrecoVenda.FCodItem := ACodItem;
    Result := ViewConsultaPrecoVenda.ShowModal();
  finally
    ViewConsultaPrecoVenda.Free;
  end;
end;

procedure TViewConsultaPrecoVenda.FormCreate(Sender: TObject);
begin
  inherited;
  FControllerItens := TControllerItens.Create(Self);
  FControllerPrecoVenda := TControllerPrecoVenda.Create(Self);

  dsItem.DataSet := FControllerItens.mtDados;
  dsHistoricoPreco.DataSet := FControllerPrecoVenda.mtDados;
  dsPrecoAtual.DataSet := FControllerPrecoVenda.mtPrecoAtual;
  dsNovoPreco.DataSet := FControllerPrecoVenda.mtNovoPreco;

  pcPrecos.ActivePage := tsHistorico;
end;

procedure TViewConsultaPrecoVenda.FormShow(Sender: TObject);
begin
  inherited;
  edtDatIniVig.DateTime := Now;
  edtDatIniPrecoVenda.DateTime := StartOfTheDay(IncMonth(Now, -2));
  AtualizarTela;
end;

procedure TViewConsultaPrecoVenda.pcPrecosChange(Sender: TObject);
begin
  inherited;
  if (pcPrecos.ActivePage = tsNovoPreco)
  and not(dsNovoPreco.State in [dsInsert])
  then dsNovoPreco.DataSet.Append;
end;

end.
