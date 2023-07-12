unit Loja.Model.Dao.Venda.MeioPagto.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Venda.Interfaces,
  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Venda.MeioPagto;

type
  TLojaModelDaoVendaMeioPagtoInMemory = class(TNoRefCountObject, ILojaModelDaoVendaMeioPagto)
  private
    FRepository: TLojaModelEntityVendaMeioPagtoLista;
    function Clone(ASource: TLojaModelEntityVendaMeioPagto): TLojaModelEntityVendaMeioPagto;

    class var FDao: TLojaModelDaoVendaMeioPagtoInMemory;
  public
    constructor Create;
    destructor Destroy; override;
    class function GetInstance: ILojaModelDaoVendaMeioPagto;
    class destructor UnInitialize;

    { ILojaModelDaoVendaMeioPagto }
    function ObterMeiosPagtoVenda(ANumVnda: Integer): TLojaModelEntityVendaMeioPagtoLista;
    function ObterMeioPagtoVenda(ANumVnda, ANumSeqMeioPagto: Integer): TLojaModelEntityVendaMeioPagto;
    procedure RemoverMeiosPagtoVenda(ANumVnda: Integer);
    function InserirMeioPagto(ANovoMeioPagto: TLojaModelEntityVendaMeioPagto): TLojaModelEntityVendaMeioPagto;

  end;

implementation

{ TLojaModelDaoVendaMeioPagtoInMemory }


function TLojaModelDaoVendaMeioPagtoInMemory.Clone(
  ASource: TLojaModelEntityVendaMeioPagto): TLojaModelEntityVendaMeioPagto;
begin
  Result := TLojaModelEntityVendaMeioPagto.Create;
  Result.NumVnda := ASource.NumVnda;
  Result.NumSeqMeioPagto:= ASource.NumSeqMeioPagto;
  Result.CodMeioPagto := ASource.CodMeioPagto;
  Result.QtdParc := ASource.QtdParc;
  Result.VrParc := ASource.VrParc;
end;

constructor TLojaModelDaoVendaMeioPagtoInMemory.Create;
begin
  FRepository := TLojaModelEntityVendaMeioPagtoLista.Create;
end;

destructor TLojaModelDaoVendaMeioPagtoInMemory.Destroy;
begin
  if FRepository <> nil
  then FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoVendaMeioPagtoInMemory.GetInstance: ILojaModelDaoVendaMeioPagto;
begin
  if FDao = nil
  then FDao := TLojaModelDaoVendaMeioPagtoInMemory.Create;
  Result := FDao;
end;

function TLojaModelDaoVendaMeioPagtoInMemory.InserirMeioPagto(
  ANovoMeioPagto: TLojaModelEntityVendaMeioPagto): TLojaModelEntityVendaMeioPagto;
begin
  Result := nil;
  FRepository.Add(TLojaModelEntityVendaMeioPagto.Create);
  FRepository.Last.NumVnda := ANovoMeioPagto.NumVnda;
  FRepository.Last.NumSeqMeioPagto := ANovoMeioPagto.NumSeqMeioPagto;
  FRepository.Last.CodMeioPagto := ANovoMeioPagto.CodMeioPagto;
  FRepository.Last.QtdParc := ANovoMeioPagto.QtdParc;
  FRepository.Last.VrParc := ANovoMeioPagto.VrParc;
  Result := Clone(FRepository.Last);
end;

function TLojaModelDaoVendaMeioPagtoInMemory.ObterMeioPagtoVenda(ANumVnda,
  ANumSeqMeioPagto: Integer): TLojaModelEntityVendaMeioPagto;
begin
  Result := nil;
  for var LMeio in FRepository
  do
    if  (LMeio.NumVnda = ANumVnda)
    and (LMeio.NumSeqMeioPagto = ANumSeqMeioPagto)
    then begin
      Result := Clone(LMeio);
      Break;
    end;
end;

function TLojaModelDaoVendaMeioPagtoInMemory.ObterMeiosPagtoVenda(
  ANumVnda: Integer): TLojaModelEntityVendaMeioPagtoLista;
begin
  Result := TLojaModelEntityVendaMeioPagtoLista.Create;
  for var LMeio in FRepository
  do
    if LMeio.NumVnda = ANumVnda
    then Result.Add(Clone(LMeio));
end;

procedure TLojaModelDaoVendaMeioPagtoInMemory.RemoverMeiosPagtoVenda(
  ANumVnda: Integer);
begin
  for var LMeioPagto in FRepository
  do
    if LMeioPagto.NumVnda = ANumVnda
    then FRepository.Remove(LMeioPagto);
end;

class destructor TLojaModelDaoVendaMeioPagtoInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNil(FDao);
end;

end.
