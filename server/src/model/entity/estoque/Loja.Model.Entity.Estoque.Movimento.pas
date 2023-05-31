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
    FCodOrigMov: TLojaModelEntityEstoqueOrigemMovimento;
    FDatMov: TDateTime;
    FCodMov: Integer;
    FDscMot: string;
    function GetDscTipoMov: string;
    function GetDscOrigMov: string;
    procedure SetDscTipoMov(AValue: string);
    procedure SetDscOrigMov(AValue: string);
  public
    constructor Create;

    property CodMov: Integer read FCodMov write FCodMov;
    property CodItem: Integer read FCodItem write FCodItem;
    property QtdMov: Integer read FQtdMov write FQtdMov;
    property DatMov: TDateTime read FDatMov write FDatMov;
    property CodTipoMov: TLojaModelEntityEstoqueTipoMovimento read FCodTipoMov write FCodTipoMov;
    property DscTipoMov: string read GetDscTipoMov write SetDscTipoMov;
    property CodOrigMov: TLojaModelEntityEstoqueOrigemMovimento read FCodOrigMov write FCodOrigMov;
    property DscOrigMov: string read GetDscOrigMov write SetDscOrigMov;
    property DscMot: string read FDscMot write FDscMot;

  end;

  TLojaModelEntityEstoqueMovimentoLista = TObjectList<TLojaModelEntityEstoqueMovimento>;


implementation

{ TLojaModelEntityEstoqueMovimento }

constructor TLojaModelEntityEstoqueMovimento.Create;
begin
  FCodOrigMOv := orgVenda;
  FCodTipoMov := movSaida;
end;

function TLojaModelEntityEstoqueMovimento.GetDscTipoMov: string;
begin
  Result := ESTOQUE_TIPO_MOVIMENTO[FCodTipoMov];
end;

function TLojaModelEntityEstoqueMovimento.GetDscOrigMov: string;
begin
  Result := ESTOQUE_ORIGEM_MOVIMENTO[FCodOrigMOv];
end;

procedure TLojaModelEntityEstoqueMovimento.SetDscTipoMov(AValue: string);
begin
  FCodTipoMov := TLojaModelEntityEstoqueTipoMovimento(AnsiIndexStr(
    AValue,ESTOQUE_TIPO_MOVIMENTO));
end;

procedure TLojaModelEntityEstoqueMovimento.SetDscOrigMov(AValue: string);
begin
  FCodOrigMOv := TLojaModelEntityEstoqueOrigemMovimento(AnsiIndexStr(
    AValue,ESTOQUE_ORIGEM_MOVIMENTO));
end;


end.
