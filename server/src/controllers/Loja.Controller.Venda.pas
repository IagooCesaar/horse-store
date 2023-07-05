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

procedure Registry(const AContext: string);
begin

  ConfigSwagger;
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
