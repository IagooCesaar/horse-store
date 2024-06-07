unit Loja.Model.Bo.Estoque;

interface

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  System.Generics.Defaults,
  System.Generics.Collections,

  Loja.Environment.Interfaces,
  Loja.Model.Bo.Interfaces;

type
  TLojaModelBoEstoque = class(TInterfacedObject,
    ILojaModelBoEstoque, ILojaModelBoEstoqueFechamentoSaldo)
  private
    FEnvRules: ILojaEnvironmentRuler;
  public
    constructor Create(AEnvRules: ILojaEnvironmentRuler);
    destructor Destroy; override;
    class function New(AEnvRules: ILojaEnvironmentRuler): ILojaModelBoEstoque;

    { ILojaModelBoEstoque }
    function FechamentoSaldo: ILojaModelBoEstoqueFechamentoSaldo;

    { ILojaModelBoEstoqueFechamentoSaldo }
    function EndFechamentoSaldo: ILojaModelBoEstoque;

    function FecharSaldoMensalItem(ACodItem: Integer): ILojaModelBoEstoqueFechamentoSaldo;
    function CriarNovoFechamento(ACodItem: Integer; ADatRef: TDateTime;
      ASaldo: Integer): ILojaModelBoEstoqueFechamentoSaldo;
  end;


implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Factory,
  Loja.Model.Entity.Estoque.Types,
  Loja.Model.Entity.Estoque.Movimento,
  Loja.Model.Entity.Estoque.Saldo;

{ TLojaModelBoEstoque }

constructor TLojaModelBoEstoque.Create(AEnvRules: ILojaEnvironmentRuler);
begin
  FEnvRules := AEnvRules;
end;

function TLojaModelBoEstoque.CriarNovoFechamento(ACodItem: Integer;
  ADatRef: TDateTime; ASaldo: Integer): ILojaModelBoEstoqueFechamentoSaldo;
var LFechamento: TLojaModelEntityEstoqueSaldo;
begin
  Result := Self;
  LFechamento := TLojaModelDaoFactory.New(FEnvRules).Estoque
    .Saldo
    .ObterFechamentoItem(ACodItem, ADatRef);
  if LFechamento <> nil
  then try
    raise EHorseException.New
      .Status(THTTPStatus.BadRequest)
      .&Unit(Self.UnitName)
      .Error(Format(
        'Já existe um fechamento de saldo para o item %d na data %s',
        [ACodItem, FormatDateTime('dddddd', LFechamento.DatSaldo)]
      ));
  finally
    FreeAndNil(LFechamento);
  end;

  LFechamento := TLojaModelDaoFactory.New(FEnvRules).Estoque
    .Saldo
    .CriarFechamentoSaldoItem(ACodItem, ADatRef, ASaldo);
  LFechamento.Free;
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

function TLojaModelBoEstoque.FecharSaldoMensalItem(
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
    LUltFechamento := TLojaModelDaoFactory.New(FEnvRules).Estoque
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

      LMovimentos := TLojaModelDaoFactory.New(FEnvRules).Estoque
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

          // Último dia do mês anterior à data do 1º movimento
          LDatIni := EndOfTheMonth(StartOfTheMonth(LMovimentos.First.DatMov)-1);

          // Se não houve fechamentos entre o 1º Fechamento e o ùltimo dia do mês anterior ao fechamento
          if LHaFechamento then
            while not(SameDate(StartOfTheMonth(LDatUltFech), StartOfTheMonth(LDatIni)))
            do begin
              // último dia do próximo mês
              LDatUltFech := EndOfTheMonth(LDatUltFech+1);
              CriarNovoFechamento(ACodItem, LDatUltFech, LUltSaldo);
            end;

          // Último dia do mês tendo como referência a data do movimento
          LDatIni := EndOfTheMonth(LMovimentos.First.DatMov);

          for var LMovimento in LMovimentos do
          begin
            // Se o próximo movimento não for no mês subsequente
            while not(SameDate(StartOfTheMonth(LMovimento.DatMov), StartOfTheMonth(LDatIni)))
            do begin
              LDatUltFech := LDatIni;
              CriarNovoFechamento(ACodItem, LDatUltFech, LUltSaldo);
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
            CriarNovoFechamento(ACodItem, LDatUltFech, LUltSaldo);
            LDatIni := EndOfTheMonth(LDatUltFech+1);
          until (SameDate(StartOfTheMonth(LDatIni), StartOfTheMonth(LDatFim+1)));
        end
        else
        begin
          // Se não houve fechamentos e nem movimentos
          if not LHaFechamento
          then begin
            CriarNovoFechamento(ACodItem, LDatFim, LUltSaldo);
          end else
          // houve fechamento, mas não houve movimentos
          begin
            LDatIni := EndOfTheMonth(LDatIni);
            repeat
              LDatUltFech := LDatIni;
              CriarNovoFechamento(ACodItem, LDatUltFech, LUltSaldo);
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

class function TLojaModelBoEstoque.New(AEnvRules: ILojaEnvironmentRuler): ILojaModelBoEstoque;
begin
  Result := Self.Create(AEnvRules);
end;

end.
