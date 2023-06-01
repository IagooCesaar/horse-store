unit Loja.Model.Bo.Estoque;

interface

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  System.Generics.Defaults,
  System.Generics.Collections,
  Loja.Model.Bo.Interfaces;

type
  TLojaModelBoEstoque = class(TInterfacedObject,
    ILojaModelBoEstoque, ILojaModelBoEstoqueFechamentoSaldo)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelBoEstoque;

    { ILojaModelBoEstoque }
    function FechamentoSaldo: ILojaModelBoEstoqueFechamentoSaldo;

    { ILojaModelBoEstoqueFechamentoSaldo }
    function FechamentoSaldoMensalItem(ACodItem: Integer): ILojaModelBoEstoqueFechamentoSaldo;
    function EndFechamentoSaldo: ILojaModelBoEstoque;
  end;


implementation

uses
  Loja.Model.Dao.Factory,
  Loja.Model.Entity.Estoque.Types,
  Loja.Model.Entity.Estoque.Movimento,
  Loja.Model.Entity.Estoque.Saldo;

{ TLojaModelBoEstoque }

constructor TLojaModelBoEstoque.Create;
begin

end;

destructor TLojaModelBoEstoque.Destroy;
begin

  inherited;
end;

function TLojaModelBoEstoque.EndFechamentoSaldo: ILojaModelBoEstoque;
begin
  Result := Self;
end;

function TLojaModelBoEstoque.FechamentoSaldo: ILojaModelBoEstoqueFechamentoSaldo;
begin
  Result := Self;
end;

function TLojaModelBoEstoque.FechamentoSaldoMensalItem(
  ACodItem: Integer): ILojaModelBoEstoqueFechamentoSaldo;
var
  LHaFechamento: Boolean;
  LUltSaldo: Integer;
  LDatUltFech, LDatIni, LDatFim : TDateTime;
  LUltFechamento: TLojaModelEntityEstoqueSaldo;
  LMovimentos: TLojaModelEntityEstoqueMovimentoLista;
begin
  Result := Self;
  // Realiza fechamento de saldo mensal até mês anterior
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
    // ultimo dia do mês anterior
    LDatFim := EndOfTheMonth(EncodeDate(YearOf(Now), MonthOf(Now), 1)-1);

    // Se o último mês ainda não estiver fechado
    if LDatUltFech < LDatFim then
    begin
      LDatIni := LDatUltFech+1;

      LMovimentos := TLojaModelDaoFactory.New.Estoque
        .Movimento
        .ObterMovimentoItemEntreDatas(ACodItem, LDatIni, LDatFim);
      try
        if (LMovimentos <> nil) and (LMovimentos.Count > 0)
        then begin
          //Ordenar pela data de movimentação
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

          // Último dia do mês tendo como referência a data do movimento
          LDatIni := EndOfTheMonth(LMovimentos.First.DatMov);

          // Se há intervalo maior que 1 mês entre último fechamento e o esperado
          if LHaFechamento then
            while SameDate(StartOfTheMonth(LDatUltFech), StartOfTheMonth(LDatIni))
            do begin
              // último dia do próximo mês
              LDatUltFech := EndOfTheMonth(LDatUltFech+1);
              var LFecha := TLojaModelDaoFactory.New.Estoque
                .Saldo
                .CriarFechamentoSaldoItem(ACodItem, LDatUltFech, LUltSaldo);
              LFecha.Free;
            end;

          for var LMovimento in LMovimentos do
          begin
            // Se o próximo movimento não for no mês subsequente
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
          // Se não houve fechamentos e nem movimentos
          if not LHaFechamento
          then begin
            var LFecha := TLojaModelDaoFactory.New.Estoque
              .Saldo
              .CriarFechamentoSaldoItem(ACodItem, LDatFim, LUltSaldo);
            LFecha.Free;
          end else
          // houve fechamento, mas não houve movimentos
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

class function TLojaModelBoEstoque.New: ILojaModelBoEstoque;
begin
  Result := Self.Create;
end;

end.
