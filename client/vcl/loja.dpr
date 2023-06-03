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
  Loja.Controller.Vendas in 'controller\venda\Loja.Controller.Vendas.pas' {ControllerVendas: TDataModule};

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
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.CreateForm(TdmImagens, dmImagens);
  Application.Run;
end.