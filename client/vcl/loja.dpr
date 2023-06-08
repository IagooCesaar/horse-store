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
  Loja.Controller.Infra in 'controller\infra\Loja.Controller.Infra.pas' {ControllerInfra: TDataModule};

{$R *.res}

begin
  RegisterClasses([
     TViewModelo
    ,TViewModeloMdi
    ,TViewModeloModal
    ,TViewVender
  ]);

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.CreateForm(TdmImagens, dmImagens);
  Application.Run;
end.
