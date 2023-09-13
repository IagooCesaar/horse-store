unit Loja.Model.Dao.Itens.Item;

interface

uses
  System.Classes,
  System.Variants,
  System.Generics.Collections,
  Data.DB,

  Loja.Model.Dao.Itens.Interfaces,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Itens.FiltroItens;

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
    function AtualizarItem(AItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
    function ObterItens(AFiltro: TLojaModelDtoReqItensFiltroItens): TLojaModelEntityItensItemLista;
  end;

implementation

uses
  Database.Factory,
  Horse.Commons;

{ TLojaModelDaoItensItem }

function TLojaModelDaoItensItem.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityItensItem;
begin
  Result := TLojaModelEntityItensItem.Create;
  Result.CodItem := ds.FieldByName('cod_item').AsInteger;
  Result.NomItem := ds.FieldByName('nom_item').AsString;
  Result.NumCodBarr := ds.FieldByName('num_cod_barr').AsString;
  Result.FlgPermSaldNeg := ds.FieldByName('flg_perm_sald_neg').AsString;
  Result.FlgTabPreco := ds.FieldByName('flg_tab_preco').AsString;
end;

function TLojaModelDaoItensItem.AtualizarItem(
  AItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
begin
  Result := nil;

  var LSql := #13#10
  + 'update item '
  + 'set nom_item = :nom_item, '
  + '    num_cod_barr = :num_cod_barr, '
  + '    flg_perm_sald_neg = :flg_perm_sald_neg, '
  + '    flg_tab_preco = :flg_tab_preco '
  + 'where (cod_item = :cod_item) '
  ;

  TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('cod_item', AItem.CodItem)
      .AddString('nom_item', AItem.NomItem)
      .AddString('num_cod_barr', Variant(AItem.NumCodBarr))
      .AddString('flg_perm_sald_neg', AItem.FlgPermSaldNeg)
      .AddString('flg_tab_preco', AItem.FlgTabPreco)
      .&End
    .ExecSQL();

  Result := ObterPorCodigo(AItem.CodItem);
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
      'insert into item (cod_item, nom_item, num_cod_barr, flg_perm_sald_neg, flg_tab_preco) '+
      'values (:cod_item, :nom_item, :num_cod_barr, :flg_perm_sald_neg, :flg_tab_preco) ')
    .ParamList
      .AddInteger('cod_item', Lid)
      .AddString('nom_item', ANovoItem.NomItem)
      .AddString('num_cod_barr', Variant(ANovoItem.NumCodBarr))
      .AddString('flg_perm_sald_neg', ANovoItem.FlgPermSaldNeg)
      .AddString('flg_tab_preco', ANovoItem.FlgTabPreco)
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

function TLojaModelDaoItensItem.ObterItens(
  AFiltro: TLojaModelDtoReqItensFiltroItens): TLojaModelEntityItensItemLista;
begin
  var LSql := #13#10
  + 'select * from ITEM i '
  + 'where 1=1 ';

  if AFiltro.NomItem <> ''
  then begin
    LSql := LSql +'  and i.nom_item like :nom_item ';
    case AFiltro.NomItemLhsBracketsType of
      TLhsBracketsType.Contains:
        AFiltro.NomItem := '%'+AFiltro.NomItem+'%';
      TLhsBracketsType.StartsWith:
        AFiltro.NomItem := AFiltro.NomItem+'%';
      TLhsBracketsType.EndsWith:
        AFiltro.NomItem := '%'+AFiltro.NomItem;
    else // Equals
      AFiltro.NomItem := AFiltro.NomItem;
    end;
  end;

  if AFiltro.NumCodBarr <> ''
  then begin
    LSql := LSql + '  and i.num_cod_barr like :num_cod_barr ';
    case AFiltro.NumCodBarrLhsBracketsType of
      TLhsBracketsType.Contains:
        AFiltro.NumCodBarr := '%'+AFiltro.NumCodBarr+'%';
      TLhsBracketsType.StartsWith:
        AFiltro.NumCodBarr := AFiltro.NumCodBarr+'%';
      TLhsBracketsType.EndsWith:
        AFiltro.NumCodBarr := '%'+AFiltro.NumCodBarr;
    else  // Equals
      AFiltro.NumCodBarr := AFiltro.NumCodBarr;
    end;
  end;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddString('nom_item', AFiltro.NomItem)
      .AddString('num_cod_barr', AFiltro.NumCodBarr)
      .&End
    .Open;

  Result := TLojaModelEntityItensItemLista.Create;
  while not ds.Eof do begin
    Result.Add(AtribuiCampos(ds));
    ds.Next;
  end;
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
      .AddString('num_cod_barr', ANumCodBarr)
      .&End
    .Open;

  if ds.isEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

end.
