unit Loja.Controller.Base;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,

  RESTRequest4D,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TControllerBase = class(TDataModule)
    mtDados: TFDMemTable;
  private
    { Private declarations }
  protected
    procedure CriarDatasets; virtual;

    function PreparaRequest: IRequest;
    procedure RaiseException(AResponse : IResponse; ATituloMensagem: string);
    procedure Serializar(AResponse : IResponse; dsDestino: TDataSet = nil); overload;
    procedure Serializar(AJsonString : string; dsDestino: TDataSet = nil); overload;
    procedure Serializar(AJsonValue : TJSONValue; dsDestino: TDataSet = nil); overload;
  public
  end;

implementation

uses
  DataSet.Serialize,
  Horse.JsonInterceptor.Helpers,

  Loja.Model.Infra.Configuracoes,
  Loja.Model.Infra.Usuario,
  Loja.Model.Infra.DTO.ApiError;

{$R *.dfm}

{ TControllerBase }

procedure TControllerBase.RaiseException(AResponse: IResponse;
  ATituloMensagem: string);
var LMensagem: String;

  function RetornoErroHorse: string;
  var LApiError: TLojaModelInfraDTOApiError; LJson: TJSONObject;
  begin
    try
      try
        // Se o erro foi tratado pelo EHorseException virá em formato JSON
        LJson := TJSONObject.ParseJSONValue(AResponse.Content) as TJSONObject;
        LApiError := TJson.ClearJsonAndConvertToObject<TLojaModelInfraDTOApiError>(LJson);
        Result := Format(
          #13#10#13#10+
          'Mensagem: %s'+#13#10+#13#10+
          'Unit da API: %s'+#13#10+
          'Status code: %d %s',
          [LApiError.error, LApiError.&unit, AResponse.StatusCode, AResponse.StatusText]
        );
      finally
        if LApiError <> nil
        then LApiError.Free;
        if LJson <> nil
        then LJson.Free;
      end;
    except
      // Se erro ocorre antes dos controles de Exceção do Horse, vem em text/plain
      Result := Format(
        #13#10#13#10+
        'Mensagem: %s'+#13#10+#13#10+
        'Status code: %d %s',
        [AResponse.Content, AResponse.StatusCode, AResponse.StatusText]
      );
    end;
  end;
begin
  case AResponse.StatusCode of
    400..499: begin
      LMensagem := Format(
        '%s: %s',
        [ATituloMensagem, RetornoErroHorse]
      );
    end;
    500..599: begin
      LMensagem := Format(
        '%s: %s'+#13#10+
        'Erro interno na API.',
        [ATituloMensagem, RetornoErroHorse]
      );
    end;
  else
    // Caso genérico, Status Code diferente do esperado
    LMensagem := Format(
      '%s:'+#13#10+
      'Código de status do retorno diferente do esperado.'+
      '%s',
      [ATituloMensagem, RetornoErroHorse]
    );
  end;
  raise Exception.Create(LMensagem);
end;

procedure TControllerBase.CriarDatasets;
begin
  if mtDados.Active
  then mtDados.Close;
  mtDados.CreateDataSet;
end;

function TControllerBase.PreparaRequest: IRequest;
begin
  Result := TRequest.New
    .BaseUrl(TLojaModelInfraConfiguracoes.GetInstance.APIUrl)
    .Timeout(TLojaModelInfraConfiguracoes.GetInstance.APITimeout)
    .BasicAuthentication(
      TLojaModelInfraUsuario.GetInstance.Login,
      TLojaModelInfraUsuario.GetInstance.Senha
    )
  ;
end;

procedure TControllerBase.Serializar(AResponse: IResponse; dsDestino: TDataSet);
begin
  if dsDestino = nil
  then dsDestino := mtDados;

  try
    dsDestino.DisableControls;
    dsDestino.LoadFromJSON(AResponse.Content);
  finally
    dsDestino.EnableControls;
  end;
end;

procedure TControllerBase.Serializar(AJsonString: string; dsDestino: TDataSet);
begin
  if dsDestino = nil
  then dsDestino := mtDados;

  try
    dsDestino.DisableControls;
    dsDestino.LoadFromJSON(AJsonString);
  finally
    dsDestino.EnableControls;
  end;
end;

procedure TControllerBase.Serializar(AJsonValue: TJSONValue;
  dsDestino: TDataSet);
begin
  if dsDestino = nil
  then dsDestino := mtDados;

  try
    dsDestino.DisableControls;
    if AJsonValue is TJSONObject
    then dsDestino.LoadFromJSON(AJsonValue as TJSONObject)
    else
    if AJsonValue is TJSONArray
    then dsDestino.LoadFromJSON(AJsonValue as TJSONArray);
  finally
    dsDestino.EnableControls;
  end;
end;


end.
