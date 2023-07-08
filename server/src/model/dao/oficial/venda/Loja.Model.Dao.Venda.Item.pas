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

  end;

implementation

uses
  Database.Factory,
  Horse.Commons;

{ TLojaModelDaoVendaItem }

function TLojaModelDaoVendaItem.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityVendaItem;
begin

end;

constructor TLojaModelDaoVendaItem.Create;
begin

end;

destructor TLojaModelDaoVendaItem.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoVendaItem.New: ILojaModelDaoVendaItem;
begin
  Result := Self.Create;
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
