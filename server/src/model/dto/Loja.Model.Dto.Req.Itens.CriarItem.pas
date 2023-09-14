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
    FFlgPermSaldNeg: boolean;
    FFlgTabPreco: boolean;

  public
    [SwagIgnore]
    property CodItem: Integer read FCodItem write FCodItem;

    property NomItem: String read FNomItem write FNomItem;
    property NumCodBarr: string read FNumCodBarr write FNumCodBarr;
    property FlgPermSaldNeg: boolean read FFlgPermSaldNeg write FFlgPermSaldNeg;
    property FlgTabPreco: boolean read FFlgTabPreco write FFlgTabPreco;

    constructor Create;
  end;

implementation

{ TLojaModelDtoReqItensCriarItem }

constructor TLojaModelDtoReqItensCriarItem.Create;
begin
  Self.FFlgPermSaldNeg := False;
  Self.FFlgTabPreco := True;
end;

end.
