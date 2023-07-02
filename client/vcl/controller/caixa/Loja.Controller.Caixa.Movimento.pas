unit Loja.Controller.Caixa.Movimento;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TControllerCaixaMovimento = class(TControllerBase)
    mtDadosCOD_MEIO_PAGTO: TStringField;
    mtDadosCOD_TIPO_MOV: TStringField;
    mtDadosCOD_ORIG_MOV: TStringField;
    mtDadosVR_MOV: TCurrencyField;
    mtDadosDAT_MOV: TDateTimeField;
    mtDadosDSC_OBS: TStringField;
    mtDadosCOD_MOV: TIntegerField;
    mtDadosCOD_CAIXA: TIntegerField;
  private
    { Private declarations }
  public
    procedure ObterMovimentosCaixa(ACodCaixa: Integer);
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TControllerCaixaMovimento }

procedure TControllerCaixaMovimento.ObterMovimentosCaixa(ACodCaixa: Integer);
begin
  var LResponse := PreparaRequest
    .Resource('/caixa/{cod_caixa}/movimento')
    .AddUrlSegment('cod_caixa', ACodCaixa.ToString)
    .Get();

  if not(LResponse.StatusCode in [200])
  then RaiseException(LResponse, 'Falha ao obter movimentos do caixa');

  Serializar(LResponse);
end;
end.
