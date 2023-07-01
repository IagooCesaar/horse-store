unit Loja.Controller.Caixa;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TControllerBase1 = class(TControllerBase)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ControllerBase1: TControllerBase1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
