unit Loja.Model.Dao.Interfaces;

interface

uses
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Itens.Interfaces,
  Loja.Model.Dao.Estoque.Interfaces;

type

  ILojaModelDaoFactory = interface
    ['{0EE57E31-3E31-49E9-9A76-9D20DF15C419}']
    function Itens: ILojaModelDaoItensItemFactory;
    function Estoque: ILojaModelDaoEstoqueFactory;
  end;

implementation

end.
