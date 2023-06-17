program loja;

uses
  Vcl.Forms,
  System.Classes,
  Loja.View.Principal in 'view\Loja.View.Principal.pas' {ViewPrincipal},
  Loja.DM.Imagens in 'view\infra\Loja.DM.Imagens.pas' {dmImagens: TDataModule},
  Loja.View.ModeloModal in 'view\infra\Loja.View.ModeloModal.pas' {ViewModeloModal},
  Loja.View.Modelo in 'view\infra\Loja.View.Modelo.pas' {ViewModelo},
  Loja.View.ModeloMdi in 'view\infra\Loja.View.ModeloMdi.pas' {ViewModeloMdi},
  Loja.Controller.Base in 'controller\infra\Loja.Controller.Base.pas' {ControllerBase: TDataModule},
  Loja.Controller.Itens in 'controller\itens\Loja.Controller.Itens.pas' {ControllerItens: TDataModule},
  Loja.View.Vender in 'view\Loja.View.Vender.pas' {ViewVender},
  Loja.Controller.Vendas in 'controller\venda\Loja.Controller.Vendas.pas' {ControllerVendas: TDataModule},
  Loja.View.Logon in 'view\infra\Loja.View.Logon.pas' {ViewLogon},
  Vcl.Themes,
  Vcl.Styles,
  Loja.View.Configuracoes in 'view\infra\Loja.View.Configuracoes.pas' {ViewConfiguracoes},
  Loja.Model.Infra.Configuracoes in 'model\infra\Loja.Model.Infra.Configuracoes.pas',
  Loja.Model.Infra.Usuario in 'model\infra\Loja.Model.Infra.Usuario.pas',
  Loja.Controller.Infra in 'controller\infra\Loja.Controller.Infra.pas' {ControllerInfra: TDataModule},
  Loja.Model.Infra.DTO.ApiError in 'model\infra\Loja.Model.Infra.DTO.ApiError.pas',
  Loja.View.Itens in 'view\Loja.View.Itens.pas' {ViewItens},
  Loja.View.Comprar in 'view\Loja.View.Comprar.pas' {ViewComprar},
  Loja.Model.Infra.Types in 'model\infra\Loja.Model.Infra.Types.pas',
  Loja.Controller.Estoque.Saldo in 'controller\estoque\Loja.Controller.Estoque.Saldo.pas' {ControllerEstoqueSaldo: TDataModule},
  Loja.Controller.Estoque.Movimento in 'controller\estoque\Loja.Controller.Estoque.Movimento.pas' {ControllerEstoqueMovimento: TDataModule},
  Loja.View.Estoque.Consulta in 'view\Loja.View.Estoque.Consulta.pas' {ViewEstoqueConsulta},
  Loja.Model.Estoque.AcertoEstoque in 'model\Loja.Model.Estoque.AcertoEstoque.pas',
  Loja.View.Estoque.AcertoEstoque in 'view\Loja.View.Estoque.AcertoEstoque.pas' {ViewAcertoEstoque},
  Loja.View.Preco.ConsultaPreco in 'view\Loja.View.Preco.ConsultaPreco.pas' {ViewConsultaPrecoVenda},
  Loja.Controller.Preco.Venda in 'controller\preco\Loja.Controller.Preco.Venda.pas' {ControllerPrecoVenda: TDataModule},
  Loja.Model.Preco.PrecoVenda in 'model\Loja.Model.Preco.PrecoVenda.pas';

{$R *.res}

begin
  RegisterClasses([
     TViewModelo
    ,TViewModeloMdi
    ,TViewModeloModal
    ,TViewVender
    ,TViewItens
    ,TViewComprar
  ]);

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Loja';
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.CreateForm(TdmImagens, dmImagens);
  Application.Run;
end.
