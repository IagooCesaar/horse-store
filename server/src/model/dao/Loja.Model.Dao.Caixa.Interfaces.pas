unit Loja.Model.Dao.Caixa.Interfaces;

interface

uses
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Movimento,
  Loja.Model.Dto.Req.Caixa.Abertura,
  Loja.Model.Dto.Req.Caixa.Fechamento,
  Loja.Model.Dto.Req.Caixa.CriarMovimento;

type
  ILojaModelDaoCaixaCaixa = interface
    ['{715AEB32-93A4-4C1C-A522-0E282059A1FA}']
    function ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
    function ObterCaixaPorCodigo(ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
    function ObterCaixasPorDataAbertura(ADatIni, ADatFim: TDate): TLojaModelEntityCaixaCaixaLista;

    function ObterUltimoCaixaFechado(ADatRef: TDateTime): TLojaModelEntityCaixaCaixa;
    function CriarNovoCaixa(ANovoCaixa: TLojaModelDtoReqCaixaAbertura): TLojaModelEntityCaixaCaixa;
    function AtualizarFechamentoCaixa(ACodCaixa: Integer; ADatFecha: TDateTime; AVrFecha: Currency): TLojaModelEntityCaixaCaixa;
  end;

  ILojaModelDaoCaixaMovimento = interface
    ['{8941F82E-D594-4BA1-8826-9FC4B83E941D}']
    function ObterMovimentoPorCodigo(ACodMov: Integer): TLojaModelEntityCaixaMovimento;
    function ObterMovimentoPorCaixa(ACodCaixa: Integer): TLojaModelEntityCaixaMovimentoLista;
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqCaixaCriarMovimento): TLojaModelEntityCaixaMovimento;
  end;

  ILojaModelDaoCaixaFactory = interface
    ['{5D01581E-CEAF-48F4-94F6-7D62F0D81138}']
    function Caixa: ILojaModelDaoCaixaCaixa;
    function Movimento: ILojaModelDaoCaixaMovimento;
  end;

implementation

end.
