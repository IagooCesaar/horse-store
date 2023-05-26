unit Loja.Model.Dao.Itens.Item.InMemory;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,

  Loja.Model.Dao.Itens.Interfaces,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem;

type
  TLojaModelDaoItensItemInMemory = class(TNoRefCountObject, ILojaModelDaoItensItem)
  private
    FRepository: TObjectList<TLojaModelEntityItensItem>;

    class var FDao: TLojaModelDaoItensItemInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoItensItem;
    class destructor UnInitialize;

    { ILojaModelDaoItensItem }
    function ObterPorCodigo(ACodItem: Integer): TLojaModelEntityItensItem;
    function ObterPorNumCodBarr(ANumCodBarr: string): TLojaModelEntityItensItem;
    function CriarItem(ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
  end;

implementation

{ TLojaModelDaoItensItem }



constructor TLojaModelDaoItensItemInMemory.Create;
begin
  FRepository := TObjectList<TLojaModelEntityItensItem>.Create;
end;

function TLojaModelDaoItensItemInMemory.CriarItem(
  ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
var LId: Integer;
begin
  if FRepository.Count > 0
  then Lid := FRepository.Last.CodItem + 1
  else LId := 1;

  FRepository.Add(TLojaModelEntityItensItem.Create);
  FRepository.Last.CodItem := Lid;
  FRepository.Last.NomItem := ANovoItem.NomItem;
  FRepository.Last.NumCodBarr := ANovoItem.NumCodBarr;

  Result := FRepository.Last;
end;

destructor TLojaModelDaoItensItemInMemory.Destroy;
begin
  FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoItensItemInMemory.GetInstance: ILojaModelDaoItensItem;
begin
  if not Assigned(FDao)
  then FDao := Self.Create;
  Result := FDao;
end;

function TLojaModelDaoItensItemInMemory.ObterPorCodigo(
  ACodItem: Integer): TLojaModelEntityItensItem;
begin
  Result := nil;
  for var i := 0 to Pred(FRepository.Count)
  do if FRepository[i].CodItem = ACodItem then begin
    Result := FRepository[i];
    Break;
  end;
end;

function TLojaModelDaoItensItemInMemory.ObterPorNumCodBarr(
  ANumCodBarr: string): TLojaModelEntityItensItem;
begin
  Result := nil;
  for var i := 0 to Pred(FRepository.Count)
  do if FRepository[i].NumCodBarr = ANumCodBarr then begin
    Result := FRepository[i];
    Break;
  end;
end;

class destructor TLojaModelDaoItensItemInMemory.UnInitialize;
begin
  if Assigned(FDao)
  then FreeAndNil(FDao);
end;

end.
