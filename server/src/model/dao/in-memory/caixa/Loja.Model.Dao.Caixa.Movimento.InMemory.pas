unit Loja.Model.Dao.Caixa.Movimento.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Caixa.Interfaces,
  Loja.Model.Entity.Caixa.Movimento;

type
  TLojaModelDaoCaixaMovimentoInMemory = class(TInterfacedObject, ILojaModelDaoCaixaMovimento)
  private
    FRepository: TLojaModelEntityCaixaMovimentoLista;
    function Clone(ASource: TLojaModelEntityCaixaMovimento): TLojaModelEntityCaixaMovimento;

    class var FDao: TLojaModelDaoCaixaMovimentoInMemory;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function GetInstance: ILojaModelDaoCaixaMovimento;
    class destructor UnInitialize;

    { ILojaModelDaoCaixaMovimento }
  end;

implementation

{ TLojaModelDaoCaixaMovimentoInMemory }

function TLojaModelDaoCaixaMovimentoInMemory.Clone(
  ASource: TLojaModelEntityCaixaMovimento): TLojaModelEntityCaixaMovimento;
begin
  Result := TLojaModelEntityCaixaMovimento.Create;

end;

constructor TLojaModelDaoCaixaMovimentoInMemory.Create;
begin
  FRepository := TLojaModelEntityCaixaMovimentoLista.Create;
end;

destructor TLojaModelDaoCaixaMovimentoInMemory.Destroy;
begin
  FreeAndNil(FRepository);
  inherited;
end;

class function TLojaModelDaoCaixaMovimentoInMemory.GetInstance: ILojaModelDaoCaixaMovimento;
begin
  if FDao = nil
  then FDao := TLojaModelDaoCaixaMovimentoInMemory.Create;
  Result := FDao;
end;

class destructor TLojaModelDaoCaixaMovimentoInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNil(FDao);
end;

end.
