unit Loja.Model.Dao.Estoque.Movimento.InMemory;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,

  Loja.Model.Dao.Estoque.Interfaces,
  Loja.Model.Dto.Req.Estoque.CriarMovimento,
  Loja.Model.Entity.Estoque.Movimento;

type
  TLojaModelDaoEstoqueMovimentoInMemory = class(TNoRefCountObject, ILojaModelDaoEstoqueMovimento)
  private
    FRepository: TLojaModelEntityEstoqueMovimentoLista;
    function Clone(ASource: TLojaModelEntityEstoqueMovimento): TLojaModelEntityEstoqueMovimento;

    class var FDao: TLojaModelDaoEstoqueMovimentoInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoEstoqueMovimento;
    class destructor UnInitialize;

    { ILojaModelDaoEstoqueMovimento }
    function ObterPorCodigo(ACodMov: Integer): TLojaModelEntityEstoqueMovimento;
    function ObterMovimentoItemEntreDatas(ACodItem: Integer; ADatIni, ADatFim: TDateTime): TLojaModelEntityEstoqueMovimentoLista;
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;

  end;

implementation

{ TLojaModelDaoEstoqueMovimentoInMemory }

function TLojaModelDaoEstoqueMovimentoInMemory.Clone(
  ASource: TLojaModelEntityEstoqueMovimento): TLojaModelEntityEstoqueMovimento;
begin
  Result := TLojaModelEntityEstoqueMovimento.Create;
  Result.CodMov := ASource.CodMov;
  Result.CodItem := ASource.CodItem;
  Result.QtdMov := ASource.QtdMov;
  Result.DatMov := ASource.DatMov;
  Result.DscOrigMov := Result.DscOrigMov;
  Result.DscTipoMov := Result.DscTipoMov;
  Result.DscMot := Result.DscMot;
end;

constructor TLojaModelDaoEstoqueMovimentoInMemory.Create;
begin
  FRepository := TLojaModelEntityEstoqueMovimentoLista.Create;
end;

function TLojaModelDaoEstoqueMovimentoInMemory.CriarNovoMovimento(
  ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
var LId: Integer;
begin
  Result := nil;
  if FRepository.Count > 0
  then Lid := FRepository.Last.CodItem + 1
  else LId := 1;

  FRepository.Add(TLojaModelEntityEstoqueMovimento.Create);
  FRepository.Last.CodMov := LId;
  FRepository.Last.CodItem := ANovoMovimento.CodItem;
  FRepository.Last.QtdMov := ANovoMovimento.QtdMov;
  FRepository.Last.DatMov := ANovoMovimento.DatMov;
  FRepository.Last.CodTipoMov := ANovoMovimento.CodTipoMov;
  FRepository.Last.CodOrigMov := ANovoMovimento.CodOrigMov;
  FRepository.Last.DscMot := ANovoMovimento.DscMot;

  Result := Clone(FRepository.Last);
end;

destructor TLojaModelDaoEstoqueMovimentoInMemory.Destroy;
begin
  FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoEstoqueMovimentoInMemory.GetInstance: ILojaModelDaoEstoqueMovimento;
begin
  if not Assigned(FDao)
  then FDao := Self.Create;
  Result := FDao;
end;

function TLojaModelDaoEstoqueMovimentoInMemory.ObterMovimentoItemEntreDatas(
  ACodItem: Integer; ADatIni,
  ADatFim: TDateTime): TLojaModelEntityEstoqueMovimentoLista;
begin
  Result := TLojaModelEntityEstoqueMovimentoLista.Create;
  for var LMovimento in FRepository
  do begin
    if  (LMovimento.DatMov >= ADatIni)
    and (LMovimento.DatMov <= ADatFim)
    then Result.Add(Clone(LMovimento));
  end;
end;

function TLojaModelDaoEstoqueMovimentoInMemory.ObterPorCodigo(
  ACodMov: Integer): TLojaModelEntityEstoqueMovimento;
begin
  Result := nil;
  for var i := 0 to Pred(FRepository.Count)
  do if FRepository[i].CodMov = ACodMov then begin
    Result := Clone(FRepository[i]);
    Break;
  end;
end;

class destructor TLojaModelDaoEstoqueMovimentoInMemory.UnInitialize;
begin
  if Assigned(FDao)
  then FreeAndNil(FDao);
end;

end.
