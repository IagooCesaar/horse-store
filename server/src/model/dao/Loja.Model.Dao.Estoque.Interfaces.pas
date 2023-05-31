unit Loja.Model.Dao.Estoque.Interfaces;

interface

uses
  Loja.Model.Dto.Req.Estoque.CriarMovimento,
  Loja.Model.Entity.Estoque.Movimento,
  Loja.Model.Entity.Estoque.Saldo;

type

  ILojaModelDaoEstoqueMovimento = interface
    ['{F9A0B70C-5320-48FB-85AA-A2D56B0A73B0}']
    function ObterPorCodigo(ACodMov: Integer): TLojaModelEntityEstoqueMovimento;
    function ObterMovimentoItemEntreDatas(ACodItem: Integer; ADatIni, ADatFim: TDateTime): TLojaModelEntityEstoqueMovimentoLista;
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
  end;

  ILojaModelDaoEstoqueSaldo = interface
    ['{2C7EAF9D-BDA3-44A8-B8AF-B9FFFF23F59D}']
    function ObterUltimoFechamentoItem(ACodItem: Integer): TLojaModelEntityEstoqueSaldo;
    function ObterFechamentoItem(ACodItem: Integer; ADatSaldo: TDateTime): TLojaModelEntityEstoqueSaldo;
    function CriarFechamentoSaldoItem(ACodItem: Integer; ADatSaldo: TDateTime; AQtdSaldo: Integer):TLojaModelEntityEstoqueSaldo;
  end;

  ILojaModelDaoEstoqueFactory = interface
    function Movimento: ILojaModelDaoEstoqueMovimento;
    function Saldo: ILojaModelDaoEstoqueSaldo;
  end;

implementation

end.
