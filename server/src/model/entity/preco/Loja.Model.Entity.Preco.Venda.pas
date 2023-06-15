unit Loja.Model.Entity.Preco.Venda;

interface

uses
  System.Classes,
  System.Generics.Collections;

type
  TLojaModelEntityPrecoVenda = class
  private
    FCodItem: Integer;
    FDatIni: TDateTime;
    FVrVnda: Currency;
  public
    property CodItem: Integer read FCodItem write FCodItem;
    property DatIni: TDateTime read FDatIni write FDatIni;
    property VrVnda: Currency read FVrVnda write FVrVnda;
  end;

  TLojaModelEntityPrecoVendaLista = TObjectList<TLojaModelEntityPrecoVenda>;

implementation

end.
