unit Loja.Controller.Itens;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TControllerItens = class(TControllerBase)
  private
    { Private declarations }
  public
    procedure ObterItem;
  end;


implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TControllerItens }

procedure TControllerItens.ObterItem;
begin
  var LResponse := PreparaRequest
    .Get();
end;

end.
