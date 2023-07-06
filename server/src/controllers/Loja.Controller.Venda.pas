unit Loja.Controller.Venda;

interface

uses
  Horse,
  Horse.Commons,
  Horse.JsonInterceptor.Helpers;

procedure Registry(const AContext: string);
procedure ConfigSwagger;

const C_UnitName = 'Loja.Controller.Venda';

implementation

uses
  System.SysUtils,
  GBSwagger.Model.Interfaces,

  Loja.Model.Factory,
  Loja.Model.Entity.Venda.Venda,
  Loja.Model.Dto.Resp.Venda.Item,
  Loja.Model.Entity.Venda.MeioPagto,

  Loja.Model.Dto.Req.Venda.EfetivaVenda,
  Loja.Model.Dto.Req.Venda.MeioPagto,
  Loja.Model.Dto.Req.Venda.Item;

procedure GetVendas(Req: THorseRequest; Resp: THorseResponse);
begin
  var LDatInclIni := Req.Params.Field('dat_incl_ini')
    .Required
    .RequiredMessage('O filtro de data de inclus�o inicial � obrigat�rio')
    .InvalidFormatMessage('O valor informado n�o � uma data v�lida')
    .AsDate;

  var LDatInclFim := Req.Params.Field('dat_incl_fim')
    .Required
    .RequiredMessage('O filtro de data de inclus�o final � obrigat�rio')
    .InvalidFormatMessage('O valor informado n�o � uma data v�lida')
    .AsDate;

  var LFlgApenasEfet := Req.Params.Field('flg_apenas_efet')
    .InvalidFormatMessage('O valor informado n�o � um booleano v�lido')
    .AsBoolean;

  var LVendas := TLojaModelFactory.New.Venda.ObterVendas(LDatInclIni, LDatInclFim, LFlgApenasEfet);

  if LVendas.Count = 0
  then Resp.Status(THTTPStatus.NoContent)
  else Resp.Send(TJson.ObjectToClearJsonValue(LVendas)).Status(THTTPStatus.OK);

  LVendas.Free;
end;

procedure PostIniciarVenda(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure GetVenda(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure PatchEfetivarVenda(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure PatchCancelarVenda(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure GetItensVenda(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure PostInserirItem(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure PutAtualizarItem(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure GetMeiosPagtoVenda(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure PostMeiosPagtoVenda(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure PutMeiosPagtoVenda(Req: THorseRequest; Resp: THorseResponse);
begin

end;

procedure Registry(const AContext: string);
begin
  ConfigSwagger;

  THorse.Group.Prefix(AContext+'/venda')
    .Get('/', GetVendas)
    .Post('/', PostIniciarVenda)
    .Get('/:num_vnda', GetVenda)
    .Patch('/:num_vnda/efetivar', PatchEfetivarVenda)
    .Patch('/:num_vnda/cancelar', PatchCancelarVenda)

    .Get('/:num_vnda/itens', GetItensVenda)
    .Post('/:num_vnda/itens', PostInserirItem)
    .Put('/:num_vnda/itens/:num_seq_item', PutAtualizarItem)

    .Get('/venda/:num_vnda/meios-pagamento', GetMeiosPagtoVenda)
    .Post('/venda/:num_vnda/meios-pagamento', PostMeiosPagtoVenda)
    .Put('/venda/:num_vnda/meios-pagamento', PutMeiosPagtoVenda)
  ;
end;

procedure ConfigSwagger;
begin
  Swagger
    .Path('/venda')
    .Tag('Venda')
      .GET('Obt�m lista de vendas')
        .Description('Obt�m uma lista de vendas que ocorreram em determinado per�odo')
        .AddParamQuery('dat_incl_ini', 'Data inclus�o inicial')
          .Schema(SWAG_STRING, 'date')
          .Required(True)
        .&End
        .AddParamQuery('dat_incl_fim', 'Data inclus�o final')
          .Schema(SWAG_STRING, 'date')
          .Required(True)
        .&End
        .AddParamQuery('flg_apenas_efet', 'Apenas vendas efetivadas')
          .Schema('boolean')
          .Required(True)
        .&End
        .AddResponse(Integer(THTTPStatus.OK))
          .Schema(TLojaModelEntityVendaVenda)
          .IsArray(True)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/venda')
    .Tag('Venda')
      .POST('Iniciar uma nova venda')
        .Description('Inicia uma nova venda')
        .AddResponse(Integer(THTTPStatus.Created))
          .Schema(TLojaModelEntityVendaVenda)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/venda/{num_vnda}')
    .Tag('Venda')
      .GET('Obt�m dados de uma venda por c�digo')
        .Description('Obt�m dados de uma venda por c�digo')
        .AddParamPath('num_vnda', 'C�digo identificador da venda')
          .Schema(SWAG_INTEGER)
          .Required(True)
        .&End
        .AddResponse(Integer(THTTPStatus.OK))
          .Schema(TLojaModelEntityVendaVenda)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/venda/{num_vnda}/efetivar')
    .Tag('Venda')
      .PATCH('Efetiva��o da venda')
        .Description('Encerra o ciclo da venda efetivando-a. Permite informar desconto geral.')
        .AddParamPath('num_vnda', 'C�digo identificador da venda')
          .Schema(SWAG_INTEGER)
          .Required(True)
        .&End
        .AddParamBody('body')
          .Schema(TLojaModelDtoReqVendaEfetivaVenda)
        .&End
        .AddResponse(Integer(THTTPStatus.OK))
          .Schema(TLojaModelEntityVendaVenda)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/venda/{num_vnda}/cancelar')
    .Tag('Venda')
      .PATCH('Cancelamento da venda')
        .Description('Encerra o ciclo da venda cancelando-a')
        .AddParamPath('num_vnda', 'C�digo identificador da venda')
          .Schema(SWAG_INTEGER)
          .Required(True)
        .&End
        .AddResponse(Integer(THTTPStatus.OK))
          .Schema(TLojaModelEntityVendaVenda)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/venda/{num_vnda}/itens')
    .Tag('Venda')
      .GET('Itens da venda')
        .Description('Rela��o de itens da venda')
        .AddParamPath('num_vnda', 'C�digo identificador da venda')
          .Schema(SWAG_INTEGER)
          .Required(True)
        .&End
        .AddResponse(Integer(THTTPStatus.OK))
          .Schema(TLojaModelDtoRespVendaItem)
          .IsArray(True)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/venda/{num_vnda}/itens')
    .Tag('Venda')
      .POST('Insere um novo item na venda')
        .Description('Insere um novo item na venda')
        .AddParamPath('num_vnda', 'C�digo identificador da venda')
          .Schema(SWAG_INTEGER)
          .Required(True)
        .&End
        .AddParamBody('body')
          .Schema(TLojaModelDtoReqVendaItem)
        .&End
        .AddResponse(Integer(THTTPStatus.Created))
          .Schema(TLojaModelDtoRespVendaItem)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/venda/{num_vnda}/itens/{num_seq_item}')
    .Tag('Venda')
      .PUT('Atualiza informa��es do item na venda')
        .Description('Atualiza informa��es do item na venda')
        .AddParamPath('num_vnda', 'C�digo identificador da venda')
          .Schema(SWAG_INTEGER)
          .Required(True)
        .&End
        .AddParamPath('num_seq_item', 'C�digo sequencial do item na venda')
          .Schema(SWAG_INTEGER)
          .Required(True)
        .&End
        .AddParamBody('body')
          .Schema(TLojaModelDtoReqVendaItem)
        .&End
        .AddResponse(Integer(THTTPStatus.OK))
          .Schema(TLojaModelDtoRespVendaItem)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/venda/{num_vnda}/meios-pagamento')
    .Tag('Venda')
      .GET('Meios de Pagamento')
        .Description('Valores pagos pelo cliente distribu�dos por meio de pagamento')
        .AddParamPath('num_vnda', 'C�digo identificador da venda')
          .Schema(SWAG_INTEGER)
          .Required(True)
        .&End
        .AddResponse(Integer(THTTPStatus.OK))
          .Schema(TLojaModelEntityVendaMeioPagto)
          .IsArray(True)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/venda/{num_vnda}/meios-pagamento')
    .Tag('Venda')
      .POST('Criar rela��o de Meios de Pagamento')
        .Description('Defini a distribui��o do valor da venda entre os meios de pagamento configurados')
        .AddParamPath('num_vnda', 'C�digo identificador da venda')
          .Schema(SWAG_INTEGER)
          .Required(True)
        .&End
        .AddParamBody('body')
          .Schema(TLojaModelDtoReqVendaMeioPagamento)
          .IsArray(True)
        .&End
        .AddResponse(Integer(THTTPStatus.Created))
          .Schema(TLojaModelEntityVendaMeioPagto)
          .IsArray(True)
        .&End
        .AddResponse(Integer(THTTPStatus.NoContent)).&End
        .AddResponse(Integer(THTTPStatus.BadRequest)).&End
        .AddResponse(Integer(THTTPStatus.NotFound)).&End
        .AddResponse(Integer(THTTPStatus.PreconditionFailed)).&End
        .AddResponse(Integer(THTTPStatus.InternalServerError)).&End
      .&End
    .&End

    .Path('/venda/{num_vnda}/meios-pagamento')
    .Tag('Venda')
      .PUT('Atualiza toda a rela��o de Meios de Pagamento')
        .Description('Atualiza toda a distribui��o do valor da venda entre os meios de pagamento configurados')
        .AddParamPath('num_vnda', 'C�digo identificador da venda')
          .Schema(SWAG_INTEGER)
          .Required(True)
        .&End
        .AddParamBody('body')
          .Schema(TLojaModelDtoReqVendaMeioPagamento)
          .IsArray(True)
        .&End
        .AddResponse(Integer(THTTPStatus.OK))
          .Schema(TLojaModelEntityVendaMeioPagto)
          .IsArray(True)
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
