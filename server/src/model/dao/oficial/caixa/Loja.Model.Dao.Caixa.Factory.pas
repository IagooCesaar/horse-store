unit Loja.Model.Dao.Caixa.Factory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Caixa.Interfaces;

type
  TLojaModelDaoCaixaFactory = class(TInterfacedObject, ILojaModelDaoCaixaFactory)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoCaixaFactory;

    { ILojaModelDaoCaixaFactory }

  end;

implementation

{ TLojaModelDaoCaixaFactory }

constructor TLojaModelDaoCaixaFactory.Create;
begin

end;

destructor TLojaModelDaoCaixaFactory.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoCaixaFactory.New: ILojaModelDaoCaixaFactory;
begin
  Result := Self.Create;
end;

end.
