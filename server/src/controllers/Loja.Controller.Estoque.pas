unit Loja.Controller.Estoque;

interface

uses
  Horse,
  Horse.Commons,
  Horse.JsonInterceptor.Helpers;

procedure Registry(const AContext: string);
procedure ConfigSwagger(const AContext: string);

const C_UnitName = 'Loja.Controller.Estoque';

implementation

uses
  System.SysUtils,
  System.NetEncoding,
  Loja.Model.Factory,
  Loja.Model.Dto.Req.Estoque.AcertoEstoque,

  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Itens.FiltroItens;

procedure CriarAcertoEstoque(Req: THorseRequest; Resp: THorseResponse);
var LDto : TLojaModelDtoReqEstoqueAcertoEstoque;
begin
  try
    try
      LDto := TJson.ClearJsonAndConvertToObject
        <TLojaModelDtoReqEstoqueAcertoEstoque>(Req.Body);

      LDto.CodItem := Req.Params.Field('cod_item')
        .Required
        .RequiredMessage('O código do item é obrigatório')
        .InvalidFormatMessage('O valor fornecido não é um inteiro válido')
        .AsInteger;

    except
      raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(C_UnitName)
        .Error('O body não estava no formato esperado');
    end;

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
    .RequiredMessage('O código do item é obrigatório')
    .InvalidFormatMessage('O valor fornecido não é um inteiro válido')
    .AsInteger;

  LDatIni := Req.Query.Field('dat_ini')
    .Required
    .RequiredMessage('É obrigatório informar data inicial')
    .InvalidFormatMessage('O valor fornecido não é uma data válida')
    .AsDate;

  LDatFim := Req.Query.Field('dat_fim')
    .Required
    .RequiredMessage('É obrigatório informar data final')
    .InvalidFormatMessage('O valor fornecido não é uma data válida')
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
    .RequiredMessage('O código do item é obrigatório')
    .InvalidFormatMessage('O valor fornecido não é um inteiro válido')
    .AsInteger;

  var LSado := TLojaModelFactory.New
    .Estoque
    .ObterSaldoAtualItem(LCodItem);
  Resp.Status(THTTPStatus.Ok).Send(TJSON.ObjectToClearJsonValue(LSado));
  LSado.Free;
end;

procedure Registry(const AContext: string);
begin
  THorse.Group.Prefix(AContext+'/estoque')
    .Post('/:cod_item/acerto-de-estoque', CriarAcertoEstoque)
    .Get('/:cod_item/historico-movimento', ObterHistoricoMovimento)
    .Get('/:cod_item/saldo-atual', ObterSaldoAtual)
end;

procedure ConfigSwagger(const AContext: string);
begin

end;

end.
