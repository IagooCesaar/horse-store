unit Loja.Model.Venda.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,

  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem,

  Loja.Model.Entity.Preco.Venda,
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda,

  Loja.Model.Dto.Req.Estoque.AcertoEstoque,

  Loja.Model.Dto.Req.Caixa.Abertura,
  Loja.Model.Entity.Caixa.Caixa;

type
  [TestFixture]
  TLojaModelVendaTest = class
  private
    FCaixa: TLojaModelEntityCaixaCaixa;

    function CriarItem(ANome, ACodBarr: String): TLojaModelEntityItensItem;
    function CriarPrecoVenda(ACodItem: Integer; AVrVnda: Currency;
      ADatIni: TDateTime): TLojaModelEntityPrecoVenda;
    procedure RealizarAcertoEstoque(ACodItem: Integer; AQtdSaldoReal: Integer);
    procedure AbrirCaixa(AVrAbert: Currency);
    procedure FecharCaixaAtual;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;
  end;

implementation

uses
  Horse,
  Horse.Exception,
  System.DateUtils,

  Loja.Model.Factory,
  Loja.Model.Dao.Factory,

  Loja.Model.Dto.Req.Caixa.Fechamento,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto;

{ TLojaModelVendaTest }

procedure TLojaModelVendaTest.AbrirCaixa(
  AVrAbert: Currency);
begin
  var LAbertura := TLojaModelDtoReqCaixaAbertura.Create;
  try
    LAbertura.VrAbert := AVrAbert;
    FCaixa := TLojaModelFactory.New.Caixa.AberturaCaixa(LAbertura);
  finally
    LAbertura.Free;
  end;
end;

function TLojaModelVendaTest.CriarItem(ANome,
  ACodBarr: String): TLojaModelEntityItensItem;
var LDTONovoItem: TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := ANome;
    LDTONovoItem.NumCodBarr := ACodBarr;
    Result := TLojaModelDaoFactory.New.Itens.Item.CriarItem(LDTONovoItem);
  finally
    LDTONovoItem.Free;
  end;
end;

function TLojaModelVendaTest.CriarPrecoVenda(ACodItem: Integer;
  AVrVnda: Currency; ADatIni: TDateTime): TLojaModelEntityPrecoVenda;
begin
  var LDto := TLojaModelDtoReqPrecoCriarPrecoVenda.Create;
  try
    LDto.CodItem := ACodItem;
    LDto.DatIni := ADatIni;
    LDto.VrVnda := AVrVnda;

    Result := TLojaModelFactory.New
      .Preco
      .CriarPrecoVendaItem(LDto);
  finally
    LDto.Free;
  end;
end;

procedure TLojaModelVendaTest.FecharCaixaAtual;
begin
  var LCaixaAberto := TLojaModelFactory.New.Caixa.ObterCaixaAberto;
  if LCaixaAberto = nil
  then Exit;

  try
    var LResumo := TLojaModelFactory.New.Caixa.ObterResumoCaixa(LCaixaAberto.CodCaixa);

    var LFechamento := TLojaModelDtoReqCaixaFechamento.Create;
    LFechamento.CodCaixa := LCaixaAberto.CodCaixa;
    LFechamento.MeiosPagto := TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista.Create;

    for var LMeioPagto in LResumo.MeiosPagto
    do begin
      LFechamento.MeiosPagto.Get(LMeioPagto.CodMeioPagto).VrTotal :=
        LMeioPagto.VrTotal;
    end;

    try
      var LCaixaFechado := TLojaModelFactory.New.Caixa.FechamentoCaixa(LFechamento);
      LCaixaFechado.Free;
    finally
      LResumo.Free;
      LFechamento.Free;
    end;
  finally
    LCaixaAberto.Free;
  end;
end;

procedure TLojaModelVendaTest.RealizarAcertoEstoque(ACodItem,
  AQtdSaldoReal: Integer);
begin
  var LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  try
    LAcerto.CodItem := ACodItem;
    LAcerto.QtdSaldoReal := AQtdSaldoReal;
    LAcerto.DscMot := 'TLojaModelVendaTest';

    var LMovimento := TLojaModelFactory.New
      .Estoque
      .CriarAcertoEstoque(LAcerto);
    LMovimento.Free;
  finally
    LAcerto.Free;
  end;
end;

procedure TLojaModelVendaTest.SetupFixture;
begin
  TLojaModelDaoFactory.InMemory := True;
end;

procedure TLojaModelVendaTest.TearDownFixture;
begin
  TLojaModelDaoFactory.InMemory := False;
  if FCaixa <> nil
  then FreeAndNil(FCaixa);
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelVendaTest);

end.
