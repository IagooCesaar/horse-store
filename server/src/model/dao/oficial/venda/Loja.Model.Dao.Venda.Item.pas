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

end.
