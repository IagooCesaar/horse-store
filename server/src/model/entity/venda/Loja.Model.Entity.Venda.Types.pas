unit Loja.Model.Entity.Venda.Types;

interface

uses
  System.Classes,
  System.StrUtils,
  TypInfo;

type
  TLojaModelEntityVendaSituacao = (
    sitPendente,
    sitCancelada,
    sitEfetivada
  );

  TLojaModelEntityVendaItemSituacao = (
    sitAtivo,
    sitRemovido
  );


  TLojaModelEntityVendaSituacaoHelper = record helper for TLojaModelEntityVendaSituacao
  public
    function ToString: string;
    function Name: string;
    constructor Create(AValue: string); overload;
    constructor CreateByName(AValue: string); overload;
  end;

  TLojaModelEntityVendaItemSituacaoHelper = record helper for TLojaModelEntityVendaItemSituacao
  public
    function ToString: string;
    constructor Create(AValue: string); overload;
  end;

implementation

{ TLojaModelEntityVendaSituacaoHelper }

constructor TLojaModelEntityVendaSituacaoHelper.Create(AValue: string);
begin
  case AnsiIndexStr(AValue, ['P', 'C', 'E']) of
    0: Self := sitPendente;
    1: Self := sitCancelada;
    2: Self := sitEfetivada;
  end;
end;

constructor TLojaModelEntityVendaSituacaoHelper.CreateByName(AValue: string);
begin
  Self := TLojaModelEntityVendaSituacao(GetEnumValue(TypeInfo(TLojaModelEntityVendaSituacao), AValue));
end;

function TLojaModelEntityVendaSituacaoHelper.Name: string;
begin
  Result := GetEnumName(TypeInfo(TLojaModelEntityVendaSituacao),Integer(Self));
end;

function TLojaModelEntityVendaSituacaoHelper.ToString: string;
begin
  case Self of
    sitPendente:
      Result := 'P';
    sitCancelada:
      Result := 'C';
    sitEfetivada:
      Result := 'E';
  end;
end;

{ TLojaModelEntityVendaItemSituacaoHelper }

constructor TLojaModelEntityVendaItemSituacaoHelper.Create(AValue: string);
begin
  case AnsiIndexStr(AValue, ['A', 'R']) of
    0: Self := sitAtivo;
    1: Self := sitRemovido;
  end;
end;

function TLojaModelEntityVendaItemSituacaoHelper.ToString: string;
begin
  case Self of
    sitAtivo:
      Result := 'A';
    sitRemovido:
      Result := 'R';
  end;
end;

end.
