unit Loja.Model.Dao.Itens.Item;

interface

uses
  System.Classes,
  System.Variants,
  System.Generics.Collections,
  Data.DB,

  Loja.Model.Dao.Itens.Interfaces,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem;

type
  TLojaModelDaoItensItem = class(TInterfacedObject, ILojaModelDaoItensItem)
  private
    function AtribuiCampos(ds: TDataSet): TLojaModelEntityItensItem;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelDaoItensItem;

    { ILojaModelDaoItensItem }
    function ObterPorCodigo(ACodItem: Integer): TLojaModelEntityItensItem;
    function ObterPorNumCodBarr(ANumCodBarr: string): TLojaModelEntityItensItem;
    function CriarItem(ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
  end;

implementation

uses
  Database.Factory;

{ TLojaModelDaoItensItem }

function TLojaModelDaoItensItem.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityItensItem;
begin
  Result := TLojaModelEntityItensItem.Create;
  Result.CodItem := ds.FieldByName('cod_item').AsInteger;
  Result.NomItem := ds.FieldByName('nom_item').AsString;
  Result.NumCodBarr := ds.FieldByName('num_cod_barr').AsString;
end;

constructor TLojaModelDaoItensItem.Create;
begin

end;

function TLojaModelDaoItensItem.CriarItem(
  ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
begin
  Result := nil;
  var Lid := TDatabaseFactory.New.SQL
    .GeraProximoCodigo('GEN_ITEM_ID');

  TDatabaseFactory.New.SQL
    .SQL(
      'insert into item (cod_item, nom_item, num_cod_barr) '+
      'values (:cod_item, :nom_item, :num_cod_barr) ')
    .ParamList
      .AddInteger('cod_item', Lid)
      .AddString('nom_item', ANovoItem.NomItem)
      .AddString('num_cod_barr', Variant(ANovoItem.NumCodBarr))
      .&End
    .ExecSQL();

  Result := ObterPorCodigo(LId);
end;

destructor TLojaModelDaoItensItem.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoItensItem.New: ILojaModelDaoItensItem;
begin
  Result := Self.Create;
end;

function TLojaModelDaoItensItem.ObterPorCodigo(
  ACodItem: Integer): TLojaModelEntityItensItem;
begin
  Result := nil;

  var LSQL := 'select * from ITEM where cod_item = :cod_item';
  var ds := TDatabaseFactory.New
    .SQL
    .SQL(LSQL)
    .ParamList
      .AddInteger('cod_item', ACodItem)
      .&End
    .Open;

  if ds.isEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

function TLojaModelDaoItensItem.ObterPorNumCodBarr(
  ANumCodBarr: string): TLojaModelEntityItensItem;
begin
  Result := nil;

  var LSQL := 'select * from ITEM where num_cod_barr = :num_cod_barr';
  var ds := TDatabaseFactory.New
    .SQL
    .SQL(LSQL)
    .ParamList
      .AddString('cod_item', ANumCodBarr)
      .&End
    .Open;

  if ds.isEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

end.
