unit Loja.Controller.Registry;

interface

uses
  Horse,
  Horse.Commons,
  Horse.GBSwagger,
  System.Classes,
  System.SysUtils,
  System.JSON;

procedure DoRegistry(const AContext: string);

implementation

uses
  Loja.Controller.Itens,
  Loja.Controller.Estoque,
  Loja.Controller.Preco,
  Loja.Controller.Caixa,
  Loja.Controller.Venda;

procedure HealtCheck(Req: THorseRequest; Resp: THorseResponse);
begin
  Resp.Status(THTTPStatus.OK).Send('{"healthcheck": "Ok"}');
end;

procedure ValidarLogon(Req: THorseRequest; Resp: THorseResponse);
begin
  Resp.Status(THTTPStatus.OK).Send('{"logon": "Ok"}');
end;

procedure DoRegistry(const AContext: string);
begin
  var LContext := AContext + '/api';
  Loja.Controller.Itens.Registry(LContext);
  Loja.Controller.Estoque.Registry(LContext);
  Loja.Controller.Preco.Registry(LContext);
  Loja.Controller.Caixa.Registry(LContext);
  Loja.Controller.Venda.Registry(LContext);

  THorse
    .Get(LContext+'/healthcheck', HealtCheck)
    .Get(LContext+'/validar-logon', ValidarLogon);

  Swagger
    .Path('/healthcheck')
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

    .Path('/validar-logon')
    .Tag('Infraestrutura')
      .GET('Validar Logon')
        .Description('Rota utilitária para validar a autenticação')
        .AddResponse(Integer(THTTPStatus.OK)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

end;

end.
