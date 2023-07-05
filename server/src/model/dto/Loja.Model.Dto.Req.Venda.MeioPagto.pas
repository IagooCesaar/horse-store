unit Loja.Model.Dto.Req.Venda.MeioPagto;

interface

uses
  System.Classes,
  System.Generics.Collections,
  GBSwagger.Model.Attributes,

  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Caixa.Types;

type
  TLojaModelDtoReqVendaMeioPagamento = class
  private
    FNumVnda: Integer;
    FCodMeioPagto: TLojaModelEntityCaixaMeioPagamento;
    FQtdParc: Integer;
    FVrParc: Currency;
    FNumSeqMeioPagto: Integer;
  public
    [SwagIgnore]
    property NumVnda: Integer read FNumVnda write FNumVnda;

    property NumSeqMeioPagto: Integer read FNumSeqMeioPagto write FNumSeqMeioPagto;
    property CodMeioPagto: TLojaModelEntityCaixaMeioPagamento read FCodMeioPagto write FCodMeioPagto;
    property QtdParc: Integer read FQtdParc write FQtdParc;
    property VrParc: Currency read FVrParc write FVrParc;
  end;

  TLojaModelDtoReqVendaMeioPagamentoLista = TObjectList<TLojaModelDtoReqVendaMeioPagamento>;

implementation

end.
