unit Loja.Model.Itens;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Itens.FiltroItens,
  Loja.Model.Dto.Resp.Itens.Item;

type
  TLojaModelItens = class(TInterfacedObject, ILojaModelItens)
  private
    function EntityToDTO(ASource: TLojaModelEntityItensItem): TLojaModelDtoRespItensItem; overload;
    function EntityToDTO(ASource: TLojaModelEntityItensItemLista): TLojaModelDtoRespItensItemLista; overload;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelItens;

    { ILojaModelItens }
    function ObterPorCodigo(ACodItem: Integer): TLojaModelDtoRespItensItem;
    function ObterPorNumCodBarr(ANumCodBarr: string): TLojaModelDtoRespItensItem;
    function ObterItens(AFiltro: TLojaModelDtoReqItensFiltroItens): TLojaModelDtoRespItensItemLista;
    function CriarItem(ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelDtoRespItensItem;
    function AtualizarItem(AItem: TLojaModelDtoReqItensCriarItem): TLojaModelDtoRespItensItem;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Factory;

{ TLojaModelItens }

function TLojaModelItens.AtualizarItem(
  AItem: TLojaModelDtoReqItensCriarItem): TLojaModelDtoRespItensItem;
const C_NOM_MIN = 4; C_NOM_MAX = 100; C_COD_BAR_MAX = 14;
begin
  if Length(AItem.NomItem) < C_NOM_MIN
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error(Format('O nome do item deverá ter no mínimo %d caracteres', [ C_NOM_MIN ]));

  if Length(AItem.NomItem) > C_NOM_MAX
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error(Format('O nome do item deverá ter no máximo %d caracteres', [ C_NOM_MAX ]));

  if Length(AItem.NumCodBarr) > C_COD_BAR_MAX
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error(Format('O código de barras deverá ter no máximo %d caracteres', [ C_NOM_MAX ]));

  var LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorCodigo(AItem.CodItem);

  if LItem = nil
  then raise EHorseException.New
      .Status(THTTPStatus.NotFound)
      .&Unit(Self.UnitName)
      .Error('Não foi possível encontrar o item pelo código informado');
  LItem.Free;

  if AItem.NumCodBarr <> ''
  then begin
    var LItemExiteCodBarr := TLojaModelDaoFactory.New.Itens.Item.ObterPorNumCodBarr(AItem.NumCodBarr);
    if (LItemExiteCodBarr <> nil) and (LItemExiteCodBarr.CodItem <> AItem.CodItem)
    then try
      raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(Self.UnitName)
        .Error('Já existe um item cadastrado com este código de barras');
    finally
      LItemExiteCodBarr.Free;
    end;
  end;

  if AItem.FlgPermSaldNeg = ''
  then AItem.FlgPermSaldNeg := 'S';

  if AItem.FlgTabPreco = ''
  then AItem.FlgTabPreco := 'S';

  Result := EntityToDTO(
    TLojaModelDaoFactory.New.Itens
      .Item
      .AtualizarItem(AItem)
    );
end;

constructor TLojaModelItens.Create;
begin

end;

function TLojaModelItens.CriarItem(
  ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelDtoRespItensItem;
const C_NOM_MIN = 4; C_NOM_MAX = 100; C_COD_BAR_MAX = 14;
begin
  if Length(ANovoItem.NomItem) < C_NOM_MIN
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error(Format('O nome do item deverá ter no mínimo %d caracteres', [ C_NOM_MIN ]));

  if Length(ANovoItem.NomItem) > C_NOM_MAX
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error(Format('O nome do item deverá ter no máximo %d caracteres', [ C_NOM_MAX ]));

  if Length(ANovoItem.NumCodBarr) > C_COD_BAR_MAX
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error(Format('O código de barras deverá ter no máximo %d caracteres', [ C_NOM_MAX ]));

  if ANovoItem.NumCodBarr <> ''
  then begin
    var LItem := TLojaModelDaoFactory.New.Itens.Item.ObterPorNumCodBarr(ANovoItem.NumCodBarr);
    if LItem <> nil
    then try
      raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(Self.UnitName)
        .Error('Já existe um item cadastrado com este código de barras');
    finally
      LItem.Free;
    end;
  end;

  if ANovoItem.FlgPermSaldNeg = ''
  then ANovoItem.FlgPermSaldNeg := 'S';

  if ANovoItem.FlgTabPreco = ''
  then ANovoItem.FlgTabPreco := 'S';

  Result := EntityToDTO(
    TLojaModelDaoFactory.New.Itens
      .Item
      .CriarItem(ANovoItem)
    );
end;

destructor TLojaModelItens.Destroy;
begin

  inherited;
end;

function TLojaModelItens.EntityToDTO(
  ASource: TLojaModelEntityItensItemLista): TLojaModelDtoRespItensItemLista;
begin
  Result := TLojaModelDtoRespItensItemLista.Create;
  for var LItem in ASource
  do Result.Add(EntityToDTO(LItem));
end;

function TLojaModelItens.EntityToDTO(
  ASource: TLojaModelEntityItensItem): TLojaModelDtoRespItensItem;
begin
  Result := TLojaModelDtoRespItensItem.Create;
  Result.CodItem := ASource.CodItem;
  Result.NomItem := ASource.NomItem;
  Result.NumCodBarr := ASource.NumCodBarr;
  Result.FlgPermSaldNeg := ASource.FlgPermSaldNeg = 'S';
  Result.FlgTabPreco := ASource.FlgTabPreco = 'S';
end;

class function TLojaModelItens.New: ILojaModelItens;
begin
  Result := Self.Create;
end;

function TLojaModelItens.ObterItens(
  AFiltro: TLojaModelDtoReqItensFiltroItens): TLojaModelDtoRespItensItemLista;
begin
  Result := nil;
  if  (Length(AFiltro.NomItem) = 0)
  and (Length(AFiltro.NumCodBarr) = 0)
  then raise EHorseException.New
      .Status(THTTPStatus.PreconditionRequired)
      .&Unit(Self.UnitName)
      .Error('Você deve informar um critério para filtro');

  Result := EntityToDTO(
    TLojaModelDaoFactory.New.Itens
      .Item
      .ObterItens(AFiltro)
    );
end;

function TLojaModelItens.ObterPorCodigo(
  ACodItem: Integer): TLojaModelDtoRespItensItem;
var LItem : TLojaModelEntityItensItem;
begin
  LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorCodigo(ACodItem);

  if LItem = nil
  then raise EHorseException.New
      .Status(THTTPStatus.NotFound)
      .&Unit(Self.UnitName)
      .Error('Não foi possível encontrar o item pelo código informado');

  Result := EntityToDTO(LItem);
end;

function TLojaModelItens.ObterPorNumCodBarr(
  ANumCodBarr: string): TLojaModelDtoRespItensItem;
begin
  var LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorNumCodBarr(ANumCodBarr);

  if not Assigned(LItem)
  then raise EHorseException.New
      .Status(THTTPStatus.NotFound)
      .&Unit(Self.UnitName)
      .Error('Não foi possível encontrar o item pelo código de barras informado');

  Result := EntityToDTO(LItem);
end;

end.
