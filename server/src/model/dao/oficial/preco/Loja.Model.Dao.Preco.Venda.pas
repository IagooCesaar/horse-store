unit Loja.Model.Dao.Preco.Venda;

interface

uses
  Data.DB,
  Loja.Model.Dao.Preco.Interfaces,
  Loja.Model.Entity.Preco.Venda;

type
  TLojaModelDaoPrecoVenda = class(TInterfacedObject, ILojaModelDaoPrecoVenda)
  private
    function AtribuiCampos(ds: TDataSet): TLojaModelEntityPrecoVenda;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoPrecoVenda;

    { ILojaModelDaoPrecoVenda }

  end;

implementation

{ TLojaModelDaoPrecoVenda }

function TLojaModelDaoPrecoVenda.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityPrecoVenda;
begin
  Result := TLojaModelEntityPrecoVenda.Create;
  Result.CodItem := ds.FieldByName('cod_item').AsInteger;
  Result.DatIni := ds.FieldByName('dat_ini').AsDateTime;
  Result.VrVnda := ds.FieldByName('vr_vnda').AsFloat;
end;

constructor TLojaModelDaoPrecoVenda.Create;
begin

end;

destructor TLojaModelDaoPrecoVenda.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoPrecoVenda.New: ILojaModelDaoPrecoVenda;
begin
  Result := Self.Create;
end;

end.
