unit Loja.Controller.Itens;

interface

uses
  Horse,
  Horse.Commons,
  Horse.JsonInterceptor.Helpers;

procedure Registry(const AContext: string);
procedure ConfigSwagger;

const C_UnitName = 'Loja.Controller.Itens';

implementation

uses
  System.SysUtils,
  GBSwagger.Model.Interfaces,

  Loja.Model.Factory,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Itens.FiltroItens,
  Loja.Model.Dto.Resp.Itens.Item;

procedure ObterItens(Req: THorseRequest; Resp: THorseResponse);
var
  LLhsBracketType: TLhsBracketsType;
  LFiltros: TLojaModelDtoReqItensFiltroItens;
begin
  THorseCoreParamConfig.GetInstance.CheckLhsBrackets(True);

  try
    LFiltros := TLojaModelDtoReqItensFiltroItens.Create;

    for LLhsBracketType in Req.Query.Field('nom_item').LhsBrackets.Types do
    begin
      LFiltros.NomItem := Req.Query.Field('nom_item').LhsBrackets.GetValue(LLhsBracketType);
      LFiltros.NomItemLhsBracketsType := LLhsBracketType;
    end;

    for LLhsBracketType in Req.Query.Field('num_cod_barr').LhsBrackets.Types do
    begin
      LFiltros.NumCodBarr := Req.Query.Field('num_cod_barr').LhsBrackets.GetValue(LLhsBracketType);
      LFiltros.NumCodBarrLhsBracketsType := LLhsBracketType;
    end;

    var LItens := TLojaModelFactory.New
      .Itens
      .ObterItens(LFiltros);

    if LItens.Count = 0
    then Resp.Status(THTTPStatus.NoContent)
    else Resp.Status(THTTPStatus.Ok).Send(TJSON.ObjectToClearJsonValue(LItens));

    LItens.Free;
  finally
    FreeAndNil(LFiltros);
  end;
end;

procedure CriarItem(Req: THorseRequest; Resp: THorseResponse);
var LDto: TLojaModelDtoReqItensCriarItem;
begin
  if Req.Body = ''
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(C_UnitName)
    .Error('O body não estava no formato esperado');

  try
    LDto := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoReqItensCriarItem>(Req.Body);

    var LItem := TLojaModelFactory.New
      .Itens
      .CriarItem(LDto);

    Resp.Status(THTTPStatus.Created).Send(TJSON.ObjectToClearJsonObject(LItem));
    LItem.Free;
  finally
    if Assigned(LDto)
    then FreeAndNil(LDto);
  end;
end;

procedure AtualizarItem(Req: THorseRequest; Resp: THorseResponse);
var LDto: TLojaModelDtoReqItensCriarItem; LCodItem : Integer;
begin
  LCodItem := Req.Params.Field('cod_item')
    .Required
    .RequiredMessage('O código do item é obrigatório')
    .InvalidFormatMessage('O valor fornecido não é um inteiro válido')
    .AsInteger;

  if LCodItem <= 0 then
    raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(C_UnitName)
      .Error('O código do item deve ser superior a zero');

  if Req.Body = ''
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(C_UnitName)
    .Error('O body não estava no formato esperado');

  try
    LDto := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoReqItensCriarItem>(Req.Body);
    LDto.CodItem := LCodItem;

    var LItem := TLojaModelFactory.New
      .Itens
      .AtualizarItem(LDto);

    Resp.Status(THTTPStatus.Ok).Send(TJSON.ObjectToClearJsonObject(LItem));
    LItem.Free;
  finally
    if Assigned(LDto)
    then FreeAndNil(LDto);
  end;
end;

procedure GetItemPorCodigo(Req: THorseRequest; Resp: THorseResponse);
var LCodItem : Integer;
begin
  LCodItem := Req.Params.Field('cod_item')
    .Required
    .RequiredMessage('O código do item é obrigatório')
    .InvalidFormatMessage('O valor fornecido não é um inteiro válido')
    .AsInteger;

  if LCodItem <= 0 then
    raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(C_UnitName)
      .Error('O código do item deve ser superior a zero');

  var LItem := TLojaModelFactory.New
    .Itens
    .ObterPorCodigo(LCodItem);

  Resp.Send(TJSON.ObjectToClearJsonObject(LItem));
  LItem.Free;
end;

procedure GetItemPorNumCodBarr(Req: THorseRequest; Resp: THorseResponse);
var LCodBarr : String;
begin
  LCodBarr := Req.Params.Field('num_cod_barr')
    .Required
    .RequiredMessage('O código de barras do item é obrigatório')
    .AsString;

  var LItem := TLojaModelFactory.New
    .Itens
    .ObterPorNumCodBarr(LCodBarr);

  Resp.Send(TJSON.ObjectToClearJsonObject(LItem));
  LItem.Free;
end;

procedure Registry(const AContext: string);
begin
  ConfigSwagger;

  THorse.Group.Prefix(AContext+'/itens')
    .Post('/', CriarItem)
    .Get('/', ObterItens)
    .Get('/:cod_item', GetItemPorCodigo)
    .Put('/:cod_item', AtualizarItem)
    .Get('/codigo-barras/:num_cod_barr', GetItemPorNumCodBarr)
end;

procedure ConfigSwagger;
begin
  Swagger
    .Path('/itens')
    .Tag('Itens')
      .GET('Obter dados cadastrais de vários itens')
        .Description('Obter dados cadastrais de itens. Utilize LHS Brackets para filtrar: (eq, contains, startsWith e endsWith)')
        .AddParamQuery('nom_item', 'Nome do item. Utilize LHS Brackets para filtrar: (eq, contains, startsWith e endsWith)').&End
        .AddParamQuery('num_cod_barr', 'Número do código de barras do item. Utilize LHS Brackets para filtrar: (eq, contains, startsWith e endsWith)').&End
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelDtoRespItensItem).IsArray(true).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End

      .POST('Cria um novo item')
        .Description('Cria um novo item para venda')
        .AddParamBody('Body').Schema(TLojaModelDtoReqItensCriarItem).&End
        .AddResponse(Integer(THTTPStatus.Created)).Schema(TLojaModelDtoRespItensItem).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End

    .&End

    .Path('/itens/{cod_item}')
    .Tag('Itens')
      .PUT('Atualizar o cadastro de um item')
        .Description('Atualizar o cadastro de um item')
        .AddParamPath('cod_item', 'Código do item')
          .Schema(SWAG_INTEGER)
        .&End
        .AddParamBody('Body').Schema(TLojaModelDtoReqItensCriarItem).&End
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelDtoRespItensItem).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/itens/{cod_item}')
    .Tag('Itens')
      .GET('Obter dados cadastrais de um item')
        .Description('Obter dados cadastrais de um item')
        .AddParamPath('cod_item', 'Código do item')
          .Schema(SWAG_INTEGER)
        .&End
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelDtoRespItensItem).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/itens/codigo-barras/{num_cod_barr}')
    .Tag('Itens')
      .GET('Obter dados cadastrais de um item')
        .Description('Obter dados cadastrais de um item')
        .AddParamPath('num_cod_barr', 'Código de barras')
          .Schema(SWAG_STRING)
        .&End
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelDtoRespItensItem).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End
  ;
end;

end.
