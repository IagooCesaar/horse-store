unit Loja.Model.Caixa.Types;

interface

uses
  System.Classes,
  System.StrUtils,
  TypInfo;

type
  TLojaModelCaixaMeioPagamento = (
    pagDinheiro,
    pagPix,
    pagCartaoCredito,
    pagCartaoDebito,
    pagCheque
  );

  TLojaModelCaixaMeioPagamentoHelper = record helper for TLojaModelCaixaMeioPagamento
  public
    function ToString: string;
    function Name: string;
    constructor Create(AValue: string); overload;
  end;

implementation

{ TLojaModelCaixaMeioPagamentoHelper }

constructor TLojaModelCaixaMeioPagamentoHelper.Create(AValue: string);
begin
  Self := TLojaModelCaixaMeioPagamento(GetEnumValue(TypeInfo(TLojaModelCaixaMeioPagamento), AValue));
end;

function TLojaModelCaixaMeioPagamentoHelper.Name: string;
begin
  case (Self) of
    pagDinheiro:
      Result := 'Dinheiro';
    pagPix:
      Result := 'Pix';
    pagCartaoCredito:
      Result := 'Cartão de Crédito';
    pagCartaoDebito:
      Result := 'Cartão de Débito';
    pagCheque:
      Result := 'Cheque';
  end;
end;

function TLojaModelCaixaMeioPagamentoHelper.ToString: string;
begin
  Result := GetEnumName(TypeInfo(TLojaModelCaixaMeioPagamento),Integer(Self));
end;

end.
