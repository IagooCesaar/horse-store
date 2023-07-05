unit Loja.Model.Dto.Req.Venda.Item;

interface

uses
  System.Classes,
  System.Generics.Collections,
  GBSwagger.Model.Attributes,

  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Caixa.Types;

type
  TLojaModelDtoReqVendaItem = class
  private
    FNumVnda: Integer;
    FNumSeqItem: Integer;
    FCodItem: Integer;
    FQtdItem: Integer;
    FVrPrecoUnit: Currency;
    FVrBruto: Currency;
    FVrDesc: Currency;
    FVrTotal: Currency;
    FCodSit: TLojaModelEntityVendaItemSituacao;
  public
    [SwagIgnore]
    property NumVnda: Integer read FNumVnda write FNumVnda;
    [SwagIgnore]
    property NumSeqItem: Integer read FNumSeqItem write FNumSeqItem;

    property CodItem: Integer read FCodItem write FCodItem;
    property CodSit: TLojaModelEntityVendaItemSituacao read FCodSit write FCodSit;
    property QtdItem: Integer read FQtdItem write FQtdItem;
    property VrPrecoUnit: Currency read FVrPrecoUnit write FVrPrecoUnit;
    property VrBruto: Currency read FVrBruto write FVrBruto;
    property VrDesc: Currency read FVrDesc write FVrDesc;
    property VrTotal: Currency read FVrTotal write FVrTotal;
  end;

  TLojaModelDtoReqVendaItemLista = TObjectList<TLojaModelDtoReqVendaItem>;

implementation

end.
