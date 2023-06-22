unit Loja.Model.Bo.Interfaces;

interface

uses
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Caixa.Caixa;

type
  ILojaModelBoEstoque = interface;

  ILojaModelBoEstoqueFechamentoSaldo = interface
    ['{3A4731D1-8360-46BA-BF4D-92057DA7F375}']
    function EndFechamentoSaldo: ILojaModelBoEstoque;

    function FecharSaldoMensalItem(ACodItem: Integer): ILojaModelBoEstoqueFechamentoSaldo;
    function CriarNovoFechamento(ACodItem: Integer; ADatRef: TDateTime;
      ASaldo: Integer): ILojaModelBoEstoqueFechamentoSaldo;
  end;

  ILojaModelBoEstoque = interface
    ['{23DF78D8-0532-4236-AA25-DE884FABAA86}']
    function FechamentoSaldo: ILojaModelBoEstoqueFechamentoSaldo;
  end;

  ILojaModelBoItens = interface
    ['{9012E209-99BA-461C-8241-A0B3B89792A1}']
    function ValidaExistenciaItemPorCodigo(ACodItem: Integer): Boolean;
  end;

  ILojaModelBoCaixa = interface
    ['{E34AC112-8645-4DDD-B2C4-C7140029A2EB}']
    //function PermiteMovimentoCaixa: Boolean;
    function ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
    //function CriaMovimentoCaixa;
    //function Saldo Real ($$)
  end;

  ILojaModelBoFactory = interface
    ['{12CFCFF9-0CE0-4AA0-8D81-4A3493A2CE6C}']
    function Estoque: ILojaModelBoEstoque;
    function Caixa: ILojaModelBoCaixa;
  end;

implementation

end.
