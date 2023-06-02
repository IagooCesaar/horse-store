unit Loja.Model.Dao.Estoque.Saldo.InMemory;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,

  Loja.Model.Dao.Estoque.Interfaces,
  Loja.Model.Entity.Estoque.Saldo;

type
  TLojaModelDaoEstoqueSaldoInMemory = class(TNoRefCountObject, ILojaModelDaoEstoqueSaldo)
  private
    FRepository: TLojaModelEntityEstoqueSaldoLista;
    function Clone(ASource: TLojaModelEntityEstoqueSaldo): TLojaModelEntityEstoqueSaldo;

    class var FDao: TLojaModelDaoEstoqueSaldoInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoEstoqueSaldo;
    class destructor UnInitialize;

    { ILojaModelDaoEstoqueSaldo }
    function ObterUltimoFechamentoItem(ACodItem: Integer): TLojaModelEntityEstoqueSaldo;
    function ObterFechamentoItem(ACodItem: Integer; ADatSaldo: TDateTime): TLojaModelEntityEstoqueSaldo;
    function CriarFechamentoSaldoItem(ACodItem: Integer; ADatSaldo: TDateTime; AQtdSaldo: Integer):TLojaModelEntityEstoqueSaldo;

  end;

implementation

{ TLojaModelDaoEstoqueMovimentoInMemory }

function TLojaModelDaoEstoqueSaldoInMemory.Clone(
  ASource: TLojaModelEntityEstoqueSaldo): TLojaModelEntityEstoqueSaldo;
begin
  Result := TLojaModelEntityEstoqueSaldo.Create;
  Result.CodFechSaldo := ASource.CodFechSaldo;
  Result.CodItem := ASource.CodItem;
  Result.DatSaldo := ASource.DatSaldo;
end;

constructor TLojaModelDaoEstoqueSaldoInMemory.Create;
begin
  FRepository := TLojaModelEntityEstoqueSaldoLista.Create;
end;

function TLojaModelDaoEstoqueSaldoInMemory.CriarFechamentoSaldoItem(
  ACodItem: Integer; ADatSaldo: TDateTime;
  AQtdSaldo: Integer): TLojaModelEntityEstoqueSaldo;
var LId: Integer;
begin
  if FRepository.Count > 0
  then Lid := FRepository.Last.CodFechSaldo + 1
  else LId := 1;

  FRepository.Add(TLojaModelEntityEstoqueSaldo.Create);
  FRepository.Last.CodFechSaldo := LId;
  FRepository.Last.CodItem := ACodItem;
  FRepository.Last.DatSaldo := ADatSaldo;
  FRepository.Last.QtdSaldo := AQtdSaldo;

  Result := Clone(FRepository.Last);
end;

destructor TLojaModelDaoEstoqueSaldoInMemory.Destroy;
begin
  FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoEstoqueSaldoInMemory.GetInstance: ILojaModelDaoEstoqueSaldo;
begin
  if not Assigned(FDao)
  then FDao := Self.Create;
  Result := FDao;
end;

function TLojaModelDaoEstoqueSaldoInMemory.ObterFechamentoItem(
  ACodItem: Integer; ADatSaldo: TDateTime): TLojaModelEntityEstoqueSaldo;
begin
  Result := nil;
  for var i := 0 to Pred(FRepository.Count)
  do begin
    if  (FRepository[i].CodItem = ACodItem)
    and (FRepository[i].DatSaldo = ADatSaldo)
    then begin
      Result := Clone(FRepository[i]);
      Break;
    end;
  end;
end;

function TLojaModelDaoEstoqueSaldoInMemory.ObterUltimoFechamentoItem(
  ACodItem: Integer): TLojaModelEntityEstoqueSaldo;
var idx: Integer;
begin
  Result := nil;
  idx := -1;
  for var i := 0 to Pred(FRepository.Count)
  do begin
    if  (FRepository[i].CodItem = ACodItem)
    then begin
      if idx = -1
      then idx := i;

      if FRepository[i].DatSaldo >= FRepository[idx].DatSaldo
      then idx := i;
    end;
  end;

  if idx > -1
  then Result := Clone(FRepository[idx]);
end;

class destructor TLojaModelDaoEstoqueSaldoInMemory.UnInitialize;
begin
  if Assigned(FDao)
  then FreeAndNil(FDao);
end;

end.
