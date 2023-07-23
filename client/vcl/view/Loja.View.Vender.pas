unit Loja.View.Vender;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.ModeloMdi, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls,

  Loja.DM.Imagens;

type
  TViewVender = class(TViewModeloMdi)
    pcPrinc: TPageControl;
    tsVenda: TTabSheet;
    tsPesquisa: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    edtPesquisa: TEdit;
    sbInserir: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
