unit Loja.Model.Dao.Caixa.Caixa.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Caixa.Interfaces,
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Dto.Req.Caixa.Abertura;

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
    function ObterUltimoCaixaFechado(ADatRef: TDateTime): TLojaModelEntityCaixaCaixa;
    function CriarNovoCaixa(ANovoCaixa: TLojaModelDtoReqCaixaAbertura): TLojaModelEntityCaixaCaixa;
    function AtualizarFechamentoCaixa(ACodCaixa: Integer; ADatFecha: TDateTime;
      AVrFecha: Currency): TLojaModelEntityCaixaCaixa;
  end;

implementation

{ TLojaModelDaoCaixaCaixaInMemory }

function TLojaModelDaoCaixaCaixaInMemory.AtualizarFechamentoCaixa(
  ACodCaixa: Integer; ADatFecha: TDateTime;
  AVrFecha: Currency): TLojaModelEntityCaixaCaixa;
begin
  Result := nil;
  for var LCaixa in FRepository do
    if LCaixa.CodCaixa = ACodCaixa
    then begin
      LCaixa.CodSit := sitFechado;
      LCaixa.DatFecha := ADatFecha;
      Lcaixa.VrFecha := AVrFecha;

      Result := Clone(LCaixa);
      Break;
    end;
end;

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

function TLojaModelDaoCaixaCaixaInMemory.CriarNovoCaixa(
  ANovoCaixa: TLojaModelDtoReqCaixaAbertura): TLojaModelEntityCaixaCaixa;
var LId: Integer;
begin
  if FRepository.Count > 0
  then LId := FRepository.Last.CodCaixa
  else LId := 1;

  FRepository.Add(TLojaModelEntityCaixaCaixa.Create);
  FRepository.Last.CodCaixa := LId;
  FRepository.Last.CodSit := sitAberto;
  FRepository.Last.DatAbert := ANovoCaixa.DatAbert;
  FRepository.Last.VrAbert := ANovoCaixa.VrAbert;

  Result := Clone(FRepository.Last);
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

function TLojaModelDaoCaixaCaixaInMemory.ObterUltimoCaixaFechado(
  ADatRef: TDateTime): TLojaModelEntityCaixaCaixa;
var LUlt: TLojaModelEntityCaixaCaixa;
begin
  Result := nil;
  LUlt := nil;

  for var LCaixa in FRepository do
    if  (LCaixa.CodSit = sitFechado)
    and (LCaixa.DatFecha <= ADatRef)
    then begin
      if LUlt = nil
      then LUlt := LCaixa
      else
      if LCaixa.DatFecha > LUlt.DatFecha
      then LUlt := LCaixa;
    end;

  if LUlt <> nil
  then Result := Clone(LUlt);
end;

class destructor TLojaModelDaoCaixaCaixaInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNIl(FDao);
end;

end.
