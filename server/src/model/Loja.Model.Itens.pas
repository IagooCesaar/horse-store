unit Loja.Model.Itens;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Environment.Interfaces,
  Loja.Model.Interfaces,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Itens.FiltroItens,
  Loja.Model.Dto.Resp.Itens.Item;

type
  TLojaModelItens = class(TInterfacedObject, ILojaModelItens)
  private
    FEnvRules: ILojaEnvironmentRuler;
    function EntityToDTO(ASource: TLojaModelEntityItensItem): TLojaModelDtoRespItensItem; overload;
    function EntityToDTO(ASource: TLojaModelEntityItensItemLista): TLojaModelDtoRespItensItemLista; overload;
  public
    constructor Create(AEnvRules: ILojaEnvironmentRuler);
	  destructor Destroy; override;
	  class function New(AEnvRules: ILojaEnvironmentRuler): ILojaModelItens;

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
    .Error(Format('O nome do item dever� ter no m�nimo %d caracteres', [ C_NOM_MIN ]));

  if Length(AItem.NomItem) > C_NOM_MAX
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error(Format('O nome do item dever� ter no m�ximo %d caracteres', [ C_NOM_MAX ]));

  if Length(AItem.NumCodBarr) > C_COD_BAR_MAX
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error(Format('O c�digo de barras dever� ter no m�ximo %d caracteres', [ C_NOM_MAX ]));

  var LItem := TLojaModelDaoFactory.New(FEnvRules).Itens
    .Item
    .ObterPorCodigo(AItem.CodItem);

  if LItem = nil
  then raise EHorseException.New
      .Status(THTTPStatus.NotFound)
      .&Unit(Self.UnitName)
      .Error('N�o foi poss�vel encontrar o item pelo c�digo informado');
  LItem.Free;

  if AItem.NumCodBarr <> ''
  then begin
    var LItemExiteCodBarr := TLojaModelDaoFactory.New(FEnvRules).Itens.Item.ObterPorNumCodBarr(AItem.NumCodBarr);
    if (LItemExiteCodBarr <> nil) and (LItemExiteCodBarr.CodItem <> AItem.CodItem)
    then try
      raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(Self.UnitName)
        .Error('J� existe um item cadastrado com este c�digo de barras');
    finally
      LItemExiteCodBarr.Free;
    end;
  end;

  var LItemAtualizado := TLojaModelDaoFactory.New(FEnvRules).Itens
    .Item
    .AtualizarItem(AItem);

  Result := EntityToDTO(LItemAtualizado);
  LItemAtualizado.Free;
end;

constructor TLojaModelItens.Create(AEnvRules: ILojaEnvironmentRuler);
begin
  FEnvRules := AEnvRules;
end;

function TLojaModelItens.CriarItem(
  ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelDtoRespItensItem;
const C_NOM_MIN = 4; C_NOM_MAX = 100; C_COD_BAR_MAX = 14;
begin
  if Length(ANovoItem.NomItem) < C_NOM_MIN
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error(Format('O nome do item dever� ter no m�nimo %d caracteres', [ C_NOM_MIN ]));

  if Length(ANovoItem.NomItem) > C_NOM_MAX
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error(Format('O nome do item dever� ter no m�ximo %d caracteres', [ C_NOM_MAX ]));

  if Length(ANovoItem.NumCodBarr) > C_COD_BAR_MAX
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error(Format('O c�digo de barras dever� ter no m�ximo %d caracteres', [ C_NOM_MAX ]));

  if ANovoItem.NumCodBarr <> ''
  then begin
    var LItem := TLojaModelDaoFactory.New(FEnvRules).Itens.Item.ObterPorNumCodBarr(ANovoItem.NumCodBarr);
    if LItem <> nil
    then try
      raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(Self.UnitName)
        .Error('J� existe um item cadastrado com este c�digo de barras');
    finally
      LItem.Free;
    end;
  end;

  var LNovoItem := TLojaModelDaoFactory.New(FEnvRules).Itens
    .Item
    .CriarItem(ANovoItem);

  Result := EntityToDTO(LNovoItem);
  LNovoItem.Free;
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

class function TLojaModelItens.New(AEnvRules: ILojaEnvironmentRuler): ILojaModelItens;
begin
  Result := Self.Create(AEnvRules);
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
      .Error('Voc� deve informar um crit�rio para filtro');

  AFiltro.NomItem := AnsiUpperCase(AFiltro.NomItem);

  var LItens := TLojaModelDaoFactory.New(FEnvRules).Itens
    .Item
    .ObterItens(AFiltro);

  Result := EntityToDTO(LItens);
  LItens.Free;
end;

function TLojaModelItens.ObterPorCodigo(
  ACodItem: Integer): TLojaModelDtoRespItensItem;
var LItem : TLojaModelEntityItensItem;
begin
  LItem := TLojaModelDaoFactory.New(FEnvRules).Itens
    .Item
    .ObterPorCodigo(ACodItem);

  if LItem = nil
  then raise EHorseException.New
      .Status(THTTPStatus.NotFound)
      .&Unit(Self.UnitName)
      .Error('N�o foi poss�vel encontrar o item pelo c�digo informado');

  Result := EntityToDTO(LItem);
  LItem.Free;
end;

function TLojaModelItens.ObterPorNumCodBarr(
  ANumCodBarr: string): TLojaModelDtoRespItensItem;
begin
  var LItem := TLojaModelDaoFactory.New(FEnvRules).Itens
    .Item
    .ObterPorNumCodBarr(ANumCodBarr);

  if not Assigned(LItem)
  then raise EHorseException.New
      .Status(THTTPStatus.NotFound)
      .&Unit(Self.UnitName)
      .Error('N�o foi poss�vel encontrar o item pelo c�digo de barras informado');

  Result := EntityToDTO(LItem);
  LItem.Free;
end;

end.
