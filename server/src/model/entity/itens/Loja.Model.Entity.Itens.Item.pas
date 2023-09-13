unit Loja.Model.Entity.Itens.Item;

interface

uses
  System.Classes,
  System.Generics.Collections;

type
  TLojaModelEntityItensItem = class
  private
    FCodItem: Integer;
    FNomItem: String;
    FNumCodBarr: string;
    FFlgPermSaldNeg: string;
    FFlgTabPreco: string;
  public
    property CodItem: Integer read FCodItem write FCodItem;
    property NomItem: String read FNomItem write FNomItem;
    property NumCodBarr: string read FNumCodBarr write FNumCodBarr;
    property FlgPermSaldNeg: string read FFlgPermSaldNeg write FFlgPermSaldNeg;
    property FlgTabPreco: string read FFlgTabPreco write FFlgTabPreco;

  end;

  TLojaModelEntityItensItemLista = TObjectList<TLojaModelEntityItensItem>;


implementation

end.
