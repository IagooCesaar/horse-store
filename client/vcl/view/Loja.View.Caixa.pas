unit Loja.View.Caixa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloMdi, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.ComCtrls, Vcl.Buttons,

  Loja.Frame.Caixa.ResumoMeioPagto,

  Loja.Controller.Caixa,
  Loja.Controller.Caixa.Movimento, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls;

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
    pVerCaixaAberto: TPanel;
    sbVerCaixaAberto: TSpeedButton;
    pResumo: TPanel;
    pMovimentos: TPanel;
    pCaixasGrid: TPanel;
    Panel3: TPanel;
    Label3: TLabel;
    grpResumo: TGridPanel;
    FrameCaixaResumoMeioPagto1: TFrameCaixaResumoMeioPagto;
    FrameCaixaResumoMeioPagto2: TFrameCaixaResumoMeioPagto;
    FrameCaixaResumoMeioPagto3: TFrameCaixaResumoMeioPagto;
    FrameCaixaResumoMeioPagto4: TFrameCaixaResumoMeioPagto;
    FrameCaixaResumoMeioPagto5: TFrameCaixaResumoMeioPagto;
    pAcoes: TPanel;
    btnPesquisar: TButton;
    btnCriarSangria: TButton;
    btnCriarReforco: TButton;
    btnFechamento: TButton;
    btnAbertura: TButton;
    dbgCaixas: TDBGrid;
    dbgMovimentos: TDBGrid;
    dsCaixa: TDataSource;
    pDados: TPanel;
    Label4: TLabel;
    dbtCOD_CAIXA: TDBText;
    dbtCOD_SIT: TDBText;
    Label5: TLabel;
    Label6: TLabel;
    dbtDAT_ABERT: TDBText;
    Label7: TLabel;
    dbtVR_ABERT: TDBText;
    Label8: TLabel;
    dbtDAT_FECHA: TDBText;
    Label9: TLabel;
    dbtVR_FECHA: TDBText;
    btnAtualizar: TButton;
    FrameCaixaResumoMeioPagto6: TFrameCaixaResumoMeioPagto;
    procedure FormCreate(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure dbgCaixasDblClick(Sender: TObject);
    procedure sbVerCaixaAbertoClick(Sender: TObject);
    procedure btnCriarMovimentoClick(Sender: TObject);
    procedure btnFechamentoClick(Sender: TObject);
    procedure btnAberturaClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
  private
    FControllerCaixa: TControllerCaixa;
    FControllerMovimento: TControllerCaixaMovimento;

    procedure AbrirDetalhesCaixa(ACodCaixa: Integer);
    procedure AtualizarResumoCaixa(ACodCaixa: Integer);
  public

  end;

implementation

uses
  Loja.View.Caixa.NovoMovimento,
  Loja.View.Caixa.Fechamento,
  Loja.View.ModeloModal,
  Loja.Model.Caixa.Types;

{$R *.dfm}

procedure TViewCaixa.AbrirDetalhesCaixa(ACodCaixa: Integer);
begin
  if ACodCaixa = 0
  then begin
    FControllerCaixa.ObterCaixaAberto;
    ACodCaixa := FControllerCaixa.mtDadosCOD_CAIXA.AsInteger;
    pVerCaixaAberto.Visible := False;
  end
  else
  begin
    FControllerCaixa.ObterCaixa(ACodCaixa);
    pVerCaixaAberto.Visible := True;
  end;

  FControllerMovimento.ObterMovimentosCaixa(ACodCaixa);
  AtualizarResumoCaixa(ACodCaixa);

  pcPrinc.ActivePage := tsCaixa;
end;

procedure TViewCaixa.AtualizarResumoCaixa(ACodCaixa: Integer);
begin
  FControllerCaixa.ObterResumoCaixa(ACodCaixa);

  FControllerCaixa.mtResumoMeiosPagto.First;
  while not FControllerCaixa.mtResumoMeiosPagto.Eof
  do begin
    var LMeioPagto := TLojaModelCaixaMeioPagamento.Create(FControllerCaixa.mtResumoMeiosPagtoCOD_MEIO_PAGTO.AsString).Name;
    var LVrTotal := FControllerCaixa.mtResumoMeiosPagtoVR_TOTAL.AsFloat;
    case FControllerCaixa.mtResumoMeiosPagto.RecNo of
      1: begin
        FrameCaixaResumoMeioPagto1.Nome := LMeioPagto;
        FrameCaixaResumoMeioPagto1.Valor := LVrTotal;
      end;
      2: begin
        FrameCaixaResumoMeioPagto2.Nome := LMeioPagto;
        FrameCaixaResumoMeioPagto2.Valor := LVrTotal;
      end;
      3: begin
        FrameCaixaResumoMeioPagto3.Nome := LMeioPagto;
        FrameCaixaResumoMeioPagto3.Valor := LVrTotal;
      end;
      4: begin
        FrameCaixaResumoMeioPagto4.Nome := LMeioPagto;
        FrameCaixaResumoMeioPagto4.Valor := LVrTotal;
      end;
      5: begin
        FrameCaixaResumoMeioPagto5.Nome := LMeioPagto;
        FrameCaixaResumoMeioPagto5.Valor := LVrTotal;
      end;
      6: begin
        FrameCaixaResumoMeioPagto6.Nome := LMeioPagto;
        FrameCaixaResumoMeioPagto6.Valor := LVrTotal;
      end;
    end;
    FControllerCaixa.mtResumoMeiosPagto.Next;
  end;
end;

procedure TViewCaixa.btnCriarMovimentoClick(Sender: TObject);
begin
  inherited;
  var LMovimento := TViewCaixaNovoMovimento.Exibir(Self);
  if LMovimento = nil
  then Exit;

  try
    if TButton(Sender) = btnCriarSangria
    then FControllerMovimento.CriarMovimentoSangria(
           FControllerCaixa.mtDadosCOD_CAIXA.AsInteger,
           LMovimento)
    else FControllerMovimento.CriarMovimentoReforco(
           FControllerCaixa.mtDadosCOD_CAIXA.AsInteger,
           LMovimento);

    AtualizarResumoCaixa(FControllerCaixa.mtDadosCOD_CAIXA.AsInteger);
  finally
    LMovimento.Free;
  end;
end;

procedure TViewCaixa.btnFechamentoClick(Sender: TObject);
begin
  inherited;
  try
    grpResumo.Visible := False;
    if TViewCaixaFechamento.Exibir(Self,
      FControllerCaixa.mtDadosCOD_CAIXA.AsInteger,
      FControllerCaixa) = mrOK
    then begin
      AbrirDetalhesCaixa(FControllerCaixa.mtDadosCOD_CAIXA.AsInteger);
      ShowMessage('Caixa fechado com sucesso!');
    end;
  finally
    grpResumo.Visible := True;
  end;
end;

procedure TViewCaixa.btnPesquisarClick(Sender: TObject);
begin
  inherited;
  FControllerCaixa.ObterCaixas(edtDatIni.Date, edtDatFim.Date);

  if FControllerCaixa.mtCaixas.IsEmpty
  then ShowMessage('A consulta não retornou dados');
end;

procedure TViewCaixa.btnAberturaClick(Sender: TObject);
begin
  inherited;
  var ViewAbertura := TViewModeloModal.Create(Self);
  try
    ViewAbertura.Width := 607;
    ViewAbertura.Height := 154;
    ViewAbertura.btnModeloOk.Caption := 'Ok';
    ViewAbertura.btnModeloOk.ModalResult := mrOk;

    //lbTexto
    var lbTexto := TLabel.Create(ViewAbertura);
    lbTexto.Name := 'lbTexto';
    lbTexto.Parent := ViewAbertura.pModeloClient;
    lbTexto.Left := 10;
    lbTexto.Top := 15;
    lbTexto.Width := 253;
    lbTexto.Height := 21;
    lbTexto.Caption := 'Informe o valor de abertura de caixa:';

    //edtValor
    var edtValor := TEdit.Create(ViewAbertura);
    edtValor.Name := 'edtValor';
    edtValor.Parent := ViewAbertura.pModeloClient;
    edtValor.Left := 269;
    edtValor.Top := 12;
    edtValor.Width := 324;
    edtValor.Height := 29;
    edtValor.TabOrder := 0;
    edtValor.Text := '0';

    var bOk := False;
    var LValor := 0.00;

    repeat
      if ViewAbertura.ShowModal = mrOk
      then begin
        try
          LValor := StrToFloat(edtValor.Text);
          bOk := True;
        except
          bOk := False;
        end;
      end
      else
      begin
        bOk := True;
        Exit;
      end;
    until bOk;

    if not bOk
    then Exit;

    FControllerCaixa.AbrirNovoCaixa(LValor);
    AbrirDetalhesCaixa(0);

  finally
    FreeAndNil(ViewAbertura);
  end;
end;

procedure TViewCaixa.btnAtualizarClick(Sender: TObject);
begin
  inherited;
  FControllerMovimento.ObterMovimentosCaixa(FControllerCaixa.mtDadosCOD_CAIXA.AsInteger);
  AtualizarResumoCaixa(FControllerCaixa.mtDadosCOD_CAIXA.AsInteger);
end;

procedure TViewCaixa.dbgCaixasDblClick(Sender: TObject);
begin
  inherited;
  if FControllerCaixa.mtCaixas.IsEmpty
  then Exit;

  AbrirDetalhesCaixa(FControllerCaixa.mtCaixasCOD_CAIXA.AsInteger);
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

  FControllerCaixa.CriarDataSets;
  FControllerMovimento.CriarDataSets;

  FrameCaixaResumoMeioPagto1.Cor := RGB(151, 255, 170);
  FrameCaixaResumoMeioPagto1.CorFonte := RGB(000, 000, 000);
  FrameCaixaResumoMeioPagto1.Nome := 'Meio de Pagamento';
  FrameCaixaResumoMeioPagto1.Valor := 0;

  FrameCaixaResumoMeioPagto2.Cor := RGB(173, 146, 255);
  FrameCaixaResumoMeioPagto2.CorFonte := RGB(000, 000, 000);
  FrameCaixaResumoMeioPagto2.Nome := 'Meio de Pagamento';
  FrameCaixaResumoMeioPagto2.Valor := 0;

  FrameCaixaResumoMeioPagto3.Cor := RGB(255, 220, 146);
  FrameCaixaResumoMeioPagto3.CorFonte := RGB(000, 000, 000);
  FrameCaixaResumoMeioPagto3.Nome := 'Meio de Pagamento';
  FrameCaixaResumoMeioPagto3.Valor := 0;

  FrameCaixaResumoMeioPagto4.Cor := RGB(255, 179, 149);
  FrameCaixaResumoMeioPagto4.CorFonte := RGB(000, 000, 000);
  FrameCaixaResumoMeioPagto4.Nome := 'Meio de Pagamento';
  FrameCaixaResumoMeioPagto4.Valor := 0;

  FrameCaixaResumoMeioPagto5.Cor := RGB(151, 211, 255);
  FrameCaixaResumoMeioPagto5.CorFonte := RGB(000, 000, 000);
  FrameCaixaResumoMeioPagto5.Nome := 'Meio de Pagamento';
  FrameCaixaResumoMeioPagto5.Valor := 0;

  FrameCaixaResumoMeioPagto6.Cor := RGB(255, 156, 241);
  FrameCaixaResumoMeioPagto6.CorFonte := RGB(000, 000, 000);
  FrameCaixaResumoMeioPagto6.Nome := 'Meio de Pagamento';
  FrameCaixaResumoMeioPagto6.Valor := 0;

  try
    AbrirDetalhesCaixa(0);
  except

  end;
end;

procedure TViewCaixa.sbVerCaixaAbertoClick(Sender: TObject);
begin
  inherited;
  AbrirDetalhesCaixa(0);
end;

end.
