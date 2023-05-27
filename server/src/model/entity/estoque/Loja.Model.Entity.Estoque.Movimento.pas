unit Loja.Model.Entity.Estoque.Movimento;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.StrUtils,
  Loja.Model.Entity.Estoque.Types;

type
  TLojaModelEntityEstoqueMovimento = class
  private
    FCodItem: Integer;
    FQtdMov: Integer;
    FCodTipoMov: TLojaModelEntityEstoqueTipoMovimento;
    FCodTipoOrig: TLojaModelEntityEstoqueOrigemMovimento;
    FDatMov: TDateTime;
    FCodMov: Integer;
    function GetDscTipoMov: string;
    function GetDscTipoOrig: string;
    procedure SetDscTipoMov(AValue: string);
    procedure SetDscTipoOrig(AValue: string);
  public
    constructor Create;

    property CodMov: Integer read FCodMov write FCodMov;
    property CodItem: Integer read FCodItem write FCodItem;
    property QtdMov: Integer read FQtdMov write FQtdMov;
    property DatMov: TDateTime read FDatMov write FDatMov;
    property CodTipoMov: TLojaModelEntityEstoqueTipoMovimento read FCodTipoMov write FCodTipoMov;
    property DscTipoMov: string read GetDscTipoMov write SetDscTipoMov;
    property CodTipoOrig: TLojaModelEntityEstoqueOrigemMovimento read FCodTipoOrig write FCodTipoOrig;
    property DscTipoOrig: string read GetDscTipoOrig write SetDscTipoOrig;

  end;

  TLojaModelEntityEstoqueMovimentoLista = TObjectList<TLojaModelEntityEstoqueMovimento>;


implementation

{ TLojaModelEntityEstoqueMovimento }

constructor TLojaModelEntityEstoqueMovimento.Create;
begin
  FCodTipoOrig := orgVenda;
  FCodTipoMov := movSaida;
end;

function TLojaModelEntityEstoqueMovimento.GetDscTipoMov: string;
begin
  Result := ESTOQUE_TIPO_MOVIMENTO[FCodTipoMov];
end;

function TLojaModelEntityEstoqueMovimento.GetDscTipoOrig: string;
begin
  Result := ESTOQUE_ORIGEM_MOVIMENTO[FCodTipoOrig];
end;

procedure TLojaModelEntityEstoqueMovimento.SetDscTipoMov(AValue: string);
begin
  FCodTipoMov := TLojaModelEntityEstoqueTipoMovimento(AnsiIndexStr(
    AValue,ESTOQUE_TIPO_MOVIMENTO));
end;

procedure TLojaModelEntityEstoqueMovimento.SetDscTipoOrig(AValue: string);
begin
  FCodTipoOrig := TLojaModelEntityEstoqueOrigemMovimento(AnsiIndexStr(
    AValue,ESTOQUE_ORIGEM_MOVIMENTO));
end;


end.
