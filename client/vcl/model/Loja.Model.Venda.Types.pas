unit Loja.Model.Venda.Types;

interface

uses
  System.Classes,
  System.StrUtils,
  TypInfo;

type
  TLojaModelVendaSituacao = (
    sitPendente,
    sitCancelada,
    sitEfetivada
  );

  TLojaModelVendaItemSituacao = (
    sitAtivo,
    sitRemovido
  );

  TLojaModelVendaSituacaoHelper = record helper for TLojaModelVendaSituacao
  public
    function Name: string;
    function FriendlyName: string;
    constructor CreateByName(AValue: string); overload;
  end;

implementation

{ TLojaModelVendaSituacaoHelper }

function TLojaModelVendaSituacaoHelper.FriendlyName: string;
begin
  case Self of
    sitPendente:
      Result := 'Pendente';
    sitCancelada:
      Result := 'Cancelada';
    sitEfetivada:
      Result := 'Efetivada';
  end;
end;

function TLojaModelVendaSituacaoHelper.Name: string;
begin
  Result := GetEnumName(TypeInfo(TLojaModelVendaSituacao),Integer(Self));
end;

constructor TLojaModelVendaSituacaoHelper.CreateByName(AValue: string);
begin
  Self := TLojaModelVendaSituacao(GetEnumValue(TypeInfo(TLojaModelVendaSituacao), AValue));
end;

end.
