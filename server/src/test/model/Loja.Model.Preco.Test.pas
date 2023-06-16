unit Loja.Model.Preco.Test;

interface

uses
  DUnitX.TestFramework,
  Loja.Model.Entity.Itens.Item,
  Loja.Model.Dto.Req.Itens.CriarItem;

type
  [TestFixture]
  TLojaModelPrecoTest = class
  private
    function CriarItem: TLojaModelEntityItensItem;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;
  end;

implementation

uses
  Loja.Model.Dao.Factory;

{ TLojaModelPrecoTest }

function TLojaModelPrecoTest.CriarItem: TLojaModelEntityItensItem;
var LDTONovoItem: TLojaModelDtoReqItensCriarItem;
begin
  LDTONovoItem := TLojaModelDtoReqItensCriarItem.Create;
  try
    LDTONovoItem.NomItem := 'TLojaModelPrecoTest.CriarItem';
    Result := TLojaModelDaoFactory.New.Itens.Item.CriarItem(LDTONovoItem);
  finally
    LDTONovoItem.Free;
  end;
end;

procedure TLojaModelPrecoTest.SetupFixture;
begin
  TLojaModelDaoFactory.InMemory := True;
end;

procedure TLojaModelPrecoTest.TearDownFixture;
begin
  TLojaModelDaoFactory.InMemory := False;
end;

initialization
  TDUnitX.RegisterTestFixture(TLojaModelPrecoTest);

end.
