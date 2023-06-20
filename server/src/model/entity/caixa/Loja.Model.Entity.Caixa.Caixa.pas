unit Loja.Model.Entity.Caixa.Caixa;

interface

uses
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Caixa.Types;

type
  TLojaModelEntityCaixaCaixa = class
  private
    FCodCaixa: integer;
    FCodSit: TLojaModelEntityCaixaSituacao;
    FDatAbert: TDateTime;
    FDatFecha: TDateTime;
    FVrAbert: Currency;
    FVrFecha: Currency;
  public
    property CodCaixa: integer read FCodCaixa write FCodCaixa;
    property CodSit: TLojaModelEntityCaixaSituacao read FCodSit write FCodSit;
    property DatAbert: TDateTime read FDatAbert write FDatAbert;
    property DatFecha: TDateTime read FDatFecha write FDatFecha;
    property VrAbert: Currency read FVrAbert write FVrAbert;
    property VrFecha: Currency read FVrFecha write FVrFecha;
  end;

  TLojaModelEntityCaixaCaixaLista = TObjectList<TLojaModelEntityCaixaCaixa>;

implementation

end.
