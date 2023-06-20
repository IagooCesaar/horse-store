unit Loja.Model.Entity.Caixa.Movimento;

interface

uses
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Caixa.Types;

type
  TLojaModelEntityCaixaMovimento = class
  private
    FCodCaixa: integer;
    FCodMeioPagto: TLojaModelEntityCaixaMeioPagamento;
    FCodTipoMov: TLojaModelEntityCaixaTipoMovimento;
    FCodOrigMov: TLojaModelEntityCaixaOrigemMovimento;
    FVrMov: Currency;
    FDatMov: TDateTime;
  public
    property CodCaixa: integer read FCodCaixa write FCodCaixa;
    property CodTipoMov: TLojaModelEntityCaixaTipoMovimento read FCodTipoMov write FCodTipoMov;
    property CodMeioPagto: TLojaModelEntityCaixaMeioPagamento read FCodMeioPagto write FCodMeioPagto;
    property CodOrigMov: TLojaModelEntityCaixaOrigemMovimento read FCodOrigMov write FCodOrigMov;
    property VrMov: Currency read FVrMov write FVrMov;
    property DatMov: TDateTime read FDatMov write FDatMov;
  end;

  TLojaModelEntityCaixaMovimentoLista = TObjectList<TLojaModelEntityCaixaMovimento>;

implementation

end.
