unit Loja.Controller.Vendas;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  RESTRequest4D,
  DataSet.Serialize,

  Loja.Model.Venda.Types;

type
  TControllerVendas = class(TControllerBase)
    mtVendas: TFDMemTable;
    mtItens: TFDMemTable;
    mtMeiosPagto: TFDMemTable;
    mtDadosNUM_VNDA: TIntegerField;
    mtDadosCOD_SIT: TStringField;
    mtDadosDAT_INCL: TDateTimeField;
    mtDadosDAT_CONCL: TDateTimeField;
    mtDadosVR_BRUTO: TFloatField;
    mtDadosVR_DESC: TFloatField;
    mtDadosVR_TOTAL: TFloatField;
    mtVendasNUM_VNDA: TIntegerField;
    mtVendasCOD_SIT: TStringField;
    mtVendasDAT_INCL: TDateTimeField;
    mtVendasDAT_CONCL: TDateTimeField;
    mtVendasVR_BRUTO: TFloatField;
    mtVendasVR_DESC: TFloatField;
    mtVendasVR_TOTAL: TFloatField;
    mtItensNUM_SEQ_ITEM: TIntegerField;
    mtItensCOD_ITEM: TIntegerField;
    mtItensNOM_ITEM: TStringField;
    mtItensCOD_SIT: TStringField;
    mtItensQTD_ITEM: TIntegerField;
    mtItensVR_PRECO_UNIT: TFloatField;
    mtItensVR_BRUTO: TFloatField;
    mtItensVR_DESC: TFloatField;
    mtItensVR_TOTAL: TFloatField;
    mtMeiosPagtoNUM_VNDA: TIntegerField;
    mtMeiosPagtoNUM_SEQ_MEIO_PAGTO: TIntegerField;
    mtMeiosPagtoCOD_MEIO_PAGTO: TStringField;
    mtMeiosPagtoQTD_PARC: TIntegerField;
    mtMeiosPagtoVR_TOTAL: TFloatField;
    mtItensNUM_VNDA: TIntegerField;
    procedure mtItensQTD_ITEMChange(Sender: TField);
    procedure mtItensVR_DESCChange(Sender: TField);
    procedure mtItensBeforePost(DataSet: TDataSet);
    procedure mtItensBeforeDelete(DataSet: TDataSet);
    procedure mtMeiosPagtoAfterDataChanged(DataSet: TDataSet);
  private
    procedure AtualizaValoresItem;

    procedure ConcluirVenda(AAcao: string; ANumVnda: Integer);
  public
    procedure CriarDatasets; override;

    procedure ObterVendas(ADatInclIni, ADatInclFim: TDate;
       ACodSit: TLojaModelVendaSituacao);

    procedure ObterVenda(ANumVnda: Integer);

    procedure ObterItensVenda(ANumVnda: Integer);

    procedure ObterMeiosPagtoVenda(ANumVnda: Integer);

    procedure NovaVenda;

    procedure EfetivarVenda(ANumVnda: Integer);
    procedure CancelarVenda(ANumVnda: Integer);
  end;


implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.Math;

{ TControllerVendas }

procedure TControllerVendas.AtualizaValoresItem;
begin
  mtItensVR_BRUTO.AsFloat := RoundTo(    
    mtItensQTD_ITEM.AsInteger * mtItensVR_PRECO_UNIT.AsFloat, -2);
    
  mtItensVR_TOTAL.AsFloat := mtItensVR_BRUTO.AsFloat - mtItensVR_DESC.AsFloat;
end;

procedure TControllerVendas.CancelarVenda(ANumVnda: Integer);
begin
  ConcluirVenda('cancelar', ANumVnda);
end;

procedure TControllerVendas.ConcluirVenda(AAcao: string; ANumVnda: Integer);
begin
  var LResponse := PreparaRequest
    .Resource('/venda/{num_vnda}/{acao}')
    .AddUrlSegment('num_vnda', ANumVnda.ToString)
    .AddUrlSegment('acao', AAcao)
    .Patch();

  if not(LResponse.StatusCode in [200])
  then RaiseException(LResponse, 'Erro ao concluir a venda');
end;

procedure TControllerVendas.CriarDatasets;
begin
  inherited;
  if mtDados.Active
  then mtDados.Close;

  if mtVendas.Active
  then mtVendas.Close;

  if mtMeiosPagto.Active
  then mtMeiosPagto.Close;

  if mtItens.Active
  then mtItens.Close;

  mtDados.CreateDataSet;
  mtVendas.CreateDataSet;
  mtItens.CreateDataSet;
  mtMeiosPagto.CreateDataSet;
end;

procedure TControllerVendas.EfetivarVenda(ANumVnda: Integer);
begin
  ConcluirVenda('efetivar', ANumVnda);
end;

procedure TControllerVendas.mtItensBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  if DataSet.ControlsDisabled
  then Exit;

  DataSet.Edit;
  DataSet.FieldByName('cod_sit').AsString := TLojaModelVendaItemSituacao.sitRemovido.Name;
  var LBody := DataSet.ToJSONObject();
  DataSet.Cancel;

  var LResponse := PreparaRequest
    .Resource('/venda/{num_vnda}/itens/{num_seq_item}')
    .AddUrlSegment('num_vnda', DataSet.FieldByName('num_vnda').AsString)
    .AddUrlSegment('num_seq_item', DataSet.FieldByName('num_seq_item').AsString)
    .AddBody(LBody)
    .PUT();

  try
    DataSet.DisableControls;
    if not(LResponse.StatusCode in [200,201])
    then RaiseException(LResponse, 'Erro ao remover o item da venda');

    DataSet.MergeFromJSONObject(LResponse.Content);
    Abort; // procedimento de delete
  finally
    DataSet.EnableControls;
  end;
end;

procedure TControllerVendas.mtItensBeforePost(DataSet: TDataSet);
var LResponse: IResponse;
begin
  inherited;
  if DataSet.ControlsDisabled
  then Exit;

  var LBody := DataSet.ToJSONObject();
  var LRequest := PreparaRequest;

  if (DataSet.State = dsEdit)
  then begin
    LResponse := LRequest
      .Resource('/venda/{num_vnda}/itens/{num_seq_item}')
      .AddUrlSegment('num_vnda', DataSet.FieldByName('num_vnda').AsString)
      .AddUrlSegment('num_seq_item', DataSet.FieldByName('num_seq_item').AsString)
      .AddBody(LBody)
      .PUT();
  end
  else 
  begin
    LResponse := LRequest
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', DataSet.FieldByName('num_vnda').AsString)      
      .AddBody(LBody)
      .POST();
  end;
  try
    DataSet.DisableControls;
    if not(LResponse.StatusCode in [200,201])
    then RaiseException(LResponse, 'Erro ao atualizar o item da venda');

    DataSet.MergeFromJSONObject(LResponse.Content);
  finally
    DataSet.EnableControls;
  end;
end;

procedure TControllerVendas.mtItensQTD_ITEMChange(Sender: TField);
begin
  inherited;
  if mtItens.ControlsDisabled
  then Exit;

  AtualizaValoresItem;   
end;

procedure TControllerVendas.mtItensVR_DESCChange(Sender: TField);
begin
  inherited;
  if mtItens.ControlsDisabled
  then Exit;

  AtualizaValoresItem;   
end;

procedure TControllerVendas.mtMeiosPagtoAfterDataChanged(DataSet: TDataSet);
begin
  inherited;
  if DataSet.ControlsDisabled
  then Exit;

  var LBody := DataSet.ToJSONArray();

  var LResponse := PreparaRequest
    .Resource('/venda/{num_vnda}/meios-pagamento')
    .AddUrlSegment('num_vnda', DataSet.FieldByName('NUM_VNDA').AsString)
    .AddBody(LBody)
    .Post();

  try
    DataSet.DisableControls;
    if not(LResponse.StatusCode in [201,204])
    then RaiseException(LResponse, 'Erro ao atualizar meios de pagamento da venda');

    if DataSet.Active
    then DataSet.Close;

    if LResponse.StatusCode = 201
    then DataSet.LoadFromJSON(LResponse.Content);

    if mtMeiosPagto.IsEmpty
    then mtMeiosPagto.CreateDataSet;
  finally
    DataSet.EnableControls;
  end;
end;

procedure TControllerVendas.NovaVenda;
begin
  try
    var LResponse := PreparaRequest
      .Resource('/venda')
      .Post();

    if LResponse.StatusCode <> 201
    then RaiseException(LResponse, 'Falha ao iniciar uma nova venda');

    if mtDados.Active
    then mtDados.Close;

    Serializar(LResponse);
  finally
    if not mtDados.Active
    then mtDados.CreateDataSet;
  end;
end;

procedure TControllerVendas.ObterItensVenda(ANumVnda: Integer);
begin
  try
    var LResponse := PreparaRequest
      .Resource('/venda/{num_vnda}/itens')
      .AddUrlSegment('num_vnda', ANumVnda.ToString)
      .Get();

    if not(LResponse.StatusCode in [200, 204])
    then RaiseException(LResponse, 'Não foi possível obter itens da venda');

    if mtItens.Active
    then mtItens.Close;

    if LResponse.StatusCode = 200
    then Serializar(LResponse, mtItens);

  finally
    if not mtItens.Active
    then mtItens.CreateDataSet;
  end;
end;

procedure TControllerVendas.ObterMeiosPagtoVenda(ANumVnda: Integer);
begin
  try
    var LResponse := PreparaRequest
      .Resource('/venda/{num_vnda}/meios-pagamento')
      .AddUrlSegment('num_vnda', ANumVnda.ToString)
      .Get();

    if not(LResponse.StatusCode in [200, 204])
    then RaiseException(LResponse, 'Não foi possível obter meios de pagamento da venda');

    if mtMeiosPagto.Active
    then mtMeiosPagto.Close;   

    if LResponse.StatusCode = 200
    then Serializar(LResponse, mtMeiosPagto);

  finally
    if not mtMeiosPagto.Active
    then mtMeiosPagto.CreateDataSet;
  end;
end;

procedure TControllerVendas.ObterVenda(ANumVnda: Integer);
begin
  try
    var LResponse := PreparaRequest
      .Resource('/venda/{num_vnda}')
      .AddUrlSegment('num_vnda', ANumVnda.ToString)
      .Get();

    if not(LResponse.StatusCode in [200, 204])
    then RaiseException(LResponse, 'Não foi possível obter dados da venda');

    if mtDados.Active
    then mtDados.Close;    

    if LResponse.StatusCode = 200
    then Serializar(LResponse);

  finally
    if not mtDados.Active
    then mtDados.CreateDataSet;
  end;
end;

procedure TControllerVendas.ObterVendas(ADatInclIni, ADatInclFim: TDate;
  ACodSit: TLojaModelVendaSituacao);
begin
  try
    var LResponse := PreparaRequest
      .Resource('/venda')
      .AddParam('dat_incl_ini', FormatDateTime('yyyy-mm-dd', ADatInclIni))
      .AddParam('dat_incl_fim', FormatDateTime('yyyy-mm-dd', ADatInclFim))
      .AddParam('cod_sit', ACodSit.Name)
      .Get();

    if LResponse.StatusCode <> 200
    then RaiseException(LResponse, 'Não foi possível obter lista de vendas');

    if mtVendas.Active
    then mtVendas.Close;

    Serializar(LResponse, mtVendas);
  finally
    if not mtVendas.Active
    then mtVendas.CreateDataSet;
  end;
end;

end.
