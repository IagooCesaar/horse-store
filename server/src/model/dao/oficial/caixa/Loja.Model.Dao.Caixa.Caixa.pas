unit Loja.Model.Dao.Caixa.Caixa;

interface

uses
  Data.DB,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Caixa.Interfaces,
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Types;

type
  TLojaModelDaoCaixaCaixa = class(TInterfacedObject, ILojaModelDaoCaixaCaixa)
  private
    function AtribuiCampos(ds: TDataSet): TLojaModelEntityCaixaCaixa;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoCaixaCaixa;

    { ILojaModelDaoCaixaCaixa }
    function ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
    function ObterCaixaPorCodigo(ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
    function ObterUltimoCaixaFechado(ADatRef: TDateTime): TLojaModelEntityCaixaCaixa;
  end;

implementation

uses
  Database.Factory,
  Horse.Commons;

{ TLojaModelDaoCaixaCaixa }

function TLojaModelDaoCaixaCaixa.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityCaixaCaixa;
begin
  Result := TLojaModelEntityCaixaCaixa.Create;
  Result.CodCaixa := ds.FieldByName('cod_caixa').AsInteger;
  Result.CodSit := TLojaModelEntityCaixaSituacao.Create(ds.FieldByName('cod_sit').AsString);
  Result.DatAbert := ds.FieldByName('dat_abert').AsDateTime;
  Result.VrAbert := ds.FieldByName('vr_abert').AsFloat;
  Result.DatFecha := ds.FieldByName('dat_fecha').AsDateTime;
  Result.VrFecha := ds.FieldByName('vr_fecha').AsFloat;
end;

constructor TLojaModelDaoCaixaCaixa.Create;
begin

end;

destructor TLojaModelDaoCaixaCaixa.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoCaixaCaixa.New: ILojaModelDaoCaixaCaixa;
begin
  Result := Self.Create;
end;

function TLojaModelDaoCaixaCaixa.ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
begin
  Result := nil;
  var LSql := #13#10
  + 'select first 1 * from caixa '
  + 'where cod_sit = ''A'' '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .Open;

  if ds.IsEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

function TLojaModelDaoCaixaCaixa.ObterCaixaPorCodigo(
  ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
begin
  Result := nil;
  var LSql := #13#10
  + 'select * from caixa '
  + 'where cod_caixa = :cod_caixa '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('cod_caixa', ACodCaixa)
      .&End
    .Open;

  if ds.IsEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

function TLojaModelDaoCaixaCaixa.ObterUltimoCaixaFechado(
  ADatRef: TDateTime): TLojaModelEntityCaixaCaixa;
begin
  Result := nil;

  var LSql := #13#10
  + 'select first 1 * from caixa c '
  + 'where c.cod_sit = ''F'' '
  + '  and c.dat_fecha = (select max(x.dat_fecha) from caixa x '
  + '                     where x.cod_sit = c.cod_sit and x.dat_fecha <= :dat_ref) '
  ;

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('dat_ref', ADatRef)
      .&End
    .Open;

  if ds.IsEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

end.
