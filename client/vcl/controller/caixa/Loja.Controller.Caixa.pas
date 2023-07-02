unit Loja.Controller.Caixa;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Dialogs;

type
  TControllerCaixa = class(TControllerBase)
    mtCaixas: TFDMemTable;
    mtResumoCaixa: TFDMemTable;
    mtDadosCOD_CAIXA: TIntegerField;
    mtDadosCOD_SIT: TStringField;
    mtDadosDAT_ABERT: TDateTimeField;
    mtDadosDAT_FECHA: TDateTimeField;
    mtDadosVR_ABERT: TCurrencyField;
    mtDadosVR_FECHA: TCurrencyField;
    mtCaixasCOD_CAIXA: TIntegerField;
    mtCaixasCOD_SIT: TStringField;
    mtCaixasDAT_ABERT: TDateTimeField;
    mtCaixasDAT_FECHA: TDateTimeField;
    mtCaixasVR_ABERT: TCurrencyField;
    mtCaixasVR_FECHA: TCurrencyField;
    mtResumoMeiosPagto: TFDMemTable;
    mtResumoMeiosPagtoCOD_MEIO_PAGTO: TStringField;
    mtResumoMeiosPagtoVR_TOTAL: TCurrencyField;
    mtResumoCaixaCOD_CAIXA: TIntegerField;
    mtResumoCaixaCOD_SIT: TStringField;
    mtResumoCaixaMEIOS_PAGTO: TMemoField;
    mtResumoCaixaVR_SALDO: TCurrencyField;
  public
    procedure ObterCaixas(ADatIni, ADatFim: TDate);
    procedure ObterCaixaAberto;
    procedure ObterCaixa(ACodCaixa: Integer);
    procedure ObterResumoCaixa(ACodCaixa: Integer);
  end;

implementation

uses
  System.JSON,
  Horse.JsonInterceptor.Helpers;

{$R *.dfm}

{ TControllerCaixa }

procedure TControllerCaixa.ObterCaixa(ACodCaixa: Integer);
begin
  var LResponse := PreparaRequest
    .Resource('/caixa/{cod_caixa}')
    .AddUrlSegment('cod_caixa', ACodCaixa.ToString)
    .Get();

  if not(LResponse.StatusCode in [200])
  then RaiseException(LResponse, 'Falha ao obter dados do caixa');

  Serializar(LResponse, mtDados);
end;

procedure TControllerCaixa.ObterCaixaAberto;
begin
  var LResponse := PreparaRequest
    .Resource('/caixa/caixa-aberto')
    .Get();

  if not(LResponse.StatusCode in [200])
  then RaiseException(LResponse, 'Falha ao obter o caixa aberto atualmente');

  Serializar(LResponse, mtDados);
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

  Serializar(LResponse, mtCaixas);
end;

procedure TControllerCaixa.ObterResumoCaixa(ACodCaixa: Integer);
var LBody: TJSONObject;
begin
  var LResponse := PreparaRequest
    .Resource('/caixa/{cod_caixa}/resumo')
    .AddUrlSegment('cod_caixa', ACodCaixa.ToString)
    .Get();

  if not(LResponse.StatusCode in [200])
  then RaiseException(LResponse, 'Falha ao obter resumo do caixa');

  Serializar(LResponse, mtResumoCaixa);

  LBody := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;
  Serializar(LBody.GetValue('meiosPagto'), mtResumoMeiosPagto);
end;

end.
