unit Loja.Model.Preco.PrecoVenda;

interface

uses
  System.Classes,
  System.Generics.Collections;

type
  TLojaModelPrecoPrecoVenda = class
  private
    FCodItem: Integer;
    FDatIni: TDateTime;
    FVrVnda: Currency;
  public
    property CodItem: Integer read FCodItem write FCodItem;
    property DatIni: TDateTime read FDatIni write FDatIni;
    property VrVnda: Currency read FVrVnda write FVrVnda;
  end;

implementation

end.
