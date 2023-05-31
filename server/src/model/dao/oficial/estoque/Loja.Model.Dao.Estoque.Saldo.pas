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
    function ObterUltimoFechamentoItem(ACodItem: Integer): TLojaModelEntityEstoqueSaldo;
    function ObterFechamentoItem(ACodItem: Integer; ADatSaldo: TDateTime): TLojaModelEntityEstoqueSaldo;
    function CriarFechamentoSaldoItem(ACodItem: Integer; ADatSaldo: TDateTime; AQtdSaldo: Integer):TLojaModelEntityEstoqueSaldo;

  end;

implementation

uses
  Database.Factory,
  Horse.Commons;

{ TLojaModelDaoEstoqueSaldo }

function TLojaModelDaoEstoqueSaldo.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityEstoqueSaldo;
begin
  Result := TLojaModelEntityEstoqueSaldo.Create;
  Result.CodFechSaldo := ds.FieldByName('cod_fech_saldo').AsInteger;
  Result.CodItem := ds.FieldByName('cod_item').AsInteger;
  Result.DatSaldo := ds.FieldByName('dat_saldo').AsDateTime;
  Result.QtdSaldo := ds.FieldByName('qtd_saldo').AsInteger;
end;

constructor TLojaModelDaoEstoqueSaldo.Create;
begin

end;

function TLojaModelDaoEstoqueSaldo.CriarFechamentoSaldoItem(ACodItem: Integer;
  ADatSaldo: TDateTime; AQtdSaldo: Integer): TLojaModelEntityEstoqueSaldo;
begin
  Result := nil;

  var LId := TDatabaseFactory.New.SQL
    .GeraProximoCodigo('GEN_ESTOQUE_SALDO_ID');

  TDatabaseFactory.New.SQL
    .SQL(
      'insert into estoque_saldo (cod_fech_saldo, cod_item, dat_saldo, qtd_saldo) '+
      'values (:cod_fech_saldo, :cod_item, :dat_saldo, :qtd_saldo) '
    )
    .ParamList
      .AddInteger('cod_fech_saldo', LId)
      .AddInteger('cod_item', ACodItem)
      .AddDateTime('dat_saldo', ADatSaldo)
      .AddInteger('qtd_saldo', AQtdSaldo)
      .&End
    .ExecSQL;

  Result := ObterFechamentoItem(ACodItem, ADatSaldo);
end;

destructor TLojaModelDaoEstoqueSaldo.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoEstoqueSaldo.New: ILojaModelDaoEstoqueSaldo;
begin
  Result := Self.Create;
end;

function TLojaModelDaoEstoqueSaldo.ObterFechamentoItem(ACodItem: Integer;
  ADatSaldo: TDateTime): TLojaModelEntityEstoqueSaldo;
begin
  Result := nil;
  var LSql := #13#10
  + 'select es.* from estoque_saldo es where es.cod_item = :cod_item '
  + 'and es.dat_saldo = :dat_saldo '
  + 'order by es.dat_saldo desc '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('cod_item', ACodItem)
      .AddDateTime('dat_saldo', ADatSaldo)
      .&End
    .Open();

  if ds.IsEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

function TLojaModelDaoEstoqueSaldo.ObterUltimoFechamentoItem(
  ACodItem: Integer): TLojaModelEntityEstoqueSaldo;
begin
  Result := nil;
  var LSql := #13#10
  + 'select es.* from estoque_saldo es where es.cod_item = :cod_item '
  + 'and es.dat_saldo = (select max(esx.dat_saldo) from estoque_saldo esx '
  + '                    where esx.cod_item = es.cod_Item) '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('cod_item', ACodItem)
      .&End
    .Open();

  if ds.IsEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

end.
