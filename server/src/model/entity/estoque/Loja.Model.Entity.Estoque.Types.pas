unit Loja.Model.Entity.Estoque.Types;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TLojaModelEntityEstoqueTipoMovimento = ( movEntrada, movSaida );

  TLojaModelEntityEstoqueOrigemMovimento = (
    orgCompra, orgVenda, orgAcerto, orgDevolucaoCompra, orgDevolucaoVenda
  );

const
  ESTOQUE_TIPO_MOVIMENTO: array[TLojaModelEntityEstoqueTipoMovimento]
    of string = ('E', 'S');
  ESTOQUE_ORIGEM_MOVIMENTO: array[TLojaModelEntityEstoqueOrigemMovimento]
    of string = ('CO', 'VE', 'AC', 'DC', 'DV');

implementation

end.
