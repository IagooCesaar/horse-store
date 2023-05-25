unit Loja.Model.Dao.Itens.Item;

interface

uses
  System.Classes,
  System.Generics.Collections,
  Data.DB,

  Loja.Model.Dao.Itens.Interfaces,
  Loja.Model.Entity.Itens.Item;

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
