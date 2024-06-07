unit Loja.Environment.Interfaces;

interface

type
  TLojaEnvironmentKind = (envOficial, envInMemory);

  ILojaEnvironmentRules = interface
    ['{B0FD33CB-C1DF-4D79-99FB-0EA5E8BCA96D}']
    function Kind: TLojaEnvironmentKind;
  end;

  ILojaEnvironmentRuler = interface
    ['{048566F6-4A2C-4CF5-9F75-E5C6F0EEAE68}']
    function Rules: ILojaEnvironmentRules;
    function Ruler: ILojaEnvironmentRuler;
  end;

  ILojaEnvironmentFactory = interface
    ['{C4644715-98D7-4762-BB30-70B1848ED9E5}']
    function Oficial: ILojaEnvironmentRules;
    function InMemory: ILojaEnvironmentRules;
  end;

implementation

end.
