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
    except
      raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(C_UnitName)
        .Error('O body não estava no formato esperado');
    end;

    var LMovimento := TLojaModelFactory.New
      .Estoque
      .CriarAcertoEstoque(LDto);

    Resp.Status(THTTPStatus.Created).Send(TJSON.ObjectToClearJsonObject(LMovimento));
    LMovimento.Free;
  finally
    if Assigned(LDto)
    then FreeAndNil(LDto);
  end;
end;

(*
procedure ObterItens(Req: THorseRequest; Resp: THorseResponse);
var
  LLhsBracketType: TLhsBracketsType;
  LFiltros: TLojaModelDtoReqItensFiltroItens;
  LItens : TLojaModelEntityItensItemLista;
begin
  THorseCoreParamConfig.GetInstance.CheckLhsBrackets(True);

  try
    LFiltros := TLojaModelDtoReqItensFiltroItens.Create;
    LFiltros.CodItem := Req.Query.Field('cod_item').AsInteger;

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

    LItens := TLojaModelFactory.New
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
  try
    try
      LDto := TJson.ClearJsonAndConvertToObject
        <TLojaModelDtoReqItensCriarItem>(Req.Body);
    except
      raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(C_UnitName)
        .Error('O body não estava no formato esperado');
    end;

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
*)


procedure Registry(const AContext: string);
begin
  THorse.Group.Prefix(AContext+'/estoque')
    .Post('/acerto-estoque', CriarAcertoEstoque)
end;

procedure ConfigSwagger(const AContext: string);
begin

end;

end.
