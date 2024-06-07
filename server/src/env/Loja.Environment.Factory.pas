unit Loja.Environment.Factory;

interface

uses
  Loja.Environment.Interfaces;

type
  TLojaEnvironmentFactory = class(TInterfacedObject, ILojaEnvironmentFactory)
  public
    class function New: ILojaEnvironmentFactory;

    { ILojaEnvironmentFactory }
    function Oficial: ILojaEnvironmentRules;
    function InMemory: ILojaEnvironmentRules;
  end;

implementation

{ TLojaEnvironmentFactory }

uses
  Loja.Environment.Rules;

function TLojaEnvironmentFactory.InMemory: ILojaEnvironmentRules;
begin
  Result := TLojaEnvironmentInMemory.New;
end;

class function TLojaEnvironmentFactory.New: ILojaEnvironmentFactory;
begin
  Result := Self.Create;
end;

function TLojaEnvironmentFactory.Oficial: ILojaEnvironmentRules;
begin
  Result := TLojaEnvironmentOficial.New;
end;

end.
