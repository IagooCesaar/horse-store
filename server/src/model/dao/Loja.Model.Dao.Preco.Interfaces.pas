unit Loja.Model.Dao.Preco.Interfaces;

interface

uses
  Loja.Model.Entity.Preco.Venda,
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda;

type
  ILojaModelDaoPrecoVenda = interface
    ['{4242CDE4-338F-44AB-B60F-1A389F3C0B7C}']
    function CriarPrecoVendaItem(ANovoPreco: TLojaModelDtoReqPrecoCriarPrecoVenda): TLojaModelEntityPrecoVenda;
    function ObterHistoricoPrecoVendaItem(ACodItem: Integer; ADatRef: TDateTime): TLojaModelEntityPrecoVendaLista;
    function ObterPrecoVendaAtual(ACodItem: Integer): TLojaModelEntityPrecoVenda;
  end;

  ILojaModelDaoPrecoFactory = interface
    ['{E6869712-2DE1-43BE-83B1-D99BF32C8E57}']
    function Venda: ILojaModelDaoPrecoVenda;
  end;

implementation

end.
