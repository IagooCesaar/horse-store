unit Loja.Controller.Preco;

interface

uses
  Horse,
  Horse.Commons,
  Horse.JsonInterceptor.Helpers;

procedure Registry(const AContext: string);
procedure ConfigSwagger;

const C_UnitName = 'Loja.Controller.Preco';

implementation

uses
  System.SysUtils,
  GBSwagger.Model.Interfaces,

  Loja.Model.Factory,
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda,
  Loja.Model.Entity.Preco.Venda;

procedure GetPrecoVendaAtual(Req: THorseRequest; Resp: THorseResponse);
begin
  var LCodItem := Req.Params.Field('cod_item')
    .Required
    .RequiredMessage('O código do item é obrigatório')
    .InvalidFormatMessage('O valor informado não é um inteiro válido')
    .AsInteger;

  var LPreco := TLojaModelFactory.New.Preco.ObterPrecoVendaAtual(LCodItem);
  try
    if LPreco = nil
    then Resp.Status(THTTPStatus.NoContent)
    else Resp.Send(TJson.ObjectToClearJsonValue(LPreco)).Status(THTTPStatus.OK);
  finally
    if LPreco <> nil
    then FreeAndNil(LPreco);
  end;
end;

procedure GetHistoricoPrecoVenda(Req: THorseRequest; Resp: THorseResponse);
begin
  var LCodItem := Req.Params.Field('cod_item')
    .Required
    .RequiredMessage('O código do item é obrigatório')
    .InvalidFormatMessage('O valor informado não é um inteiro válido')
    .AsInteger;

  var LDatRef := Req.Query.Field('dat_ref')
    .Required
    .RequiredMessage('A data de referência é obrigatória')
    .InvalidFormatMessage('O valor informado não é um inteiro válido')
    .AsDateTime;

  var LHistorico := TLojaModelFactory.New.Preco.ObterHistoricoPrecoVendaItem(LCodItem, LDatRef);
  try
    if (LHistorico = nil) or (LHistorico.Count = 0)
    then Resp.Status(THTTPStatus.NoContent)
    else Resp.Send(TJson.ObjectToClearJsonValue(LHistorico)).Status(THTTPStatus.OK);
  finally
    if LHistorico <> nil
    then FreeAndNil(LHistorico);
  end;
end;

procedure PostCriarPrecoVenda(Req: THorseRequest; Resp: THorseResponse);
begin
  var LCodItem := Req.Params.Field('cod_item')
    .Required
    .RequiredMessage('O código do item é obrigatório')
    .InvalidFormatMessage('O valor informado não é um inteiro válido')
    .AsInteger;

  if Req.Body = ''
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(C_UnitName)
    .Error('O body não estava no formato esperado');

  var LDto := TJson.ClearJsonAndConvertToObject<TLojaModelDtoReqPrecoCriarPrecoVenda>
    (Req.Body);
  try
    LDto.CodItem := LCodItem;
    var LPreco := TLojaModelFactory.New.Preco.CriarPrecoVendaItem(LDto);

    Resp.Status(THTTPStatus.Created).Send(TJson.ObjectToClearJsonValue(LPreco));
    LPreco.Free;
  finally
    LDto.Free;
  end;
end;

procedure Registry(const AContext: string);
begin
  ConfigSwagger;

  THorse.Group.Prefix(AContext+'/preco-venda')
    .Get('/:cod_item', GetPrecoVendaAtual)
    .Post('/:cod_item', PostCriarPrecoVenda)
    .Get('/:cod_item/historico', GetHistoricoPrecoVenda)
end;

procedure ConfigSwagger;
begin
  Swagger
    .Path('/preco-venda/{cod_item}')
    .Tag('Preço de Venda')
      .GET('Preço atual')
        .AddParamPath('cod_item')
          .Schema(SWAG_INTEGER)
        .&End
        .Description('Obtêm o valor que o item deverá ser vendido hoje')
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelEntityPrecoVenda).&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End

      .POST('Criar um novo preço de venda')
        .Description('Cria um novo preço que deverá se praticado a paritr da data inicial informada')
        .AddParamPath('cod_item')
          .Schema(SWAG_INTEGER)
        .&End
        .AddParamBody('body')
          .Schema(TLojaModelDtoReqPrecoCriarPrecoVenda)
        .&End
        .AddResponse(Integer(THTTPStatus.Created)).Schema(TLojaModelEntityPrecoVenda).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/preco-venda/{cod_item}/historico')
    .Tag('Preço de Venda')
      .GET('Histórico de preço praticado')
        .AddParamPath('cod_item')
          .Schema(SWAG_INTEGER)
        .&End
        .AddParamQuery('dat_ref', 'Data de referência')
          .Schema(SWAG_STRING, SWAG_STRING_FORMAT_DATETIME)
          .Required(True)
        .&End
        .Description('Obtêm o histórico de preço de venda de item praticado a partir da data de referência informada')
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelEntityPrecoVenda).IsArray(True).&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End
end;

end.
