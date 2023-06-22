unit Loja.Model.Dao.Caixa.Caixa.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Caixa.Interfaces,
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Types;

type
  TLojaModelDaoCaixaCaixaInMemory = class(TInterfacedObject, ILojaModelDaoCaixaCaixa)
  private
    FRepository: TLojaModelEntityCaixaCaixaLista;
    function Clone(ASource: TLojaModelEntityCaixaCaixa): TLojaModelEntityCaixaCaixa;

    class var FDao: TLojaModelDaoCaixaCaixaInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoCaixaCaixa;
    class destructor UnInitialize;

    { ILojaModelDaoCaixaMovimento }
    function ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
    function ObterCaixaPorCodigo(ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
  end;

implementation

{ TLojaModelDaoCaixaCaixaInMemory }

function TLojaModelDaoCaixaCaixaInMemory.Clone(
  ASource: TLojaModelEntityCaixaCaixa): TLojaModelEntityCaixaCaixa;
begin
  Result := TLojaModelEntityCaixaCaixa.Create;
  Result.CodCaixa := ASource.CodCaixa;
  Result.CodSit := ASource.CodSit;
  Result.DatAbert := ASource.DatAbert;
  Result.VrAbert := ASource.VrAbert;
  Result.DatFecha := ASource.DatFecha;
  Result.VrFecha := ASource.VrFecha;
end;

constructor TLojaModelDaoCaixaCaixaInMemory.Create;
begin
  FRepository := TLojaModelEntityCaixaCaixaLista.Create;
end;

destructor TLojaModelDaoCaixaCaixaInMemory.Destroy;
begin
  FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoCaixaCaixaInMemory.GetInstance: ILojaModelDaoCaixaCaixa;
begin
  if FDao = nil
  then FDao := TLojaModelDaoCaixaCaixaInMemory.Create;
  Result := FDao;
end;

function TLojaModelDaoCaixaCaixaInMemory.ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
begin
  Result := nil;
  for var LCaixa in FRepository do
    if LCaixa.CodSit = sitAberto
    then begin
      Result := Clone(LCaixa);
      Break;
    end;
end;

function TLojaModelDaoCaixaCaixaInMemory.ObterCaixaPorCodigo(
  ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
begin
  Result := nil;
  for var LCaixa in FRepository do
    if LCaixa.CodCaixa = ACodCaixa
    then begin
      Result := Clone(LCaixa);
      Break;
    end;
end;

class destructor TLojaModelDaoCaixaCaixaInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNIl(FDao);
end;

end.