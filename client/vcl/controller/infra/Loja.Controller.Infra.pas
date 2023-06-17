unit Loja.Controller.Infra;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TControllerInfra = class(TControllerBase)
  public
    function ValidarLogon: Boolean;
  end;

var
  ControllerInfra: TControllerInfra;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TControllerInfra }

function TControllerInfra.ValidarLogon: Boolean;
begin
  var LResponse := PreparaRequest
    .Resource('/validar-logon')
    .Get();

  Result := LResponse.StatusCode = 200;
end;

end.
