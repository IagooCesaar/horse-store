unit Loja.Model.Bo.Factory;

interface

uses
  System.Classes,
  Loja.Environment.Interfaces,
  Loja.Model.Bo.Interfaces;

type
  TLojaModelBoFactory = class(TInterfacedObject, ILojaModelBoFactory)
  private
    FEnvRules: ILojaEnvironmentRuler;
  public
    constructor Create(AEnvRules: ILojaEnvironmentRuler);
    destructor Destroy; override;
    class function New(AEnvRules: ILojaEnvironmentRuler): ILojaModelBoFactory;

    { ILojaModelBoFactory }
    function Estoque: ILojaModelBoEstoque;
    function Caixa: ILojaModelBoCaixa;
  end;

implementation

uses
  Loja.Model.Bo.Estoque,
  Loja.Model.Bo.Caixa;

{ TLojaModelBoFactory }

function TLojaModelBoFactory.Caixa: ILojaModelBoCaixa;
begin
  Result := TLojaModelBoCaixa.New(FEnvRules);
end;

constructor TLojaModelBoFactory.Create(AEnvRules: ILojaEnvironmentRuler);
begin
  FEnvRules := AEnvRules;
end;

destructor TLojaModelBoFactory.Destroy;
begin

  inherited;
end;

function TLojaModelBoFactory.Estoque: ILojaModelBoEstoque;
begin
  Result := TLojaModelBoEstoque.New(FEnvRules);
end;

class function TLojaModelBoFactory.New(AEnvRules: ILojaEnvironmentRuler): ILojaModelBoFactory;
begin
  Result := Self.Create(AEnvRules);
end;

end.
