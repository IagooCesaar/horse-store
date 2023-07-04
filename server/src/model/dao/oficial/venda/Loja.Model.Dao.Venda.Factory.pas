unit Loja.Model.Dao.Venda.Factory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Venda.Interfaces;

type
  TLojaModelDaoVendaFactory = class(TInterfacedObject, ILojaModelDaoVendaFactory)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoVendaFactory;

    { ILojaModelDaoVendaFactory }
    function Venda: ILojaModelDaoVendaVenda;
    function Item: ILojaModelDaoVendaItem;
    function MeioPagto: ILojaModelDaoVendaMeioPagto;
  end;

implementation

uses
  Loja.Model.Dao.Venda.MeioPagto,
  Loja.Model.Dao.Venda.Item,
  Loja.Model.Dao.Venda.Venda;

{ TLojaModelDaoVendaFactory }

constructor TLojaModelDaoVendaFactory.Create;
begin

end;

destructor TLojaModelDaoVendaFactory.Destroy;
begin

  inherited;
end;

function TLojaModelDaoVendaFactory.Item: ILojaModelDaoVendaItem;
begin
  Result := TLojaModelDaoVendaItem.New;
end;

function TLojaModelDaoVendaFactory.MeioPagto: ILojaModelDaoVendaMeioPagto;
begin
  Result := TLojaModelDaoVendaMeioPagto.New;
end;

class function TLojaModelDaoVendaFactory.New: ILojaModelDaoVendaFactory;
begin
  Result := Self.Create;
end;

function TLojaModelDaoVendaFactory.Venda: ILojaModelDaoVendaVenda;
begin
  Result := TLojaModelDaoVendaVenda.New;
end;

end.
