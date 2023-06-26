unit Loja.Controller.Caixa;

interface

uses
  Horse,
  Horse.Commons,
  Horse.JsonInterceptor.Helpers;

procedure Registry(const AContext: string);
procedure ConfigSwagger;

const C_UnitName = 'Loja.Controller.Caixa';

implementation

uses
  System.SysUtils,
  GBSwagger.Model.Interfaces,

  Loja.Model.Factory,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa,
  Loja.Model.Dto.Req.Caixa.CriarMovimento,
  Loja.Model.Dto.Req.Caixa.Abertura,
  Loja.Model.Dto.Req.Caixa.Fechamento,
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Movimento;

procedure GetCaixas(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure GetCaixaAberto(Req: THorseRequest; Resp: THorseResponse);
begin
  var LCaixa := TLojaModelFactory.New.Caixa
    .ObterCaixaAberto;

  if LCaixa = nil
  then Resp.Status(THTTPStatus.NoContent)
  else Resp.Status(THTTPStatus.OK).Send(TJson.ObjectToClearJsonValue(LCaixa));

  LCaixa.Free;
end;

procedure GetCaixaPorCodigo(Req: THorseRequest; Resp: THorseResponse);
begin
  var LCodCaixa := Req.Params.Field('cod_caixa')
    .InvalidFormatMessage('O valor informado não é um inteiro válido')
    .AsInteger;

  var LCaixa := TLojaModelFactory.New.Caixa.ObterCaixaPorCodigo(LCodCaixa);

  if LCaixa = nil
  then Resp.Status(THTTPStatus.NoContent)
  else Resp.Status(THTTPStatus.OK).Send(TJson.ObjectToClearJsonValue(LCaixa));

  LCaixa.Free;
end;

procedure GetResumoCaixa(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure GetMovimentoCaixa(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure PostMovimentoSangria(Req: THorseRequest; Resp: THorseResponse);
begin
  if Req.Body = ''
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(C_UnitName)
    .Error('O body não estava no formato esperado');

  var LCodCaixa := Req.Params.Field('cod_caixa')
    .InvalidFormatMessage('O valor informado não é um inteiro válido')
    .AsInteger;

  var LDto := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoReqCaixaCriarMovimento>(Req.Body);
  try
    LDto.CodCaixa := LCodCaixa;
    var LMovimento := TLojaModelFactory.New.Caixa.CriarSangriaCaixa(LDto);
    Resp.Status(THttpStatus.Created).Send(TJson.ObjectToClearJsonValue(LMovimento));
    LMovimento.Free;
  finally
    LDto.Free;
  end;
end;

procedure PostMovimentoReforco(Req: THorseRequest; Resp: THorseResponse);
begin
  if Req.Body = ''
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(C_UnitName)
    .Error('O body não estava no formato esperado');

  var LCodCaixa := Req.Params.Field('cod_caixa')
    .InvalidFormatMessage('O valor informado não é um inteiro válido')
    .AsInteger;

  var LDto := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoReqCaixaCriarMovimento>(Req.Body);
  try
    LDto.CodCaixa := LCodCaixa;
    var LMovimento := TLojaModelFactory.New.Caixa.CriarReforcoCaixa(LDto);
    Resp.Status(THttpStatus.Created).Send(TJson.ObjectToClearJsonValue(LMovimento));
    LMovimento.Free;
  finally
    LDto.Free;
  end;
end;

procedure PostAbrirCaixa(Req: THorseRequest; Resp: THorseResponse);
begin
  if Req.Body = ''
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(C_UnitName)
    .Error('O body não estava no formato esperado');

  var LDto := TJson.ClearJsonAndConvertToObject
    <TLojaModelDtoReqCaixaAbertura>(Req.Body);
  try
    var LCaixa := TLojaModelFactory.New.Caixa.AberturaCaixa(LDto);
    Resp.Status(THTTPStatus.Created).Send(TJson.ObjectToClearJsonValue(LCaixa));
    LCaixa.Free;
  finally
    LDto.Free;
  end;
end;

procedure PatchFecharCaixa(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure Registry(const AContext: string);
begin
  ConfigSwagger;

  THorse.Group.Prefix(AContext+'/caixa')
    .Get('/', GetCaixas)
    .Get('/caixa-aberto', GetCaixaAberto)
    .Post('/abrir-caixa', PostAbrirCaixa)
    .Get('/:cod_caixa', GetCaixaPorCodigo)
    .Patch('/:cod_caixa/fechar-caixa', PatchFecharCaixa)
    .Get('/:cod_caixa/resumo', GetResumoCaixa)
    .Get('/:cod_caixa/movimento', GetMovimentoCaixa)
    .Post('/:cod_caixa/movimento/sangria', PostMovimentoSangria)
    .Post('/:cod_caixa/movimento/reforco', PostMovimentoReforco)
end;

procedure ConfigSwagger;
begin
  Swagger
    .Path('/caixa')
    .Tag('Caixa')
      .GET('Obtêm lista de caixas')
        .Description('Obtêm uma lista de caixas que foram abertos no periodo especificado')
        .AddParamQuery('dat_ini', 'Data inicial')
          .Schema(SWAG_STRING, 'date')
          .Required(True)
        .&End
        .AddParamQuery('dat_fim', 'Data final')
          .Schema(SWAG_STRING, 'date')
          .Required(True)
        .&End
        .AddResponse(Integer(THTTPStatus.OK))
          .Schema(TLojaModelEntityCaixaCaixa)
          .IsArray(True)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/caixa/caixa-aberto')
    .Tag('Caixa')
      .GET('Obtêm informações sobre o caixa que estiver aberto')
        .Description('Obtêm informações sobre o caixa que estiver aberto')
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelEntityCaixaCaixa).&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/caixa/abrir-caixa')
    .Tag('Caixa')
      .POST('Realiza abertura de caixa')
        .Description('Realiza a abertura de caixa')
        .AddParamBody('Body')
           .Schema(TLojaModelDtoReqCaixaAbertura)
        .&End
        .AddResponse(Integer(THTTPStatus.Created)).Schema(TLojaModelEntityCaixaCaixa).&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/caixa/{cod_caixa}')
    .Tag('Caixa')
      .GET('Obtêm informações sobre um caixa específico')
        .Description('Obtêm dados da abertura e fechamento de um caixa específico')
        .AddParamPath('cod_caixa', 'Código identificador do caixa')
          .Schema(SWAG_INTEGER)
        .&End
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelEntityCaixaCaixa).&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/caixa/{cod_caixa}/fechar-caixa')
    .Tag('Caixa')
      .PATCH('Realiza fechamento de caixa')
        .Description('Realiza o fechamento do caixa informado')
        .AddParamPath('cod_caixa', 'Código identificador do caixa')
          .Schema(SWAG_INTEGER)
        .&End
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelEntityCaixaCaixa).&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/caixa/{cod_caixa}/resumo')
    .Tag('Caixa')
      .GET('Resumo de caixa')
        .Description('Obtêm resumo de movimentos do caixa por meio de pagamento')
        .AddParamPath('cod_caixa', 'Código identificador do caixa')
          .Schema(SWAG_INTEGER)
        .&End
        .AddResponse(Integer(THTTPStatus.OK))
          .Schema(TLojaModelDtoRespCaixaResumoCaixa)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/caixa/{cod_caixa}/movimento')
    .Tag('Caixa')
      .GET('Movimento de caixa')
        .Description('Obtêm detalhes da movimentação de um caixa')
        .AddParamPath('cod_caixa', 'Código identificador do caixa')
          .Schema(SWAG_INTEGER)
        .&End
        .AddResponse(Integer(THTTPStatus.OK))
          .Schema(TLojaModelEntityCaixaMovimento)
          .IsArray(True)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/caixa/{cod_caixa}/movimento/sangria')
    .Tag('Caixa')
      .POST('Sangria de caixa')
        .Description('Realiza uma retirada de valores do caixa')
        .AddParamPath('cod_caixa', 'Código identificador do caixa')
          .Schema(SWAG_INTEGER)
        .&End
        .AddParamBody('Body')
          .Schema(TLojaModelDtoReqCaixaCriarMovimento)
        .&End
        .AddResponse(Integer(THTTPStatus.Created))
          .Schema(TLojaModelEntityCaixaMovimento)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/caixa/{cod_caixa}/movimento/reforco')
    .Tag('Caixa')
      .POST('Reforço de caixa')
        .Description('Realiza um reforço de valores do caixa')
        .AddParamPath('cod_caixa', 'Código identificador do caixa')
          .Schema(SWAG_INTEGER)
        .&End
        .AddParamBody('Body')
          .Schema(TLojaModelDtoReqCaixaCriarMovimento)
        .&End
        .AddResponse(Integer(THTTPStatus.Created))
          .Schema(TLojaModelEntityCaixaMovimento)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

end;

end.
