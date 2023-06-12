unit Loja.Controller.Estoque.Saldo;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  Loja.Model.Estoque.AcertoEstoque;

type
  TControllerEstoqueSaldo = class(TControllerBase)
    mtUltFecha: TFDMemTable;
    mtMovimentos: TFDMemTable;
    mtDadosCOD_ITEM: TIntegerField;
    mtDadosQTD_SALDO_ATU: TIntegerField;
    mtDadosULTIMO_MOVIMENTOS: TMemoField;
    mtDadosULTIMO_FECHAMENTO: TMemoField;
    mtUltFechaCOD_ITEM: TIntegerField;
    mtUltFechaQTD_SALDO: TIntegerField;
    mtUltFechaDAT_SALDO: TDateTimeField;
    mtUltFechaCOD_FECH_SALDO: TIntegerField;
    mtMovimentosCOD_ITEM: TIntegerField;
    mtMovimentosQTD_MOV: TIntegerField;
    mtMovimentosCOD_TIPO_MOV: TStringField;
    mtMovimentosCOD_ORIG_MOV: TStringField;
    mtMovimentosDAT_MOV: TDateTimeField;
    mtMovimentosCOD_MOV: TIntegerField;
    mtMovimentosDSC_MOT: TStringField;
  private
    { Private declarations }
  public
    procedure ObterSaldo(ACodItem: Integer);
    procedure RealizarAcertoEstoque(ACodItem: Integer; AAcerto: TLojaModelEstoqueAcertoEstoque);
  end;

implementation

uses
  System.JSON,
  Horse.JsonInterceptor.Helpers;

{$R *.dfm}

{ TControllerEstoqueSaldo }

procedure TControllerEstoqueSaldo.ObterSaldo(ACodItem: Integer);
var LBody: TJSONObject;
begin
  if mtDados.Active
  then mtDados.Close;

  if mtUltFecha.Active
  then mtUltFecha.Close;

  if mtMovimentos.Active
  then mtMovimentos.Close;

  var LResponse := PreparaRequest
    .Resource('/estoque/{cod_item}/saldo-atual')
    .AddUrlSegment('cod_item', ACodItem.ToString)
    .Get();

  if not(LResponse.StatusCode in [200,204])
  then RaiseException(LResponse, 'Falha ao obter saldo atual do item');

  if LResponse.StatusCode = 200
  then begin
    try
      Serializar(LResponse, mtDados);
      LBody := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;

      Serializar(LBody.GetValue('ultimoFechamento'), mtUltFecha);
      Serializar(LBody.GetValue('ultimosMovimentos'), mtMovimentos);

    finally
      if not mtDados.Active
      then mtDados.CreateDataSet;

      if not mtUltFecha.Active
      then mtUltFecha.CreateDataSet;

      if not mtMovimentos.Active
      then mtMovimentos.CreateDataSet;
    end;
  end;
end;

procedure TControllerEstoqueSaldo.RealizarAcertoEstoque(ACodItem: Integer;
  AAcerto: TLojaModelEstoqueAcertoEstoque);
begin
  var LResponse := PreparaRequest
    .Resource('/estoque/{cod_item}/acerto-de-estoque')
    .AddUrlSegment('cod_item', ACodItem.ToString)
    .AddBody(TJson.ObjectToClearJsonObject(AAcerto))
    .Post();

   if LResponse.StatusCode <> 201
   then RaiseException(LResponse, 'Falha ao realizar acerto de estoque');
end;

end.
