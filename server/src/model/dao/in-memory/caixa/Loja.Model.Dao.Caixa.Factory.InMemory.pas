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

  end;

implementation

{ TLojaModelDaoCaixaFactory }


{ TLojaModelDaoCaixaFactoryInMemory }

destructor TLojaModelDaoCaixaFactoryInMemory.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoCaixaFactoryInMemory.GetInstance: ILojaModelDaoCaixaFactory;
begin
  if FFactory = nil
  then FFactory := TLojaModelDaoCaixaFactoryInMemory.Create;
end;

class destructor TLojaModelDaoCaixaFactoryInMemory.UnInitialize;
begin
  if FFactory <> nil
  then FreeAndNil(FFactory);
end;

end.

