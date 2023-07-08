unit Loja.Model.Dao.Venda.Venda.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Venda.Interfaces,
  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Venda.Venda;

type
  TLojaModelDaoVendaVendaInMemory = class(TNoRefCountObject, ILojaModelDaoVendaVenda)
  private
    FRepository: TLojaModelEntityVendaVendaLista;
    function Clone(ASource: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;

    class var FDao: TLojaModelDaoVendaVendaInMemory;
  public
    constructor Create;
    destructor Destroy; override;
    class function GetInstance: ILojaModelDaoVendaVenda;
    class destructor UnInitialize;

    { ILojaModelDaoVendaVenda }
    function ObterVendas(ADatInclIni, ADatInclFim: TDate;
      AFlgApenasEfet: Boolean): TLojaModelEntityVendaVendaLista;

  end;

implementation

{ TLojaModelDaoVendaVendaInMemory }

function TLojaModelDaoVendaVendaInMemory.Clone(
  ASource: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;
begin
  Result := TLojaModelEntityVendaVenda.Create;
  Result.NumVnda := ASource.NumVnda;
  Result.CodSit := ASource.CodSit;
  Result.DatIncl := ASource.DatIncl;
  Result.DatConcl := ASource.DatConcl;
  Result.VrBruto := ASource.VrBruto;
  Result.VrDesc := ASource.VrDesc;
  Result.VrTotal := ASource.VrTotal;
end;

constructor TLojaModelDaoVendaVendaInMemory.Create;
begin
  FRepository := TLojaModelEntityVendaVendaLista.Create;
end;

destructor TLojaModelDaoVendaVendaInMemory.Destroy;
begin
  if FRepository <> nil
  then FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoVendaVendaInMemory.GetInstance: ILojaModelDaoVendaVenda;
begin
  if FDao = nil
  then FDao := TLojaModelDaoVendaVendaInMemory.Create;
  Result := FDao;
end;

function TLojaModelDaoVendaVendaInMemory.ObterVendas(ADatInclIni,
  ADatInclFim: TDate; AFlgApenasEfet: Boolean): TLojaModelEntityVendaVendaLista;
begin
  Result := TLojaModelEntityVendaVendaLista.Create;

  for var LVenda in FRepository
  do begin
    if  (Trunc(LVenda.DatIncl) >= ADatInclIni)
    and (Trunc(LVenda.DatIncl) <= ADatInclFim)
    then
      if AFlgApenasEfet and (LVenda.CodSit = sitEfetivada)
      then Result.Add(Clone(LVenda))
      else
      if not AFlgApenasEfet
      then Result.Add(Clone(LVenda));
  end;
end;

class destructor TLojaModelDaoVendaVendaInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNil(FDao);
end;

end.
