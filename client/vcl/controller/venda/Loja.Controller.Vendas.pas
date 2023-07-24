unit Loja.Controller.Vendas;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

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
    mtItensNUM_VNDA: TIntegerField;
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
  private
    { Private declarations }
  public
    procedure CriarDatasets; override;

    procedure ObterVendas(ADatInclIni, ADatInclFim: TDate;
       ACodSit: TLojaModelVendaSituacao);
  end;


implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TControllerVendas }

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
    then RaiseException(LResponse, 'N�o foi poss�vel obter lista de vendas');

    if mtVendas.Active
    then mtVendas.Close;

    Serializar(LResponse, mtVendas);
  finally
    if not mtVendas.Active
    then mtVendas.CreateDataSet;
  end;
end;

end.
