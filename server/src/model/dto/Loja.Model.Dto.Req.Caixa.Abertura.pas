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
    FVrAbertura: Currency;
    FDatAbert: TDateTime;
  public
    [SwagIgnore]
    property DatAbert: TDateTime read FDatAbert write FDatAbert;
    property VrAbertura: Currency read FVrAbertura write FVrAbertura;
  end;

implementation

end.
