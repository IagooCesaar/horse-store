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
  public
    [SwagIgnore]
    property CodItem: Integer read FCodItem write FCodItem;

    property NomItem: String read FNomItem write FNomItem;
    property NumCodBarr: string read FNumCodBarr write FNumCodBarr;
  end;

implementation

end.
