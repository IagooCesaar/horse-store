unit Loja.Model.Caixa;

interface

uses
  System.SysUtils,
  System.Classes,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Caixa.Caixa;

type
  TLojaModelCaixa = class(TInterfacedObject, ILojaModelCaixa)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelCaixa;

    { ILojaModelCaixa }
    function ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Factory,
  Loja.Model.Bo.Factory;

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

function TLojaModelCaixa.ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
begin
  Result := TLojaModelBoFactory.New.Caixa
    .ObterCaixaAberto;
end;

end.
