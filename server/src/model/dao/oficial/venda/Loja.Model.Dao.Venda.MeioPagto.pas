unit Loja.Model.Dao.Venda.MeioPagto;

interface

uses
  Data.DB,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Venda.Interfaces,
  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Venda.MeioPagto;

type
  TLojaModelDaoVendaMeioPagto = class(TInterfacedObject, ILojaModelDaoVendaMeioPagto)
  private
    function AtribuiCampos(ds: TDataSet): TLojaModelEntityVendaMeioPagto;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoVendaMeioPagto;

    { ILojaModelDaoVendaMeioPagto }

  end;

implementation

uses
  Database.Factory,
  Horse.Commons;
{ TLojaModelDaoVendaMeioPagto }

function TLojaModelDaoVendaMeioPagto.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityVendaMeioPagto;
begin

end;

constructor TLojaModelDaoVendaMeioPagto.Create;
begin

end;

destructor TLojaModelDaoVendaMeioPagto.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoVendaMeioPagto.New: ILojaModelDaoVendaMeioPagto;
begin
  Result := Self.Create;
end;

end.
