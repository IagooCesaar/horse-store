unit Loja.Model.Entity.Venda.MeioPagto;

interface

uses
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Caixa.Types;

type
  TLojaModelEntityVendaMeioPagto = class
  private
    FNumVnda: Integer;
    FCodMeioPagto: TLojaModelEntityCaixaMeioPagamento;
    FQtdParc: Integer;
    FVrTotal: Currency;
    FNumSeqMeioPagto: Integer;
  public
    property NumVnda: Integer read FNumVnda write FNumVnda;
    property NumSeqMeioPagto: Integer read FNumSeqMeioPagto write FNumSeqMeioPagto;
    property CodMeioPagto: TLojaModelEntityCaixaMeioPagamento read FCodMeioPagto write FCodMeioPagto;
    property QtdParc: Integer read FQtdParc write FQtdParc;
    property VrTotal: Currency read FVrTotal write FVrTotal;
  end;

  TLojaModelEntityVendaMeioPagtoLista = TObjectList<TLojaModelEntityVendaMeioPagto>;

implementation

end.
