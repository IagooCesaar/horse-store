unit Loja.Model.Caixa;

interface

uses
  System.SysUtils,
  System.Classes,

  Loja.Model.Interfaces;

type
  TLojaModelCaixa = class(TInterfacedObject, ILojaModelCaixa)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelCaixa;

    { ILojaModelCaixa }
  end;

implementation

{ TLojaModelCaixa }

constructor TLojaModelCaixa.Create;
begin

end;

destructor TLojaModelCaixa.Destroy;
begin

  inherited;
end;

class function TLojaModelCaixa.New: ILojaModelCaixa;
begin
  Result := Self.Create;
end;

end.
