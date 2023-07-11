unit Loja.Model.Dao.Venda.Item.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Venda.Interfaces,
  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Venda.Item;

type
  TLojaModelDaoVendaItemInMemory = class(TNoRefCountObject, ILojaModelDaoVendaItem)
  private
    FRepository: TLojaModelEntityVendaItemLista;
    function Clone(ASource: TLojaModelEntityVendaItem): TLojaModelEntityVendaItem;

    class var FDao: TLojaModelDaoVendaItemInMemory;
  public
    constructor Create;
    destructor Destroy; override;
    class function GetInstance: ILojaModelDaoVendaItem;
    class destructor UnInitialize;

    { ILojaModelDaoVendaItem }
    function ObterUltimoNumSeq(ANumVnda: Integer): Integer;
    function ObterItensVenda(ANumVnda: Integer): TLojaModelEntityVendaItemLista;
  end;

implementation

{ TLojaModelDaoVendaItemInMemory }

function TLojaModelDaoVendaItemInMemory.Clone(
  ASource: TLojaModelEntityVendaItem): TLojaModelEntityVendaItem;
begin
  Result := TLojaModelEntityVendaItem.Create;
  Result.NumVnda := ASource.NumVnda;
  Result.NumSeqItem := ASource.NumSeqItem;
  Result.CodItem := ASource.CodItem;
  Result.CodSit := ASource.CodSit;
  Result.QtdItem := ASource.QtdItem;
  Result.VrPrecoUnit := ASource.VrPrecoUnit;
  Result.VrBruto := ASource.VrBruto;
  Result.VrDesc := ASource.VrDesc;
  Result.VrTotal := ASource.VrTotal;
end;

constructor TLojaModelDaoVendaItemInMemory.Create;
begin
  FRepository := TLojaModelEntityVendaItemLista.Create;
end;

destructor TLojaModelDaoVendaItemInMemory.Destroy;
begin
  if FRepository <> nil
  then FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoVendaItemInMemory.GetInstance: ILojaModelDaoVendaItem;
begin
  if FDao = nil
  then FDao := TLojaModelDaoVendaItemInMemory.Create;
  Result := FDao;
end;

function TLojaModelDaoVendaItemInMemory.ObterItensVenda(
  ANumVnda: Integer): TLojaModelEntityVendaItemLista;
begin
  Result := TLojaModelEntityVendaItemLista.Create;
  for var LItem in FRepository
  do begin
    if LItem.NumVnda = ANumVnda
    then Result.Add(Clone(LItem));
  end;
end;

function TLojaModelDaoVendaItemInMemory.ObterUltimoNumSeq(
  ANumVnda: Integer): Integer;
begin
  var LNumSeq := 0;
  for var LItem in FRepository
  do
    if LItem.NumVnda = ANumVnda
    then begin
      if LItem.NumSeqItem > LNumSeq
      then LNumSeq := LItem.NumSeqItem;
    end;
end;

class destructor TLojaModelDaoVendaItemInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNil(FDao);
end;

end.
