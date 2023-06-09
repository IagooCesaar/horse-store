unit Loja.Controller.Base;

interface

uses
  System.SysUtils,
  System.Classes,

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
    function PreparaRequest: IRequest;
    procedure InternalRaiseException(AResponse : IResponse; ATituloMensagem: string);
  end;

implementation

uses
  System.JSON,
  DataSet.Serialize,
  Horse.JsonInterceptor.Helpers,

  Loja.Model.Infra.Configuracoes,
  Loja.Model.Infra.Usuario,
  Loja.Model.Infra.DTO.ApiError;

{$R *.dfm}

{ TControllerBase }

procedure TControllerBase.InternalRaiseException(AResponse: IResponse;
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
          #13#10+
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

end.
