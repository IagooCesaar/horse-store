unit Loja.Controller.Preco.Venda;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TControllerPrecoVenda = class(TControllerBase)
    mtDadosCOD_ITEM: TIntegerField;
    mtDadosDAT_INI: TDateTimeField;
    mtDadosVR_VNDA: TFloatField;
    mtPrecoAtual: TFDMemTable;
    mtPrecoAtualCOD_ITEM: TIntegerField;
    mtPrecoAtualDAT_INI: TDateTimeField;
    mtPrecoAtualVR_VNDA: TFloatField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ObterPrecoVendaAtual(ACodItem: Integer);
    procedure ObterHistoricoPrecoVenda(ACodItem: Integer; ADatRef: TDateTime);
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TControllerPrecoVenda.DataModuleCreate(Sender: TObject);
begin
  inherited;
  mtDados.CreateDataSet;
  mtPrecoAtual.CreateDataSet;
end;

procedure TControllerPrecoVenda.ObterHistoricoPrecoVenda(ACodItem: Integer;
  ADatRef: TDateTime);
begin
  if mtDados.Active
  then mtDados.Close;

  var LResponse := PreparaRequest
    .Resource('/preco-venda/{cod_item}')
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
