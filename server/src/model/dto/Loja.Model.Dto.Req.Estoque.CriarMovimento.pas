unit Loja.Model.Dto.Req.Estoque.CriarMovimento;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.StrUtils,
  Loja.Model.Entity.Estoque.Types;

type
  TLojaModelDtoReqEstoqueCriarMovimento = class
  private
    FCodItem: Integer;
    FQtdMov: Integer;
    FCodTipoMov: TLojaModelEntityEstoqueTipoMovimento;
    FCodOrigMov: TLojaModelEntityEstoqueOrigemMovimento;
    FDatMov: TDateTime;
    FDscMot: string;
    function GetDscTipoMov: string;
    function GetDscTipoOrig: string;
    {procedure SetDscTipoMov(AValue: string);
    procedure SetDscTipoOrig(AValue: string);}
  public
    constructor Create;

    property CodItem: Integer read FCodItem write FCodItem;
    property QtdMov: Integer read FQtdMov write FQtdMov;
    property DatMov: TDateTime read FDatMov write FDatMov;
    property CodTipoMov: TLojaModelEntityEstoqueTipoMovimento read FCodTipoMov write FCodTipoMov;
    property DscTipoMov: string read GetDscTipoMov;// write SetDscTipoMov;
    property CodOrigMov: TLojaModelEntityEstoqueOrigemMovimento read FCodOrigMov write FCodOrigMov;
    property DscTipoOrig: string read GetDscTipoOrig;// write SetDscTipoOrig;
    property DscMot: string read FDscMot write FDscMot;

  end;


implementation

{ TLojaModelDtoReqEstoqueCriarMovimento }

constructor TLojaModelDtoReqEstoqueCriarMovimento.Create;
begin
  FCodOrigMov := orgVenda;
  FCodTipoMov := movSaida;
end;

function TLojaModelDtoReqEstoqueCriarMovimento.GetDscTipoMov: string;
begin
  Result := ESTOQUE_TIPO_MOVIMENTO[FCodTipoMov];
end;

function TLojaModelDtoReqEstoqueCriarMovimento.GetDscTipoOrig: string;
begin
  Result := ESTOQUE_ORIGEM_MOVIMENTO[FCodOrigMov];
end;

{procedure TLojaModelDtoReqEstoqueCriarMovimento.SetDscTipoMov(AValue: string);
begin
  FCodTipoMov := TLojaModelEntityEstoqueTipoMovimento(AnsiIndexStr(
    AValue,ESTOQUE_TIPO_MOVIMENTO));
end;

procedure TLojaModelDtoReqEstoqueCriarMovimento.SetDscTipoOrig(AValue: string);
begin
  FCodOrigMov := TLojaModelEntityEstoqueOrigemMovimento(AnsiIndexStr(
    AValue,ESTOQUE_ORIGEM_MOVIMENTO));
end;}

end.
