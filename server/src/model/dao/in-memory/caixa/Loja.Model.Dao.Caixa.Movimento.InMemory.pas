unit Loja.Model.Dao.Caixa.Movimento.InMemory;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Caixa.Interfaces,
  Loja.Model.Entity.Caixa.Movimento,
  Loja.Model.Dto.Req.Caixa.CriarMovimento;

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
    function ObterMovimentoPorCodigo(ACodMov: Integer): TLojaModelEntityCaixaMovimento;
    function ObterMovimentoPorCaixa(ACodCaixa: Integer): TLojaModelEntityCaixaMovimentoLista;
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
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

function TLojaModelDaoCaixaMovimentoInMemory.CriarNovoMovimento(
  ANovoMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
begin

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

function TLojaModelDaoCaixaMovimentoInMemory.ObterMovimentoPorCaixa(
  ACodCaixa: Integer): TLojaModelEntityCaixaMovimentoLista;
begin

end;

function TLojaModelDaoCaixaMovimentoInMemory.ObterMovimentoPorCodigo(
  ACodMov: Integer): TLojaModelEntityCaixaMovimento;
begin

end;

class destructor TLojaModelDaoCaixaMovimentoInMemory.UnInitialize;
begin
  if FDao <> nil
  then FreeAndNil(FDao);
end;

end.
