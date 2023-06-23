unit Loja.Model.Dto.Req.Caixa.Abertura;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  GBSwagger.Model.Attributes;

type
  TLojaModelDtoReqCaixaAbertura = class
  private
    FVrAbert: Currency;
    FDatAbert: TDateTime;
  public
    [SwagIgnore]
    property DatAbert: TDateTime read FDatAbert write FDatAbert;
    property VrAbert: Currency read FVrAbert write FVrAbert;
  end;

implementation

end.
