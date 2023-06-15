unit Loja.Model.Factory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Itens.Item;

type
  TLojaModelFactory = class(TInterfacedObject, ILojaModelFactory)
  private
  public
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelFactory;

    { ILojaModelFactory }
    function Itens: ILojaModelItens;
    function Estoque: ILojaModelEstoque;
    function Preco: ILojaModelPreco;
  end;

implementation

uses
  Loja.Model.Itens,
  Loja.Model.Estoque,
  Loja.Model.Preco;

{ TLojaModelFactory }

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

end.
