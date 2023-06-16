unit Loja.Model.Dao.Preco.Venda;

interface

uses
  Data.DB,
  Loja.Model.Dao.Preco.Interfaces,
  Loja.Model.Entity.Preco.Venda,
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda;

type
  TLojaModelDaoPrecoVenda = class(TInterfacedObject, ILojaModelDaoPrecoVenda)
  private
    function AtribuiCampos(ds: TDataSet): TLojaModelEntityPrecoVenda;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoPrecoVenda;

    { ILojaModelDaoPrecoVenda }
    function CriarPrecoVendaItem(ANovoPreco: TLojaModelDtoReqPrecoCriarPrecoVenda): TLojaModelEntityPrecoVenda;
    function ObterHistoricoPrecoVendaItem(ACodItem: Integer; ADatRef: TDateTime): TLojaModelEntityPrecoVendaLista;
    function ObterPrecoVendaVigente(ACodItem: Integer; ADatRef: TDateTime): TLojaModelEntityPrecoVenda;
    function ObterPrecoVendaAtual(ACodItem: Integer): TLojaModelEntityPrecoVenda;

  end;

implementation

uses
  System.SysUtils,
  Database.Factory,
  Horse.Commons;

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

function TLojaModelDaoPrecoVenda.CriarPrecoVendaItem(
  ANovoPreco: TLojaModelDtoReqPrecoCriarPrecoVenda): TLojaModelEntityPrecoVenda;
begin
  var LSql := #13#10
  + 'insert into preco_venda(cod_item, dat_ini, vr_vnda) '
  + 'values (:cod_item, :dat_ini, :vr_vnda) '
  ;

  TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('cod_item', ANovoPreco.CodItem)
      .AddDateTime('dat_ini', ANovoPreco.DatIni)
      .AddFloat('vr_vnda', ANovoPreco.VrVnda)
      .&End
    .ExecSQL;

  Result := TLojaModelEntityPrecoVenda.Create;
  Result.CodItem := ANovoPreco.CodItem;
  Result.DatIni := ANovoPreco.DatIni;
  Result.VrVnda := ANovoPreco.VrVnda;
end;

destructor TLojaModelDaoPrecoVenda.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoPrecoVenda.New: ILojaModelDaoPrecoVenda;
begin
  Result := Self.Create;
end;

function TLojaModelDaoPrecoVenda.ObterHistoricoPrecoVendaItem(ACodItem: Integer;
  ADatRef: TDateTime): TLojaModelEntityPrecoVendaLista;
begin
  Result := nil;
  var LSql := #13#10
  + 'select * from preco_venda pv '
  + 'where pv.cod_item = :cod_item '
  + '  and pv.dat_ini >= coalesce((select max(x.dat_ini) from preco_venda x '
  + '                              where x.cod_item = pv.cod_item '
  + '                                and x.dat_ini <= :dat_ref) '
  + '                              ,:dat_ref) '
  + 'order by pv.dat_ini '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('cod_item', ACodItem)
      .AddDateTime('dat_ref', ADatRef)
      .&End
    .Open();

  Result := TLojaModelEntityPrecoVendaLista.Create;
  while not ds.Eof
  do begin
    Result.Add(AtribuiCampos(ds));
    ds.Next;
  end;
end;

function TLojaModelDaoPrecoVenda.ObterPrecoVendaAtual(
  ACodItem: Integer): TLojaModelEntityPrecoVenda;
begin
  Result := ObterPrecoVendaVigente(ACodItem, Now);
end;

function TLojaModelDaoPrecoVenda.ObterPrecoVendaVigente(ACodItem: Integer;
  ADatRef: TDateTime): TLojaModelEntityPrecoVenda;
begin
  Result := nil;
  var LSql := #13#10
  + 'select * from preco_venda pv '
  + 'where pv.cod_item = :cod_item '
  + '  and pv.dat_ini = coalesce((select max(x.dat_ini) from preco_venda x '
  + '                             where x.cod_item = pv.cod_item '
  + '                               and x.dat_ini <= :dat_ref) '
  + '                             ,:dat_ref) '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('cod_item', ACodItem)
      .AddDateTime('dat_ref', ADatRef)
      .&End
    .Open();

  if ds.isEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

end.
