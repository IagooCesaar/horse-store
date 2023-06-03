unit Loja.Model.Dto.Resp.Estoque.SaldoItem;

interface

uses
  System.Classes,
  System.SysUtils,

  Loja.Model.Entity.Estoque.Saldo,
  Loja.Model.Entity.Estoque.Movimento;

type
  TLojaModelDtoRespEstoqueSaldoItem = class
  private
    FCodItem: Integer;
    FQtdSaldoAtu: Integer;

    FUltimosMovimentos: TLojaModelEntityEstoqueMovimentoLista;
    FUltimoFechamento: TLojaModelEntityEstoqueSaldo;

  public
    destructor Destroy; override;

    property CodItem: Integer read FCodItem write FCodItem;
    property QtdSaldoAtu: Integer read FQtdSaldoAtu write FQtdSaldoAtu;
    property UltimoFechamento: TLojaModelEntityEstoqueSaldo read FUltimoFechamento write FUltimoFechamento;
    property UltimosMovimentos: TLojaModelEntityEstoqueMovimentoLista read FUltimosMovimentos write FUltimosMovimentos;
  end;

implementation

{ TLojaModelDtoRespEstoqueSaldoItem }

destructor TLojaModelDtoRespEstoqueSaldoItem.Destroy;
begin
  if FUltimosMovimentos <> nil
  then FreeAndNil(FUltimosMovimentos);

  if FUltimoFechamento <> nil
  then FreeAndNil(FUltimoFechamento);

  inherited;
end;

end.
