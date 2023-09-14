unit Loja.Model.Dto.Resp.Itens.Item;

interface

uses
  System.Classes,
  System.Generics.Collections;

type
  TLojaModelDtoRespItensItem = class
  private
    FCodItem: Integer;
    FNomItem: String;
    FNumCodBarr: string;
    FFlgPermSaldNeg: Boolean;
    FFlgTabPreco: Boolean;
  public
    property CodItem: Integer read FCodItem write FCodItem;
    property NomItem: String read FNomItem write FNomItem;
    property NumCodBarr: string read FNumCodBarr write FNumCodBarr;
    property FlgPermSaldNeg: Boolean read FFlgPermSaldNeg write FFlgPermSaldNeg;
    property FlgTabPreco: Boolean read FFlgTabPreco write FFlgTabPreco;
  end;

  TLojaModelDtoRespItensItemLista = TObjectList<TLojaModelDtoRespItensItem>;

implementation

end.
