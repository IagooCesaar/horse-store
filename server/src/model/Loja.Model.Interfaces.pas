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
  Loja.Model.Dto.Resp.Estoque.SaldoItem,

  Loja.Model.Dto.Req.Preco.CriarPrecoVenda,
  Loja.Model.Entity.Preco.Venda,

  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Movimento,
  Loja.Model.Dto.Req.Caixa.Abertura;

type
  ILojaModelItens = interface
    ['{C4B5FD33-A52B-47D3-8DA8-709CAEC9CC4D}']
    function ObterPorCodigo(ACodItem: Integer): TLojaModelEntityItensItem;
    function ObterPorNumCodBarr(ANumCodBarr: string): TLojaModelEntityItensItem;
    function ObterItens(AFiltro: TLojaModelDtoReqItensFiltroItens): TLojaModelEntityItensItemLista;
    function CriarItem(ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
    function AtualizarItem(AItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
  end;

  ILojaModelEstoque = interface
    ['{AC91CEDC-1BAD-465B-B72A-CAFE30A03906}']
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
    function CriarAcertoEstoque(AAcertoEstoque: TLojaModelDtoReqEstoqueAcertoEstoque): TLojaModelEntityEstoqueMovimento;
    function ObterHistoricoMovimento(ACodItem: Integer; ADatIni, ADatFim: TDateTime): TLojaModelEntityEstoqueMovimentoLista;
    function ObterFechamentosSaldo(ACodItem: Integer; ADatIni, ADatFim: TDateTime): TLojaModelEntityEstoqueSaldoLista;
    function ObterSaldoAtualItem(ACodItem: Integer): TLojaModelDtoRespEstoqueSaldoItem;
  end;

  ILojaModelPreco = interface
    ['{5AFBBF1C-8A33-4253-9D14-94595FF92902}']
    function CriarPrecoVendaItem(ANovoPreco: TLojaModelDtoReqPrecoCriarPrecoVenda): TLojaModelEntityPrecoVenda;
    function ObterHistoricoPrecoVendaItem(ACodItem: Integer; ADatRef: TDateTime): TLojaModelEntityPrecoVendaLista;
    function ObterPrecoVendaAtual(ACodItem: Integer): TLojaModelEntityPrecoVenda;
  end;

  ILojaModelCaixa = interface
    ['{D1CBDDA3-2034-49E7-929B-2B86FF2C925C}']
    function ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
    function ObterCaixaPorCodigo(ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
    // obter resumo de caixa -- total por meio de pagamento
    // obter movimentação de caixa -- movimentos específicos do caixa
    function AberturaCaixa(AAbertura: TLojaModelDtoReqCaixaAbertura): TLojaModelEntityCaixaCaixa;
    // fechar caixa
    // reforço de caixa  -- com observação
    // sangria de caixa  -- com observação
  end;

  ILojaModelFactory = interface
    ['{FBA02FC1-F0C9-4969-BF2A-AA7662040FC8}']
    function Itens: ILojaModelItens;
    function Estoque: ILojaModelEstoque;
    function Preco: ILojaModelPreco;
    function Caixa: ILojaModelCaixa;
  end;

implementation

end.
