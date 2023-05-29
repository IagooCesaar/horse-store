unit Loja.Controller.Api.Test;

interface

uses
  System.Classes,
  System.SysUtils,
  App;

type
  TLojaControllerApiTest = class
  private
    FApp: TApp;

    class var FApiTest: TLojaControllerApiTest;
    function getBaseUrl: string;
    function getUsername: string;
    function getPassword: string;
  public
    constructor Create;
	  destructor Destroy; override;

    property BaseURL: string read getBaseUrl;
    property UserName: string read getUsername;
    property Password: string read getPassword;

    class destructor UnInitialize;
    class function GetInstance: TLojaControllerApiTest;

  end;

implementation

{ TLojaControllerApiTest }

constructor TLojaControllerApiTest.Create;
begin
  FApp := TApp.Create;
  FApp.Start(9000);
end;

destructor TLojaControllerApiTest.Destroy;
begin
  if Assigned(FApp)
  then begin
    try
      FApp.Stop;
    finally
      FreeAndNil(FApp);
    end;
  end;
  inherited;
end;

function TLojaControllerApiTest.getBaseUrl: string;
begin
  Result := FApp.BaseURL;
end;

class function TLojaControllerApiTest.GetInstance: TLojaControllerApiTest;
begin
  if not Assigned(FApiTest)
  then FApiTest := TLojaControllerApiTest.Create;
  Result := FApiTest;
end;

function TLojaControllerApiTest.getPassword: string;
begin
  Result := FApp.Senha;
end;

function TLojaControllerApiTest.getUsername: string;
begin
  Result := FApp.Usuario;
end;

class destructor TLojaControllerApiTest.UnInitialize;
begin
  if Assigned(FApiTest)
  then FreeAndNil(FApiTest);
end;

end.
