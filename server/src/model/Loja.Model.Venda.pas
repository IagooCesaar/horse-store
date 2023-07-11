unit Loja.Model.Venda;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Estoque.Types,

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

    function EfetivarVenda(ANumVnda: Integer): TLojaModelEntityVendaVenda;

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

  Loja.Model.Factory,
  Loja.Model.Dao.Factory,
  Loja.Model.Dto.Req.Caixa.CriarMovimento,
  Loja.Model.Dto.Req.Estoque.CriarMovimento;

{ TLojaModelVenda }

function TLojaModelVenda.AtualizarItemVenda(
  AItem: TLojaModelDtoReqVendaItem): TLojaModelDtoRespVendaItem;
begin

end;

function TLojaModelVenda.AtualizarMeiosPagtoVenda(ANumVnda: Integer;
  AMeiosPagto: TLojaModelEntityVendaMeioPagtoLista): TLojaModelEntityVendaMeioPagtoLista;
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
end;

function TLojaModelVenda.CalculaTotaisVenda(
  var AVenda: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;
begin
  var LItens := TLojaModelDaoFactory.New.Venda
    .Item
    .ObterItensVenda(AVenda.NumVnda);

  AVenda.VrBruto := 0;
  AVenda.VrDesc := 0;

  for var LItem in LItens
  do begin
    LItem.VrBruto := LItem.VrPrecoUnit * Litem.QtdItem;
    LItem.VrTotal := LItem.VrBruto - LItem.VrDesc;

    if LItem.CodSit = sitAtivo
    then begin
      AVenda.VrBruto := AVenda.VrBruto + LItem.VrTotal;
      AVenda.VrDesc := AVenda.VrDesc + LItem.VrDesc;
    end;
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

function TLojaModelVenda.EfetivarVenda(ANumVnda: Integer): TLojaModelEntityVendaVenda;
begin
  var LCaixa := ObterEValidarCaixa;

  var LVenda := TLojaModelDaoFactory.New.Venda
    .Venda
    .ObterVenda(ANumVnda);

  if LVenda = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('Não foi possível encontrar a venda pelo número informado');

  var LItens := TLojaModelDaoFactory.New.Venda
    .Item
    .ObterItensVenda(ANumVnda);

  var LMeiosPagto := TLojaModelDaoFactory.New.Venda
    .MeioPagto
    .ObterMeiosPagtoVenda(ANumVnda);

  try
    if LItens.Count = 0
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('Não há itens na venda');

    var LEncontrou := False;
    for var LItem in LItens
    do begin
      if LItem.CodSit = sitAtivo
      then begin
        LEncontrou := True;
        Break;
      end;
    end;
    if not LEncontrou
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('Não há itens ativos na venda');

    // Validar saldo estoque dos itens
    var LQtdItens := TDictionary<Integer, Integer>.Create;
    try
      for var LItem in LItens
      do begin
        if LItem.CodSit <> sitAtivo
        then continue;

        var LQtd := 0;

        if LQtdItens.ContainsKey(LItem.CodItem)
        then LQtdItens.TryGetValue(LItem.CodItem, LQtd);

        LQtd := LQtd + LItem.QtdItem;
        LQtdItens.AddOrSetValue(LItem.CodItem, LQtd);
      end;
      LQtdItens.TrimExcess;

      for var LKey in LQtdItens.Keys
      do begin
        var LSaldo := TLojaModelFactory.New.Estoque.ObterSaldoAtualItem(LKey);

        if LSaldo.QtdSaldoAtu < LQtdItens.Items[LKey]
        then raise EHorseException.New
          .Status(THTTPStatus.BadRequest)
          .&Unit(Self.UnitName)
          .Error(Format('Não há saldo disponível para o item %d (Saldo atual %d, Qtd Venda %d)', [
            LSaldo.CodItem, LSaldo.QtdSaldoAtu, LQtdItens.Items[LKey]
          ]));

        LSaldo.Free;
      end;
    finally
      LQtdItens.Free;
    end;

    if LMeiosPagto.Count = 0
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('Não há meios de pagamento definidos na venda');

    // Efetiva venda
    CalculaTotaisVenda(LVenda);
    LVenda.DatConcl := Now;
    LVenda.CodSit := sitEfetivada;

    Result := TLojaModelDaoFactory.New.Venda
      .Venda
      .AtualizarVenda(LVenda);

    // Fazer lançamento de caixa
    var LMovCaixa := TLojaModelDtoReqCaixaCriarMovimento.Create;
    LMovCaixa.CodCaixa := LCaixa.CodCaixa;
    LMovCaixa.DatMov := LVenda.DatConcl;
    LMovCaixa.CodTipoMov := TLojaModelEntityCaixaTipoMovimento.movEntrada;
    LMovCaixa.CodOrigMov := TLojaModelEntityCaixaOrigemMovimento.orgVenda;
    for var LMeioPagto in LMeiosPagto
    do begin
      LMovCaixa.DscObs := Format('Referente à venda %d - %d parcela(s) de %3.2f', [
        LVenda.NumVnda, LMeioPagto.QtdParc, RoundTo(LMeioPagto.VrParc / LMeioPagto.QtdParc, -2)
      ]);
      LMovCaixa.VrMov := LMeioPagto.VrParc;

      var LMovimento := TLojaModelBoFactory.New.Caixa.CriarMovimentoCaixa(LMovCaixa);
      LMovimento.Free;

    end;
    LMovCaixa.Free;

    // Gerar movimento de estoque
    var LMovEstq := TLojaModelDtoReqEstoqueCriarMovimento.Create;
    LMovEstq.DatMov := LVenda.DatConcl;
    LMovEstq.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movSaida;
    LMovEstq.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgVenda;
    for var LItem in LItens
    do begin
      if LItem.CodSit <> sitAtivo
      then Continue;

      LMovEstq.CodItem := LItem.CodItem;
      LMovEstq.QtdMov := Litem.QtdItem;
      LMovEstq.DscMot := Format('Referente à Venda %d, Item Seq. %d',[
        LItem.NumVnda, LItem.NumSeqItem]);

      var LMovimento := TLojaModelFactory.New
        .Estoque
        .CriarNovoMovimento(LMovEstq);
      LMovimento.Free;
    end;
    LMovEstq.Free;

  finally
    FreeAndNil(LCaixa);
    FreeAndNil(LVenda);
    FreeAndNil(LItens);
    FreeAndNil(LMeiosPagto);
  end;
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
  Result := nil;

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

  var LItens := TLojaModelDaoFactory.New.Venda
    .Item
    .ObterItensVenda(ANumVnda);

  Result := TLojaModelDtoRespVendaItemLista.Create;
  for var LItem in LItens
  do Result.Add(EntityToDto(LItem));

  LItens.Free;
end;

function TLojaModelVenda.ObterMeiosPagtoVenda(
  ANumVnda: Integer): TLojaModelEntityVendaMeioPagtoLista;
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

  Result := TLojaModelDaoFactory.New.Venda
    .MeioPagto
    .ObterMeiosPagtoVenda(ANumVnda);
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
