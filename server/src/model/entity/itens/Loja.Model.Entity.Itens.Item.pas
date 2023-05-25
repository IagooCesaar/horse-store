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
  public
    property CodItem: Integer read FCodItem write FCodItem;
    property NomItem: String read FNomItem write FNomItem;
    property NumCodBarr: string read FNumCodBarr write FNumCodBarr;
  end;


implementation

end.
