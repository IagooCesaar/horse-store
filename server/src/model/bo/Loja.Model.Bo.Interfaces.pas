unit Loja.Model.Bo.Interfaces;

interface

uses
  System.Classes,
  System.Generics.Collections;

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

  ILojaModelBoFactory = interface
    ['{12CFCFF9-0CE0-4AA0-8D81-4A3493A2CE6C}']
    function Estoque: ILojaModelBoEstoque;
  end;

implementation

end.
