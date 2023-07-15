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
    function ObterMeiosPagtoVenda(ANumVnda: Integer): TLojaModelEntityVendaMeioPagtoLista;
    function ObterMeioPagtoVenda(ANumVnda, ANumSeqMeioPagto: Integer): TLojaModelEntityVendaMeioPagto;
    procedure RemoverMeiosPagtoVenda(ANumVnda: Integer);
    function InserirMeioPagto(ANovoMeioPagto: TLojaModelEntityVendaMeioPagto): TLojaModelEntityVendaMeioPagto;

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
  Result.VrTotal := ds.FieldByName('vr_total').AsCurrency;
end;

constructor TLojaModelDaoVendaMeioPagto.Create;
begin

end;

destructor TLojaModelDaoVendaMeioPagto.Destroy;
begin

  inherited;
end;

function TLojaModelDaoVendaMeioPagto.InserirMeioPagto(
  ANovoMeioPagto: TLojaModelEntityVendaMeioPagto): TLojaModelEntityVendaMeioPagto;
begin
  Result := nil;
  var LSql := #13#10
  + 'insert into venda_meio_pagto ( '
  + '  num_vnda, num_seq_meio_pagto, cod_meio_pagto, qtd_parc, vr_total) '
  + 'values ( '
  + '  :num_vnda, :num_seq_meio_pagto, :cod_meio_pagto, :qtd_parc, :vr_total) '
  ;
  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('num_vnda',ANovoMeioPagto.NumVnda)
      .AddInteger('num_seq_meio_pagto',ANovoMeioPagto.NumSeqMeioPagto)
      .AddString('cod_meio_pagto',ANovoMeioPagto.CodMeioPagto.ToString)
      .AddInteger('qtd_parc',ANovoMeioPagto.QtdParc)
      .AddFloat('vr_total',ANovoMeioPagto.VrTotal)
      .&End
    .ExecSQL();

  Result := ObterMeioPagtoVenda(ANovoMeioPagto.NumVnda, ANovoMeioPagto.NumSeqMeioPagto);
end;

class function TLojaModelDaoVendaMeioPagto.New: ILojaModelDaoVendaMeioPagto;
begin
  Result := Self.Create;
end;

function TLojaModelDaoVendaMeioPagto.ObterMeioPagtoVenda(ANumVnda,
  ANumSeqMeioPagto: Integer): TLojaModelEntityVendaMeioPagto;
begin
  Result := nil;
  var LSql := #13#10
  + 'select * '
  + 'from venda_meio_pagto '
  + 'where num_vnda = :num_vnda '
  + '  and num_seq_meio_pagto = :num_seq_meio_pagto '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('num_vnda', ANumVnda)
      .AddInteger('num_seq_meio_pagto', ANumSeqMeioPagto)
      .&End
    .Open;

  if ds.IsEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

function TLojaModelDaoVendaMeioPagto.ObterMeiosPagtoVenda(
  ANumVnda: Integer): TLojaModelEntityVendaMeioPagtoLista;
begin
  Result := TLojaModelEntityVendaMeioPagtoLista.Create;
  var LSql := #13#10
  + 'select * '
  + 'from venda_meio_pagto '
  + 'where num_vnda = :num_vnda '
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

procedure TLojaModelDaoVendaMeioPagto.RemoverMeiosPagtoVenda(
  ANumVnda: Integer);
begin
  var LSql := #13#10
  + 'delete from venda_meio_pagto where num_vnda = :num_vnda '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('num_vnda', ANumVnda)
      .&End
    .ExecSQL;
end;

end.
