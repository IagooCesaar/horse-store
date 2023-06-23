unit Loja.Model.Caixa;

interface

uses
  System.SysUtils,
  System.Classes,

  Loja.Model.Interfaces,
  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Entity.Caixa.Caixa,
  Loja.Model.Dto.Req.Caixa.Abertura,
  Loja.Model.Dto.Req.Caixa.Fechamento,
  Loja.Model.Dto.Req.Caixa.CriarMovimento;

type
  TLojaModelCaixa = class(TInterfacedObject, ILojaModelCaixa)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelCaixa;

    { ILojaModelCaixa }
    function ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
    function ObterCaixaPorCodigo(ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
    function AberturaCaixa(AAbertura: TLojaModelDtoReqCaixaAbertura): TLojaModelEntityCaixaCaixa;
  end;

implementation

uses
  Horse,
  Horse.Exception,

  Loja.Model.Dao.Factory,
  Loja.Model.Bo.Factory;

{ TLojaModelCaixa }

function TLojaModelCaixa.AberturaCaixa(
  AAbertura: TLojaModelDtoReqCaixaAbertura): TLojaModelEntityCaixaCaixa;
begin
  if AAbertura.VrAbert < 0
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O caixa não poderá ser aberto com valor negativo');

  AAbertura.DatAbert := Now;

  var LCaixaAberto := TLojaModelDaoFactory.New.Caixa
    .Caixa
    .ObterCaixaAberto;
  if LCaixaAberto <> nil
  then try
    raise EHorseException.New
      .Status(THTTPStatus.PreconditionFailed)
      .&Unit(Self.UnitName)
      .Error(Format(
        'Há um caixa aberto (Data abertura: %s). Feche-o para então realizar nova abertura.',
        [DateTimeToStr(LCaixaAberto.DatAbert)])
      );
  finally
    LCaixaAberto.Free;
  end;

  var LUltFechado := TLojaModelDaoFactory.New.Caixa
    .Caixa
    .ObterUltimoCaixaFechado(AAbertura.DatAbert);

  var LNovoCaixa := TLojaModelDaoFactory.New.Caixa
    .Caixa
    .CriarNovoCaixa(AAbertura);

  if LUltFechado <> nil
  then begin
    if LNovoCaixa.VrAbert <> LUltFechado.VrFecha
    then begin
      var LMovAbert := TLojaModelDtoReqCaixaCriarMovimento.Create;
      try
        LMovAbert.CodCaixa := LNovoCaixa.CodCaixa;
        LMovAbert.DatMov := LNovoCaixa.DatAbert;
        LMovAbert.DscObs := 'Saldo abertura divergente do último fechamento';
        LMovAbert.CodMeioPagto := pagDinheiro;
        LMovAbert.VrMov := Abs(LNovoCaixa.VrAbert - LUltFechado.VrFecha);
        if LNovoCaixa.VrAbert > LUltFechado.VrFecha
        then begin
          LMovAbert.CodTipoMov := movEntrada;
          LMovAbert.CodOrigMov := orgReforco;
        end
        else
        begin
          LMovAbert.CodTipoMov := movSaida;
          LMovAbert.CodOrigMov := orgSangria;
        end;

        var LMovimento := TLojaModelDaoFactory.New.Caixa
          .Movimento
          .CriarNovoMovimento(LMovAbert);
        LMovimento.Free;
      finally
        LMovAbert.Free;
      end;
    end;

    LUltFechado.Free;
  end;

  Result := LNovoCaixa;
end;

constructor TLojaModelCaixa.Create;
begin

end;

destructor TLojaModelCaixa.Destroy;
begin

  inherited;
end;

class function TLojaModelCaixa.New: ILojaModelCaixa;
begin
  Result := Self.Create;
end;

function TLojaModelCaixa.ObterCaixaAberto: TLojaModelEntityCaixaCaixa;
begin
  Result := TLojaModelBoFactory.New.Caixa
    .ObterCaixaAberto;
end;

function TLojaModelCaixa.ObterCaixaPorCodigo(
  ACodCaixa: Integer): TLojaModelEntityCaixaCaixa;
begin
  if ACodCaixa <= 0
  then EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .&Unit(Self.UnitName)
    .Error('O código de caixa informado é inválido');

  Result := TLojaModelDaoFactory.New.Caixa
    .Caixa
    .ObterCaixaPorCodigo(ACodCaixa);
end;

end.
