unit Loja.Model.Dao.Estoque.Saldo;

interface

uses
  System.Classes,
  System.Variants,
  System.Generics.Collections,
  Data.DB,

  Loja.Model.Dao.Estoque.Interfaces,
  Loja.Model.Entity.Estoque.Saldo;

type
  TLojaModelDaoEstoqueSaldo = class(TInterfacedObject, ILojaModelDaoEstoqueSaldo)
  private
    function AtribuiCampos(ds: TDataSet): TLojaModelEntityEstoqueSaldo;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelDaoEstoqueSaldo;

    { ILojaModelDaoEstoqueSaldo }

  end;

implementation

{ TLojaModelDaoEstoqueSaldo }

function TLojaModelDaoEstoqueSaldo.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityEstoqueSaldo;
begin
  Result := TLojaModelEntityEstoqueSaldo.Create;
  Result.CodFechSaldo := ds.FieldByName('cod_fech_saldo').AsInteger;
  Result.CodItem := ds.FieldByName('cod_item').AsInteger;
  Result.DatSaldo := ds.FieldByName('dat_saldo').AsDateTime;
end;

constructor TLojaModelDaoEstoqueSaldo.Create;
begin

end;

destructor TLojaModelDaoEstoqueSaldo.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoEstoqueSaldo.New: ILojaModelDaoEstoqueSaldo;
begin
  Result := Self.Create;
end;

end.
