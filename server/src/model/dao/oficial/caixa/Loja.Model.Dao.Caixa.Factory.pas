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
    function Caixa: ILojaModelDaoCaixaCaixa;
    function Movimento: ILojaModelDaoCaixaMovimento;

  end;

implementation

uses
  Loja.Model.Dao.Caixa.Caixa,
  Loja.Model.Dao.Caixa.Movimento;


{ TLojaModelDaoCaixaFactory }

function TLojaModelDaoCaixaFactory.Caixa: ILojaModelDaoCaixaCaixa;
begin
  Result := TLojaModelDaoCaixaCaixa.New;
end;

constructor TLojaModelDaoCaixaFactory.Create;
begin

end;

destructor TLojaModelDaoCaixaFactory.Destroy;
begin

  inherited;
end;

function TLojaModelDaoCaixaFactory.Movimento: ILojaModelDaoCaixaMovimento;
begin
  Result := TLojaModelDaoCaixaMovimento.New;
end;

class function TLojaModelDaoCaixaFactory.New: ILojaModelDaoCaixaFactory;
begin
  Result := Self.Create;
end;

end.
