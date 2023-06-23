unit Loja.Model.Dto.Req.Caixa.CriarMovimento;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  GBSwagger.Model.Attributes,

  Loja.Model.Entity.Caixa.Types;

type
  TLojaModelDtoReqCaixaCriarMovimento = class
  private
    FCodCaixa: integer;
    FCodMeioPagto: TLojaModelEntityCaixaMeioPagamento;
    FCodTipoMov: TLojaModelEntityCaixaTipoMovimento;
    FCodOrigMov: TLojaModelEntityCaixaOrigemMovimento;
    FVrMov: Currency;
    FDatMov: TDateTime;
    FDscObs: string;
    FCodMov: Integer;
  public
    [SwagIgnore]
    property CodCaixa: integer read FCodCaixa write FCodCaixa;
    [SwagIgnore]
    property CodTipoMov: TLojaModelEntityCaixaTipoMovimento read FCodTipoMov write FCodTipoMov;
    [SwagIgnore]
    property CodMeioPagto: TLojaModelEntityCaixaMeioPagamento read FCodMeioPagto write FCodMeioPagto;
    [SwagIgnore]
    property CodOrigMov: TLojaModelEntityCaixaOrigemMovimento read FCodOrigMov write FCodOrigMov;
    [SwagIgnore]
    property DatMov: TDateTime read FDatMov write FDatMov;

    property VrMov: Currency read FVrMov write FVrMov;
    property DscObs: string read FDscObs write FDscObs;
  end;

implementation

end.
