program loja;

uses
  Vcl.Forms,
  Loja.View.Principal in 'view\Loja.View.Principal.pas' {ViewPrincipal},
  Loja.DM.Imagens in 'view\infra\Loja.DM.Imagens.pas' {dmImagens: TDataModule},
  Loja.View.ModeloModal in 'view\infra\Loja.View.ModeloModal.pas' {ViewModeloModal},
  Loja.View.Modelo in 'view\infra\Loja.View.Modelo.pas' {ViewModelo},
  Loja.View.ModeloMdi in 'view\infra\Loja.View.ModeloMdi.pas' {ViewModeloMdi};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.CreateForm(TdmImagens, dmImagens);
  Application.Run;
end.
