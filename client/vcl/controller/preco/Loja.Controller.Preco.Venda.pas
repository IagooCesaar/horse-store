unit Loja.Controller.Preco.Venda;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  RESTRequest4D,
  DataSet.Serialize,

  Loja.Model.Preco.PrecoVenda;

type
  TControllerPrecoVenda = class(TControllerBase)
    mtDadosCOD_ITEM: TIntegerField;
    mtDadosDAT_INI: TDateTimeField;
    mtDadosVR_VNDA: TFloatField;
    mtPrecoAtual: TFDMemTable;
    mtPrecoAtualCOD_ITEM: TIntegerField;
    mtPrecoAtualDAT_INI: TDateTimeField;
    mtPrecoAtualVR_VNDA: TFloatField;
    mtNovoPreco: TFDMemTable;
    mtNovoPrecoCOD_ITEM: TIntegerField;
    mtNovoPrecoDAT_INI: TDateTimeField;
    mtNovoPrecoVR_VNDA: TFloatField;
    procedure DataModuleCreate(Sender: TObject);
    procedure mtNovoPrecoBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ObterPrecoVendaAtual(ACodItem: Integer);
    procedure ObterHistoricoPrecoVenda(ACodItem: Integer; ADatRef: TDateTime);
    procedure CriarPrecoVenda(ANovoPreco: TLojaModelPrecoPrecoVenda);
  end;

implementation

uses
  Horse.JsonInterceptor.Helpers;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TControllerPrecoVenda.CriarPrecoVenda(
  ANovoPreco: TLojaModelPrecoPrecoVenda);
begin
  var LResponse := PreparaRequest
    .Resource('/preco-venda/{cod_item}')
    .AddUrlSegment('cod_item', ANovoPreco.CodItem.ToString)
    .AddBody(TJson.ObjectToClearJsonString(ANovoPreco))
    .Get();

  if LResponse.StatusCode <> 201
  then RaiseException(LResponse, 'Falha ao criar novo preço de venda para o item');
end;

procedure TControllerPrecoVenda.DataModuleCreate(Sender: TObject);
begin
  inherited;
  mtDados.CreateDataSet;
  mtPrecoAtual.CreateDataSet;
  mtNovoPreco.CreateDataSet;
end;

procedure TControllerPrecoVenda.mtNovoPrecoBeforePost(DataSet: TDataSet);
var LResponse: IResponse;
begin
  inherited;
  if DataSet.ControlsDisabled
  then Exit;

  var LBody := DataSet.ToJSONObject();
  var LRequest := PreparaRequest;

  //if (DataSet.State = dsInsert)
  LResponse := LRequest
    .Resource('/preco-venda/{cod_item}')
    .AddUrlSegment('cod_item', DataSet.FieldByName('cod_item').AsString)
    .AddBody(LBody)
    .POST();

  try
    DataSet.DisableControls;
    if not(LResponse.StatusCode in [201])
    then RaiseException(LResponse, 'Erro ao criar novo preço de venda para o item');
  finally
    DataSet.EnableControls;
  end;
end;

procedure TControllerPrecoVenda.ObterHistoricoPrecoVenda(ACodItem: Integer;
  ADatRef: TDateTime);
begin
  if mtDados.Active
  then mtDados.Close;

  var LResponse := PreparaRequest
    .Resource('/preco-venda/{cod_item}/historico')
    .AddUrlSegment('cod_item', ACodItem.ToString)
    .AddParam('dat_ref', FormatDateTime('yyyy-mm-dd', ADatRef))
    .Get();

  if not(LResponse.StatusCode in [200,204])
  then RaiseException(LResponse, 'Falha ao obter histórico de preço de venda do item');

  if LResponse.StatusCode = 200
  then Serializar(LResponse, mtDados);
end;

procedure TControllerPrecoVenda.ObterPrecoVendaAtual(ACodItem: Integer);
begin
  if mtPrecoAtual.Active
  then mtPrecoAtual.Close;

  var LResponse := PreparaRequest
    .Resource('/preco-venda/{cod_item}')
    .AddUrlSegment('cod_item', ACodItem.ToString)
    .Get();

  if not(LResponse.StatusCode in [200,204])
  then RaiseException(LResponse, 'Falha ao obter preço atual do item');

  if LResponse.StatusCode = 200
  then Serializar(LResponse, mtPrecoAtual);
end;

end.
