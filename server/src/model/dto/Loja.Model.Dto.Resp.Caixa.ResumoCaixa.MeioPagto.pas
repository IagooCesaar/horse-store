unit Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Caixa.Types;

type
  TLojaModelDtoRespCaixaResumoCaixaMeioPagto = class;
  TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista = TObjectList<TLojaModelDtoRespCaixaResumoCaixaMeioPagto>;

  TLojaModelDtoRespCaixaResumoCaixaMeioPagto = class
  private
    FCodMeioPagto: TLojaModelEntityCaixaMeioPagamento;
    FVrTotal: Currency;
  public
    property CodMeioPagto: TLojaModelEntityCaixaMeioPagamento read FCodMeioPagto write FCodMeioPagto;
    property VrTotal: Currency read FVrTotal write FVrTotal;
  end;

implementation


end.
