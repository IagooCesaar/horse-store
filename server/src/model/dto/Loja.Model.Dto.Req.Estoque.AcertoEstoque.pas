unit Loja.Model.Dto.Req.Estoque.AcertoEstoque;

interface

uses
  System.Classes;

type
  TLojaModelDtoReqEstoqueAcertoEstoque = class
  private
    FCodItem: integer;
    FQtdSaldoReal: Integer;
    FDscMotivo: string;
  public
    property CodItem: integer read FCodItem write FCodItem;
    property QtdSaldoReal: Integer read FQtdSaldoReal write FQtdSaldoReal;
    property DscMotivo: string read FDscMotivo write FDscMotivo;
  end;

implementation

end.
