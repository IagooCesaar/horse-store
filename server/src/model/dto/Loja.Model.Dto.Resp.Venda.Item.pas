unit Loja.Model.Dto.Resp.Venda.Item;

interface

uses
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Venda.Types;

type
  TLojaModelDtoRespVendaItem = class
  private
    FNumVnda: Integer;
    FNumSeqItem: Integer;
    FCodItem: Integer;
    FNomItem: String;
    FFlgTabPreco: Boolean;
    FQtdItem: Integer;
    FVrPrecoUnit: Currency;
    FVrBruto: Currency;
    FVrDesc: Currency;
    FVrTotal: Currency;
    FCodSit: TLojaModelEntityVendaItemSituacao;
  public
    property NumVnda: Integer read FNumVnda write FNumVnda;
    property NumSeqItem: Integer read FNumSeqItem write FNumSeqItem;
    property CodItem: Integer read FCodItem write FCodItem;
    property NomItem: String read FNomItem write FNomItem;
    property FlgTabPreco: Boolean read FFlgTabPreco write FFlgTabPreco;
    property CodSit: TLojaModelEntityVendaItemSituacao read FCodSit write FCodSit;
    property QtdItem: Integer read FQtdItem write FQtdItem;
    property VrPrecoUnit: Currency read FVrPrecoUnit write FVrPrecoUnit;
    property VrBruto: Currency read FVrBruto write FVrBruto;
    property VrDesc: Currency read FVrDesc write FVrDesc;
    property VrTotal: Currency read FVrTotal write FVrTotal;
  end;

  TLojaModelDtoRespVendaItemLista = TObjectList<TLojaModelDtoRespVendaItem>;

implementation

end.
