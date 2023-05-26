unit Loja.Controller.Itens;

interface

uses
  Horse,
  Horse.JsonInterceptor.Helpers;

procedure Registry(const AContext: string);
procedure ConfigSwagger(const AContext: string);

const C_UnitName = 'Loja.Controller.Itens';

implementation

uses
  System.SysUtils,
  Loja.Model.Factory,
  Loja.Model.Dto.Req.Itens.CriarItem;

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

    Resp.Send(TJSON.ObjectToClearJsonObject(LItem));
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

procedure Registry(const AContext: string);
begin
  THorse.Group.Prefix(AContext+'/itens')
    .Post('/', CriarItem)
    .Get('/:cod_item', GetItemPorCodigo)
end;

procedure ConfigSwagger(const AContext: string);
begin

end;

end.
