unit Loja.Model.Caixa.ResumoMeioPagto;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Caixa.Types;

type
  TLojaModelCaixaResumoMeioPagto = class;
  TLojaModelCaixaResumoMeioPagtoLista = TObjectList<TLojaModelCaixaResumoMeioPagto>;

  TLojaModelCaixaResumoMeioPagto = class
  private
    FCodMeioPagto: TLojaModelCaixaMeioPagamento;
    FVrTotal: Currency;
  public
    property CodMeioPagto: TLojaModelCaixaMeioPagamento read FCodMeioPagto write FCodMeioPagto;
    property VrTotal: Currency read FVrTotal write FVrTotal;
  end;

  TLojaModelDtoRespCaixaResumoCaixaMeioPagtoListaHelper = class helper for TLojaModelCaixaResumoMeioPagtoLista
  public
    function Get(ACodMeioPagto: TLojaModelCaixaMeioPagamento): TLojaModelCaixaResumoMeioPagto;
  end;

implementation


{ TLojaModelDtoRespCaixaResumoCaixaMeioPagtoListaHelper }

function TLojaModelDtoRespCaixaResumoCaixaMeioPagtoListaHelper.Get(
  ACodMeioPagto: TLojaModelCaixaMeioPagamento): TLojaModelCaixaResumoMeioPagto;
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
    Self.Add(TLojaModelCaixaResumoMeioPagto.Create);
    Self.Last.CodMeioPagto := ACodMeioPagto;
    Self.Last.VrTotal := 0;
    Result := Self.Last;
  end;
end;

end.
