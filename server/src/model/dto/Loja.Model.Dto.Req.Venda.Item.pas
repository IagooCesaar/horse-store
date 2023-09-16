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
    FVrDesc: Currency;
    FCodSit: TLojaModelEntityVendaItemSituacao;
  public
    [SwagIgnore]
    property NumVnda: Integer read FNumVnda write FNumVnda;
    [SwagIgnore]
    property NumSeqItem: Integer read FNumSeqItem write FNumSeqItem;

    property CodItem: Integer read FCodItem write FCodItem;
    property CodSit: TLojaModelEntityVendaItemSituacao read FCodSit write FCodSit;
    property QtdItem: Integer read FQtdItem write FQtdItem;

    [SwagProp('Valor unit�rio do item - necess�rio informar quando item n�o utilizar tabela de pre�o de venda', false)]
    property VrPrecoUnit: Currency read FVrPrecoUnit write FVrPrecoUnit;

    property VrDesc: Currency read FVrDesc write FVrDesc;
  end;

  TLojaModelDtoReqVendaItemLista = TObjectList<TLojaModelDtoReqVendaItem>;

implementation

end.
