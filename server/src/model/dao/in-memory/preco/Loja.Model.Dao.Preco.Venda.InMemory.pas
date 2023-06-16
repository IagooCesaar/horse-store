unit Loja.Model.Dao.Preco.Venda.InMemory;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,

  Loja.Model.Dao.Preco.Interfaces,
  Loja.Model.Entity.Preco.Venda,
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda;

type
  TLojaModelDaoPrecoVendaInMemory = class(TNoRefCountObject, ILojaModelDaoPrecoVenda)
  private
    FRepository: TLojaModelEntityPrecoVendaLista;
    function Clone(ASource: TLojaModelEntityPrecoVenda): TLojaModelEntityPrecoVenda;

    class var FDao: TLojaModelDaoPrecoVendaInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoPrecoVenda;
    class destructor UnInitialize;

    { ILojaModelDaoItensItem }
    function CriarPrecoVendaItem(ANovoPreco: TLojaModelDtoReqPrecoCriarPrecoVenda): TLojaModelEntityPrecoVenda;
    function ObterHistoricoPrecoVendaItem(ACodItem: Integer; ADatRef: TDateTime): TLojaModelEntityPrecoVendaLista;
    function ObterPrecoVendaVigente(ACodItem: Integer; ADatRef: TDateTime): TLojaModelEntityPrecoVenda;
    function ObterPrecoVendaAtual(ACodItem: Integer): TLojaModelEntityPrecoVenda;
  end;

implementation

{ TLojaModelDaoPrecoVendaInMemory }

function TLojaModelDaoPrecoVendaInMemory.Clone(
  ASource: TLojaModelEntityPrecoVenda): TLojaModelEntityPrecoVenda;
begin
  Result := TLojaModelEntityPrecoVenda.Create;
  Result.CodItem := ASource.CodItem;
  Result.DatIni := ASource.DatIni;
  Result.VrVnda := ASource.VrVnda;
end;

constructor TLojaModelDaoPrecoVendaInMemory.Create;
begin
  FRepository := TLojaModelEntityPrecoVendaLista.Create;
end;

function TLojaModelDaoPrecoVendaInMemory.CriarPrecoVendaItem(
  ANovoPreco: TLojaModelDtoReqPrecoCriarPrecoVenda): TLojaModelEntityPrecoVenda;
begin
  FRepository.Add(TLojaModelEntityPrecoVenda.Create);
  FRepository.Last.CodItem := ANovoPreco.CodItem;
  FRepository.Last.DatIni := ANovoPreco.DatIni;
  FRepository.Last.VrVnda := ANovoPreco.VrVnda;

  Result := Clone(FRepository.Last);
end;

destructor TLojaModelDaoPrecoVendaInMemory.Destroy;
begin
  FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoPrecoVendaInMemory.GetInstance: ILojaModelDaoPrecoVenda;
begin
  if FDao = nil
  then FDao := TLojaModelDaoPrecoVendaInMemory.Create;
  Result := FDao;
end;

function TLojaModelDaoPrecoVendaInMemory.ObterHistoricoPrecoVendaItem(
  ACodItem: Integer; ADatRef: TDateTime): TLojaModelEntityPrecoVendaLista;
var LPrecoAnterior: TLojaModelEntityPrecoVenda;
begin
  LPrecoAnterior := nil;
  Result := TLojaModelEntityPrecoVendaLista.Create;
  for var LPreco in FRepository
  do begin
    if  (LPreco.CodItem = ACodItem)
    then
      if (LPreco.DatIni >= ADatRef)
      then Result.Add(Clone(LPreco))
      else begin
         // identificar o preço que estava vigente na data ref
         if LPrecoAnterior = nil
         then LPrecoAnterior := LPreco
         else if LPrecoAnterior.DatIni < LPreco.DatIni
              then LPrecoAnterior := LPreco;
      end;
  end;

  if LPrecoAnterior <> nil
  then Result.Add(Clone(LPrecoAnterior));
end;

function TLojaModelDaoPrecoVendaInMemory.ObterPrecoVendaAtual(
  ACodItem: Integer): TLojaModelEntityPrecoVenda;
begin
  Result := ObterPrecoVendaVigente(ACodItem, Now);
end;

function TLojaModelDaoPrecoVendaInMemory.ObterPrecoVendaVigente(
  ACodItem: Integer; ADatRef: TDateTime): TLojaModelEntityPrecoVenda;
var
  LPrecoVigente: TLojaModelEntityPrecoVenda;
begin
  for var LPreco in FRepository
  do begin
    if  (LPreco.CodItem = ACodItem)
    and (LPreco.DatIni <= ADatRef)
    then begin
      // identificar o preço que estava vigente hoje
      if LPrecoVigente = nil
      then LPrecoVigente := LPreco
      else if LPrecoVigente.DatIni < LPreco.DatIni
      then LPrecoVigente := LPreco;
    end;
  end;

  if LPrecoVigente = nil
  then Result := nil
  else Result := Clone(LPrecoVigente);
end;
class destructor TLojaModelDaoPrecoVendaInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNil(FDao);
end;

end.
