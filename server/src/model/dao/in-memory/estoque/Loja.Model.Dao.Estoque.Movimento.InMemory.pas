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

    class var FDao: TLojaModelDaoEstoqueMovimentoInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoEstoqueMovimento;
    class destructor UnInitialize;

    { ILojaModelDaoEstoqueMovimento }
    function ObterPorCodigo(ACodMov: Integer): TLojaModelEntityEstoqueMovimento;
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;

  end;

implementation

{ TLojaModelDaoEstoqueMovimentoInMemory }

constructor TLojaModelDaoEstoqueMovimentoInMemory.Create;
begin
  FRepository := TLojaModelEntityEstoqueMovimentoLista.Create;
end;

function TLojaModelDaoEstoqueMovimentoInMemory.CriarNovoMovimento(
  ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
var LId: Integer;
begin
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

function TLojaModelDaoEstoqueMovimentoInMemory.ObterPorCodigo(
  ACodMov: Integer): TLojaModelEntityEstoqueMovimento;
begin
  Result := nil;
  for var i := 0 to Pred(FRepository.Count)
  do if FRepository[i].CodMov = ACodMov then begin
    Result := FRepository[i];
    Break;
  end;
end;

class destructor TLojaModelDaoEstoqueMovimentoInMemory.UnInitialize;
begin
  if Assigned(FDao)
  then FreeAndNil(FDao);
end;

end.
