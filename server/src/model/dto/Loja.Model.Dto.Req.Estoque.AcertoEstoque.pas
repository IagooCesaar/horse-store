unit Loja.Model.Dto.Req.Estoque.AcertoEstoque;

interface

uses
  System.Classes;

type
  TLojaModelDtoReqEstoqueAcertoEstoque = class
  private
    FCodItem: integer;
    FQtdSaldoReal: Integer;
    FDscMot: string;
  public
    property CodItem: integer read FCodItem write FCodItem;
    property QtdSaldoReal: Integer read FQtdSaldoReal write FQtdSaldoReal;
    property DscMot: string read FDscMot write FDscMot;
  end;

implementation

end.
