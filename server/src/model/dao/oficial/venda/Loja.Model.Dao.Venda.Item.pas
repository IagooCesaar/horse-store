unit Loja.Model.Dao.Venda.Item;

interface

uses
  Data.DB,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Venda.Interfaces,
  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Venda.Item;

type
  TLojaModelDaoVendaItem = class(TInterfacedObject, ILojaModelDaoVendaItem)
  private
    function AtribuiCampos(ds: TDataSet): TLojaModelEntityVendaItem;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoVendaItem;

    { ILojaModelDaoVendaItem }
    function ObterUltimoNumSeq(ANumVnda: Integer): Integer;
    function ObterItensVenda(ANumVnda: Integer): TLojaModelEntityVendaItemLista;
    function ObterItem(ANumVnda, ANumSeqItem: Integer): TLojaModelEntityVendaItem;
    function InserirItem(ANovoItem: TLojaModelEntityVendaItem): TLojaModelEntityVendaItem;
    function AtulizarItem(AItem: TLojaModelEntityVendaItem): TLojaModelEntityVendaItem;
  end;

implementation

uses
  Database.Factory,
  Horse.Commons;

{ TLojaModelDaoVendaItem }

function TLojaModelDaoVendaItem.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityVendaItem;
begin
  Result := TLojaModelEntityVendaItem.Create;
  Result.NumVnda := ds.FieldByName('num_vnda').AsInteger;
  Result.NumSeqItem := ds.FieldByName('num_seq_item').AsInteger;
  Result.CodItem := ds.FieldByName('cod_item').AsInteger;
  Result.CodSit := TLojaModelEntityVendaItemSituacao.Create(ds.FieldByName('cod_sit').AsString);
  Result.QtdItem := ds.FieldByName('qtd_item').AsInteger;
  Result.VrPrecoUnit := ds.FieldByName('vr_preco_unit').AsCurrency;
  Result.VrBruto := ds.FieldByName('vr_bruto').AsCurrency;
  Result.VrDesc := ds.FieldByName('vr_desc').AsCurrency;
  Result.VrTotal := ds.FieldByName('vr_total').AsCurrency;
end;

function TLojaModelDaoVendaItem.AtulizarItem(
  AItem: TLojaModelEntityVendaItem): TLojaModelEntityVendaItem;
begin
  Result := nil;
  var LSql := #13#10
  + 'update venda_item '
  + 'set cod_item = :cod_item, '
  + '    cod_sit = :cod_sit, '
  + '    qtd_item = :qtd_item, '
  + '    vr_preco_unit = :vr_preco_unit, '
  + '    vr_bruto = :vr_bruto, '
  + '    vr_desc = :vr_desc, '
  + '    vr_total = :vr_total '
  + 'where num_vnda = :num_vnda '
  + '  and num_seq_item = :num_seq_item '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('num_vnda', AItem.NumVnda)
      .AddInteger('num_seq_item', AItem.NumSeqItem)
      .AddInteger('cod_item', AItem.CodItem)
      .AddInteger('qtd_item', AItem.QtdItem)
      .AddFloat('vr_preco_unit', AItem.VrPrecoUnit)
      .AddFloat('vr_bruto', AItem.VrBruto)
      .AddFloat('vr_desc', AItem.VrDesc)
      .AddFloat('vr_total', AItem.VrTotal)
      .&End
    .ExecSQL();

  Result := ObterItem(AItem.NumVnda, AItem.NumSeqItem);
end;

constructor TLojaModelDaoVendaItem.Create;
begin

end;

destructor TLojaModelDaoVendaItem.Destroy;
begin

  inherited;
end;

function TLojaModelDaoVendaItem.InserirItem(
  ANovoItem: TLojaModelEntityVendaItem): TLojaModelEntityVendaItem;
begin
  Result := nil;
  var LSql := #13#10
  + 'insert into venda_item ( '
  + '  num_vnda, num_seq_item, cod_item, cod_sit, qtd_item, vr_preco_unit, '
  + '  vr_bruto, vr_desc, vr_total) '
  + 'values ( '
  + '  :num_vnda, :num_seq_item, :cod_item, :cod_sit, :qtd_item, :vr_preco_unit, '
  + '  :vr_bruto, :vr_desc, :vr_total) '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('num_vnda', ANovoItem.NumVnda)
      .AddInteger('num_seq_item', ANovoItem.NumSeqItem)
      .AddInteger('cod_item', ANovoItem.CodItem)
      .AddInteger('qtd_item', ANovoItem.QtdItem)
      .AddFloat('vr_preco_unit', ANovoItem.VrPrecoUnit)
      .AddFloat('vr_bruto', ANovoItem.VrBruto)
      .AddFloat('vr_desc', ANovoItem.VrDesc)
      .AddFloat('vr_total', ANovoItem.VrTotal)
      .&End
    .ExecSQL();

  Result := ObterItem(ANovoItem.NumVnda, ANovoItem.NumSeqItem);
end;

class function TLojaModelDaoVendaItem.New: ILojaModelDaoVendaItem;
begin
  Result := Self.Create;
end;

function TLojaModelDaoVendaItem.ObterItem(ANumVnda,
  ANumSeqItem: Integer): TLojaModelEntityVendaItem;
begin
  Result := nil;
  var LSql := #13#10
  + 'select * from venda_item vi '
  + 'where vi.num_vnda = :num_vnda '
  + '  and vi.num_seq_item = :num_seq_item '
  + 'order by vi.num_seq_item '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('num_vnda', ANumVnda)
      .AddInteger('num_seq_item', ANumSeqItem)
      .&End
    .Open;

  if ds.IsEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

function TLojaModelDaoVendaItem.ObterItensVenda(
  ANumVnda: Integer): TLojaModelEntityVendaItemLista;
begin
  Result := TLojaModelEntityVendaItemLista.Create;

  var LSql := #13#10
  + 'select * from venda_item vi '
  + 'where vi.num_vnda = :num_vnda '
  + 'order by vi.num_seq_item '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('num_vnda', ANumVnda)
      .&End
    .Open;

  while not ds.Eof
  do begin
    Result.Add(AtribuiCampos(ds));
    ds.Next;
  end;
end;

function TLojaModelDaoVendaItem.ObterUltimoNumSeq(ANumVnda: Integer): Integer;
begin
  Result := 0;
  var LSql := #13#10
  + 'select max(num_seq_item) as num_seq_item from venda_item where num_vnda = :num_vnda '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('num_vnda', ANumVnda)
      .&End
    .Open;
  if not ds.IsEmpty
  then Result := ds.FieldByName('num_seq_item').AsInteger;
end;

end.
