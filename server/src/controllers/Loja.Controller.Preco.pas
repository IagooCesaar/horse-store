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

  Loja.Model.Dto.Req.Preco.CriarPrecoVenda,
  Loja.Model.Entity.Preco.Venda;

procedure GetPrecoVendaAtual(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure GetHistoricoPrecoVenda(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure PostCriarPrecoVenda(Req: THorseRequest; Resp: THorseResponse);
begin

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
          .Required(True)
        .&End
        .Description('Obt�m o hist�rico de pre�o de venda de item praticado a partir da data de refer�ncia informada')
        .AddResponse(Integer(THTTPStatus.OK)).Schema(TLojaModelEntityPrecoVenda).IsArray(True).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End
end;

end.
