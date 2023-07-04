unit Loja.Model.Entity.Venda.Venda;

interface

uses
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Venda.Types;

type
  TLojaModelEntityVendaVenda = class
  private
    FNumVnda: Integer;
    FDatIncl: TDateTime;
    FDatEfet: TDateTime;
    FVrBruto: Currency;
    FVrDesc: Currency;
    FVrTotal: Currency;
    FCodSit: TLojaModelEntityVendaSituacao;
  public
    property NumVnda: Integer read FNumVnda write FNumVnda;
    property CodSit: TLojaModelEntityVendaSituacao read FCodSit write FCodSit;
    property DatIncl: TDateTime read FDatIncl write FDatIncl;
    property DatEfet: TDateTime read FDatEfet write FDatEfet;
    property VrBruto: Currency read FVrBruto write FVrBruto;
    property VrDesc: Currency read FVrDesc write FVrDesc;
    property VrTotal: Currency read FVrTotal write FVrTotal;
  end;

  TLojaModelEntityVendaVendaLista = TObjectList<TLojaModelEntityVendaVenda>;

implementation

end.
