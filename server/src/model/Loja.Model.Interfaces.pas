unit Loja.Model.Interfaces;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem;

type
  ILojaModelItens = interface
    ['{C4B5FD33-A52B-47D3-8DA8-709CAEC9CC4D}']
    function ObterPorCodigo(ACodItem: Integer): TLojaModelEntityItensItem;
    function ObterPorNumCodBarr(ANumCodBarr: string): TLojaModelEntityItensItem;
    function CriarItem(ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
  end;

  ILojaModelFactory = interface
    ['{FBA02FC1-F0C9-4969-BF2A-AA7662040FC8}']
    function Itens: ILojaModelItens;
  end;

implementation

end.
