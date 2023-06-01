unit Loja.Model.Bo.Factory;

interface

uses
  System.Classes,
  Loja.Model.Bo.Interfaces;

type
  TLojaModelBoFactory = class(TInterfacedObject, ILojaModelBoFactory)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelBoFactory;

    { ILojaModelBoFactory }
    function Estoque: ILojaModelBoEstoque;
  end;

implementation

uses
  Loja.Model.Bo.Estoque;

{ TLojaModelBoFactory }

constructor TLojaModelBoFactory.Create;
begin

end;

destructor TLojaModelBoFactory.Destroy;
begin

  inherited;
end;

function TLojaModelBoFactory.Estoque: ILojaModelBoEstoque;
begin
  Result := TLojaModelBoEstoque.New;
end;

class function TLojaModelBoFactory.New: ILojaModelBoFactory;
begin
  Result := Self.Create;
end;

end.
