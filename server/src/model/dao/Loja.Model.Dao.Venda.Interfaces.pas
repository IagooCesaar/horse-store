unit Loja.Model.Dao.Venda.Interfaces;

interface

type
  ILojaModelDaoVendaVenda = interface
    ['{7EEF7952-CD8B-4896-A1E3-267EA929D485}']

  end;

  ILojaModelDaoVendaItem = interface
    ['{FE32EC6C-3C0C-450B-B93F-9C8DE18A56DB}']

  end;

  ILojaModelDaoVendaMeioPagto = interface
    ['{571BB48D-EEC9-462B-B1AE-07D7A52D69D0}']

  end;

  ILojaModelDaoVendaFactory = interface
    ['{631A4A49-CCF0-447D-A4E6-A0F1A065A003}']
    function Venda: ILojaModelDaoVendaVenda;
    function Item: ILojaModelDaoVendaItem;
    function MeioPagto: ILojaModelDaoVendaMeioPagto;
  end;

implementation

end.
