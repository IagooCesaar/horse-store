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
    procedure FormCreate(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
  private
    FControllerCaixa: TControllerCaixa;
    FControllerMovimento: TControllerCaixaMovimento;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TViewCaixa.btnPesquisarClick(Sender: TObject);
begin
  inherited;
  FControllerCaixa.ObterCaixas(edtDatIni.Date, edtDatFim.Date);
end;

procedure TViewCaixa.FormCreate(Sender: TObject);
begin
  inherited;
  edtDatIni.Date := Trunc(Now - 30);
  edtDatFim.Date := Trunc(Now);

  FControllerCaixa := TControllerCaixa.Create(Self);
  FControllerMovimento := TControllerCaixaMovimento.Create(Self);

  dsCaixas.DataSet := FControllerCaixa.mtDados;
  dsMovimentos.DataSet := FControllerMovimento.mtDados;

  FrameCaixaResumoMeioPagto1.Nome := 'Dinheiro';
  FrameCaixaResumoMeioPagto1.Valor := 1234.56;
  FrameCaixaResumoMeioPagto1.Cor := clRed;
end;

end.
