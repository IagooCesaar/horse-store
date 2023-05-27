unit Loja.Model.Dto.Req.Itens.FiltroItens;

interface

uses
  System.Classes;

type
  TLojaModelDtoReqItensFiltroItens = class
  private
    FNomItem: String;
    FCodItem: Integer;
    FNumCodBarr: string;
  public
    property CodItem: Integer read FCodItem write FCodItem;
    property NomItem: String read FNomItem write FNomItem;
    property NumCodBarr: string read FNumCodBarr write FNumCodBarr;
  end;

implementation

end.
