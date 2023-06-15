unit Loja.Model.Dao.Preco.Factory;

interface

uses
  Loja.Model.Dao.Preco.Interfaces;

type
  TLojaModelDaoPrecoFactory = class(TInterfacedObject, ILojaModelDaoPrecoFactory)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoPrecoFactory;

    { ILojaModelDaoPrecoFactory }
    function Venda: ILojaModelDaoPrecoVenda;
  end;

implementation

{ TLojaModelDaoPrecoFactory }

constructor TLojaModelDaoPrecoFactory.Create;
begin

end;

destructor TLojaModelDaoPrecoFactory.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoPrecoFactory.New: ILojaModelDaoPrecoFactory;
begin
  Result := Self.Create;
end;

function TLojaModelDaoPrecoFactory.Venda: ILojaModelDaoPrecoVenda;
begin

end;

end.
