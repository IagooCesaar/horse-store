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
    function ObterVendas(ADatInclIni, ADatInclFim: TDate;
      ACodSit: TLojaModelEntityVendaSituacao): TLojaModelEntityVendaVendaLista;

    function ObterVenda(ANumVnda: Integer): TLojaModelEntityVendaVenda;

    function NovaVenda(ANovaVenda: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;

    function AtualizarVenda(AVenda: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;
  end;

implementation

uses
  Database.Factory,
  Horse.Commons,

  System.Math,
  System.StrUtils;


{ TLojaModelDaoVendaVenda }

function TLojaModelDaoVendaVenda.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityVendaVenda;
begin
  Result := TLojaModelEntityVendaVenda.Create;
  Result.NumVnda := ds.FieldByName('num_vnda').AsInteger;
  Result.CodSit := TLojaModelEntityVendaSituacao.Create(ds.FieldByName('cod_sit').AsString);
  Result.DatIncl := ds.FieldByName('dat_incl').AsDateTime;
  Result.DatConcl := ds.FieldByName('dat_concl').AsDateTime;
  Result.VrBruto := ds.FieldByName('vr_bruto').AsCurrency;
  Result.VrDesc := ds.FieldByName('vr_desc').AsCurrency;
  Result.VrTotal := ds.FieldByName('vr_total').AsCurrency
end;

function TLojaModelDaoVendaVenda.AtualizarVenda(
  AVenda: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;
begin
  Result := nil;

  var LSql := #13#10
  + 'update venda '
  + 'set cod_sit = :cod_sit, '
  + '   dat_incl = :dat_incl, '
  + '   dat_concl = :dat_concl, '
  + '   vr_bruto = :vr_bruto, '
  + '   vr_desc = :vr_desc, '
  + '   vr_total = :vr_total '
  + 'where num_vnda = :num_vnda '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('num_vnda', AVenda.NumVnda)
      .AddString('cod_sit', AVenda.CodSit.ToString)
      .AddDateTime('dat_incl', AVenda.DatIncl)
      .AddDateTime('dat_concl', Variant(AVenda.DatConcl))
      .AddFloat('vr_bruto', Double(AVenda.VrBruto))
      .AddFloat('vr_desc', AVenda.VrDesc)
      .AddFloat('vr_total', AVenda.VrTotal)
      .&End
    .ExecSQL();

  Result := ObterVenda(AVenda.NumVnda);
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

function TLojaModelDaoVendaVenda.NovaVenda(
  ANovaVenda: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;
begin
  var LID := TDatabaseFactory.New.SQL.GeraProximoCodigo('GEN_VENDA_ID');

  var LSql := #13#10
  + 'insert into venda (num_vnda, cod_sit, dat_incl, vr_bruto, vr_desc, vr_total) '
  + 'values (:num_vnda, :cod_sit, :dat_incl, :vr_bruto, :vr_desc, :vr_total) '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('num_vnda', LID)
      .AddString('cod_sit', ANovaVenda.CodSit.ToString)
      .AddDateTime('dat_incl', ANovaVenda.DatIncl)
      .AddFloat('vr_bruto', ANovaVenda.VrBruto)
      .AddFloat('vr_desc', ANovaVenda.VrDesc)
      .AddFloat('vr_total', ANovaVenda.VrTotal)
      .&End
    .ExecSQL();

  Result := ObterVenda(LID);
end;

function TLojaModelDaoVendaVenda.ObterVenda(
  ANumVnda: Integer): TLojaModelEntityVendaVenda;
begin
  Result := nil;

  var LSql := #13#10
  + 'select * from venda where num_vnda = :num_vnda '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('num_vnda', ANumVnda)
      .&End
    .Open();

  if ds.IsEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

function TLojaModelDaoVendaVenda.ObterVendas(ADatInclIni, ADatInclFim: TDate;
  ACodSit: TLojaModelEntityVendaSituacao): TLojaModelEntityVendaVendaLista;
begin
  Result := TLojaModelEntityVendaVendaLista.Create;

  var LSql := #13#10
  + 'select * from venda v '
  + 'where cast(v.dat_incl as date) between :dat_incl_ini and :dat_incl_fim '
  + '  and v.cod_sit = :cod_sit '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddDateTime('dat_incl_ini', ADatInclIni)
      .AddDateTime('dat_incL_fim', ADatInclFim)
      .AddString('cod_sit', ACodSit.ToString)
      .&End
    .Open;

  while not ds.Eof
  do begin
    Result.Add(AtribuiCampos(ds));
    ds.Next;
  end;
end;

end.
