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

  end;

implementation

{ TLojaModelDaoVendaItemInMemory }

function TLojaModelDaoVendaItemInMemory.Clone(
  ASource: TLojaModelEntityVendaItem): TLojaModelEntityVendaItem;
begin

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
