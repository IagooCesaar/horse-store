unit Loja.Model.Dto.Req.Caixa.MovimentoAvulso;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  GBSwagger.Model.Attributes,

  Loja.Model.Entity.Caixa.Types;

type
  TLojaModelDtoReqCaixaMovimentoAvulso = class
  private
    FCodCaixa: Integer;
    FVrMov: Currency;
    FDscObs: string;
    FOrigMov: TLojaModelEntityCaixaOrigemMovimento;
  public
    [SwagIgnore]
    property CodCaixa: Integer read FCodCaixa write FCodCaixa;
    [SwagIgnore]
    property OrigMov: TLojaModelEntityCaixaOrigemMovimento read FOrigMov write FOrigMov;

    property VrMov: Currency read FVrMov write FVrMov;
    property DscObs: string read FDscObs write FDscObs;
  end;

implementation

end.
