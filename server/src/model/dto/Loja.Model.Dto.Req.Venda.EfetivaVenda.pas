unit Loja.Model.Dto.Req.Venda.EfetivaVenda;

interface

uses
  System.Classes,
  GBSwagger.Model.Attributes;

type
  TLojaModelDtoReqVendaEfetivaVenda = class
  private
    FNumVnda: Integer;
    FVrDesc: Currency;
  public
    [SwagIgnore]
    property NumVnda: Integer read FNumVnda write FNumVnda;
    property VrDesc: Currency read FVrDesc write FVrDesc;
  end;

implementation

end.
