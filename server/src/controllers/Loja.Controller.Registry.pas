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
  Loja.Controller.Estoque;

procedure HealtCheck(Req: THorseRequest; Resp: THorseResponse);
begin
  Resp.Status(THTTPStatus.OK).Send('{"healthcheck": "Ok"}');
end;

procedure GetLhsBracketsTest(Req: THorseRequest; Res: THorseResponse);
var
  LLhsBracketType: TLhsBracketsType;
  LValues: TStringList;
begin
  THorseCoreParamConfig.GetInstance.CheckLhsBrackets(True);

  LValues := TStringList.Create;

  for LLhsBracketType in Req.Query.Field('test').LhsBrackets.Types do
  begin

    LValues.Add(
      Format('test %s = %s', [
        LLhsBracketType.ToString,
        Req.Query.Field('test').LhsBrackets.GetValue(LLhsBracketType)
    ]));
  end;
  LValues.Add('*'+Req.Query.Field('test').AsString);

  Res.Send(LValues.Text);
  LValues.Free;
end;

procedure DoRegistry(const AContext: string);
begin
  var LContext := AContext + '/api';
  Loja.Controller.Itens.Registry(LContext);
  Loja.Controller.Estoque.Registry(LContext);

  THorse
    .Get(LContext+'/healthcheck', HealtCheck)
    .Get(LContext+'/lhs-brackets-test', GetLhsBracketsTest);


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
