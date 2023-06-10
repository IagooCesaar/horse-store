unit Loja.Controller.Itens;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,


  Loja.Model.Infra.Types;

type
  TControllerItens = class(TControllerBase)
    mtDadosCOD_ITEM: TIntegerField;
    mtDadosNOM_ITEM: TStringField;
    mtDadosNUM_COD_BARR: TStringField;
  private
    { Private declarations }
  public
    procedure ObterItem;
    procedure ObterItens(ANome: TLhsBracketFilter);
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

procedure TControllerItens.ObterItens(ANome: TLhsBracketFilter);
begin
  var LResponse := PreparaRequest
    .Resource('/itens')
    .AddParam(Format('%s%s',['nom_item', ANome.Tipo.ToString]), ANome.Valor)
    .Get();

  if not(LResponse.StatusCode in [200,204])
  then RaiseException(LResponse, 'Falha ao obter lista de itens');

  if LResponse.StatusCode = 200
  then Serializar(LResponse);
end;

end.
