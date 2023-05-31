unit Loja.Model.Dao.Itens.Item.InMemory;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,

  Loja.Model.Dao.Itens.Interfaces,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Itens.FiltroItens;

type
  TLojaModelDaoItensItemInMemory = class(TNoRefCountObject, ILojaModelDaoItensItem)
  private
    FRepository: TObjectList<TLojaModelEntityItensItem>;
    function Clone(ASource: TLojaModelEntityItensItem): TLojaModelEntityItensItem;

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
    function ObterItens(AFiltro: TLojaModelDtoReqItensFiltroItens): TLojaModelEntityItensItemLista;
  end;

implementation

{ TLojaModelDaoItensItem }



function TLojaModelDaoItensItemInMemory.Clone(
  ASource: TLojaModelEntityItensItem): TLojaModelEntityItensItem;
begin
  Result := TLojaModelEntityItensItem.Create;
  Result.CodItem := ASource.CodItem;
  Result.NomItem := ASource.NomItem;
  Result.NumCodBarr := ASource.NumCodBarr;
end;

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

  Result := Clone(FRepository.Last);
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

function TLojaModelDaoItensItemInMemory.ObterItens(
  AFiltro: TLojaModelDtoReqItensFiltroItens): TLojaModelEntityItensItemLista;
var LValido: Boolean;
begin
  Result := TLojaModelEntityItensItemLista.Create;
  for var i := 0 to Pred(FRepository.Count) do
  begin
    LValido := True;
    if (AFiltro.NomItem <> '')
    then if (Pos(AFiltro.NomItem, FRepository[i].NomItem)>0)
         then LValido := True and LValido
         else LValido := False;

    if (AFiltro.NumCodBarr<> '')
    then if (Pos(AFiltro.NomItem, FRepository[i].NumCodBarr)>0)
         then LValido := True and LValido
         else LValido := False;

    if AFiltro.CodItem > 0
    then if AFiltro.CodItem = FRepository[i].CodItem
         then LValido := True and LValido
         else LValido := False;

    if LValido
    then Result.Add(Clone(FRepository[i]));
  end;
end;

function TLojaModelDaoItensItemInMemory.ObterPorCodigo(
  ACodItem: Integer): TLojaModelEntityItensItem;
begin
  Result := nil;
  for var i := 0 to Pred(FRepository.Count)
  do if FRepository[i].CodItem = ACodItem then begin
    Result := Clone(FRepository[i]);
    Break;
  end;
end;

function TLojaModelDaoItensItemInMemory.ObterPorNumCodBarr(
  ANumCodBarr: string): TLojaModelEntityItensItem;
begin
  Result := nil;
  for var i := 0 to Pred(FRepository.Count)
  do if FRepository[i].NumCodBarr = ANumCodBarr then begin
    Result := Clone(FRepository[i]);
    Break;
  end;
end;

class destructor TLojaModelDaoItensItemInMemory.UnInitialize;
begin
  if Assigned(FDao)
  then FreeAndNil(FDao);
end;

end.
