unit Loja.Model.Dao.Caixa.Factory.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Caixa.Interfaces;

type
  TLojaModelDaoCaixaFactoryInMemory = class(TInterfacedObject, ILojaModelDaoCaixaFactory)
  private
    class var FFactory: TLojaModelDaoCaixaFactoryInMemory;
  public
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoCaixaFactory;
    class destructor UnInitialize;

    { ILojaModelDaoCaixaFactory }
    function Caixa: ILojaModelDaoCaixaCaixa;
    function Movimento: ILojaModelDaoCaixaMovimento;
  end;

implementation

uses
  Loja.Model.Dao.Caixa.Caixa.InMemory,
  Loja.Model.Dao.Caixa.Movimento.InMemory;

function TLojaModelDaoCaixaFactoryInMemory.Caixa: ILojaModelDaoCaixaCaixa;
begin
  Result := TLojaModelDaoCaixaCaixaInMemory.GetInstance;
end;

destructor TLojaModelDaoCaixaFactoryInMemory.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoCaixaFactoryInMemory.GetInstance: ILojaModelDaoCaixaFactory;
begin
  if FFactory = nil
  then FFactory := TLojaModelDaoCaixaFactoryInMemory.Create;
  Result := FFactory;
end;

function TLojaModelDaoCaixaFactoryInMemory.Movimento: ILojaModelDaoCaixaMovimento;
begin
  Result := TLojaModelDaoCaixaMovimentoInMemory.GetInstance;
end;

class destructor TLojaModelDaoCaixaFactoryInMemory.UnInitialize;
begin
  if FFactory <> nil
  then FreeAndNil(FFactory);
end;

end.

