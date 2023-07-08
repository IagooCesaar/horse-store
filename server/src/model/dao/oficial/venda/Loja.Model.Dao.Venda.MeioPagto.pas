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
    function ObterUltimoNumSeq(ANumVnda: Integer): Integer;

  end;

implementation

uses
  Database.Factory,
  Horse.Commons;
{ TLojaModelDaoVendaMeioPagto }

function TLojaModelDaoVendaMeioPagto.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityVendaMeioPagto;
begin
  Result := TLojaModelEntityVendaMeioPagto.Create;
  Result.NumVnda := ds.FieldByName('num_vnda').AsInteger;
  Result.NumSeqMeioPagto := ds.FieldByName('num_seq_meio_pagto').AsInteger;
  Result.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.Create(ds.FieldByName('cod_meio_pagto').AsString);
  Result.QtdParc := ds.FieldByName('qtd_parc').AsInteger;
  Result.VrParc := ds.FieldByName('vr_parc').AsCurrency;
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

function TLojaModelDaoVendaMeioPagto.ObterUltimoNumSeq(
  ANumVnda: Integer): Integer;
begin
  Result := 0;
  var LSql := #13#10
  + 'select max(num_seq_meio_pagto) as num_seq_meio_pagto from venda_meio_pagto where num_vnda = :num_vnda '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('num_vnda', ANumVnda)
      .&End
    .Open;
  if not ds.IsEmpty
  then Result := ds.FieldByName('num_seq_meio_pagto').AsInteger;
end;

end.
