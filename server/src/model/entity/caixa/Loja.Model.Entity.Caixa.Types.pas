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
    pagVoucher,
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

  TLojaModelEntityCaixaSituacao = (
    sitAberto,
    sitFechado
  );

  TLojaModelEntityCaixaMeioPagamentoHelper = record helper for TLojaModelEntityCaixaMeioPagamento
  public
    function ToString: string;
    function Name: string;
    constructor Create(AValue: string); overload;
  end;

  TLojaModelEntityCaixaTipoMovimentoHelper = record helper for TLojaModelEntityCaixaTipoMovimento
  public
    function ToString: string;
    constructor Create(AValue: string); overload;
  end;

  TLojaModelEntityCaixaOrigemMovimentoHelper = record helper for TLojaModelEntityCaixaOrigemMovimento
  public
    function ToString: string;
    constructor Create(AValue: string); overload;
  end;

  TLojaModelEntityCaixaSituacaoHelper = record helper for TLojaModelEntityCaixaSituacao
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

constructor TLojaModelEntityCaixaMeioPagamentoHelper.Create(AValue: string);
begin
  case AnsiIndexStr(AValue,['DN', 'PX', 'CC', 'CD', 'VO', 'CH']) of
    0: Self := pagDinheiro;
    1: Self := pagPix;
    2: Self := pagCartaoCredito;
    3: Self := pagCartaoDebito;
    4: Self := pagVoucher;
    5: Self := pagCheque;
  end;
end;

function TLojaModelEntityCaixaMeioPagamentoHelper.Name: string;
begin
  case (Self) of
    pagDinheiro:
      Result := 'Dinheiro';
    pagPix:
      Result := 'Pix';
    pagCartaoCredito:
      Result := 'Cart�o de Cr�dito';
    pagCartaoDebito:
      Result := 'Cart�o de D�bito';
    pagVoucher:
      Result := 'Voucher';
    pagCheque:
      Result := 'Cheque';
  end;
end;

function TLojaModelEntityCaixaMeioPagamentoHelper.ToString: string;
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
    pagVoucher:
      Result := 'VO';
    pagCheque:
      Result := 'CH';
  end;
end;

{ TTipoMovimentoHelper }

constructor TLojaModelEntityCaixaTipoMovimentoHelper.Create(AValue: string);
begin
  case AnsiIndexStr(AValue,['E', 'S']) of
    0: Self := movEntrada;
    1: Self := movSaida;
  end;
end;

function TLojaModelEntityCaixaTipoMovimentoHelper.ToString: string;
begin
  case (Self) of
    movEntrada:
      Result := 'E';
    movSaida:
      Result := 'S';
  end;
end;

{ TOrigemMovimentoHelper }

constructor TLojaModelEntityCaixaOrigemMovimentoHelper.Create(AValue: string);
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

function TLojaModelEntityCaixaOrigemMovimentoHelper.ToString: string;
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

{ TLojaModelEntityCaixaSituacaoHelper }

constructor TLojaModelEntityCaixaSituacaoHelper.Create(AValue: string);
begin
  case AnsiIndexStr(AValue, ['A', 'F']) of
    0: Self := sitAberto;
    1: Self := sitFechado;
  end;
end;

function TLojaModelEntityCaixaSituacaoHelper.ToString: string;
begin
  case (Self) of
    sitAberto:
      Result := 'A';
    sitFechado:
      Result := 'F';
  end;
end;

end.
