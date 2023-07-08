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
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelVenda;

    { ILojaModelVenda }
    function ObterVendas(ADatInclIni, ADatInclFim: TDate;
      AFlgApenasEfet: Boolean): TLojaModelEntityVendaVendaLista;

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

function TLojaModelVenda.CancelarVenda(
  ANumVnda: Integer): TLojaModelEntityVendaVenda;
begin

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

end;

function TLojaModelVenda.ObterVendas(ADatInclIni, ADatInclFim: TDate;
  AFlgApenasEfet: Boolean): TLojaModelEntityVendaVendaLista;
begin

end;

end.
