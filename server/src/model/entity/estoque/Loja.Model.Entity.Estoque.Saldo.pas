unit Loja.Model.Entity.Estoque.Saldo;

interface

uses
  System.Classes,
  System.Generics.Collections;

type
  TLojaModelEntityEstoqueSaldo = class
  private
    FCodItem: Integer;
    FDatSaldo: TDateTime;
    FQtdSaldo: Integer;
    FCodFechSaldo: Integer;
  public
    property CodFechSaldo: Integer read FCodFechSaldo write FCodFechSaldo;
    property CodItem: Integer read FCodItem write FCodItem;
    property DatSaldo: TDateTime read FDatSaldo write FDatSaldo;
    property QtdSaldo: Integer read FQtdSaldo write FQtdSaldo;
  end;

  TLojaModelEntityEstoqueSaldoLista = TObjectList<TLojaModelEntityEstoqueSaldo>;


implementation

end.
