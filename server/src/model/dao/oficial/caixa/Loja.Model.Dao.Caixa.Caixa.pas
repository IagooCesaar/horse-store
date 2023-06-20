unit Loja.Model.Dao.Caixa.Caixa;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Caixa.Interfaces;

type
  TLojaModelDaoCaixaCaixa = class(TInterfacedObject, ILojaModelDaoCaixaCaixa)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoCaixaCaixa;

    { ILojaModelDaoCaixaCaixa }

  end;

implementation

{ TLojaModelDaoCaixaCaixa }

constructor TLojaModelDaoCaixaCaixa.Create;
begin

end;

destructor TLojaModelDaoCaixaCaixa.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoCaixaCaixa.New: ILojaModelDaoCaixaCaixa;
begin
  Result := Self.Create;
end;

end.
