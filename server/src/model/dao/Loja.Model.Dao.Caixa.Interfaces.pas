unit Loja.Model.Dao.Caixa.Interfaces;

interface

uses
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Entity.Caixa.Movimento;

type
  ILojaModelDaoCaixaCaixa = interface
    ['{715AEB32-93A4-4C1C-A522-0E282059A1FA}']
    function ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
    function ObterCaixaPorCodigo(ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
  end;

  ILojaModelDaoCaixaMovimento = interface
    ['{8941F82E-D594-4BA1-8826-9FC4B83E941D}']

  end;

  ILojaModelDaoCaixaFactory = interface
    ['{5D01581E-CEAF-48F4-94F6-7D62F0D81138}']
    function Caixa: ILojaModelDaoCaixaCaixa;
    function Movimento: ILojaModelDaoCaixaMovimento;
  end;

implementation

end.
