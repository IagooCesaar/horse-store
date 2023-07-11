unit Loja.Model.Venda;

interface

uses
  System.SysUtils,
  System.Classes,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Caixa.Types,

  Loja.Model.Entity.Venda.Venda,
  Loja.Model.Entity.Venda.MeioPagto,
  Loja.Model.Entity.Venda.Item,

  Loja.Model.Dto.Resp.Venda.Item,
  Loja.Model.Dto.Req.Venda.Item,
  Loja.Model.Dto.Req.Venda.MeioPagto,
  Loja.Model.Dto.Req.Venda.EfetivaVenda,

  Loja.Model.Bo.Factory,
  Loja.Model.Entity.Caixa.Caixa;

type
  TLojaModelVenda = class(TInterfacedObject, ILojaModelVenda)
  private
    function EntityToDto(ASource: TLojaModelEntityVendaItem): TLojaModelDtoRespVendaItem; overload;
    function ObterEValidarCaixa: TLojaModelEntityCaixaCaixa;
    function CalculaTotaisVenda(var AVenda: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelVenda;

    { ILojaModelVenda }
    function ObterVendas(ADatInclIni, ADatInclFim: TDate;
      ACodSit: TLojaModelEntityVendaSituacao): TLojaModelEntityVendaVendaLista;

    function NovaVenda: TLojaModelEntityVendaVenda;

    function ObterVenda(ANumVnda: Integer): TLojaModelEntityVendaVenda;

    function EfetivarVenda(
      AEfetivacao: TLojaModelDtoReqVendaEfetivaVenda): TLojaModelEntityVendaVenda;

    function CancelarVenda(ANumVnda: Integer): TLojaModelEntityVendaVenda;

    function ObterItensVenda(ANumVnda: Integer): TLojaModelDtoRespVendaItemLista;

    function InserirItemVenda(ANovoItem: TLojaModelDtoReqVendaItem): TLojaModelDtoRespVendaItem;

    function AtualizarItemVenda(AItem: TLojaModelDtoReqVendaItem): TLojaModelDtoRespVendaItem;

    function ObterMeiosPagtoVenda(ANumVnda: Integer): TLojaModelEntityVendaMeioPagtoLista;

    function InserirMeiosPagtoVenda(ANumVnda: Integer;
      AMeiosPagto: TLojaModelEntityVendaMeioPagtoLista): TLojaModelEntityVendaMeioPagtoLista;

    function AtualizarMeiosPagtoVenda(ANumVnda: Integer;
      AMeiosPagto: TLojaModelEntityVendaMeioPagtoLista): TLojaModelEntityVendaMeioPagtoLista;
  end;

implementation

uses
  Horse,
  Horse.Exception,
  System.Math,

  Loja.Model.Dao.Factory;

{ TLojaModelVenda }

function TLojaModelVenda.AtualizarItemVenda(
  AItem: TLojaModelDtoReqVendaItem): TLojaModelDtoRespVendaItem;
begin

end;

function TLojaModelVenda.AtualizarMeiosPagtoVenda(ANumVnda: Integer;
  AMeiosPagto: TLojaModelEntityVendaMeioPagtoLista): TLojaModelEntityVendaMeioPagtoLista;
begin

end;

function TLojaModelVenda.CalculaTotaisVenda(
  var AVenda: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;
begin
  var LItens := TLojaModelDaoFactory.New.Venda
    .Item
    .ObterItensVenda(AVenda.NumVnda);

  AVenda.VrBruto := 0;

  for var LItem in LItens
  do begin
    LItem.VrBruto := LItem.VrPrecoUnit * Litem.QtdItem;
    LItem.VrTotal := LItem.VrBruto - LItem.VrDesc;

    if LItem.CodSit = sitAtivo
    then AVenda.VrBruto := AVenda.VrBruto + LItem.VrTotal;
  end;

  AVenda.VrTotal := AVenda.VrBruto - AVenda.VrDesc;

  LItens.Free;
end;

function TLojaModelVenda.CancelarVenda(
  ANumVnda: Integer): TLojaModelEntityVendaVenda;
begin
  if ANumVnda <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O número de venda informado é inválido');

  var LVenda := TLojaModelDaoFactory.New.Venda
    .Venda
    .ObterVenda(ANumVnda);

  if LVenda = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('Não foi possível encontrar a venda pelo número informado');

  try
    if LVenda.CodSit <> sitPendente
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('A venda informada não está Pendente.');

    CalculaTotaisVenda(LVenda);
    LVenda.CodSit := sitCancelada;
    LVenda.DatConcl := Now;

    Result := TLojaModelDaoFactory.New.Venda
      .Venda
      .AtualizarVenda(LVenda);
  finally
    LVenda.Free;
  end;
end;

constructor TLojaModelVenda.Create;
begin

end;

destructor TLojaModelVenda.Destroy;
begin

  inherited;
end;

function TLojaModelVenda.EfetivarVenda(
  AEfetivacao: TLojaModelDtoReqVendaEfetivaVenda): TLojaModelEntityVendaVenda;
begin
  var LCaixa := ObterEValidarCaixa;
end;

function TLojaModelVenda.EntityToDto(
  ASource: TLojaModelEntityVendaItem): TLojaModelDtoRespVendaItem;
begin
  var LItem := TLojaModelDaoFactory.New.Itens
    .Item
    .ObterPorCodigo(ASource.CodItem);

  Result := TLojaModelDtoRespVendaItem.Create;
  Result.NumVnda := ASource.NumVnda;
  Result.NumSeqItem := ASource.NumSeqItem;
  Result.CodItem := ASource.CodItem;
  Result.NomItem := LItem.NomItem;
  Result.CodSit := ASource.CodSit;
  Result.QtdItem := ASource.QtdItem;
  Result.VrPrecoUnit := ASource.VrPrecoUnit;
  Result.VrBruto := ASource.VrBruto;
  Result.VrDesc := ASource.VrDesc;
  Result.VrTotal := ASource.VrTotal;

  LItem.Free;
end;

function TLojaModelVenda.InserirItemVenda(
  ANovoItem: TLojaModelDtoReqVendaItem): TLojaModelDtoRespVendaItem;
begin

end;

function TLojaModelVenda.InserirMeiosPagtoVenda(ANumVnda: Integer;
  AMeiosPagto: TLojaModelEntityVendaMeioPagtoLista): TLojaModelEntityVendaMeioPagtoLista;
begin

end;

class function TLojaModelVenda.New: ILojaModelVenda;
begin
  Result := Self.Create;
end;

function TLojaModelVenda.NovaVenda: TLojaModelEntityVendaVenda;
begin
  var LCaixa := ObterEValidarCaixa;
  LCaixa.Free;

  var LNovaVenda := TLojaModelEntityVendaVenda.Create;
  LNovaVenda.CodSit := sitPendente;
  LNovaVenda.DatIncl := Now;
  LNovaVenda.VrBruto := 0;
  LNovaVenda.VrDesc := 0;
  LNovaVenda.VrTotal := 0;

  var LVenda := TLojaModelDaoFactory.New.Venda
    .Venda
    .NovaVenda(LNovaVenda);

  Result := LVenda;
  LNovaVenda.Free;
end;

function TLojaModelVenda.ObterEValidarCaixa: TLojaModelEntityCaixaCaixa;
begin
  Result := nil;

  var LCaixa := TLojaModelBoFactory.New.Caixa.ObterCaixaAberto;

  if LCaixa = nil
  then raise EHorseException.New
    .Status(THTTPStatus.PreconditionRequired)
    .&Unit(Self.UnitName)
    .Error('Não há caixa aberto');
  try
    if Trunc(LCaixa.DatAbert) < Trunc(Now)
    then raise EHorseException.New
      .Status(THTTPStatus.PreconditionRequired)
      .&Unit(Self.UnitName)
      .Error('O caixa atual não foi aberto hoje. Realize o fechamento e uma nova abertura');

    Result := LCaixa;
  except
    LCaixa.Free;
    raise;
  end;
end;

function TLojaModelVenda.ObterItensVenda(
  ANumVnda: Integer): TLojaModelDtoRespVendaItemLista;
begin

end;

function TLojaModelVenda.ObterMeiosPagtoVenda(
  ANumVnda: Integer): TLojaModelEntityVendaMeioPagtoLista;
begin

end;

function TLojaModelVenda.ObterVenda(
  ANumVnda: Integer): TLojaModelEntityVendaVenda;
begin
  if ANumVnda <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O número de venda informado é inválido');

  Result := TLojaModelDaoFactory.New.Venda
    .Venda
    .ObterVenda(ANumVnda);

  if Result = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('Não foi possível encontrar a venda pelo número informado');
end;

function TLojaModelVenda.ObterVendas(ADatInclIni, ADatInclFim: TDate;
  ACodSit: TLojaModelEntityVendaSituacao): TLojaModelEntityVendaVendaLista;
begin
  if ADatInclIni > ADatInclFim
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('A data inicial deve ser inferior à data final em pelo menos 1 dia');

  Result := TLojaModelDaoFactory.New.Venda
    .Venda
    .ObterVendas(ADatInclIni, ADatInclFim, ACodSit);
end;

end.
