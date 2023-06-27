unit Loja.Model.Dto.Req.Caixa.Fechamento;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  GBSwagger.Model.Attributes,

  Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto;

type
  TLojaModelDtoReqCaixaFechamento = class
  private
    FCodCaixa: Integer;
    FMeiosPagto: TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista;
  public
    [SwagIgnore]
    property CodCaixa: Integer read FCodCaixa write FCodCaixa;

    property MeiosPagto: TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista read FMeiosPagto write FMeiosPagto;
  end;

implementation

end.
