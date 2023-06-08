unit Loja.Model.Infra.Configuracoes;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IniFiles;

type
  TLojaModelInfraConfiguracoes = class
  private
    FIniFile: TIniFile;
    class var FConfig: TLojaModelInfraConfiguracoes;
    function getTema: string;
    procedure setTema(const Value: string);


  public
    constructor Create;
    destructor Destroy; override;
    class destructor UnInitialize;
    class function GetInstance: TLojaModelInfraConfiguracoes;

    property Tema: string read getTema write setTema;
  end;

implementation

uses
  Vcl.Forms,
  Vcl.Themes;

const
  C_SECAO_GERAL: string = 'GERAL';
  C_SECAO_API: string = 'API';

{ TLojaModelInfraConfiguracoes }

constructor TLojaModelInfraConfiguracoes.Create;
begin
  FIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
end;

destructor TLojaModelInfraConfiguracoes.Destroy;
begin
  FreeAndNil(FIniFile);
  FreeAndNil(FConfig);
  inherited;
end;

class function TLojaModelInfraConfiguracoes.GetInstance: TLojaModelInfraConfiguracoes;
begin
  if FConfig = nil
  then FConfig := TLojaModelInfraConfiguracoes.Create;
  Result := FConfig;
end;

function TLojaModelInfraConfiguracoes.getTema: string;
begin
  Result := FIniFile.ReadString(C_SECAO_GERAL, 'Tema', TStyleManager.ActiveStyle.Name);
end;

procedure TLojaModelInfraConfiguracoes.setTema(const Value: string);
begin
  TStyleManager.SetStyle(Value);
  FIniFile.WriteString(C_SECAO_GERAL, 'Tema', Value);
end;

class destructor TLojaModelInfraConfiguracoes.UnInitialize;
begin
  if FConfig <> nil
  then FreeAndNil(FConfig);
end;

end.
