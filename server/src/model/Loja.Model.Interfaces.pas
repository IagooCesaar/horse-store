unit Loja.Model.Interfaces;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Itens.FiltroItens,

  Loja.Model.Entity.Estoque.Movimento,
  Loja.Model.Entity.Estoque.Saldo,
  Loja.Model.Dto.Req.Estoque.CriarMovimento,
  Loja.Model.Dto.Req.Estoque.AcertoEstoque,
  Loja.Model.Dto.Resp.Estoque.SaldoItem;

type
  ILojaModelItens = interface
    ['{C4B5FD33-A52B-47D3-8DA8-709CAEC9CC4D}']
    function ObterPorCodigo(ACodItem: Integer): TLojaModelEntityItensItem;
    function ObterPorNumCodBarr(ANumCodBarr: string): TLojaModelEntityItensItem;
    function ObterItens(AFiltro: TLojaModelDtoReqItensFiltroItens): TObjectList<TLojaModelEntityItensItem>;
    function CriarItem(ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
  end;

  ILojaModelEstoque = interface
    ['{AC91CEDC-1BAD-465B-B72A-CAFE30A03906}']
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
    function CriarAcertoEstoque(AAcertoEstoque: TLojaModelDtoReqEstoqueAcertoEstoque): TLojaModelEntityEstoqueMovimento;
    function ObterHistoricoMovimento(ACodItem: Integer; ADatIni, ADatFim: TDateTime): TLojaModelEntityEstoqueMovimentoLista;
    function ObterSaldoAtualItem(ACodItem: Integer): TLojaModelDtoRespEstoqueSaldoItem;
  end;

  ILojaModelFactory = interface
    ['{FBA02FC1-F0C9-4969-BF2A-AA7662040FC8}']
    function Itens: ILojaModelItens;
    function Estoque: ILojaModelEstoque;
  end;

implementation

end.
