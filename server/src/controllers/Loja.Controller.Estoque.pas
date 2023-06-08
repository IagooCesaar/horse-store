unit Loja.Controller.Estoque;

interface

uses
  Horse,
  Horse.Commons,
  Horse.JsonInterceptor.Helpers;

procedure Registry(const AContext: string);
procedure ConfigSwagger;

const C_UnitName = 'Loja.Controller.Estoque';

implementation

uses
  System.SysUtils,
  GBSwagger.Model.Interfaces,

  Loja.Model.Factory,
  Loja.Model.Dto.Req.Estoque.AcertoEstoque,

  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Itens.FiltroItens,
  Loja.Model.Dto.Resp.Estoque.SaldoItem,
  Loja.Model.Entity.Estoque.Saldo,
  Loja.Model.Entity.Estoque.Movimento;

procedure CriarAcertoEstoque(Req: THorseRequest; Resp: THorseResponse);
var LDto : TLojaModelDtoReqEstoqueAcertoEstoque;
begin
  if Req.Body = ''
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(C_UnitName)
    .Error('O body n�o estava no formato esperado');

  try
    LDto := TJson.ClearJsonAndConvertToObject
      <TLojaModelDtoReqEstoqueAcertoEstoque>(Req.Body);

    LDto.CodItem := Req.Params.Field('cod_item')
      .Required
      .RequiredMessage('O c�digo do item � obrigat�rio')
      .InvalidFormatMessage('O valor fornecido n�o � um inteiro v�lido')
      .AsInteger;

    var LMovimento := TLojaModelFactory.New
      .Estoque
      .CriarAcertoEstoque(LDto);

    Resp.Status(THTTPStatus.Created).Send(TJSON.ObjectToClearJsonValue(LMovimento));
    LMovimento.Free;
  finally
    if Assigned(LDto)
    then FreeAndNil(LDto);
  end;
end;

procedure ObterHistoricoMovimento(Req: THorseRequest; Resp: THorseResponse);
var LCodItem : Integer; LDatIni, LDatFim: TDateTime;
begin
  LCodItem := Req.Params.Field('cod_item')
    .Required
    .RequiredMessage('O c�digo do item � obrigat�rio')
    .InvalidFormatMessage('O valor fornecido n�o � um inteiro v�lido')
    .AsInteger;

  LDatIni := Req.Query.Field('dat_ini')
    .Required
    .RequiredMessage('� obrigat�rio informar data inicial')
    .InvalidFormatMessage('O valor fornecido n�o � uma data v�lida')
    .AsDate;

  LDatFim := Req.Query.Field('dat_fim')
    .Required
    .RequiredMessage('� obrigat�rio informar data final')
    .InvalidFormatMessage('O valor fornecido n�o � uma data v�lida')
    .AsDate;

  var LMovimentos := TLojaModelFactory.New
    .Estoque
    .ObterHistoricoMovimento(LCodItem, LDatIni, LDatFim);

  if LMovimentos.Count = 0
  then Resp.Status(THTTPStatus.NoContent)
  else Resp.Status(THTTPStatus.Ok).Send(TJSON.ObjectToClearJsonValue(LMovimentos));
  LMovimentos.Free;
end;

procedure ObterSaldoAtual(Req: THorseRequest; Resp: THorseResponse);
begin
  var LCodItem := Req.Params.Field('cod_item')
    .Required
    .RequiredMessage('O c�digo do item � obrigat�rio')
    .InvalidFormatMessage('O valor fornecido n�o � um inteiro v�lido')
    .AsInteger;

  var LSaldo := TLojaModelFactory.New
    .Estoque
    .ObterSaldoAtualItem(LCodItem);
  Resp.Status(THTTPStatus.Ok).Send(TJSON.ObjectToClearJsonValue(LSaldo));
  LSaldo.Free;
end;

procedure ObterFechamentosSaldo(Req: THorseRequest; Resp: THorseResponse);
var LCodItem : Integer; LDatIni, LDatFim: TDateTime;
begin
  LCodItem := Req.Params.Field('cod_item')
    .Required
    .RequiredMessage('O c�digo do item � obrigat�rio')
    .InvalidFormatMessage('O valor fornecido n�o � um inteiro v�lido')
    .AsInteger;

  LDatIni := Req.Query.Field('dat_ini')
    .Required
    .RequiredMessage('� obrigat�rio informar data inicial')
    .InvalidFormatMessage('O valor fornecido n�o � uma data v�lida')
    .AsDate;

  LDatFim := Req.Query.Field('dat_fim')
    .Required
    .RequiredMessage('� obrigat�rio informar data final')
    .InvalidFormatMessage('O valor fornecido n�o � uma data v�lida')
    .AsDate;

  var LFechamentos := TLojaModelFactory.New.Estoque
    .ObterFechamentosSaldo(LCodItem, LDatIni, LDatFim);

  if LFechamentos.Count = 0
  then Resp.Status(THTTPStatus.NoContent)
  else Resp.Status(THTTPStatus.Ok).Send(TJSON.ObjectToClearJsonValue(LFechamentos));
  LFechamentos.Free;
end;

procedure Registry(const AContext: string);
begin
  ConfigSwagger;

  THorse.Group.Prefix(AContext+'/estoque')
    .Post('/:cod_item/acerto-de-estoque', CriarAcertoEstoque)
    .Get('/:cod_item/historico-movimento', ObterHistoricoMovimento)
    .Get('/:cod_item/fechamentos-saldo', ObterFechamentosSaldo)
    .Get('/:cod_item/saldo-atual', ObterSaldoAtual)
end;

procedure ConfigSwagger;
begin
  Swagger
    .Path('/estoque/{cod_item}/saldo-atual')
    .Tag('Estoque')
      .GET('Obt�m saldo atual do item')
        .Description('Obt�m saldo atual, �ltimo fechamento e �ltimos movimentos do item')
        .AddParamPath('cod_item', 'C�digo do item')
          .Schema(SWAG_INTEGER)
        .&End
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelDtoRespEstoqueSaldoItem).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/estoque/{cod_item}/fechamentos-saldo')
    .Tag('Estoque')
      .GET('Obt�m fechamentos de saldo do item')
        .Description('Obt�m fechamentos de saldo do item em um per�odo de tempo')
        .AddParamPath('cod_item', 'C�digo do item')
          .Schema(SWAG_INTEGER)
        .&End
        .AddParamQuery('dat_ini', 'Data inicial (YYYY-MM-DD)')
          .Schema(SWAG_STRING)
          .Required(True)
        .&End
        .AddParamQuery('dat_fim', 'Data final (YYYY-MM-DD)')
          .Schema(SWAG_STRING)
          .Required(True)
        .&End
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelEntityEstoqueSaldo).IsArray(True).&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/estoque/{cod_item}/historico-movimento')
    .Tag('Estoque')
      .GET('Obt�m hist�rico de movimenta��o')
        .Description('Obt�m hist�rico de movimenta��o de estoque do item em um per�odo de tempo')
        .AddParamPath('cod_item', 'C�digo do item')
          .Schema(SWAG_INTEGER)
        .&End
        .AddParamQuery('dat_ini', 'Data inicial (YYYY-MM-DD)')
          .Schema(SWAG_STRING)
          .Required(True)
        .&End
        .AddParamQuery('dat_fim', 'Data final (YYYY-MM-DD)')
          .Schema(SWAG_STRING)
          .Required(True)
        .&End
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelEntityEstoqueMovimento).IsArray(True).&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/estoque/{cod_item}/acerto-de-estoque')
    .Tag('Estoque')
      .POST('Realizar acerto de estoque')
        .Description('Defini o saldo atual do item')
        .AddParamPath('cod_item', 'C�digo do item')
          .Schema(SWAG_INTEGER)
        .&End
        .AddParamBody('Body')
          .Schema(TLojaModelDtoReqEstoqueAcertoEstoque)
        .&End
        .AddResponse(Integer(THTTPStatus.Created)).Schema(TLojaModelEntityEstoqueMovimento).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End
end;

end.
