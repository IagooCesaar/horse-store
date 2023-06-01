unit Loja.Model.Estoque;

interface

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  System.Generics.Defaults,
  System.Generics.Collections,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Estoque.Movimento,
  Loja.Model.Entity.Estoque.Saldo,
  Loja.Model.Dto.Req.Estoque.CriarMovimento,
  Loja.Model.Dto.Req.Estoque.AcertoEstoque;

type
  TLojaModelEstoque = class(TinterfacedObject, ILojaModelEstoque)
  private
    procedure RealizarFechamentoSaldoDiario(ACodItem: Integer);
    procedure RealizarFechamentoSaldoMensal(ACodItem: Integer);
    procedure RealizarFechamentoSaldo(ACodItem: Integer);
    function SaldoAtualItem(ACodItem: Integer): Integer;
  public
    constructor Create;
	  destructor Destroy; override;
	  class function New: ILojaModelEstoque;

    { ILojaModelEstoque }
    function CriarNovoMovimento(ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
    function CriarAcertoEstoque(AAcertoEstoque: TLojaModelDtoReqEstoqueAcertoEstoque): TLojaModelEntityEstoqueMovimento;
    function ObterHistoricoMovimento(ACodItem: Integer; ADatIni, ADatFim: TDateTime): TLojaModelEntityEstoqueMovimentoLista;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Factory,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Entity.Estoque.Types;

{ TLojaModelEstoque }

constructor TLojaModelEstoque.Create;
begin

end;

function TLojaModelEstoque.CriarAcertoEstoque(
  AAcertoEstoque: TLojaModelDtoReqEstoqueAcertoEstoque): TLojaModelEntityEstoqueMovimento;
const C_MOT_MIN = 4; C_MOT_MAX = 40;
var
  LItem: TLojaModelEntityItensItem;
  LSaldo: Integer;
  LMovimento: TLojaModelDtoReqEstoqueCriarMovimento;
begin
  Result := nil;
  if AAcertoEstoque.DscMot = ''
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('A descri��o do motivo � obrigat�ria para acerto de estoque');

  if AAcertoEstoque.QtdSaldoReal < 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('N�o � permitido estoque negativo');

  LItem := TLojaModelDaoFactory.New.Itens.Item.ObterPorCodigo(AAcertoEstoque.CodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O item informado n�o existe');
  LItem.Free;


  LSaldo := SaldoAtualItem(AAcertoEstoque.CodItem);
  if LSaldo = AAcertoEstoque.QtdSaldoReal
  then raise EHorseException.New
    .Status(THTTPStatus.ExpectationFailed)
    .&Unit(Self.UnitName)
    .Error('O saldo atual do item j� est� conforme o acerto informado');

  LMovimento := TLojaModelDtoReqEstoqueCriarMovimento.Create;
  try
    LMovimento.CodItem := AAcertoEstoque.CodItem;
    LMovimento.DatMov := Now;
    LMovimento.QtdMov := Abs(AAcertoEstoque.QtdSaldoReal - LSaldo);
    if AAcertoEstoque.QtdSaldoReal <  LSaldo
    then LMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movSaida
    else LMovimento.CodTipoMov := TLojaModelEntityEstoqueTipoMovimento.movEntrada;
    LMovimento.CodOrigMov := TLojaModelEntityEstoqueOrigemMovimento.orgAcerto;
    LMovimento.DscMot := AAcertoEstoque.DscMot;

    Result := CriarNovoMovimento(LMovimento);
  finally
    LMovimento.Free;
  end;
end;

function TLojaModelEstoque.CriarNovoMovimento(
  ANovoMovimento: TLojaModelDtoReqEstoqueCriarMovimento): TLojaModelEntityEstoqueMovimento;
const C_MOT_MIN = 4; C_MOT_MAX = 40;
var
  LItem: TLojaModelEntityItensItem;
  LSaldo: Integer;
  LMovimento: TLojaModelDtoReqEstoqueCriarMovimento;
begin
  Result := nil;

  if ANovoMovimento.DscMot <> ''
  then begin
    if Length(ANovoMovimento.DscMot) < C_MOT_MIN
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error(Format('A descri��o do motivo para realiza��o do acerto dever� ter no m�nimo %d caracteres', [ C_MOT_MIN ]));

    if Length(ANovoMovimento.DscMot) > C_MOT_MAX
    then raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error(Format('A descri��o do motivo para realiza��o do acerto dever� ter no m�ximo %d caracteres', [ C_MOT_MAX ]));
  end
  else
  if ANovoMovimento.CodOrigMov = orgAcerto
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('� obrigat�rio informar o motivo do acerto de estoque');

  case ANovoMovimento.CodTipoMov of
    movEntrada:
      if not(ANovoMovimento.CodOrigMov in ESTOQUE_MOVIMENTOS_ENTRADA)
      then raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(Self.UnitName)
        .Error('A origem do movimento de estoque n�o � do tipo de movimento de Entrada');

    movSaida:
      if not(ANovoMovimento.CodOrigMov in ESTOQUE_MOVIMENTOS_SAIDA)
      then raise EHorseException.New
        .Status(THTTPStatus.BadRequest)
        .&Unit(Self.UnitName)
        .Error('A origem do movimento de estoque n�o � do tipo de movimento de Sa�da');

  else
    raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error('N�o foi poss�vel reconhecer o tipo de movimento de estoque');
  end;

  LItem := TLojaModelDaoFactory.New.Itens.Item.ObterPorCodigo(ANovoMovimento.CodItem);
  if LItem = nil
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O item informado n�o existe');
  LItem.Free;

  Result := TLojaModelDaoFactory.New.Estoque
    .Movimento
    .CriarNovoMovimento(ANovoMovimento);
end;

destructor TLojaModelEstoque.Destroy;
begin

  inherited;
end;

class function TLojaModelEstoque.New: ILojaModelEstoque;
begin
  Result := Self.Create;
end;

function TLojaModelEstoque.ObterHistoricoMovimento(ACodItem: Integer; ADatIni,
  ADatFim: TDateTime): TLojaModelEntityEstoqueMovimentoLista;
begin
  Result := nil;
end;

procedure TLojaModelEstoque.RealizarFechamentoSaldo(ACodItem: Integer);
begin
  RealizarFechamentoSaldoMensal(ACodItem);
  //RealizarFechamentoSaldoDiario(ACodItem);
end;

procedure TLojaModelEstoque.RealizarFechamentoSaldoDiario(ACodItem: Integer);
var
  LUltSaldo: Integer;
  LDatIni, LDatFim : TDateTime;
  LUltFechamento: TLojaModelEntityEstoqueSaldo;
  LMovimentos: TLojaModelEntityEstoqueMovimentoLista;
begin
// Realiza fechamento de saldo di�rio at� "ontem"
  try
    LUltFechamento := TLojaModelDaoFactory.New.Estoque
      .Saldo
      .ObterUltimoFechamentoItem(ACodItem);

    if LUltFechamento <> nil
    then begin
      LDatIni := Trunc(LUltFechamento.DatSaldo)+1;
      LUltSaldo := LUltFechamento.QtdSaldo;
    end else
    begin
      LDatIni := EncodeDate(1900,01,01);
      LUltSaldo := 0;
    end;

    LDatFim := Trunc(Now)-1;

    if LDatIni <= LDatFim then
    begin
      LMovimentos := TLojaModelDaoFactory.New.Estoque
        .Movimento
        .ObterMovimentoItemEntreDatas(ACodItem, LDatIni, LDatFim);
      try
        if (LMovimentos <> nil) and (LMovimentos.Count > 0)
        then begin
          //Ordenar pela data de movimenta��o
          LMovimentos.Sort(
            TComparer<TLojaModelEntityEstoqueMovimento>.Construct(
            function (const L, R: TLojaModelEntityEstoqueMovimento): Integer
            begin
              if Trunc(L.DatMov) > Trunc(R.DatMov)
              then Result := 1
              else
              if Trunc(L.DatMov) < Trunc(R.DatMov)
              then Result := -1
              else Result := 0;
            end)
          );

          LDatIni := LMovimentos.First.DatMov;

          for var LMovimento in LMovimentos do
          begin
            if LDatIni <> LMovimento.DatMov
            then begin
              var LFecha := TLojaModelDaoFactory.New.Estoque
                .Saldo
                .CriarFechamentoSaldoItem(ACodItem, LDatIni, LUltSaldo);
              LFecha.Free;
            end;

            while LDatIni < (LMovimento.DatMov-1)
            do begin
              LDatIni := LDatIni + 1;
              var LFecha := TLojaModelDaoFactory.New.Estoque
                .Saldo
                .CriarFechamentoSaldoItem(ACodItem, LDatIni, LUltSaldo);
              LFecha.Free;
            end;

            LDatIni := LMovimento.DatMov;

            case LMovimento.CodTipoMov of
              movEntrada:
                Inc(LUltSaldo, LMovimento.QtdMov);
              movSaida:
                Dec(LUltSaldo, LMovimento.QtdMov);
            end;
          end;

          var LFecha := TLojaModelDaoFactory.New.Estoque
            .Saldo
            .CriarFechamentoSaldoItem(ACodItem, LDatIni, LUltSaldo);
          LFecha.Free;

          LDatIni := LDatIni +1;
          while LDatIni <= LDatFim
          do begin

            LFecha := TLojaModelDaoFactory.New.Estoque
              .Saldo
              .CriarFechamentoSaldoItem(ACodItem, LDatIni, LUltSaldo);
            LFecha.Free;
            LDatIni := LDatIni + 1;
          end;

        end
        else
        begin
          if LDatIni = EncodeDate(1900,01,01)
          then begin
            // Se n�o houve movimentos, criar um fechamento com saldo zero "ontem"
            var LFecha := TLojaModelDaoFactory.New.Estoque
              .Saldo
              .CriarFechamentoSaldoItem(ACodItem, LDatFim, LUltSaldo);
            LFecha.Free;
          end else
          while LDatIni <= LDatFim
          do begin
            var LFecha := TLojaModelDaoFactory.New.Estoque
              .Saldo
              .CriarFechamentoSaldoItem(ACodItem, LDatIni, LUltSaldo);
            LFecha.Free;
            LDatIni := LDatIni + 1;
          end;
        end;
      finally
        if LMovimentos <> nil
        then FreeAndNil(LMovimentos);
      end;
    end;
  finally
    if LUltFechamento <> nil
    then FreeAndNil(LUltFechamento);
  end;
end;

procedure TLojaModelEstoque.RealizarFechamentoSaldoMensal(ACodItem: Integer);
var
  LHaFechamento: Boolean;
  LUltSaldo: Integer;
  LDatUltFech, LDatIni, LDatFim : TDateTime;
  LUltFechamento: TLojaModelEntityEstoqueSaldo;
  LMovimentos: TLojaModelEntityEstoqueMovimentoLista;
begin
  // Realiza fechamento de saldo mensal at� m�s anterior
  try
    LUltFechamento := TLojaModelDaoFactory.New.Estoque
      .Saldo
      .ObterUltimoFechamentoItem(ACodItem);

    if LUltFechamento <> nil
    then begin
      LDatUltFech := LUltFechamento.DatSaldo;
      LUltSaldo := LUltFechamento.QtdSaldo;
      LHaFechamento := True;
    end else
    begin
      LDatUltFech := EncodeDate(1900,01,01);
      LUltSaldo := 0;
      LHaFechamento := False;
    end;
    // ultimo dia do m�s anterior
    LDatFim := EndOfTheMonth(EncodeDate(YearOf(Now), MonthOf(Now), 1)-1);

    // Se o �ltimo m�s ainda n�o estiver fechado
    if LDatUltFech < LDatFim then
    begin
      LDatIni := LDatUltFech+1;

      LMovimentos := TLojaModelDaoFactory.New.Estoque
        .Movimento
        .ObterMovimentoItemEntreDatas(ACodItem, LDatIni, LDatFim);
      try
        if (LMovimentos <> nil) and (LMovimentos.Count > 0)
        then begin
          //Ordenar pela data de movimenta��o
          LMovimentos.Sort(
            TComparer<TLojaModelEntityEstoqueMovimento>.Construct(
            function (const L, R: TLojaModelEntityEstoqueMovimento): Integer
            begin
              if Trunc(L.DatMov) > Trunc(R.DatMov)
              then Result := 1
              else
              if Trunc(L.DatMov) < Trunc(R.DatMov)
              then Result := -1
              else Result := 0;
            end)
          );

          // �ltimo dia do m�s tendo como refer�ncia a data do movimento
          LDatIni := EndOfTheMonth(LMovimentos.First.DatMov);

          // Se h� intervalo maior que 1 m�s entre �ltimo fechamento e o esperado
          if LHaFechamento then
            while SameDate(StartOfTheMonth(LDatUltFech), StartOfTheMonth(LDatIni))
            do begin
              // �ltimo dia do pr�ximo m�s
              LDatUltFech := EndOfTheMonth(LDatUltFech+1);
              var LFecha := TLojaModelDaoFactory.New.Estoque
                .Saldo
                .CriarFechamentoSaldoItem(ACodItem, LDatUltFech, LUltSaldo);
              LFecha.Free;
            end;

          for var LMovimento in LMovimentos do
          begin
            // Se o pr�ximo movimento n�o for no m�s subsequente
            while not(SameDate(StartOfTheMonth(LMovimento.DatMov), StartOfTheMonth(LDatIni)))
            do begin
              LDatUltFech := LDatIni;
              var LFecha := TLojaModelDaoFactory.New.Estoque
                .Saldo
                .CriarFechamentoSaldoItem(ACodItem, LDatUltFech, LUltSaldo);
              LFecha.Free;
              LDatIni := EndOfTheMonth(LDatUltFech+1);
            end;

            case LMovimento.CodTipoMov of
              movEntrada:
                Inc(LUltSaldo, LMovimento.QtdMov);
              movSaida:
                Dec(LUltSaldo, LMovimento.QtdMov);
            end;
          end;

          repeat
            LDatUltFech := LDatIni;
            var LFecha := TLojaModelDaoFactory.New.Estoque
              .Saldo
              .CriarFechamentoSaldoItem(ACodItem, LDatUltFech, LUltSaldo);
            LFecha.Free;
            LDatIni := EndOfTheMonth(LDatUltFech+1);
          until (SameDate(StartOfTheMonth(LDatIni), StartOfTheMonth(LDatFim+1)));
        end
        else
        begin
          // Se n�o houve fechamentos e nem movimentos
          if not LHaFechamento
          then begin
            var LFecha := TLojaModelDaoFactory.New.Estoque
              .Saldo
              .CriarFechamentoSaldoItem(ACodItem, LDatFim, LUltSaldo);
            LFecha.Free;
          end else
          // houve fechamento, mas n�o houve movimentos
          begin
            LDatIni := EndOfTheMonth(LDatIni);
            repeat
              LDatUltFech := LDatIni;
              var LFecha := TLojaModelDaoFactory.New.Estoque
                .Saldo
                .CriarFechamentoSaldoItem(ACodItem, LDatUltFech, LUltSaldo);
              LFecha.Free;
              LDatIni := EndOfTheMonth(LDatUltFech+1);
            until (SameDate(StartOfTheMonth(LDatIni), StartOfTheMonth(LDatFim+1)));
          end;
        end;
      finally
        if LMovimentos <> nil
        then FreeAndNil(LMovimentos);
      end;
    end;
  finally
    if LUltFechamento <> nil
    then FreeAndNil(LUltFechamento);
  end;
end;

function TLojaModelEstoque.SaldoAtualItem(ACodItem: Integer): Integer;
var
  LUltSaldo: Integer;
  LDatIni, LDatFim : TDateTime;
  LUltFechamento: TLojaModelEntityEstoqueSaldo;
  LMovimentos: TLojaModelEntityEstoqueMovimentoLista;
begin
  Result := 0;
  RealizarFechamentoSaldo(ACodItem);
  try
    LUltFechamento := TLojaModelDaoFactory.New.Estoque
      .Saldo
      .ObterUltimoFechamentoItem(ACodItem);

    if LUltFechamento <> nil
    then begin
      LDatIni := Trunc(LUltFechamento.DatSaldo)+1;
      LUltSaldo := LUltFechamento.QtdSaldo;
    end else
    begin
      LDatIni := EncodeDate(1900,01,01);
      LUltSaldo := 0;
    end;

    LDatFim := Trunc(Now);

    LMovimentos := TLojaModelDaoFactory.New.Estoque
      .Movimento
      .ObterMovimentoItemEntreDatas(ACodItem, LDatIni, LDatFim);
    if (LMovimentos <> nil) and (LMovimentos.Count > 0)
    then begin
      for var LMovimento in LMovimentos do
      begin
        case LMovimento.CodTipoMov of
          movEntrada:
            Inc(LUltSaldo, LMovimento.QtdMov);
          movSaida:
            Dec(LUltSaldo, LMovimento.QtdMov);
        end;
      end;
    end;

    Result := LUltSaldo;
  finally
    if LUltFechamento <> nil
    then FreeAndNil(LUltFechamento);

    if LMovimentos <> nil
    then FreeAndNil(LMovimentos);
  end;
end;

end.
