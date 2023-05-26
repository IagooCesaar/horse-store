unit Loja.Model.Itens;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem;

type
  TLojaModelItens = class(TInterfacedObject, ILojaModelItens)
  private
  public
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelItens;

    { ILojaModelItens }
    function ObterPorCodigo(ACodItem: Integer): TLojaModelEntityItensItem;
    function ObterPorNumCodBarr(ANumCodBarr: string): TLojaModelEntityItensItem;
    function CriarItem(ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Factory;

{ TLojaModelItens }

constructor TLojaModelItens.Create;
begin

end;

function TLojaModelItens.CriarItem(
  ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
begin
  if Length(ANovoItem.NomItem) <= 8
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O nome do item dever� ter no m�nimo 8 caracteres');

  Result := TLojaModelDaoFactory.New.Itens
    .Item
    .CriarItem(ANovoItem);
end;

destructor TLojaModelItens.Destroy;
begin

  inherited;
end;

class function TLojaModelItens.New: ILojaModelItens;
begin
  Result := Self.Create;
end;

function TLojaModelItens.ObterPorCodigo(
  ACodItem: Integer): TLojaModelEntityItensItem;
var LItem : TLojaModelEntityItensItem;
begin
  LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorCodigo(ACodItem);

  if LItem = nil
  then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('N�o foi poss�vel encontrar o item pelo c�digo informado');

  Result := LItem;
end;

function TLojaModelItens.ObterPorNumCodBarr(
  ANumCodBarr: string): TLojaModelEntityItensItem;
begin
  var LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorNumCodBarr(ANumCodBarr);

  if not Assigned(LItem)
  then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('N�o foi poss�vel encontrar o item pelo c�digo de barras informado');
end;

end.
