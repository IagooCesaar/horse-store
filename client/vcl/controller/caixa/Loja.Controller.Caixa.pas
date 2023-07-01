unit Loja.Controller.Caixa;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TControllerCaixa = class(TControllerBase)
    mtCaixaAberto: TFDMemTable;
    mtResumoCaixa: TFDMemTable;
    mtDadosCOD_CAIXA: TIntegerField;
    mtDadosCOD_SIT: TStringField;
    mtDadosDAT_ABERT: TDateTimeField;
    mtDadosDAT_FECHA: TDateTimeField;
    mtDadosVR_ABERT: TCurrencyField;
    mtDadosVR_FECHA: TCurrencyField;
    mtCaixaAbertoCOD_CAIXA: TIntegerField;
    mtCaixaAbertoCOD_SIT: TStringField;
    mtCaixaAbertoDAT_ABERT: TDateTimeField;
    mtCaixaAbertoDAT_FECHA: TDateTimeField;
    mtCaixaAbertoVR_ABERT: TCurrencyField;
    mtCaixaAbertoVR_FECHA: TCurrencyField;
    mtResumoMeiosPagto: TFDMemTable;
    mtResumoCaixaCOD_CAIXA: TIntegerField;
    mtResumoCaixaCOD_SIT: TStringField;
    mtResumoCaixaMEIOS_PAGTO: TMemoField;
    mtResumoMeiosPagtoCOD_MEIO_PAGTO: TStringField;
    mtResumoMeiosPagtoVR_TOTAL: TCurrencyField;
    mtMovimentos: TFDMemTable;
    mtMovimentosCOD_CAIXA: TIntegerField;
    mtMovimentosCOD_MEIO_PAGTO: TStringField;
    mtMovimentosCOD_TIPO_MOV: TStringField;
    mtMovimentosCOD_ORIG_MOV: TStringField;
    mtMovimentosVR_MOV: TCurrencyField;
    mtMovimentosDAT_MOV: TDateTimeField;
    mtMovimentosDSC_OBS: TStringField;
    mtMovimentosCOD_MOV: TIntegerField;
    mtResumoCaixaVR_SALDO: TCurrencyField;
  public
    procedure ObterCaixas(ADatIni, ADatFim: TDate);
    procedure ObterCaixaAberto;
    procedure ObterResumoCaixa(ACodCaixa: Integer);
    procedure ObterMovimentosCaixa(ACodCaixa: Integer);
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TControllerCaixa }

procedure TControllerCaixa.ObterCaixaAberto;
begin
  var LResponse := PreparaRequest
    .Resource('/caixa/caixa-aberto')
    .Get();

  if not(LResponse.StatusCode in [200])
  then RaiseException(LResponse, 'Falha ao obter lista de caixas');

  Serializar(LResponse, mtCaixaAberto);
end;

procedure TControllerCaixa.ObterCaixas(ADatIni, ADatFim: TDate);
begin
  var LResponse := PreparaRequest
    .Resource('/caixa')
    .AddParam('dat_ini', FormatDateTime('yyyy-mm-dd', ADatIni))
    .AddParam('dat_fim', FormatDateTime('yyyy-mm-dd', ADatFim))
    .Get();

  if not(LResponse.StatusCode in [200])
  then RaiseException(LResponse, 'Falha ao obter lista de caixas');

  Serializar(LResponse);
end;

procedure TControllerCaixa.ObterMovimentosCaixa(ACodCaixa: Integer);
begin
  var LResponse := PreparaRequest
    .Resource('/caixa/{cod_caixa}/movimento')
    .AddParam('cod_caixa', ACodCaixa.ToString)
    .Get();

  if not(LResponse.StatusCode in [200])
  then RaiseException(LResponse, 'Falha ao obter movimentos do caixa');

  Serializar(LResponse, mtMovimentos);
end;

procedure TControllerCaixa.ObterResumoCaixa(ACodCaixa: Integer);
begin
  var LResponse := PreparaRequest
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddParam('cod_caixa', ACodCaixa.ToString)
    .Get();

  if not(LResponse.StatusCode in [200])
  then RaiseException(LResponse, 'Falha ao obter resumo do caixa');

  Serializar(LResponse, mtResumoCaixa);
  Serializar(mtResumoCaixaMEIOS_PAGTO.AsString, mtResumoMeiosPagto);
end;

end.
