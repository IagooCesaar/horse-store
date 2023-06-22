unit Loja.Model.Bo.Caixa;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Bo.Interfaces,
  Loja.Model.Entity.Caixa.Caixa;

type
  TLojaModelBoCaixa = class(TInterfacedObject, ILojaModelBoCaixa)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelBoCaixa;

    { ILojaModelBoCaixa }
    function ObterCaixaAberto: TLojaModelEntityCaixaCaixa;

  end;

implementation

uses

  Loja.Model.Dao.Factory;

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

function TLojaModelBoCaixa.ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
begin
  Result := TLojaModelDaoFactory.New.Caixa
    .Caixa
    .ObterCaixaAberto;
end;

end.
