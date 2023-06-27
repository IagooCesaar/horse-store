unit Loja.Model.Dao.Caixa.Movimento.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Caixa.Interfaces,
  Loja.Model.Entity.Caixa.Movimento,
  Loja.Model.Dto.Req.Caixa.CriarMovimento;

type
  TLojaModelDaoCaixaMovimentoInMemory = class(TNoRefCountObject, ILojaModelDaoCaixaMovimento)
  private
    FRepository: TLojaModelEntityCaixaMovimentoLista;
    function Clone(ASource: TLojaModelEntityCaixaMovimento): TLojaModelEntityCaixaMovimento;

    class var FDao: TLojaModelDaoCaixaMovimentoInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoCaixaMovimento;
    class destructor UnInitialize;

    { ILojaModelDaoCaixaMovimento }
    function ObterMovimentoPorCodigo(ACodMov: Integer): TLojaModelEntityCaixaMovimento;
    function ObterMovimentoPorCaixa(ACodCaixa: Integer): TLojaModelEntityCaixaMovimentoLista;
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
  end;

implementation

{ TLojaModelDaoCaixaMovimentoInMemory }

function TLojaModelDaoCaixaMovimentoInMemory.Clone(
  ASource: TLojaModelEntityCaixaMovimento): TLojaModelEntityCaixaMovimento;
begin
  Result := TLojaModelEntityCaixaMovimento.Create;
  Result.CodMov := ASource.CodMov;
  Result.CodCaixa := ASource.CodCaixa;
  Result.CodTipoMov := ASource.CodTipoMov;
  Result.CodMeioPagto := ASource.CodMeioPagto;
  Result.CodOrigMov := ASource.CodOrigMov;
  Result.VrMov := ASource.VrMov;
  Result.DatMov := ASource.DatMov;
  Result.DscObs := ASource.DscObs;
end;

constructor TLojaModelDaoCaixaMovimentoInMemory.Create;
begin
  FRepository := TLojaModelEntityCaixaMovimentoLista.Create;
end;

function TLojaModelDaoCaixaMovimentoInMemory.CriarNovoMovimento(
  ANovoMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
var LId : Integer;
begin
  if FRepository.Count = 0
  then LId := 1
  else LID := FRepository.Last.CodMov + 1;

  FRepository.Add(TLojaModelEntityCaixaMovimento.Create);
  FRepository.Last.CodMov := LId;
  FRepository.Last.CodCaixa := ANovoMovimento.CodCaixa;
  FRepository.Last.CodTipoMov := ANovoMovimento.CodTipoMov;
  FRepository.Last.CodMeioPagto := ANovoMovimento.CodMeioPagto;
  FRepository.Last.CodOrigMov := ANovoMovimento.CodOrigMov;
  FRepository.Last.VrMov := ANovoMovimento.VrMov;
  FRepository.Last.DatMov := ANovoMovimento.DatMov;
  FRepository.Last.DscObs := ANovoMovimento.DscObs;

  Result := Clone(FRepository.Last);
end;

destructor TLojaModelDaoCaixaMovimentoInMemory.Destroy;
begin
  FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoCaixaMovimentoInMemory.GetInstance: ILojaModelDaoCaixaMovimento;
begin
  if FDao = nil
  then FDao := TLojaModelDaoCaixaMovimentoInMemory.Create;
  Result := FDao;
end;

function TLojaModelDaoCaixaMovimentoInMemory.ObterMovimentoPorCaixa(
  ACodCaixa: Integer): TLojaModelEntityCaixaMovimentoLista;
begin
  Result := TLojaModelEntityCaixaMovimentoLista.Create;

  for var LMovimento in FRepository
  do if LMovimento.CodCaixa = ACodCaixa
     then Result.Add(Clone(LMovimento));
end;

function TLojaModelDaoCaixaMovimentoInMemory.ObterMovimentoPorCodigo(
  ACodMov: Integer): TLojaModelEntityCaixaMovimento;
begin
  Result := nil;
  for var LMovimento in FRepository
  do if LMovimento.CodMov = ACodMov
  then begin
    Result := Clone(LMovimento);
    Break;
  end;
end;

class destructor TLojaModelDaoCaixaMovimentoInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNil(FDao);
end;

end.
