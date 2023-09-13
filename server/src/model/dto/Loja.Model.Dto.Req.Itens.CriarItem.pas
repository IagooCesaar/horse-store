unit Loja.Model.Dto.Req.Itens.CriarItem;

interface

uses
  System.Classes,
  System.SysUtils,

  GBSwagger.Model.Attributes;

type
  TLojaModelDtoReqItensCriarItem = class
  private
    FNomItem: String;
    FNumCodBarr: string;
    FCodItem: Integer;
    FFlgPermSaldNeg: string;
    FFlgTabPreco: string;

  public
    [SwagIgnore]
    property CodItem: Integer read FCodItem write FCodItem;

    property NomItem: String read FNomItem write FNomItem;
    property NumCodBarr: string read FNumCodBarr write FNumCodBarr;
    property FlgPermSaldNeg: string read FFlgPermSaldNeg write FFlgPermSaldNeg;
    property FlgTabPreco: string read FFlgTabPreco write FFlgTabPreco;
  end;

implementation

end.
