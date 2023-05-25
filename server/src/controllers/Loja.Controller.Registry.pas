unit Loja.Controller.Registry;

interface

uses
  Horse,
  Horse.GBSwagger;

procedure DoRegistry(const AContext: string);

implementation

uses
  Loja.Controller.Itens;

procedure HealtCheck(Req: THorseRequest; Resp: THorseResponse);
begin
  Resp.Status(THTTPStatus.OK).Send('{"healthcheck": "Ok"}');
end;

procedure DoRegistry(const AContext: string);
begin
  var LContext := AContext + '/api';
  Loja.Controller.Itens.Registry(LContext);


  THorse
    .Get(LContext+'/healthcheck', HealtCheck);

  Swagger
    .Path(LContext+'/healthcheck')
    .Tag('Infraestrutura')
      .GET('Health Check')
        .Description('Health Check')
        .AddResponse(Integer(THTTPStatus.OK)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End
end;

end.
