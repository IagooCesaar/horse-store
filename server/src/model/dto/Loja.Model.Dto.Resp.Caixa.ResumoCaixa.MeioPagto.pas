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

  TLojaModelDtoRespCaixaResumoCaixaMeioPagtoListaHelper = class helper for TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista
  public
    function Get(ACodMeioPagto: TLojaModelEntityCaixaMeioPagamento): TLojaModelDtoRespCaixaResumoCaixaMeioPagto;
  end;

implementation


{ TLojaModelDtoRespCaixaResumoCaixaMeioPagtoListaHelper }

function TLojaModelDtoRespCaixaResumoCaixaMeioPagtoListaHelper.Get(
  ACodMeioPagto: TLojaModelEntityCaixaMeioPagamento): TLojaModelDtoRespCaixaResumoCaixaMeioPagto;
begin
  Result := nil;
  for var LMeioPgto in Self
  do
    if LMeioPgto.CodMeioPagto = ACodMeioPagto
    then begin
      Result := LMeioPgto;
      Break;
    end;

  if Result = nil
  then begin
    Self.Add(TLojaModelDtoRespCaixaResumoCaixaMeioPagto.Create);
    Self.Last.CodMeioPagto := ACodMeioPagto;
    Self.Last.VrTotal := 0;
    Result := Self.Last;
  end;
end;

end.
