unit Loja.Environment.Rules;

interface

uses
  Loja.Environment.Interfaces;

type
  TLojaEnvironmentOficial = class(TInterfacedObject,
    ILojaEnvironmentRules)
  public
    class function New: ILojaEnvironmentRules;

    { ILojaEnvironmentRules }
    function Kind: TLojaEnvironmentKind;
  end;

  TLojaEnvironmentInMemory = class(TInterfacedObject,
    ILojaEnvironmentRules)
  public
    class function New: ILojaEnvironmentRules;

    { ILojaEnvironmentRules }
    function Kind: TLojaEnvironmentKind;
  end;

implementation

{ TLojaEnvironmentOficial }

function TLojaEnvironmentOficial.Kind: TLojaEnvironmentKind;
begin
  Result := envOficial;
end;

class function TLojaEnvironmentOficial.New: ILojaEnvironmentRules;
begin
  Result := Self.Create;
end;

{ TLojaEnvironmentInMemory }

function TLojaEnvironmentInMemory.Kind: TLojaEnvironmentKind;
begin
  Result := envInMemory;
end;

class function TLojaEnvironmentInMemory.New: ILojaEnvironmentRules;
begin
  Result := Self.Create;
end;

end.
