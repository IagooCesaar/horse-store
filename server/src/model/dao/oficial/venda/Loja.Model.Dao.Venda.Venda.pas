unit Loja.Model.Dao.Venda.Venda;

interface

uses
  Data.DB,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Dao.Venda.Interfaces,
  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Venda.Venda;

type
  TLojaModelDaoVendaVenda = class(TInterfacedObject, ILojaModelDaoVendaVenda)
  private
    function AtribuiCampos(ds: TDataSet): TLojaModelEntityVendaVenda;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoVendaVenda;

    { ILojaModelDaoVendaVenda }
    function ObterVendas(ADatInclIni, ADatInclFim: TDate;
      AFlgApenasEfet: Boolean): TLojaModelEntityVendaVendaLista;
  end;

implementation

uses
  Database.Factory,
  Horse.Commons,

  System.Math,
  System.StrUtils;


{ TLojaModelDaoVendaVenda }

function TLojaModelDaoVendaVenda.AtribuiCampos(
  ds: TDataSet): TLojaModelEntityVendaVenda;
begin

end;

constructor TLojaModelDaoVendaVenda.Create;
begin

end;

destructor TLojaModelDaoVendaVenda.Destroy;
begin

  inherited;
end;

class function TLojaModelDaoVendaVenda.New: ILojaModelDaoVendaVenda;
begin
  Result := Self.Create;
end;

function TLojaModelDaoVendaVenda.ObterVendas(ADatInclIni, ADatInclFim: TDate;
  AFlgApenasEfet: Boolean): TLojaModelEntityVendaVendaLista;
begin
  Result := TLojaModelEntityVendaVendaLista.Create;

  var LSql := #13#10
  + 'select * from venda v '
  + 'where v.dat_incl between :dat_incl_ini and :dat_incl_fim '
  + IfThen(AFlgApenasEfet, '  and v.cod_sit = :cod_sit ', '')
  ;


  var ds := TDatabaseFactory.New.SQL
    .SQL(LSql)
    .ParamList
      .AddDateTime('dat_incl_ini', ADatInclIni)
      .AddDateTime('dat_incL_fim', ADatInclFim)
      .AddString('cod_sit', sitEfetivada.ToString)
      .&End
    .Open;

  while not ds.Eof
  do begin
    Result.Add(AtribuiCampos(ds));
    ds.Next;
  end;
end;

end.
