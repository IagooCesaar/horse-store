unit Loja.Model.Preco;

interface

uses
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Preco.Venda,
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda;

type
  TLojaModelPreco = class(TInterfacedObject, ILojaModelPreco)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelPreco;

    { ILojaModelPreco }
    function CriarPrecoVendaItem(ANovoPreco: TLojaModelDtoReqPrecoCriarPrecoVenda): TLojaModelEntityPrecoVenda;
    function ObterHistoricoPrecoVendaItem(ACodItem: Integer; ADatRef: TDateTime): TLojaModelEntityPrecoVendaLista;
    function ObterPrecoVendaAtual(ACodItem: Integer): TLojaModelEntityPrecoVenda;
  end;

implementation

{ TLojaModelPreco }

constructor TLojaModelPreco.Create;
begin

end;

function TLojaModelPreco.CriarPrecoVendaItem(
  ANovoPreco: TLojaModelDtoReqPrecoCriarPrecoVenda): TLojaModelEntityPrecoVenda;
begin
  Result := nil;
end;

destructor TLojaModelPreco.Destroy;
begin

  inherited;
end;

class function TLojaModelPreco.New: ILojaModelPreco;
begin
  Result := Self.Create;
end;

function TLojaModelPreco.ObterHistoricoPrecoVendaItem(ACodItem: Integer;
  ADatRef: TDateTime): TLojaModelEntityPrecoVendaLista;
begin
  Result := nil;
end;

function TLojaModelPreco.ObterPrecoVendaAtual(
  ACodItem: Integer): TLojaModelEntityPrecoVenda;
begin
  Result := nil;
end;

end.
