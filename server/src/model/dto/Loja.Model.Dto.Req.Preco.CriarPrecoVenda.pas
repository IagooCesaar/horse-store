unit Loja.Model.Dto.Req.Preco.CriarPrecoVenda;

interface

uses
  System.Classes,
  System.Generics.Collections,

  GBSwagger.Model.Attributes;

type
  TLojaModelDtoReqPrecoCriarPrecoVenda = class
  private
    FCodItem: Integer;
    FDatIni: TDateTime;
    FVrVnda: Currency;
  public
    [SwagIgnore]
    property CodItem: Integer read FCodItem write FCodItem;
    property DatIni: TDateTime read FDatIni write FDatIni;
    property VrVnda: Currency read FVrVnda write FVrVnda;
  end;

  TLojaModelDtoReqPrecoCriarPrecoVendaLista = TObjectList<TLojaModelDtoReqPrecoCriarPrecoVenda>;

implementation

end.

