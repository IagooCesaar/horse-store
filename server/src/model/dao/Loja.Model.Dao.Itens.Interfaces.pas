unit Loja.Model.Dao.Itens.Interfaces;

interface

uses
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Itens.FiltroItens;

type
  ILojaModelDaoItensItem = interface
    ['{29C88626-7650-4C9C-9825-205184EA9F35}']
    function ObterPorCodigo(ACodItem: Integer): TLojaModelEntityItensItem;
    function ObterPorNumCodBarr(ANumCodBarr: string): TLojaModelEntityItensItem;
    function CriarItem(ANovoItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
    function AtualizarItem(AItem: TLojaModelDtoReqItensCriarItem): TLojaModelEntityItensItem;
    function ObterItens(AFiltro: TLojaModelDtoReqItensFiltroItens): TLojaModelEntityItensItemLista;

  end;

  ILojaModelDaoItensFactory = interface
    ['{66D6B9AE-A7E6-40B0-9A8D-9055325AEFE8}']
    function Item: ILojaModelDaoItensItem;
  end;



implementation

end.
