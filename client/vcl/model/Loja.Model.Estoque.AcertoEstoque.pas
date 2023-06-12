unit Loja.Model.Estoque.AcertoEstoque;

interface

uses
  System.Classes;

type
  TLojaModelEstoqueAcertoEstoque = class
  private
    FQtdSaldoReal: Integer;
    FDscMot: String;
  public
    property QtdSaldoReal: Integer read FQtdSaldoReal write FQtdSaldoReal;
    property DscMot: String read FDscMot write FDscMot;
  end;

implementation

end.
