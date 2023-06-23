unit Loja.Model.Dao.Caixa.Movimento;

interface

uses
  Data.DB,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Caixa.Interfaces,
  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Caixa.Movimento,
  Loja.Model.Dto.Req.Caixa.CriarMovimento;

type
  TLojaModelDaoCaixaMovimento = class(TInterfacedObject, ILojaModelDaoCaixaMovimento)
  private
    function AtribuiCampos(ds: TDataSet): TLojaModelEntityCaixaMovimento;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoCaixaMovimento;

    { ILojaModelDaoCaixaCaixa }
    function ObterMovimentoPorCodigo(ACodMov: Integer): TLojaModelEntityCaixaMovimento;
    function ObterMovimentoPorCaixa(ACodCaixa: Integer): TLojaModelEntityCaixaMovimentoLista;
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;

  end;

implementation

uses
  Database.Factory,
  Horse.Commons;

{ TLojaModelDaoCaixaCaixa }

function TLojaModelDaoCaixaMovimento.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityCaixaMovimento;
begin
  Result := TLojaModelEntityCaixaMovimento.Create;
  Result.CodMov := ds.FieldByName('cod_mov').AsInteger;
  Result.CodCaixa := ds.FieldByName('cod_caixa').AsInteger;
  Result.CodTipoMov := TLojaModelEntityCaixaTipoMovimento.Create(ds.FieldByName('cod_tipo_mov').AsString);
  Result.CodMeioPagto := TLojaModelEntityCaixaMeioPagamento.Create(ds.FieldByName('cod_meio_pagto').AsString);
  Result.CodOrigMov := TLojaModelEntityCaixaOrigemMovimento.Create(ds.FieldByName('cod_orig_mov').AsString);
  Result.VrMov := ds.FieldByName('vr_mov').AsFloat;
  Result.DatMov := ds.FieldByName('dat_mov').AsDateTime;
  Result.DscObs := ds.FieldByName('dsc_obs').AsString;
end;

constructor TLojaModelDaoCaixaMovimento.Create;
begin

end;

function TLojaModelDaoCaixaMovimento.CriarNovoMovimento(
  ANovoMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
begin
  Result := nil;
  var LId := TDatabaseFactory.New.SQL.GeraProximoCodigo('GEN_CAIXA_MOVIMENTO_ID');

  var LSql := #13#10
  + 'insert into caixa_movimento (cod_mov, cod_caixa, cod_tipo_mov, cod_meio_pagto, '
  + '  cod_orig_mov, vr_mov, dat_mov, dsc_obs) '
  + 'values (:cod_mov, :cod_caixa, :cod_tipo_mov, :cod_meio_pagto, '
  + '  :cod_orig_mov, :vr_mov, :dat_mov, :dsc_obs) '
  ;

  TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('cod_mov', LId)
      .AddInteger('cod_caixa', ANovoMovimento.CodCaixa)
      .AddString('cod_tipo_mov', ANovoMovimento.CodTipoMov.ToString)
      .AddString('cod_meio_pagto', ANovoMovimento.CodMeioPagto.ToString)
      .AddString('cod_orig_mov', ANovoMovimento.CodOrigMov.ToString)
      .AddFloat('vr_mov', ANovoMovimento.VrMov)
      .AddDateTime('dat_mov', ANovoMovimento.DatMov)
      .AddString('dsc_obs', ANovoMovimento.DscObs)
      .&End
    .ExecSQL;

  Result := ObterMovimentoPorCodigo(LId);
end;

destructor TLojaModelDaoCaixaMovimento.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoCaixaMovimento.New: ILojaModelDaoCaixaMovimento;
begin
  Result := Self.Create;
end;

function TLojaModelDaoCaixaMovimento.ObterMovimentoPorCaixa(
  ACodCaixa: Integer): TLojaModelEntityCaixaMovimentoLista;
begin
  Result := nil;

  var LSql := 'select * from caixa_movimento where cod_caixa = :cod_caixa';

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('cod_caixa', ACodCaixa)
      .&End
    .Open;

  Result := TLojaModelEntityCaixaMovimentoLista.Create;
  while not ds.Eof
  do begin
    Result.Add(AtribuiCampos(ds));
    ds.Next;
  end;
end;

function TLojaModelDaoCaixaMovimento.ObterMovimentoPorCodigo(
  ACodMov: Integer): TLojaModelEntityCaixaMovimento;
begin
  Result := nil;

  var LSql := 'select * from caixa_movimento where cod_mov = :cod_mov';

  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddInteger('cod_mov', ACodMov)
      .&End
    .Open;

  if ds.IsEmpty
  then Exit;

  Result := AtribuiCampos(ds);
end;

end.

