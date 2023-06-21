program loja_server_vcl;

{$R *.dres}

uses
  Vcl.Forms,
  ufrmPrinc in 'ufrmPrinc.pas' {frmPrinc},
  App in 'src\App.pas',
  Loja.Model.Entity.Itens.Item in 'src\model\entity\itens\Loja.Model.Entity.Itens.Item.pas',
  Loja.Model.Dao.Itens.Item in 'src\model\dao\oficial\itens\Loja.Model.Dao.Itens.Item.pas',
  Loja.Model.Dao.Itens.Factory in 'src\model\dao\oficial\itens\Loja.Model.Dao.Itens.Factory.pas',
  Loja.Model.Dao.Itens.Factory.InMemory in 'src\model\dao\in-memory\itens\Loja.Model.Dao.Itens.Factory.InMemory.pas',
  Loja.Model.Dao.Itens.Item.InMemory in 'src\model\dao\in-memory\itens\Loja.Model.Dao.Itens.Item.InMemory.pas',
  Loja.Model.Interfaces in 'src\model\Loja.Model.Interfaces.pas',
  Loja.Model.Itens in 'src\model\Loja.Model.Itens.pas',
  Loja.Model.Factory in 'src\model\Loja.Model.Factory.pas',
  Loja.Controller.Itens in 'src\controllers\Loja.Controller.Itens.pas',
  Loja.Controller.Registry in 'src\controllers\Loja.Controller.Registry.pas',
  Loja.Model.Entity.Estoque.Movimento in 'src\model\entity\estoque\Loja.Model.Entity.Estoque.Movimento.pas',
  Loja.Model.Entity.Estoque.Saldo in 'src\model\entity\estoque\Loja.Model.Entity.Estoque.Saldo.pas',
  Loja.Model.Entity.Estoque.Types in 'src\model\entity\estoque\Loja.Model.Entity.Estoque.Types.pas',
  Loja.Model.Dto.Req.Estoque.AcertoEstoque in 'src\model\dto\Loja.Model.Dto.Req.Estoque.AcertoEstoque.pas',
  Loja.Model.Dto.Req.Estoque.CriarMovimento in 'src\model\dto\Loja.Model.Dto.Req.Estoque.CriarMovimento.pas',
  Loja.Model.Dto.Req.Itens.CriarItem in 'src\model\dto\Loja.Model.Dto.Req.Itens.CriarItem.pas',
  Loja.Model.Dto.Req.Itens.FiltroItens in 'src\model\dto\Loja.Model.Dto.Req.Itens.FiltroItens.pas',
  Loja.Model.Dao.Estoque.Interfaces in 'src\model\dao\Loja.Model.Dao.Estoque.Interfaces.pas',
  Loja.Model.Dao.Factory in 'src\model\dao\Loja.Model.Dao.Factory.pas',
  Loja.Model.Dao.Interfaces in 'src\model\dao\Loja.Model.Dao.Interfaces.pas',
  Loja.Model.Dao.Itens.Interfaces in 'src\model\dao\Loja.Model.Dao.Itens.Interfaces.pas',
  Loja.Model.Dao.Estoque.Factory.InMemory in 'src\model\dao\in-memory\estoque\Loja.Model.Dao.Estoque.Factory.InMemory.pas',
  Loja.Model.Dao.Estoque.Movimento.InMemory in 'src\model\dao\in-memory\estoque\Loja.Model.Dao.Estoque.Movimento.InMemory.pas',
  Loja.Model.Dao.Estoque.Saldo.InMemory in 'src\model\dao\in-memory\estoque\Loja.Model.Dao.Estoque.Saldo.InMemory.pas',
  Loja.Model.Dao.Estoque.Factory in 'src\model\dao\oficial\estoque\Loja.Model.Dao.Estoque.Factory.pas',
  Loja.Model.Dao.Estoque.Movimento in 'src\model\dao\oficial\estoque\Loja.Model.Dao.Estoque.Movimento.pas',
  Loja.Model.Dao.Estoque.Saldo in 'src\model\dao\oficial\estoque\Loja.Model.Dao.Estoque.Saldo.pas',
  Loja.Model.Estoque in 'src\model\Loja.Model.Estoque.pas',
  Loja.Controller.Estoque in 'src\controllers\Loja.Controller.Estoque.pas',
  Loja.Model.Bo.Factory in 'src\model\bo\Loja.Model.Bo.Factory.pas',
  Loja.Model.Bo.Interfaces in 'src\model\bo\Loja.Model.Bo.Interfaces.pas',
  Loja.Model.Bo.Estoque in 'src\model\bo\Loja.Model.Bo.Estoque.pas',
  Loja.Model.Dto.Resp.Estoque.SaldoItem in 'src\model\dto\Loja.Model.Dto.Resp.Estoque.SaldoItem.pas',
  Loja.Model.Dto.Resp.ApiError in 'src\model\dto\Loja.Model.Dto.Resp.ApiError.pas',
  Loja.Controller.Preco in 'src\controllers\Loja.Controller.Preco.pas',
  Loja.Model.Preco in 'src\model\Loja.Model.Preco.pas',
  Loja.Model.Dto.Req.Preco.CriarPrecoVenda in 'src\model\dto\Loja.Model.Dto.Req.Preco.CriarPrecoVenda.pas',
  Loja.Model.Entity.Preco.Venda in 'src\model\entity\preco\Loja.Model.Entity.Preco.Venda.pas',
  Loja.Model.Dao.Preco.Interfaces in 'src\model\dao\Loja.Model.Dao.Preco.Interfaces.pas',
  Loja.Model.Dao.Preco.Factory.InMemory in 'src\model\dao\in-memory\preco\Loja.Model.Dao.Preco.Factory.InMemory.pas',
  Loja.Model.Dao.Preco.Venda.InMemory in 'src\model\dao\in-memory\preco\Loja.Model.Dao.Preco.Venda.InMemory.pas',
  Loja.Model.Dao.Preco.Factory in 'src\model\dao\oficial\preco\Loja.Model.Dao.Preco.Factory.pas',
  Loja.Model.Dao.Preco.Venda in 'src\model\dao\oficial\preco\Loja.Model.Dao.Preco.Venda.pas',
  Loja.Model.Caixa in 'src\model\Loja.Model.Caixa.pas',
  Loja.Model.Bo.Caixa in 'src\model\bo\Loja.Model.Bo.Caixa.pas',
  Loja.Model.Dao.Caixa.Interfaces in 'src\model\dao\Loja.Model.Dao.Caixa.Interfaces.pas',
  Loja.Model.Dao.Caixa.Caixa.InMemory in 'src\model\dao\in-memory\caixa\Loja.Model.Dao.Caixa.Caixa.InMemory.pas',
  Loja.Model.Dao.Caixa.Factory.InMemory in 'src\model\dao\in-memory\caixa\Loja.Model.Dao.Caixa.Factory.InMemory.pas',
  Loja.Model.Dao.Caixa.Movimento.InMemory in 'src\model\dao\in-memory\caixa\Loja.Model.Dao.Caixa.Movimento.InMemory.pas',
  Loja.Model.Dao.Caixa.Caixa in 'src\model\dao\oficial\caixa\Loja.Model.Dao.Caixa.Caixa.pas',
  Loja.Model.Dao.Caixa.Factory in 'src\model\dao\oficial\caixa\Loja.Model.Dao.Caixa.Factory.pas',
  Loja.Model.Dao.Caixa.Movimento in 'src\model\dao\oficial\caixa\Loja.Model.Dao.Caixa.Movimento.pas',
  Loja.Model.Dto.Req.Caixa.Abertura in 'src\model\dto\Loja.Model.Dto.Req.Caixa.Abertura.pas',
  Loja.Model.Dto.Req.Caixa.Fechamento in 'src\model\dto\Loja.Model.Dto.Req.Caixa.Fechamento.pas',
  Loja.Model.Dto.Req.Caixa.MovimentoAvulso in 'src\model\dto\Loja.Model.Dto.Req.Caixa.MovimentoAvulso.pas',
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa in 'src\model\dto\Loja.Model.Dto.Resp.Caixa.ResumoCaixa.pas',
  Loja.Model.Entity.Caixa.Caixa in 'src\model\entity\caixa\Loja.Model.Entity.Caixa.Caixa.pas',
  Loja.Model.Entity.Caixa.Movimento in 'src\model\entity\caixa\Loja.Model.Entity.Caixa.Movimento.pas',
  Loja.Model.Entity.Caixa.Types in 'src\model\entity\caixa\Loja.Model.Entity.Caixa.Types.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrinc, frmPrinc);
  Application.Run;
end.
