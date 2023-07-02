unit Loja.Controller.Caixa.Movimento;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  Loja.Model.Caixa.NovoMovimento;

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
    procedure CriarMovimento(ATipoMov: string; ACodCaixa: Integer; AMovimento: TLojaModelCaixaNovoMovimento);
  public
    procedure ObterMovimentosCaixa(ACodCaixa: Integer);
    procedure CriarMovimentoSangria(ACodCaixa: Integer; AMovimento: TLojaModelCaixaNovoMovimento);
    procedure CriarMovimentoReforco(ACodCaixa: Integer; AMovimento: TLojaModelCaixaNovoMovimento);
  end;

implementation

uses
  System.JSON,
  Horse.JsonInterceptor.Helpers;

{$R *.dfm}

{ TControllerCaixaMovimento }

procedure TControllerCaixaMovimento.CriarMovimento(ATipoMov: string;
  ACodCaixa: Integer; AMovimento: TLojaModelCaixaNovoMovimento);
begin
  var LResponse := PreparaRequest
    .Resource('/caixa/{cod_caixa}/movimento/{tipo_mov}')
    .AddUrlSegment('cod_caixa', ACodCaixa.ToString)
    .AddUrlSegment('tipo_mov', ATipoMov)
    .AddBody(TJson.ObjectToClearJsonString(AMovimento))
    .Post();

  if LResponse.StatusCode <> 201
  then RaiseException(LResponse, 'Falha ao criar novo movimento de caixa');

  Serializar(LResponse);
end;

procedure TControllerCaixaMovimento.CriarMovimentoReforco(ACodCaixa: Integer;
  AMovimento: TLojaModelCaixaNovoMovimento);
begin
  CriarMovimento('reforco', ACodCaixa, AMovimento);
end;

procedure TControllerCaixaMovimento.CriarMovimentoSangria(ACodCaixa: Integer;
  AMovimento: TLojaModelCaixaNovoMovimento);
begin
  CriarMovimento('sangria', ACodCaixa, AMovimento);
end;

procedure TControllerCaixaMovimento.ObterMovimentosCaixa(ACodCaixa: Integer);
begin
  try
    if mtDados.Active
    then mtDados.Close;

    var LResponse := PreparaRequest
      .Resource('/caixa/{cod_caixa}/movimento')
      .AddUrlSegment('cod_caixa', ACodCaixa.ToString)
      .Get();

    if not(LResponse.StatusCode in [200])
    then RaiseException(LResponse, 'Falha ao obter movimentos do caixa');

    Serializar(LResponse);
  finally
    if not mtDados.Active
    then mtDados.CreateDataSet;
  end;
end;

end.
