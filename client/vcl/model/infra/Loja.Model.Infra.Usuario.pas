unit Loja.Model.Infra.Usuario;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TLojaModelInfraUsuario = class
  private
    FLogin: string;
    FSenha: string;

    class var FUsuario: TLojaModelInfraUsuario;

  public
    constructor Create;
    destructor Destroy; override;
    class destructor UnInitialize;
    class function GetInstance: TLojaModelInfraUsuario;

    property Login: string read FLogin write FLogin;
    property Senha: string read FSenha write FSenha;
  end;

implementation

{ TLojaModelInfraUsuario }

constructor TLojaModelInfraUsuario.Create;
begin

end;

destructor TLojaModelInfraUsuario.Destroy;
begin

  inherited;
end;

class function TLojaModelInfraUsuario.GetInstance: TLojaModelInfraUsuario;
begin
  if FUsuario <> nil
  then FUsuario := TLojaModelInfraUsuario.Create;
  Result := FUsuario;
end;

class destructor TLojaModelInfraUsuario.UnInitialize;
begin
  if FUsuario <> nil
  then FreeAndNil(FUsuario);
end;

end.
