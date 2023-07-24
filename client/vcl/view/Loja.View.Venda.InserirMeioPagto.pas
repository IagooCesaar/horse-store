unit Loja.View.Venda.InserirMeioPagto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloModal, Vcl.StdCtrls,
  Vcl.CategoryButtons, Vcl.ExtCtrls,

  Loja.Controller.Vendas,
  Loja.Model.Caixa.Types, Data.DB, Vcl.Mask, Vcl.DBCtrls;

type
  TViewVendaInserirMeioPagto = class(TViewModeloModal)
    Label1: TLabel;
    cmbCOD_MEIO_PAGTO: TDBComboBox;
    Label2: TLabel;
    dbQTD_PARC: TDBEdit;
    dsMeioPagto: TDataSource;
    Label3: TLabel;
    dbVR_TOTAL: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnModeloOkClick(Sender: TObject);
    procedure btnModeloCancelarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FController: TControllerVendas;
    FNumVnda: Integer;
    FCodMeioPagto: TLojaModelCaixaMeioPagamento;
  public
    { Public declarations }
    class function Exibir(AOwner: TComponent;
      AControllerVenda: TControllerVendas;
      ANumVnda: Integer; ACodMeioPagto: TLojaModelCaixaMeioPagamento): Integer;
  end;



implementation

{$R *.dfm}

{ TViewVendaInserirMeioPagto }

procedure TViewVendaInserirMeioPagto.btnModeloCancelarClick(Sender: TObject);
begin
  inherited;
  FController.mtMeiosPagto.Cancel;
end;

procedure TViewVendaInserirMeioPagto.btnModeloOkClick(Sender: TObject);
begin
  inherited;
  FController.mtMeiosPagto.Post;
  ModalResult := mrOK;
end;

class function TViewVendaInserirMeioPagto.Exibir(AOwner: TComponent;
  AControllerVenda: TControllerVendas; ANumVnda: Integer;
  ACodMeioPagto: TLojaModelCaixaMeioPagamento): Integer;
begin
  var ViewVendaInserirMeioPagto := TViewVendaInserirMeioPagto.Create(AOwner);
  try
    ViewVendaInserirMeioPagto.FController := AControllerVenda;
    ViewVendaInserirMeioPagto.FNumVnda := ANumVnda;
    ViewVendaInserirMeioPagto.FCodMeioPagto := ACodMeioPagto;
    Result := ViewVendaInserirMeioPagto.ShowModal();
  finally
    FreeAndNil(ViewVendaInserirMeioPagto);
  end;
end;

procedure TViewVendaInserirMeioPagto.FormActivate(Sender: TObject);
begin
  inherited;

  if dbVR_TOTAL.CanFocus
  then dbVR_TOTAL.SetFocus;
end;

procedure TViewVendaInserirMeioPagto.FormCreate(Sender: TObject);
begin
  inherited;

  cmbCOD_MEIO_PAGTO.Items.Clear;
  for var LMeioPagto := Low(TLojaModelCaixaMeioPagamento) to High(TLojaModelCaixaMeioPagamento)
  do cmbCOD_MEIO_PAGTO.Items.Add(LMeioPagto.ToString);
end;

procedure TViewVendaInserirMeioPagto.FormShow(Sender: TObject);
begin
  inherited;
  var LTotalVenda := 0.00;
  var LTotalMeiosPagto := 0.00;

  FController.ObterVenda(FNumVnda);
  LTotalVenda := FController.mtDadosVR_TOTAL.AsFloat;

  FController.mtMeiosPagto.First;
  while not FController.mtMeiosPagto.Eof
  do begin
    LTotalMeiosPagto := LTotalMeiosPagto + FController.mtMeiosPagtoVR_TOTAL.AsFloat;
    FController.mtMeiosPagto.Next;
  end;

  LTotalMeiosPagto := LTotalVenda - LTotalMeiosPagto;
  if LTotalMeiosPagto < 0
  then LTotalMeiosPagto := 0;

  FController.mtMeiosPagto.Append;
  FController.mtMeiosPagtoNUM_VNDA.AsInteger := FNumVnda;
  FController.mtMeiosPagtoCOD_MEIO_PAGTO.AsString := FCodMeioPagto.ToString;
  FController.mtMeiosPagtoQTD_PARC.AsInteger := 1;
  FController.mtMeiosPagtoVR_TOTAL.AsFloat := LTotalMeiosPagto;
end;

end.
