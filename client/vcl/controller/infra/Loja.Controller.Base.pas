unit Loja.Controller.Base;

interface

uses
  System.SysUtils,
  System.Classes,

  RESTRequest4D,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TControllerBase = class(TDataModule)
    mtDados: TFDMemTable;
  private
    { Private declarations }
  protected
    function PreparaRequest: IRequest;
  end;

implementation

uses
  Loja.Model.Infra.Configuracoes,
  Loja.Model.Infra.Usuario;

{$R *.dfm}

{ TControllerBase }

function TControllerBase.PreparaRequest: IRequest;
begin
  Result := TRequest.New
    .BaseUrl(TLojaModelInfraConfiguracoes.GetInstance.APIUrl)
    .Timeout(TLojaModelInfraConfiguracoes.GetInstance.APITimeout)
    .BasicAuthentication(
      TLojaModelInfraUsuario.GetInstance.Login,
      TLojaModelInfraUsuario.GetInstance.Senha
    )
  ;
end;

end.
