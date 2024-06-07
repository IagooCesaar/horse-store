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
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelFactory;

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
  Loja.Model.Itens,
  Loja.Model.Estoque,
  Loja.Model.Preco,
  Loja.Model.Caixa,
  Loja.Model.Venda;

{ TLojaModelFactory }

function TLojaModelFactory.Caixa: ILojaModelCaixa;
begin
  Result := TLojaModelCaixa.New;
end;

constructor TLojaModelFactory.Create;
begin

end;

destructor TLojaModelFactory.Destroy;
begin

  inherited;
end;

function TLojaModelFactory.Estoque: ILojaModelEstoque;
begin
  Result := TLojaModelEstoque.New;
end;

function TLojaModelFactory.Itens: ILojaModelItens;
begin
  Result := TLojaModelItens.New;
end;

class function TLojaModelFactory.New: ILojaModelFactory;
begin
  Result := Self.Create;
end;

function TLojaModelFactory.Preco: ILojaModelPreco;
begin
  Result := TlojaModelPreco.New;
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
  Result := TLojaModelVenda.New;
end;

end.
