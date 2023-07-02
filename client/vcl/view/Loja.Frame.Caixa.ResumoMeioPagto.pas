unit Loja.Frame.Caixa.ResumoMeioPagto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFrameCaixaResumoMeioPagto = class(TFrame)
    lbMeioPagto: TLabel;
    lbValor: TLabel;
    pCliente: TPanel;
  private
    procedure setNome(const Value: string);
    procedure setValor(const Value: Currency);
    procedure setCor(const Value: TColor);
    procedure setCorFonte(const Value: TColor);
  public
    property Nome: string write setNome;
    property Valor: Currency write setValor;
    property Cor: TColor write setCor;
    property CorFonte: TColor write setCorFonte;

  end;

implementation

uses
  System.StrUtils,
  Vcl.GraphUtil;

{$R *.dfm}

{ TFrameCaixaResumoMeioPagto }

procedure TFrameCaixaResumoMeioPagto.setCorFonte(const Value: TColor);
begin
  lbMeioPagto.Color := Value;
  lbValor.Color := Value;
end;

procedure TFrameCaixaResumoMeioPagto.setCor(const Value: TColor);
begin
  pCliente.Color := Value;
end;


procedure TFrameCaixaResumoMeioPagto.setNome(const Value: string);
begin
  lbMeioPagto.Caption := Value;
end;

procedure TFrameCaixaResumoMeioPagto.setValor(const Value: Currency);
begin
  lbValor.Caption := FormatFloat('R$ #,##0.00', Value);
end;

end.
