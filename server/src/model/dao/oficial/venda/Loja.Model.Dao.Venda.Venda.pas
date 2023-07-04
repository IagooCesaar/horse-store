unit Loja.Model.Dao.Venda.Venda;

interface

uses
  Data.DB,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Venda.Interfaces,
  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Venda.Venda;

type
  TLojaModelDaoVendaVenda = class(TInterfacedObject, ILojaModelDaoVendaVenda)
  private
    function AtribuiCampos(ds: TDataSet): TLojaModelEntityVendaVenda;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoVendaVenda;

    { ILojaModelDaoVendaVenda }

  end;

implementation

uses
  Database.Factory,
  Horse.Commons;


{ TLojaModelDaoVendaVenda }

function TLojaModelDaoVendaVenda.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityVendaVenda;
begin

end;

constructor TLojaModelDaoVendaVenda.Create;
begin

end;

destructor TLojaModelDaoVendaVenda.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoVendaVenda.New: ILojaModelDaoVendaVenda;
begin
  Result := Self.Create;
end;

end.
