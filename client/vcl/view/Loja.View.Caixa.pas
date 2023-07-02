unit Loja.View.Caixa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloMdi, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.ComCtrls, Vcl.Buttons,

  Loja.Frame.Caixa.ResumoMeioPagto,

  Loja.Controller.Caixa,
  Loja.Controller.Caixa.Movimento, Vcl.Grids, Vcl.DBGrids;

type
  TViewCaixa = class(TViewModeloMdi)
    dsCaixas: TDataSource;
    dsMovimentos: TDataSource;
    pcPrinc: TPageControl;
    tsCaixa: TTabSheet;
    tsLista: TTabSheet;
    Panel1: TPanel;
    edtDatIni: TDateTimePicker;
    edtDatFim: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    pResumo: TPanel;
    pMovimentos: TPanel;
    pCaixasGrid: TPanel;
    Panel3: TPanel;
    Label3: TLabel;
    GridPanel1: TGridPanel;
    FrameCaixaResumoMeioPagto1: TFrameCaixaResumoMeioPagto;
    FrameCaixaResumoMeioPagto2: TFrameCaixaResumoMeioPagto;
    FrameCaixaResumoMeioPagto3: TFrameCaixaResumoMeioPagto;
    FrameCaixaResumoMeioPagto4: TFrameCaixaResumoMeioPagto;
    FrameCaixaResumoMeioPagto5: TFrameCaixaResumoMeioPagto;
    pAcoes: TPanel;
    btnPesquisar: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    dbgCaixas: TDBGrid;
    dbgMovimentos: TDBGrid;
    dsCaixa: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure dbgCaixasDblClick(Sender: TObject);
    procedure dbgMovimentosDblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FControllerCaixa: TControllerCaixa;
    FControllerMovimento: TControllerCaixaMovimento;

    procedure AbrirDetalhesCaixa(ACodCaixa: Integer);
  public

  end;

implementation

{$R *.dfm}

procedure TViewCaixa.AbrirDetalhesCaixa(ACodCaixa: Integer);
begin
  if ACodCaixa = 0
  then begin
    FControllerCaixa.ObterCaixaAberto;
    ACodCaixa := FControllerCaixa.mtDadosCOD_CAIXA.AsInteger;
  end
  else
    FControllerCaixa.ObterCaixa(ACodCaixa);

  FControllerMovimento.ObterMovimentosCaixa(ACodCaixa);
  FControllerCaixa.ObterResumoCaixa(ACodCaixa);

  FControllerCaixa.mtResumoMeiosPagto.First;
  while not FControllerCaixa.mtResumoMeiosPagto.Eof
  do begin
    case FControllerCaixa.mtResumoMeiosPagto.RecNo of
      1: begin
        FrameCaixaResumoMeioPagto1.Nome := FControllerCaixa.mtResumoMeiosPagtoCOD_MEIO_PAGTO.AsString;
        FrameCaixaResumoMeioPagto1.Valor := FControllerCaixa.mtResumoMeiosPagtoVR_TOTAL.AsFloat;
      end;
      2: begin
        FrameCaixaResumoMeioPagto2.Nome := FControllerCaixa.mtResumoMeiosPagtoCOD_MEIO_PAGTO.AsString;
        FrameCaixaResumoMeioPagto2.Valor := FControllerCaixa.mtResumoMeiosPagtoVR_TOTAL.AsFloat;
      end;
      3: begin
        FrameCaixaResumoMeioPagto3.Nome := FControllerCaixa.mtResumoMeiosPagtoCOD_MEIO_PAGTO.AsString;
        FrameCaixaResumoMeioPagto3.Valor := FControllerCaixa.mtResumoMeiosPagtoVR_TOTAL.AsFloat;
      end;
      4: begin
        FrameCaixaResumoMeioPagto4.Nome := FControllerCaixa.mtResumoMeiosPagtoCOD_MEIO_PAGTO.AsString;
        FrameCaixaResumoMeioPagto4.Valor := FControllerCaixa.mtResumoMeiosPagtoVR_TOTAL.AsFloat;
      end;
      5: begin
        FrameCaixaResumoMeioPagto5.Nome := FControllerCaixa.mtResumoMeiosPagtoCOD_MEIO_PAGTO.AsString;
        FrameCaixaResumoMeioPagto5.Valor := FControllerCaixa.mtResumoMeiosPagtoVR_TOTAL.AsFloat;
      end;
    end;
    FControllerCaixa.mtResumoMeiosPagto.Next;
  end;

  pcPrinc.ActivePage := tsCaixa;
end;

procedure TViewCaixa.btnPesquisarClick(Sender: TObject);
begin
  inherited;
  FControllerCaixa.ObterCaixas(edtDatIni.Date, edtDatFim.Date);
end;

procedure TViewCaixa.dbgCaixasDblClick(Sender: TObject);
begin
  inherited;
  AbrirDetalhesCaixa(FControllerCaixa.mtCaixasCOD_CAIXA.AsInteger);
end;

procedure TViewCaixa.dbgMovimentosDblClick(Sender: TObject);
begin
  inherited;
  ShowMessage(FControllerCaixa.mtResumoCaixa.FieldByName('MEIOS_PAGTO').AsString);
end;

procedure TViewCaixa.FormCreate(Sender: TObject);
begin
  inherited;
  edtDatIni.Date := Trunc(Now - 30);
  edtDatFim.Date := Trunc(Now);

  FControllerCaixa := TControllerCaixa.Create(Self);
  FControllerMovimento := TControllerCaixaMovimento.Create(Self);

  dsCaixa.DataSet := FControllerCaixa.mtDados;
  dsCaixas.DataSet := FControllerCaixa.mtCaixas;
  dsMovimentos.DataSet := FControllerMovimento.mtDados;

  FrameCaixaResumoMeioPagto1.Nome := 'Dinheiro';
  FrameCaixaResumoMeioPagto1.Valor := 1234.56;
  FrameCaixaResumoMeioPagto1.Cor := clRed;
end;

procedure TViewCaixa.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  AbrirDetalhesCaixa(0);
end;

end.
