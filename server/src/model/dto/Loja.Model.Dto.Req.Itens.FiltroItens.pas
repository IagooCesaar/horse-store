unit Loja.Model.Dto.Req.Itens.FiltroItens;

interface

uses
  System.Classes,
  Horse.Commons;

type
  TLojaModelDtoReqItensFiltroItens = class
  private
    FNomItem: String;
    FCodItem: Integer;
    FNumCodBarr: string;
    FNomItemLhsBracketsType: TLhsBracketsType;
    FNumCodBarrLhsBracketsType: TLhsBracketsType;
  public
    constructor Create;

    property CodItem: Integer read FCodItem write FCodItem;

    property NomItem: String read FNomItem write FNomItem;
    property NomItemLhsBracketsType: TLhsBracketsType read FNomItemLhsBracketsType write FNomItemLhsBracketsType;

    property NumCodBarr: string read FNumCodBarr write FNumCodBarr;
    property NumCodBarrLhsBracketsType: TLhsBracketsType read FNumCodBarrLhsBracketsType write FNumCodBarrLhsBracketsType;
  end;

implementation

{ TLojaModelDtoReqItensFiltroItens }

constructor TLojaModelDtoReqItensFiltroItens.Create;
begin
  FNomItemLhsBracketsType := TLhsBracketsType.Equal;
  FNumCodBarrLhsBracketsType := TLhsBracketsType.Equal;
end;

end.
