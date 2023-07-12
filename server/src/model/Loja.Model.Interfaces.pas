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
  Loja.Model.Dto.Req.Caixa.Abertura,
  Loja.Model.Dto.Req.Caixa.Fechamento,
  Loja.Model.Dto.Req.Caixa.CriarMovimento,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa,

  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Venda.Venda,
  Loja.Model.Entity.Venda.MeioPagto,
  Loja.Model.Dto.Resp.Venda.Item,
  Loja.Model.Dto.Req.Venda.Item,
  Loja.Model.Dto.Req.Venda.MeioPagto,
  Loja.Model.Dto.Req.Venda.EfetivaVenda;

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
    function ObterCaixasPorDataAbertura(ADatIni, ADatFim: TDate): TLojaModelEntityCaixaCaixaLista;
    function ObterResumoCaixa(ACodCaixa: Integer): TLojaModelDtoRespCaixaResumoCaixa;
    function ObterMovimentoCaixa(ACodCaixa: Integer): TLojaModelEntityCaixaMovimentoLista;
    function AberturaCaixa(AAbertura: TLojaModelDtoReqCaixaAbertura): TLojaModelEntityCaixaCaixa;
    function FechamentoCaixa(AFechamento: TLojaModelDtoReqCaixaFechamento): TLojaModelEntityCaixaCaixa;
    function CriarReforcoCaixa(AMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
    function CriarSangriaCaixa(AMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
  end;

  ILojaModelVenda = interface
    ['{C36E1BEE-E9DB-451E-9872-C236CAE9A416}']
    function ObterVendas(ADatInclIni, ADatInclFim: TDate;
      ACodSit: TLojaModelEntityVendaSituacao): TLojaModelEntityVendaVendaLista;
    function NovaVenda: TLojaModelEntityVendaVenda;
    function ObterVenda(ANumVnda: Integer): TLojaModelEntityVendaVenda;
    function EfetivarVenda(ANumVnda: Integer): TLojaModelEntityVendaVenda;
    function CancelarVenda(ANumVnda: Integer): TLojaModelEntityVendaVenda;

    function ObterItensVenda(ANumVnda: Integer): TLojaModelDtoRespVendaItemLista;
    function InserirItemVenda(ANovoItem: TLojaModelDtoReqVendaItem): TLojaModelDtoRespVendaItem;
    function AtualizarItemVenda(AItem: TLojaModelDtoReqVendaItem): TLojaModelDtoRespVendaItem;

    function ObterMeiosPagtoVenda(ANumVnda: Integer): TLojaModelEntityVendaMeioPagtoLista;
    function DefinirMeiosPagtoVenda(ANumVnda: Integer;
      AMeiosPagto: TLojaModelEntityVendaMeioPagtoLista): TLojaModelEntityVendaMeioPagtoLista;
  end;

  ILojaModelFactory = interface
    ['{FBA02FC1-F0C9-4969-BF2A-AA7662040FC8}']
    function Itens: ILojaModelItens;
    function Estoque: ILojaModelEstoque;
    function Preco: ILojaModelPreco;
    function Caixa: ILojaModelCaixa;
    function Venda: ILojaModelVenda;
  end;

implementation

end.
