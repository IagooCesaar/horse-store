unit Loja.Controller.Estoque.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,

  Loja.Model.Entity.Itens.Item;

type
  [TestFixture]
  TLojaControllerEstoqueTest = class
  private
    FBaseURL, FUsarname, FPassword: String;

    function CriarItem: TLojaModelEntityItensItem;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure Test_CriarAcertoEstoque;

    [Test]
    procedure Test_ObterHistoricoMovimento;

    [Test]
    procedure Test_ObterSaldoAtual;


  end;

implementation

uses
  RESTRequest4D,
  Horse,
  Horse.JsonInterceptor.Helpers,

  Loja.Controller.Api.Test,
  Loja.Model.Dto.Req.Itens.CriarItem,
  Loja.Model.Dto.Req.Estoque.AcertoEstoque;

{ TLojaControllerEstoqueTest }

function TLojaControllerEstoqueTest.CriarItem: TLojaModelEntityItensItem;
var LNovoItem : TLojaModelDtoReqItensCriarItem;
begin
  try
    LNovoItem := TLojaModelDtoReqItensCriarItem.Create;
    LNovoItem.NomItem := 'Novo Item Cadastrado Via Teste Integração';
    LNovoItem.NumCodBarr := '0123456789';

    var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/itens')
      .AddBody(TJson.ObjectToClearJsonString(LNovoItem))
      .Post();

    Result := TJson.ClearJsonAndConvertToObject<TLojaModelEntityItensItem>
      (LResponse.Content);

  finally
    FreeAndNil(LNovoItem);
  end;
end;

procedure TLojaControllerEstoqueTest.SetupFixture;
begin
  FBaseURL := TLojaControllerApiTest.GetInstance.BaseURL;
  FUsarname := TLojaControllerApiTest.GetInstance.UserName;
  FPassword := TLojaControllerApiTest.GetInstance.Password;
end;

procedure TLojaControllerEstoqueTest.TearDownFixture;
begin

end;

procedure TLojaControllerEstoqueTest.Test_CriarAcertoEstoque;
begin
  var LItem := CriarItem;
  var LAcerto := TLojaModelDtoReqEstoqueAcertoEstoque.Create;
  LAcerto.CodItem := LItem.CodItem;
  LACerto.QtdSaldoReal := 1;
  LAcerto.DscMot := 'Implantação Teste';

  var LResponse := TRequest.New
      .BasicAuthentication(FUsarname, FPassword)
      .BaseURL(FBaseURL)
      .Resource('/estoque/{cod_item}/acerto-de-estoque')
      .AddUrlSegment('cod_item', LItem.CodItem.ToString)
      .AddBody(TJson.ObjectToClearJsonString(LAcerto))
      .Post();

  Assert.AreEqual(201, LResponse.StatusCode);

  LAcerto.Free;
end;

procedure TLojaControllerEstoqueTest.Test_ObterHistoricoMovimento;
begin

end;

procedure TLojaControllerEstoqueTest.Test_ObterSaldoAtual;
begin

end;

initialization
  TDUnitX.RegisterTestFixture(TLojaControllerEstoqueTest);

end.
