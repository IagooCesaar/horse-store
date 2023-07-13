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
    .RequiredMessage('O c�digo do item � obrigat�rio')
    .InvalidFormatMessage('O valor informado n�o � um inteiro v�lido')
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
    .RequiredMessage('O c�digo do item � obrigat�rio')
    .InvalidFormatMessage('O valor informado n�o � um inteiro v�lido')
    .AsInteger;

  var LDatRef := Req.Query.Field('dat_ref')
    .Required
    .RequiredMessage('A data de refer�ncia � obrigat�ria')
    .InvalidFormatMessage('O valor informado n�o � um inteiro v�lido')
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
    .RequiredMessage('O c�digo do item � obrigat�rio')
    .InvalidFormatMessage('O valor informado n�o � um inteiro v�lido')
    .AsInteger;

  if Req.Body = ''
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(C_UnitName)
    .Error('O body n�o estava no formato esperado');

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
    .Tag('Pre�o de Venda')
      .GET('Pre�o atual')
        .AddParamPath('cod_item')
          .Schema(SWAG_INTEGER)
        .&End
        .Description('Obt�m o valor que o item dever� ser vendido hoje')
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelEntityPrecoVenda).&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End

      .POST('Criar um novo pre�o de venda')
        .Description('Cria um novo pre�o que dever� se praticado a paritr da data inicial informada')
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
    .Tag('Pre�o de Venda')
      .GET('Hist�rico de pre�o praticado')
        .AddParamPath('cod_item')
          .Schema(SWAG_INTEGER)
        .&End
        .AddParamQuery('dat_ref', 'Data de refer�ncia')
          .Schema(SWAG_STRING, SWAG_STRING_FORMAT_DATETIME)
          .Required(True)
        .&End
        .Description('Obt�m o hist�rico de pre�o de venda de item praticado a partir da data de refer�ncia informada')
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
