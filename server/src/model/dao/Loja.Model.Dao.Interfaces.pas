unit Loja.Model.Dao.Interfaces;

interface

uses
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Itens.Interfaces,
  Loja.Model.Dao.Estoque.Interfaces,
  Loja.Model.Dao.Preco.Interfaces;

type

  ILojaModelDaoFactory = interface
    ['{0EE57E31-3E31-49E9-9A76-9D20DF15C419}']
    function Itens: ILojaModelDaoItensFactory;
    function Estoque: ILojaModelDaoEstoqueFactory;
    function Preco: ILojaModelDaoPrecoFactory;
  end;

implementation

end.
