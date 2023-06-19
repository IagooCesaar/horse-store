unit Loja.Model.Entity.Caixa.Types;

interface

uses
  System.Classes,
  System.StrUtils;

type
  TLojaModelEntityCaixaMeioPagamento = (
    pagDinheiro,
    pagPix,
    pagCartaoCredito,
    pagCartaoDebito,
    pagCheque
  );

  TLojaModelEntityCaixaTipoMovimento = (
    movEntrada,
    movSaida
  );

  TLojaModelEntityCaixaOrigemMovimento = (
    orgVenda,
    orgDevolucaoVenda,
    orgCompra,
    orgDevolucaoCompra,
    orgSangria,
    orgReforco
  );

  TMeioPagamentoHelper = record helper for TLojaModelEntityCaixaMeioPagamento
  public
    function ToString: string;
    constructor Create(AValue: string); overload;
  end;

  TTipoMovimentoHelper = record helper for TLojaModelEntityCaixaTipoMovimento
  public
    function ToString: string;
    constructor Create(AValue: string); overload;
  end;

  TOrigemMovimentoHelper = record helper for TLojaModelEntityCaixaOrigemMovimento
  public
    function ToString: string;
    constructor Create(AValue: string); overload;
  end;

const
  CAIXA_MOVIMENTOS_ENTRADA = [orgVenda, orgDevolucaoCompra, orgReforco];
  CAIXA_MOVIMENTOS_SAIDA = [orgCompra, orgDevolucaoVenda, orgSangria];
  CAIXA_MEIO_PAGAMENTO_COMUM = [pagDinheiro, pagCheque];
  CAIXA_MEIO_PAGAMENTO_DIGITAL = [pagPix, pagCartaoCredito, pagCartaoDebito];

implementation

{ TMeioPagamentoHelper }

constructor TMeioPagamentoHelper.Create(AValue: string);
begin
  case AnsiIndexStr(AValue,['DN', 'PX', 'CC', 'CD', 'CH']) of
    0: Self := pagDinheiro;
    1: Self := pagPix;
    2: Self := pagCartaoCredito;
    3: Self := pagCartaoDebito;
    4: Self := pagCheque;
  end;
end;

function TMeioPagamentoHelper.ToString: string;
begin
  case (Self) of
    pagDinheiro:
      Result := 'DN';
    pagPix:
      Result := 'PX';
    pagCartaoCredito:
      Result := 'CC';
    pagCartaoDebito:
      Result := 'CD';
    pagCheque:
      Result := 'CH';
  end;
end;

{ TTipoMovimentoHelper }

constructor TTipoMovimentoHelper.Create(AValue: string);
begin
  case AnsiIndexStr(AValue,['E', 'S']) of
    0: Self := movEntrada;
    1: Self := movSaida;
  end;
end;

function TTipoMovimentoHelper.ToString: string;
begin
  case (Self) of
    movEntrada:
      Result := 'E';
    movSaida:
      Result := 'S';
  end;
end;

{ TOrigemMovimentoHelper }

constructor TOrigemMovimentoHelper.Create(AValue: string);
begin
  case AnsiIndexStr(AValue,['VE', 'DV', 'CO', 'DC', 'SG', 'RF']) of
    0: Self := orgVenda;
    1: Self := orgDevolucaoVenda;
    2: Self := orgCompra;
    3: Self := orgDevolucaoCompra;
    4: Self := orgSangria;
    5: Self := orgReforco;
  end;
end;

function TOrigemMovimentoHelper.ToString: string;
begin
  case (Self) of
    orgVenda:
      Result := 'VE';
    orgDevolucaoVenda:
      Result := 'DV';
    orgCompra:
      Result := 'CO';
    orgDevolucaoCompra:
      Result := 'DC';
    orgSangria:
      Result := 'SG';
    orgReforco:
      Result := 'RF';
  end;
end;

end.
