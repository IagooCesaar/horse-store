unit Loja.Controller.Caixa;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Dialogs,

  Loja.Model.Caixa.Fechamento;

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
    procedure DataModuleCreate(Sender: TObject);
  public
    procedure ObterCaixas(ADatIni, ADatFim: TDate);
    procedure ObterCaixaAberto;
    procedure ObterCaixa(ACodCaixa: Integer);
    procedure ObterResumoCaixa(ACodCaixa: Integer);

    procedure FecharCaixa(ACodCaixa: Integer; AFechamento: TLojaModelCaixaFechamento);
    procedure AbrirNovoCaixa(AVrAbertura: Currency);

  end;

implementation

uses
  System.JSON,
  Horse.JsonInterceptor.Helpers;

{$R *.dfm}

{ TControllerCaixa }

procedure TControllerCaixa.AbrirNovoCaixa(AVrAbertura: Currency);
begin
  var LBody := TJSONObject.Create;
  LBody.AddPair('vrAbert', AVrAbertura);

  var LResponse := PreparaRequest
    .Resource('/caixa/abrir-caixa')
    .AddBody(LBody)
    .Post();

  if not(LResponse.StatusCode in [201])
  then RaiseException(LResponse, 'Falha ao abrir novo caixa');
end;

procedure TControllerCaixa.DataModuleCreate(Sender: TObject);
begin
  inherited;
  mtDados.CreateDataSet;
  mtCaixas.CreateDataSet;
  mtResumoCaixa.CreateDataSet;
  mtResumoMeiosPagto.CreateDataSet;
end;

procedure TControllerCaixa.FecharCaixa(ACodCaixa: Integer;
  AFechamento: TLojaModelCaixaFechamento);
begin
  try
    if mtDados.Active
    then mtDados.Close;
     var LResponse := PreparaRequest
      .Resource('/caixa/{cod_caixa}/fechar-caixa')
      .AddUrlSegment('cod_caixa', ACodCaixa.ToString)
      .AddBody(TJson.ObjectToClearJsonString(AFechamento))
      .Patch();

    if not(LResponse.StatusCode in [200])
    then RaiseException(LResponse, 'Falha ao fechar o caixa');

    Serializar(LResponse, mtDados);
  finally
    if not mtDados.Active
    then mtDados.CreateDataSet;
  end;
end;

procedure TControllerCaixa.ObterCaixa(ACodCaixa: Integer);
begin
  try
    if mtDados.Active
    then mtDados.Close;

    var LResponse := PreparaRequest
      .Resource('/caixa/{cod_caixa}')
      .AddUrlSegment('cod_caixa', ACodCaixa.ToString)
      .Get();

    if not(LResponse.StatusCode in [200])
    then RaiseException(LResponse, 'Falha ao obter dados do caixa');

    Serializar(LResponse, mtDados);
  finally
    if not mtDados.Active
    then mtDados.CreateDataSet;
  end;
end;

procedure TControllerCaixa.ObterCaixaAberto;
begin
  try
    if mtDados.Active
    then mtDados.Close;
    var LResponse := PreparaRequest
      .Resource('/caixa/caixa-aberto')
      .Get();

    if not(LResponse.StatusCode in [200])
    then RaiseException(LResponse, 'Falha ao obter o caixa aberto atualmente');

    Serializar(LResponse, mtDados);
  finally
    if not mtDados.Active
    then mtDados.CreateDataSet;
  end;
end;

procedure TControllerCaixa.ObterCaixas(ADatIni, ADatFim: TDate);
begin
  try
    if mtCaixas.Active
    then mtCaixas.Close;

    var LResponse := PreparaRequest
      .Resource('/caixa')
      .AddParam('dat_ini', FormatDateTime('yyyy-mm-dd', ADatIni))
      .AddParam('dat_fim', FormatDateTime('yyyy-mm-dd', ADatFim))
      .Get();

    if not(LResponse.StatusCode in [200,204])
    then RaiseException(LResponse, 'Falha ao obter lista de caixas');

    if LResponse.StatusCode = 200
    then Serializar(LResponse, mtCaixas);
  finally
    if not mtCaixas.Active
    then mtCaixas.CreateDataSet;
  end;
end;

procedure TControllerCaixa.ObterResumoCaixa(ACodCaixa: Integer);
var LBody: TJSONObject;
begin
  try
    if mtResumoCaixa.Active
    then mtResumoCaixa.Close;

    if mtResumoMeiosPagto.Active
    then mtResumoMeiosPagto.Close;

    var LResponse := PreparaRequest
      .Resource('/caixa/{cod_caixa}/resumo')
      .AddUrlSegment('cod_caixa', ACodCaixa.ToString)
      .Get();

    if not(LResponse.StatusCode in [200])
    then RaiseException(LResponse, 'Falha ao obter resumo do caixa');

    Serializar(LResponse, mtResumoCaixa);

    LBody := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;
    Serializar(LBody.GetValue('meiosPagto'), mtResumoMeiosPagto);
  finally
    if not mtResumoCaixa.Active
    then mtResumoCaixa.CreateDataSet;

    if not mtResumoMeiosPagto.Active
    then mtResumoMeiosPagto.CreateDataSet;
  end;
end;

end.
