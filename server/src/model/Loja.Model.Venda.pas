unit Loja.Model.Venda;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Environment.Interfaces,
  Loja.Model.Interfaces,
  Loja.Model.Entity.Venda.Types,
  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Estoque.Types,

  Loja.Model.Entity.Venda.Venda,
  Loja.Model.Entity.Venda.MeioPagto,
  Loja.Model.Entity.Venda.Item,

  Loja.Model.Dto.Resp.Venda.Item,
  Loja.Model.Dto.Req.Venda.Item,
  Loja.Model.Dto.Req.Venda.EfetivaVenda,

  Loja.Model.Bo.Factory,
  Loja.Model.Entity.Caixa.Caixa;

type
  TLojaModelVenda = class(TInterfacedObject, ILojaModelVenda)
  private
    FEnvRules: ILojaEnvironmentRuler;
    function EntityToDto(ASource: TLojaModelEntityVendaItem): TLojaModelDtoRespVendaItem;
    function ObterEValidarCaixa: TLojaModelEntityCaixaCaixa;
    function CalculaTotaisVenda(var AVenda: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;

    function ObterEValidarVenda(ANumVnda: Integer; AValidarPendente: Boolean): TLojaModelEntityVendaVenda;
  public
    constructor Create(AEnvRules: ILojaEnvironmentRuler);
    destructor Destroy; override;
    class function New(AEnvRules: ILojaEnvironmentRuler): ILojaModelVenda;

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
    function DefinirMeiosPagtoVenda(ANumVnda: Integer;
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

constructor TLojaModelVenda.Create(AEnvRules: ILojaEnvironmentRuler);
begin
  FEnvRules := AEnvRules;
end;

destructor TLojaModelVenda.Destroy;
begin

  inherited;
end;

class function TLojaModelVenda.New(AEnvRules: ILojaEnvironmentRuler): ILojaModelVenda;
begin
  Result := Self.Create(AEnvRules);
end;

function TLojaModelVenda.EntityToDto(
  ASource: TLojaModelEntityVendaItem): TLojaModelDtoRespVendaItem;
begin
  Result := nil;

  var LItem := TLojaModelDaoFactory.New(FEnvRules).Itens
    .Item
    .ObterPorCodigo(ASource.CodItem);

  Result := TLojaModelDtoRespVendaItem.Create;
  Result.NumVnda := ASource.NumVnda;
  Result.NumSeqItem := ASource.NumSeqItem;
  Result.CodItem := ASource.CodItem;
  Result.NomItem := LItem.NomItem;
  Result.FlgTabPreco := LItem.FlgTabPreco = 'S';
  Result.CodSit := ASource.CodSit;
  Result.QtdItem := ASource.QtdItem;
  Result.VrPrecoUnit := ASource.VrPrecoUnit;
  Result.VrBruto := ASource.VrBruto;
  Result.VrDesc := ASource.VrDesc;
  Result.VrTotal := ASource.VrTotal;

  LItem.Free;
end;

function TLojaModelVenda.ObterEValidarCaixa: TLojaModelEntityCaixaCaixa;
begin
  Result := nil;

  var LCaixa := TLojaModelBoFactory.New(FEnvRules).Caixa.ObterCaixaAberto;

  if LCaixa = nil
  then raise EHorseException.New
    .Status(THTTPStatus.PreconditionRequired)
    .&Unit(Self.UnitName)
    .Error('N�o h� caixa aberto');
  try
    if Trunc(LCaixa.DatAbert) < Trunc(Now)
    then raise EHorseException.New
      .Status(THTTPStatus.PreconditionRequired)
      .&Unit(Self.UnitName)
      .Error('O caixa atual n�o foi aberto hoje. Realize o fechamento e uma nova abertura');

    Result := LCaixa;
  except
    LCaixa.Free;
    raise;
  end;
end;

function TLojaModelVenda.CalculaTotaisVenda(
  var AVenda: TLojaModelEntityVendaVenda): TLojaModelEntityVendaVenda;
begin
  var LItens := TLojaModelDaoFactory.New(FEnvRules).Venda
    .Item
    .ObterItensVenda(AVenda.NumVnda);

  AVenda.VrBruto := 0;
  AVenda.VrDesc := 0;
  AVenda.VrTotal := 0;

  for var LItem in LItens
  do begin
    LItem.VrBruto := LItem.VrPrecoUnit * Litem.QtdItem;
    LItem.VrTotal := LItem.VrBruto - LItem.VrDesc;

    if LItem.CodSit = sitAtivo
    then begin
      AVenda.VrBruto := AVenda.VrBruto + LItem.VrBruto;
      AVenda.VrDesc := AVenda.VrDesc + LItem.VrDesc;
      AVenda.VrTotal := AVenda.VrTotal + LItem.VrTotal;
    end;
  end;

  LItens.Free;
end;

function TLojaModelVenda.ObterEValidarVenda(ANumVnda: Integer;
  AValidarPendente: Boolean): TLojaModelEntityVendaVenda;
begin
  Result := nil;

  if ANumVnda <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O n�mero de venda informado � inv�lido');

  var LVenda := TLojaModelDaoFactory.New(FEnvRules).Venda
    .Venda
    .ObterVenda(ANumVnda);

  if LVenda = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('N�o foi poss�vel encontrar a venda pelo n�mero informado');

  try
    if  AValidarPendente
    and (LVenda.CodSit <> sitPendente)
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('A venda informada n�o est� Pendente');
  except
    LVenda.Free;
    raise;
  end;

  Result := LVenda;
end;

function TLojaModelVenda.ObterVendas(ADatInclIni, ADatInclFim: TDate;
  ACodSit: TLojaModelEntityVendaSituacao): TLojaModelEntityVendaVendaLista;
begin
  if ADatInclIni > ADatInclFim
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('A data inicial deve ser inferior � data final em pelo menos 1 dia');

  Result := TLojaModelDaoFactory.New(FEnvRules).Venda
    .Venda
    .ObterVendas(ADatInclIni, ADatInclFim, ACodSit);
end;

function TLojaModelVenda.ObterVenda(
  ANumVnda: Integer): TLojaModelEntityVendaVenda;
begin
  Result := nil;

  var LVenda := ObterEValidarVenda(ANumVnda, False);

  CalculaTotaisVenda(LVenda);
  Result := TLojaModelDaoFactory.New(FEnvRules).Venda
    .Venda
    .AtualizarVenda(LVenda);
  LVenda.Free;
end;

function TLojaModelVenda.NovaVenda: TLojaModelEntityVendaVenda;
begin
  Result := nil;

  var LCaixa := ObterEValidarCaixa;
  LCaixa.Free;

  var LNovaVenda := TLojaModelEntityVendaVenda.Create;
  LNovaVenda.CodSit := sitPendente;
  LNovaVenda.DatIncl := Now;
  LNovaVenda.VrBruto := 0;
  LNovaVenda.VrDesc := 0;
  LNovaVenda.VrTotal := 0;

  var LVenda := TLojaModelDaoFactory.New(FEnvRules).Venda
    .Venda
    .NovaVenda(LNovaVenda);

  Result := LVenda;
  LNovaVenda.Free;
end;

 function TLojaModelVenda.CancelarVenda(
  ANumVnda: Integer): TLojaModelEntityVendaVenda;
begin
  Result := nil;
  var LVenda := ObterEValidarVenda(ANumVnda, True);

  try
    CalculaTotaisVenda(LVenda);
    LVenda.CodSit := sitCancelada;
    LVenda.DatConcl := Now;

    Result := TLojaModelDaoFactory.New(FEnvRules).Venda
      .Venda
      .AtualizarVenda(LVenda);
  finally
    LVenda.Free;
  end;
end;

function TLojaModelVenda.EfetivarVenda(ANumVnda: Integer): TLojaModelEntityVendaVenda;
begin
  Result := nil;

  var LVenda := ObterEValidarVenda(ANumVnda, True);

  var LCaixa := ObterEValidarCaixa;

  var LItens := TLojaModelDaoFactory.New(FEnvRules).Venda
    .Item
    .ObterItensVenda(ANumVnda);

  var LMeiosPagto := TLojaModelDaoFactory.New(FEnvRules).Venda
    .MeioPagto
    .ObterMeiosPagtoVenda(ANumVnda);

  try
    if LItens.Count = 0
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('N�o h� itens na venda');

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
      .Error('N�o h� itens ativos na venda');

    var LPrecoUnitOk := True;
    for var LItem in LItens
    do begin
      if  (LItem.CodSit = sitAtivo)
      and (LItem.VrPrecoUnit <= 0)
      then begin
        LPrecoUnitOk := False;
        Break;
      end;
    end;
    if not LPrecoUnitOk
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('Todos os itens da venda dever�o possuir pre�o unit�rio superior a zero');

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
        var LSaldo := TLojaModelFactory.New(FEnvRules)
          .Estoque.ObterSaldoAtualItem(LKey);
        try
          if LSaldo.QtdSaldoAtu < LQtdItens.Items[LKey]
          then begin
            var LItem := TLojaModelFactory.New(FEnvRules).Itens.ObterPorCodigo(LKey);
            try
              if not LItem.FlgPermSaldNeg
              then raise EHorseException.New
                .Status(THTTPStatus.BadRequest)
                .&Unit(Self.UnitName)
                .Error(Format('N�o h� saldo dispon�vel para o item %d (Saldo atual %d, Qtd Venda %d)', [
                  LSaldo.CodItem, LSaldo.QtdSaldoAtu, LQtdItens.Items[LKey]
                ]));
            finally
              LItem.Free;
            end;
          end;
        finally
          LSaldo.Free;
        end;
      end;
    finally
      LQtdItens.Free;
    end;

    CalculaTotaisVenda(LVenda);
    if LVenda.VrTotal <= 0
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('O valor total da venda deve ser superior a zero');

    if LMeiosPagto.Count = 0
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('N�o h� meios de pagamento definidos na venda');

    var LTotalMeioPagto := 0.00;

    for var LMeioPagto in LMeiosPagto
    do LTotalMeioPagto := LTotalMeioPagto + LMeioPagto.VrTotal;

    if LTotalMeioPagto <> LVenda.VrTotal
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error(Format(
        'Os valores informados nos meios de pagamentos (R$ %8.2f) n�o coincidem com o total da venda (R$ %8.2f)',
        [LTotalMeioPagto, LVenda.VrTotal]
      ));

    // Efetiva venda
    LVenda.DatConcl := Now;
    LVenda.CodSit := sitEfetivada;

    Result := TLojaModelDaoFactory.New(FEnvRules).Venda
      .Venda
      .AtualizarVenda(LVenda);

    // Fazer lan�amento de caixa
    var LMovCaixa := TLojaModelDtoReqCaixaCriarMovimento.Create;
    LMovCaixa.CodCaixa := LCaixa.CodCaixa;
    LMovCaixa.DatMov := LVenda.DatConcl;
    LMovCaixa.CodTipoMov := TLojaModelEntityCaixaTipoMovimento.movEntrada;
    LMovCaixa.CodOrigMov := TLojaModelEntityCaixaOrigemMovimento.orgVenda;
    for var LMeioPagto in LMeiosPagto
    do begin
      LMovCaixa.DscObs := Format('Referente � venda %d - %d parcela(s) de %3.2f', [
        LVenda.NumVnda, LMeioPagto.QtdParc, RoundTo(LMeioPagto.VrTotal / LMeioPagto.QtdParc, -2)
      ]);
      LMovCaixa.VrMov := LMeioPagto.VrTotal;
      LMovCaixa.CodMeioPagto := LMeioPagto.CodMeioPagto;

      var LMovimento := TLojaModelBoFactory.New(FEnvRules).Caixa.CriarMovimentoCaixa(LMovCaixa);
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
      LMovEstq.DscMot := Format('Referente � Venda %d, Item Seq. %d',[
        LItem.NumVnda, LItem.NumSeqItem]);

      var LMovimento := TLojaModelFactory.New(FEnvRules)
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

function TLojaModelVenda.ObterItensVenda(
  ANumVnda: Integer): TLojaModelDtoRespVendaItemLista;
begin
  Result := nil;

  var LVenda := ObterEValidarVenda(ANumVnda, False);

  var LItens := TLojaModelDaoFactory.New(FEnvRules).Venda
    .Item
    .ObterItensVenda(ANumVnda);

  Result := TLojaModelDtoRespVendaItemLista.Create;
  for var LItem in LItens
  do Result.Add(EntityToDto(LItem));

  LItens.Free;
  LVenda.Free;
end;

function TLojaModelVenda.InserirItemVenda(
  ANovoItem: TLojaModelDtoReqVendaItem): TLojaModelDtoRespVendaItem;
begin
  Result := nil;

  if ANovoItem.QtdItem <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('A quantidade do item vendido dever� ser superior a zero');

  var LItem := TLojaModelDaoFactory.New(FEnvRules).Itens.Item.ObterPorCodigo(ANovoItem.CodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('N�o foi poss�vel encontrar o item informado');

  try
    var LVenda := ObterEValidarVenda(ANovoItem.NumVnda, True);
    try
      var LPrecoVnda := TLojaModelDaoFactory.New(FEnvRules).Preco.Venda.ObterPrecoVendaAtual(ANovoItem.CodItem);
      if (LPrecoVnda = nil) and (LItem.FlgTabPreco = 'S')
      then raise EHorseException.New
        .Status(THTTPStatus.NotFound)
        .&Unit(Self.UnitName)
        .Error('N�o h� pre�o de venda implantado para o item');

      var LItemVenda := TLojaModelEntityVendaItem.Create;
      try
        LItemVenda.NumVnda := ANovoItem.NumVnda;
        LItemVenda.CodItem := ANovoItem.CodItem;
        LItemVenda.NumSeqItem := TLojaModelDaoFactory.New(FEnvRules).Venda.Item.ObterUltimoNumSeq(LItemVenda.NumVnda) + 1;
        LItemVenda.CodSit := sitAtivo;
        LItemVenda.QtdItem := ANovoItem.QtdItem;
        if LPrecoVnda = nil
        then LItemVenda.VrPrecoUnit := ANovoItem.VrPrecoUnit
        else LItemVenda.VrPrecoUnit := LPrecoVnda.VrVnda;
        LItemVenda.VrBruto := RoundTo(LItemVenda.QtdItem * LItemVenda.VrPrecoUnit, -2);
        LItemVenda.VrDesc := ANovoItem.VrDesc;
        LItemVenda.VrTotal := LItemVenda.VrBruto - LItemVenda.VrDesc;

        if LItemVenda.VrTotal < 0
        then raise EHorseException.New
          .Status(THTTPStatus.BadRequest)
          .&Unit(Self.UnitName)
          .Error('O valor total do item n�o pode ser negativo');

        var LItemInserido := TLojaModelDaoFactory.New(FEnvRules).Venda
          .Item
          .InserirItem(LItemVenda);

        Result := EntityToDto(LItemInserido);
        LItemInserido.Free;

        CalculaTotaisVenda(LVenda);
        var LVendaAtualizada := TLojaModelDaoFactory.New(FEnvRules).Venda
          .Venda
          .AtualizarVenda(LVenda);
        LVendaAtualizada.Free;

      finally
        if LPrecoVnda <> nil
        then LPrecoVnda.Free;
        LItemVenda.Free;
      end;
    finally
      LVenda.Free;
    end;
  finally
    FreeAndNil(LItem);
  end;
end;

function TLojaModelVenda.AtualizarItemVenda(
  AItem: TLojaModelDtoReqVendaItem): TLojaModelDtoRespVendaItem;
begin
  Result := nil;

  if AItem.QtdItem <= 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('A quantidade do item vendido dever� ser superior a zero');

  var LItem := TLojaModelDaoFactory.New(FEnvRules).Itens.Item.ObterPorCodigo(AItem.CodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.NotFound)
    .&Unit(Self.UnitName)
    .Error('N�o foi poss�vel encontrar o item informado');

  try
    var LVenda := ObterEValidarVenda(AItem.NumVnda, True);
    try
      var LPrecoVnda := TLojaModelDaoFactory.New(FEnvRules).Preco.Venda.ObterPrecoVendaAtual(AItem.CodItem);
      if (LPrecoVnda = nil) and (LItem.FlgTabPreco = 'S')
      then raise EHorseException.New
        .Status(THTTPStatus.NotFound)
        .&Unit(Self.UnitName)
        .Error('N�o h� pre�o de venda implantado para o item');

      var LItemVenda := TLojaModelDaoFactory.New(FEnvRules).Venda
        .Item
        .ObterItem(AItem.NumVnda, AItem.NumSeqItem);
      try
        if LItemVenda = nil
        then raise EHorseException.New
          .Status(THTTPStatus.NotFound)
          .&Unit(Self.UnitName)
          .Error('N�o foi poss�vel encontrar item deste sequencial na venda informada');

        if LItemVenda.CodSit = TLojaModelEntityVendaItemSituacao.sitRemovido
        then raise EHorseException.New
          .Status(THTTPStatus.BadRequest)
          .&Unit(Self.UnitName)
          .Error('Este item foi removido da venda, portanto n�o pode ser alterado');

        LItemVenda.CodItem := AItem.CodItem;
        LItemVenda.NumVnda := AItem.NumVnda;
        LItemVenda.NumSeqItem := LItemVenda.NumSeqItem;

        LItemVenda.CodSit := AItem.CodSit;
        LItemVenda.CodItem := AItem.CodItem;
        LItemVenda.QtdItem := AItem.QtdItem;
        if LPrecoVnda = nil
        then LItemVenda.VrPrecoUnit := AItem.VrPrecoUnit
        else LItemVenda.VrPrecoUnit := LPrecoVnda.VrVnda;
        LItemVenda.VrBruto := RoundTo(LItemVenda.QtdItem * LItemVenda.VrPrecoUnit, -2);
        LItemVenda.VrDesc := AItem.VrDesc;
        LItemVenda.VrTotal := LItemVenda.VrBruto - LItemVenda.VrDesc;

        if LItemVenda.VrTotal < 0
        then raise EHorseException.New
          .Status(THTTPStatus.BadRequest)
          .&Unit(Self.UnitName)
          .Error('O valor total do item n�o pode ser negativo');

        var LItemAtualizado := TLojaModelDaoFactory.New(FEnvRules).Venda
          .Item
          .AtulizarItem(LItemVenda);

        Result := EntityToDto(LItemAtualizado);
        LItemAtualizado.Free;

        CalculaTotaisVenda(LVenda);
        var LVendaAtualizada := TLojaModelDaoFactory.New(FEnvRules).Venda
          .Venda
          .AtualizarVenda(LVenda);
        LVendaAtualizada.Free;

      finally
        FreeAndNil(LPrecoVnda);
        LItemVenda.Free;
      end;
    finally
      LVenda.Free;
    end;
  finally
    FreeAndNil(LItem);
  end;
end;

 function TLojaModelVenda.ObterMeiosPagtoVenda(
  ANumVnda: Integer): TLojaModelEntityVendaMeioPagtoLista;
begin
  Result := nil;

  var LVenda := ObterEValidarVenda(ANumVnda, False);

  Result := TLojaModelDaoFactory.New(FEnvRules).Venda
    .MeioPagto
    .ObterMeiosPagtoVenda(ANumVnda);

  LVenda.Free;
end;

function TLojaModelVenda.DefinirMeiosPagtoVenda(ANumVnda: Integer;
  AMeiosPagto: TLojaModelEntityVendaMeioPagtoLista): TLojaModelEntityVendaMeioPagtoLista;
begin
  Result := nil;
  var LVenda := ObterEValidarVenda(ANumVnda, True);

  try
    if AMeiosPagto.Count = 0
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('� necess�rio informar ao menos um meio de pagamento');

    TLojaModelDaoFactory.New(FEnvRules).Venda
      .MeioPagto
      .RemoverMeiosPagtoVenda(ANumVnda);

    var LNumSeq := 0;
    Result := TLojaModelEntityVendaMeioPagtoLista.Create;

    for var LMeioPagto in AMeiosPagto
    do begin
      if LMeioPagto.VrTotal <= 0
      then Continue;

      if LMeioPagto.QtdParc <= 0
      then Continue;

      Inc(LNumSeq);
      LMeioPagto.NumSeqMeioPagto := LNumSeq;
      LMeioPagto.NumVnda := ANumVnda;

      var LNovo := TLojaModelDaoFactory.New(FEnvRules).Venda
        .MeioPagto
        .InserirMeioPagto(LMeioPagto);

      Result.Add(LNovo);
    end;
  finally
    FreeAndNil(LVenda);
  end;
end;

end.
