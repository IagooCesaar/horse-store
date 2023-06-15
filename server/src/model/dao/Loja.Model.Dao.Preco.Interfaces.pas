unit Loja.Model.Dao.Preco.Interfaces;

interface

type
  ILojaModelDaoPrecoVenda = interface
    ['{4242CDE4-338F-44AB-B60F-1A389F3C0B7C}']

  end;

  ILojaModelDaoPrecoFactory = interface
    ['{E6869712-2DE1-43BE-83B1-D99BF32C8E57}']
    function Venda: ILojaModelDaoPrecoVenda;
  end;

implementation

end.
