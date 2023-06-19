unit Loja.Model.Entity.Estoque.Types;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils;

type
  TLojaModelEntityEstoqueTipoMovimento = ( movEntrada, movSaida );

  TLojaModelEntityEstoqueOrigemMovimento = (
    orgCompra, orgVenda, orgAcerto, orgDevolucaoCompra, orgDevolucaoVenda
  );

  type TLojaModelEntityEstoqueTipoMovimentoHelper = record helper for TLojaModelEntityEstoqueTipoMovimento
  public
    function ToString: string;
    constructor Create(AValue: string); overload;
  end;

  TLojaModelEntityEstoqueOrigemMovimentoHelper = record helper for TLojaModelEntityEstoqueOrigemMovimento
  public
    function ToString: string;
    constructor Create(AValue: string); overload;
  end;

const
  ESTOQUE_MOVIMENTOS_ENTRADA = [orgCompra, orgAcerto, orgDevolucaoVenda];
  ESTOQUE_MOVIMENTOS_SAIDA = [orgVenda, orgAcerto, orgDevolucaoCompra];

implementation

{ TLojaModelEntityEstoqueOrigemMovimentoHelper }

constructor TLojaModelEntityEstoqueOrigemMovimentoHelper.Create(AValue: string);
begin
  case AnsiIndexStr(AValue, ['CO', 'VE', 'AC', 'DC', 'DV']) of
    0: Self := orgCompra;
    1: Self := orgVenda;
    2: Self := orgAcerto;
    3: Self := orgDevolucaoCompra;
    4: Self := orgDevolucaoVenda;
  end;
end;

function TLojaModelEntityEstoqueOrigemMovimentoHelper.ToString: string;
begin
  case (Self) of
    orgCompra:
      Result := 'CO';
    orgVenda:
      Result := 'VE';
    orgAcerto:
      Result := 'AC';
    orgDevolucaoCompra:
      Result := 'DC';
    orgDevolucaoVenda:
      Result := 'DV';
  end;
end;

{ TLojaModelEntityEstoqueTipoMovimentoHelper }

constructor TLojaModelEntityEstoqueTipoMovimentoHelper.Create(AValue: string);
begin
  case AnsiIndexStr(AValue, ['E', 'S']) of
    0: Self := movEntrada;
    1: Self := movSaida;
  end;
end;

function TLojaModelEntityEstoqueTipoMovimentoHelper.ToString: string;
begin
  case (Self) of
    movEntrada:
      Result := 'E';
    movSaida:
      Result := 'S';
  end;
end;

end.
