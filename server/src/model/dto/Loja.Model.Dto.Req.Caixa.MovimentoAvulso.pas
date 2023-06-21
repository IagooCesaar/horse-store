unit Loja.Model.Dto.Req.Caixa.MovimentoAvulso;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Caixa.Types;

type
  TLojaModelDtoReqCaixaMovimentoAvulso = class
  private
    FCodCaixa: Integer;
    FVrMov: Currency;
    FDscMotv: string;
    FOrigMov: TLojaModelEntityCaixaOrigemMovimento;
  public
    property CodCaixa: Integer read FCodCaixa write FCodCaixa;
    property VrMov: Currency read FVrMov write FVrMov;
    property DscMotv: string read FDscMotv write FDscMotv;
    property OrigMov: TLojaModelEntityCaixaOrigemMovimento read FOrigMov write FOrigMov;
  end;

implementation

end.
