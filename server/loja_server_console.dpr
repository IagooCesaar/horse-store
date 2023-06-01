program loja_server_console;

{$APPTYPE CONSOLE}

{$R *.res}

{$R *.dres}

uses
  System.SysUtils,
  App in 'src\App.pas',
  Database.Conexao in 'src\infra\database\Database.Conexao.pas',
  Database.Factory in 'src\infra\database\Database.Factory.pas',
  Database.Interfaces in 'src\infra\database\Database.Interfaces.pas',
  Database.SQL in 'src\infra\database\Database.SQL.pas',
  Database.Tipos in 'src\infra\database\Database.Tipos.pas',
  Loja.Model.Factory in 'src\model\Loja.Model.Factory.pas',
  Loja.Model.Interfaces in 'src\model\Loja.Model.Interfaces.pas',
  Loja.Model.Itens in 'src\model\Loja.Model.Itens.pas',
  Loja.Model.Dao.Factory in 'src\model\dao\Loja.Model.Dao.Factory.pas',
  Loja.Model.Dao.Interfaces in 'src\model\dao\Loja.Model.Dao.Interfaces.pas',
  Loja.Model.Dao.Itens.Interfaces in 'src\model\dao\Loja.Model.Dao.Itens.Interfaces.pas',
  Loja.Model.Dao.Itens.Factory.InMemory in 'src\model\dao\in-memory\itens\Loja.Model.Dao.Itens.Factory.InMemory.pas',
  Loja.Model.Dao.Itens.Item.InMemory in 'src\model\dao\in-memory\itens\Loja.Model.Dao.Itens.Item.InMemory.pas',
  Loja.Model.Dao.Itens.Factory in 'src\model\dao\oficial\itens\Loja.Model.Dao.Itens.Factory.pas',
  Loja.Model.Dao.Itens.Item in 'src\model\dao\oficial\itens\Loja.Model.Dao.Itens.Item.pas',
  Loja.Model.Entity.Itens.Item in 'src\model\entity\itens\Loja.Model.Entity.Itens.Item.pas',
  Loja.Controller.Itens in 'src\controllers\Loja.Controller.Itens.pas',
  Loja.Controller.Registry in 'src\controllers\Loja.Controller.Registry.pas',
  Loja.Model.Dto.Req.Itens.CriarItem in 'src\model\dto\Loja.Model.Dto.Req.Itens.CriarItem.pas',
  Loja.Model.Dto.Req.Itens.FiltroItens in 'src\model\dto\Loja.Model.Dto.Req.Itens.FiltroItens.pas',
  Loja.Model.Entity.Estoque.Saldo in 'src\model\entity\estoque\Loja.Model.Entity.Estoque.Saldo.pas',
  Loja.Model.Entity.Estoque.Movimento in 'src\model\entity\estoque\Loja.Model.Entity.Estoque.Movimento.pas',
  Loja.Model.Entity.Estoque.Types in 'src\model\entity\estoque\Loja.Model.Entity.Estoque.Types.pas',
  Loja.Model.Dto.Req.Estoque.CriarMovimento in 'src\model\dto\Loja.Model.Dto.Req.Estoque.CriarMovimento.pas',
  Loja.Model.Dto.Req.Estoque.AcertoEstoque in 'src\model\dto\Loja.Model.Dto.Req.Estoque.AcertoEstoque.pas',
  Loja.Model.Estoque in 'src\model\Loja.Model.Estoque.pas',
  Loja.Model.Dao.Estoque.Factory.InMemory in 'src\model\dao\in-memory\estoque\Loja.Model.Dao.Estoque.Factory.InMemory.pas',
  Loja.Model.Dao.Estoque.Movimento.InMemory in 'src\model\dao\in-memory\estoque\Loja.Model.Dao.Estoque.Movimento.InMemory.pas',
  Loja.Model.Dao.Estoque.Saldo.InMemory in 'src\model\dao\in-memory\estoque\Loja.Model.Dao.Estoque.Saldo.InMemory.pas',
  Loja.Model.Dao.Estoque.Movimento in 'src\model\dao\oficial\estoque\Loja.Model.Dao.Estoque.Movimento.pas',
  Loja.Model.Dao.Estoque.Saldo in 'src\model\dao\oficial\estoque\Loja.Model.Dao.Estoque.Saldo.pas',
  Loja.Model.Dao.Estoque.Factory in 'src\model\dao\oficial\estoque\Loja.Model.Dao.Estoque.Factory.pas',
  Loja.Model.Dao.Estoque.Interfaces in 'src\model\dao\Loja.Model.Dao.Estoque.Interfaces.pas',
  Loja.Controller.Estoque in 'src\controllers\Loja.Controller.Estoque.pas',
  Loja.Model.Bo.Interfaces in 'src\model\bo\Loja.Model.Bo.Interfaces.pas',
  Loja.Model.Bo.Factory in 'src\model\bo\Loja.Model.Bo.Factory.pas',
  Loja.Model.Bo.Estoque in 'src\model\bo\Loja.Model.Bo.Estoque.pas';

begin
  var App := TApp.Create;
  try
    try
      App.Start(9000);
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    FreeAndNil(App)
  end;
end.
