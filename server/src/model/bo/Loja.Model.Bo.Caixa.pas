unit Loja.Model.Bo.Caixa;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Bo.Interfaces;

type
  TLojaModelBoCaixa = class(TInterfacedObject, ILojaModelBoCaixa)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelBoCaixa;

    { ILojaModelBoCaixa }

  end;

implementation

{ TLojaModelBoCaixa }

constructor TLojaModelBoCaixa.Create;
begin

end;

destructor TLojaModelBoCaixa.Destroy;
begin

  inherited;
end;

class function TLojaModelBoCaixa.New: ILojaModelBoCaixa;
begin
  Result := Self.Create;
end;

end.
