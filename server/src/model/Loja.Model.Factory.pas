unit Loja.Model.Factory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Environment.Interfaces,
  Loja.Model.Interfaces,
  Loja.Model.Entity.Itens.Item;

type
  TLojaModelFactory = class(TInterfacedObject,
    ILojaModelFactory, ILojaEnvironmentRuler)
  private
    FRules: ILojaEnvironmentRules;

  public
    constructor Create(AEnvRules: ILojaEnvironmentRules);
	  destructor Destroy; override;
	  class function New: ILojaModelFactory;
    class function InMemory: ILojaModelFactory;

    { ILojaEnvironmentRuler }
    function Rules: ILojaEnvironmentRules;
    function Ruler: ILojaEnvironmentRuler;

    { ILojaModelFactory }
    function Itens: ILojaModelItens;
    function Estoque: ILojaModelEstoque;
    function Preco: ILojaModelPreco;
    function Caixa: ILojaModelCaixa;
    function Venda: ILojaModelVenda;
  end;

implementation

uses
  Loja.Environment.Factory,
  Loja.Model.Itens,
  Loja.Model.Estoque,
  Loja.Model.Preco,
  Loja.Model.Caixa,
  Loja.Model.Venda;

{ TLojaModelFactory }

function TLojaModelFactory.Caixa: ILojaModelCaixa;
begin
  Result := TLojaModelCaixa.New(Self.Ruler);
end;

constructor TLojaModelFactory.Create(AEnvRules: ILojaEnvironmentRules);
begin
  FRules := AEnvRules;
end;

destructor TLojaModelFactory.Destroy;
begin

  inherited;
end;

function TLojaModelFactory.Estoque: ILojaModelEstoque;
begin
  Result := TLojaModelEstoque.New(Self.Ruler);
end;

class function TLojaModelFactory.InMemory: ILojaModelFactory;
begin
  Result := Self.Create(TLojaEnvironmentFactory.New.InMemory);
end;

function TLojaModelFactory.Itens: ILojaModelItens;
begin
  Result := TLojaModelItens.New(Self.Ruler);
end;

class function TLojaModelFactory.New: ILojaModelFactory;
begin
  Result := Self.Create(TLojaEnvironmentFactory.New.Oficial);
end;

function TLojaModelFactory.Preco: ILojaModelPreco;
begin
  Result := TlojaModelPreco.New(Self.Ruler);
end;

function TLojaModelFactory.Ruler: ILojaEnvironmentRuler;
begin
  Result := Self;
end;

function TLojaModelFactory.Rules: ILojaEnvironmentRules;
begin
  Result := FRules;
end;

function TLojaModelFactory.Venda: ILojaModelVenda;
begin
  Result := TLojaModelVenda.New(Self.Ruler);
end;

end.
