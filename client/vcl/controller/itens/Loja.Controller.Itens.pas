unit Loja.Controller.Itens;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TControllerItens = class(TControllerBase)
    mtDadosCOD_ITEM: TIntegerField;
    mtDadosNOM_ITEM: TStringField;
    mtDadosNUM_COD_BARR: TStringField;
  private
    { Private declarations }
  public
    procedure ObterItem;
    procedure ObterItens(ANome: string);
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

procedure TControllerItens.ObterItens(ANome: string);
begin
  var LResponse := PreparaRequest
    .Resource('/itens')
    .AddParam(Format('%s[%s]',['nom_item', 'contains']), ANome)
    .Get();

  if LResponse.StatusCode <> 200
  then RaiseException(LResponse, 'Falha ao obter lista de itens');

  Serializar(LResponse);
end;

end.
