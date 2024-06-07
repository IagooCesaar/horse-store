unit Loja.Model.Preco;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.DateUtils,

  Loja.Environment.Interfaces,
  Loja.Model.Interfaces,
  Loja.Model.Entity.Preco.Venda,
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda;

type
  TLojaModelPreco = class(TInterfacedObject, ILojaModelPreco)
  private
    FEnvRules: ILojaEnvironmentRuler;
  public
    constructor Create(AEnvRules: ILojaEnvironmentRuler);
    destructor Destroy; override;
    class function New(AEnvRules: ILojaEnvironmentRuler): ILojaModelPreco;

    { ILojaModelPreco }
    function CriarPrecoVendaItem(ANovoPreco: TLojaModelDtoReqPrecoCriarPrecoVenda): TLojaModelEntityPrecoVenda;
    function ObterHistoricoPrecoVendaItem(ACodItem: Integer; ADatRef: TDateTime): TLojaModelEntityPrecoVendaLista;
    function ObterPrecoVendaAtual(ACodItem: Integer): TLojaModelEntityPrecoVenda;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Factory;

{ TLojaModelPreco }

constructor TLojaModelPreco.Create(AEnvRules: ILojaEnvironmentRuler);
begin
  FEnvRules := AEnvRules;
end;

function TLojaModelPreco.CriarPrecoVendaItem(
  ANovoPreco: TLojaModelDtoReqPrecoCriarPrecoVenda): TLojaModelEntityPrecoVenda;
begin
  Result := nil;

  if ANovoPreco.VrVnda <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O valor de venda deve ser maior que zero');

  var LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorCodigo(ANovoPreco.CodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('Não foi possível encontrar o item pelo código informado');
  LItem.Free;

  var LPrecoVigente := TLojaModelDaoFactory.New.Preco
    .Venda.
    ObterPrecoVendaVigente(ANovoPreco.CodItem, ANovoPreco.DatIni);
  if LPrecoVigente <> nil
  then try
    if ANovoPreco.DatIni = LPrecoVigente.DatIni
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('Já existe um preço configurado para inicar na data informada');
  finally
    LPrecoVigente.Free;
  end;

  var LPreco := TLojaModelDaoFactory.New.Preco
    .Venda
    .CriarPrecoVendaItem(ANovoPreco);

  Result := LPreco;

end;

destructor TLojaModelPreco.Destroy;
begin

  inherited;
end;

class function TLojaModelPreco.New(AEnvRules: ILojaEnvironmentRuler): ILojaModelPreco;
begin
  Result := Self.Create(AEnvRules);
end;

function TLojaModelPreco.ObterHistoricoPrecoVendaItem(ACodItem: Integer;
  ADatRef: TDateTime): TLojaModelEntityPrecoVendaLista;
begin
  Result := nil;

  var LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorCodigo(ACodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('Não foi possível encontrar o item pelo código informado');
  LItem.Free;

  var LHistorico := TLojaModelDaoFactory.New.Preco
    .Venda.
    ObterHistoricoPrecoVendaItem(ACodItem, ADatRef);

  LHistorico.Sort(TComparer<TLojaModelEntityPrecoVenda>.Construct(
    function (const L, R: TLojaModelEntityPrecoVenda): Integer
    begin
      if L.DatIni > R.DatIni
      then Result := 1
      else
      if L.DatIni < R.DatIni
      then Result := -1

      else Result := 0;
    end
  ));


  Result := LHistorico;
end;

function TLojaModelPreco.ObterPrecoVendaAtual(
  ACodItem: Integer): TLojaModelEntityPrecoVenda;
begin
  Result := Nil;

  var LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorCodigo(ACodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('Não foi possível encontrar o item pelo código informado');
  LItem.Free;

  var LPrecoVigente := TLojaModelDaoFactory.New.Preco
    .Venda
    .ObterPrecoVendaAtual(ACodItem);

  Result := LPrecoVigente;
end;

end.
