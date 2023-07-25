unit Loja.View.Sobre;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Loja.View.Modelo, Vcl.StdCtrls;

type
  TViewSobre = class(TViewModelo)
    lbTitulo: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lbEmail: TLabel;
    lbRepositorio: TLabel;
    procedure lbRepositorioClick(Sender: TObject);
    procedure lbEmailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Winapi.ShellAPI;

{$R *.dfm}

procedure TViewSobre.lbEmailClick(Sender: TObject);
begin
  ShellExecute(handle,'open',PWideChar(Format('mailto:%s',[lbEmail.Caption])),nil,nil,sw_show);
end;

procedure TViewSobre.lbRepositorioClick(Sender: TObject);
begin
  ShellExecute(handle,'open',PWideChar(lbRepositorio.Caption),nil,nil,sw_show);
end;

end.
