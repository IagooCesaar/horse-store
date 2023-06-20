unit Loja.Model.Dao.Caixa.Movimento;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Caixa.Interfaces;

type
  TLojaModelDaoCaixaMovimento = class(TInterfacedObject, ILojaModelDaoCaixaMovimento)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoCaixaMovimento;

    { ILojaModelDaoCaixaCaixa }

  end;

implementation

{ TLojaModelDaoCaixaCaixa }

constructor TLojaModelDaoCaixaMovimento.Create;
begin

end;

destructor TLojaModelDaoCaixaMovimento.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoCaixaMovimento.New: ILojaModelDaoCaixaMovimento;
begin
  Result := Self.Create;
end;

end.

