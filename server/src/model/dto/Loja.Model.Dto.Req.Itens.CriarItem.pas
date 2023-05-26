unit Loja.Model.Dto.Req.Itens.CriarItem;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TLojaModelDtoReqItensCriarItem = class
  private
    FNomItem: String;
    FNumCodBarr: string;
  public
    property NomItem: String read FNomItem write FNomItem;
    property NumCodBarr: string read FNumCodBarr write FNumCodBarr;
  end;

implementation

end.
