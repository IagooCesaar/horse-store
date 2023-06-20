unit Loja.Model.Dao.Caixa.Caixa.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Caixa.Interfaces,
  Loja.Model.Entity.Caixa.Caixa;

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
  end;

implementation

{ TLojaModelDaoCaixaCaixaInMemory }

function TLojaModelDaoCaixaCaixaInMemory.Clone(
  ASource: TLojaModelEntityCaixaCaixa): TLojaModelEntityCaixaCaixa;
begin
  Result := TLojaModelEntityCaixaCaixa.Create;

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

class destructor TLojaModelDaoCaixaCaixaInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNIl(FDao);
end;

end.
