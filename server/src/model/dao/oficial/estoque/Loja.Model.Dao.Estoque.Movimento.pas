unit Loja.Model.Dao.Estoque.Movimento;

interface

uses
  System.Classes,
  System.Variants,
  System.Generics.Collections,
  Data.DB,

  Loja.Model.Dao.Estoque.Interfaces,
  Loja.Model.Entity.Estoque.Movimento,
  Loja.Model.Dto.Req.Estoque.CriarMovimento;

type
  TLojaModelDaoEstoqueMovimento = class(TInterfacedObject, ILojaModelDaoEstoqueMovimento)
  private
    function AtribuiCampos(ds: TDataSet): TLojaModelEntityEstoqueMovimento;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelDaoEstoqueMovimento;

    { ILojaModelDaoEstoqueMovimento }
    function ObterPorCodigo(ACodMov: Integer): TLojaModelEntityEstoqueMovimento;
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
  end;

implementation

uses
  Database.Factory,
  Horse.Commons,
  Loja.Model.Entity.Estoque.Types;

{ TLojaModelDaoEstoqueSaldo }

function TLojaModelDaoEstoqueMovimento.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityEstoqueMovimento;
begin
  Result := TLojaModelEntityEstoqueMovimento.Create;
  Result.CodMov := ds.FieldByName('cod_mov').AsInteger;
  Result.CodItem := ds.FieldByName('cod_item').AsInteger;
  Result.QtdMov := ds.FieldByName('qtd_mov').AsInteger;
  Result.DatMov := ds.FieldByName('dat_mov').AsDateTime;
  Result.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento(ds.FieldByName('cod_orig_mov').AsInteger);
  Result.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento(ds.FieldByName('cod_tipo_mov').AsInteger);
  Result.DscMot := ds.FieldByName('dsc_mot').AsString;
end;

constructor TLojaModelDaoEstoqueMovimento.Create;
begin

end;

function TLojaModelDaoEstoqueMovimento.CriarNovoMovimento(
  ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
begin
  Result := nil;

  var LId := TDatabaseFactory.New.SQL
    .GeraProximoCodigo('GEN_ESTOQUE_MOVIMENTO_ID');

  TDatabaseFactory.New.SQL
    .SQL(
      'insert into estoque_movimento (cod_mov, cod_item, qtd_mov, dat_mov, cod_tipo_mov, cod_orig_mov, dsc_mot) '+
      'values (:cod_mov, :cod_item, :qtd_mov, :dat_mov, :cod_tipo_mov, :cod_orig_mov, :dsc_mot) ')
    .ParamList
      .AddInteger('cod_mov', LId)
      .AddInteger('cod_item', ANovoMovimento.CodItem)
      .AddInteger('qtd_mov', ANovoMovimento.QtdMov)
      .AddDateTime('dat_mov', ANovoMovimento.DatMov)
      .AddString('cod_tipo_mov', ANovoMovimento.DscTipoMov)
      .AddString('cod_orig_mov', ANovoMovimento.DscTipoOrig)
      .AddString('num_cod_barr', Variant(ANovoMovimento.DscMot))
      .&End
    .ExecSQL();

  Result := ObterPorCodigo(LId);
end;

destructor TLojaModelDaoEstoqueMovimento.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoEstoqueMovimento.New: ILojaModelDaoEstoqueMovimento;
begin
  Result := Self.Create;
end;

function TLojaModelDaoEstoqueMovimento.ObterPorCodigo(
  ACodMov: Integer): TLojaModelEntityEstoqueMovimento;
begin
  Result := nil;

  var ds := TDatabaseFactory.New.SQL
    .SQL('select * from estoque_movimento where cod_mov = :cod_mov')
    .ParamList
      .AddInteger('cod_mov', ACodMov)
      .&End
    .Open;

  if ds.isEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

end.
