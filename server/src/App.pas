unit App;

interface

uses System.Classes, System.JSON, MidasLib;

type
  TApp = class
  private
    FContext: string;
    FCreatedAt: TDateTime;
    FStartedAt: TDateTime;
    FBossConfig: TJSONObject;
    FUsuario: string;
    FSenha: string;

    procedure ConfigSwagger;
    procedure ConfigLogger;
    procedure ConfigDatabase;
    function GetBaseURL: string;

    procedure LoadBossConfig;
    function GetVersion: string;
    function GetDescription: string;
    function GetEmExecucao: Boolean;
    function ValidarLogin(const AUsername, APassword: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start(APort: Integer);
    procedure Stop;

    property Context: string read FContext;
    property BaseURL: string read GetBaseURL;
    property Version: string read GetVersion;
    property Description: string read GetDescription;
    property EmExecucao: Boolean read GetEmExecucao;
    property Usuario: string read FUsuario write FUsuario;
    property Senha: string read FSenha write FSenha;

end;

implementation

uses
  System.SyncObjs,
  System.SysUtils,
  System.DateUtils,
  System.StrUtils,
  System.Types,

  Horse,
  Horse.Jhonson,
  Horse.HandleException,
  Horse.GBSwagger,
  Horse.OctetStream,
  Horse.Compression,
  DataSet.Serialize,
  Horse.BasicAuthentication,

  Database.Factory,
  Database.Tipos,

  Loja.Controller.Registry;

{ TApp }

  var STARTED_AT: TDateTime;

procedure TApp.ConfigSwagger();
begin
  
end;

procedure TApp.ConfigDatabase;
var
  LDBDriverParams: TConnectionDefDriverParams;
  LDBParams: TConnectionDefParams;
  LDBPoolParams: TConnectionDefPoolParams;
begin
  LDBDriverParams.DriverDefName := 'FB_DRIVER';
  LDBDriverParams.VendorLib := ''; // Path para fbclient.dll

  LDBParams.ConnectionDefName := 'loja_prod';
  LDBParams.Server := 'localhost';
  LDBParams.Database := 'C:\#DEV\#Projetos\loja\server\database\loja-bd.fbd';
  LDBParams.UserName := 'SYSDBA';
  LDBParams.Password := 'masterkey';
  LDBParams.LocalConnection := True;

  LDBPoolParams.Pooled := True;
  LDBPoolParams.PoolMaximumItems := 50;
  LDBPoolParams.PoolCleanupTimeout := 30000;
  LDBPoolParams.PoolExpireTimeout := 60000;

  TDatabaseFactory.New
    .Conexao
    .SetConnectionDefDriverParams(LDBDriverParams)
    .SetConnectionDefParams(LDBParams)
    .SetConnectionDefPoolParams(LDBPoolParams)
    .IniciaPoolConexoes;
end;

procedure TApp.ConfigLogger();
begin
  var strConfig := '${request_clientip} [${time}] "${request_method}::${request_path_translated}" '+
    '${response_status} ${execution_time}ms';
end;

constructor TApp.Create;
begin
  inherited;

  {$IFDEF MSWINDOWS}
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  FSenha := 'admin';
  FUsuario := 'admin';
  FContext := '/loja';
  FCreatedAt := Now;

  LoadBossConfig();
  ConfigLogger();
  ConfigSwagger();

  THorse.MaxConnections := StrToIntDef(GetEnvironmentVariable('MAXCONNECTIONS'), 10000);
  THorse.ListenQueue := StrToIntDef(GetEnvironmentVariable('LISTENQUEUE'), 200);

  THorse.Use(Jhonson('UTF-8'))
        .Use(Compression())
        .Use(OctetStream)
        .Use(HorseSwagger('/swagger-ui', FContext+'/api-docs'))
        .Use(HorseBasicAuthentication(ValidarLogin,
          THorseBasicAuthenticationConfig.New.SkipRoutes([
            FContext+'/api/healthcheck/'
          ])
        ))
        .Use(HandleException);

  //Registro de Rotas
  Loja.Controller.Registry.DoRegistry(FContext);

  THorse.Get('/ping',
    procedure (AReq: THorseRequest; AResp: THorseResponse)
    begin
      AResp.Send(TDatabaseFactory.New.SQL
        .SQL('SELECT * FROM MON$ATTACHMENTS')
        .Open
        .ToJSONArray
      );
    end
  );
end;

destructor TApp.Destroy;
begin
  while THorse.IsRunning do begin
    THorse.StopListen;
    Sleep(1000);
  end;
  FBossConfig.Free;
  inherited;
end;

function TApp.GetBaseURL: string;
begin
  Result := Format('http://localhost:%d%s/%s', [THorse.Port, FContext, 'api']);
end;

function TApp.GetDescription: string;
begin
  Result := FBossConfig.GetValue<string>('description');
end;

function TApp.GetEmExecucao: Boolean;
begin
  Result := THorse.IsRunning;
end;

function TApp.GetVersion: string;
begin
  Result := FBossConfig.GetValue<string>('version');
end;

procedure TApp.LoadBossConfig;
var RS : TResourceStream; LBossConfig : TStringList;
begin
  LBossConfig := TStringList.Create;
  RS := TResourceStream.Create(HInstance, 'boss_config', System.Types.RT_RCDATA);
  try
    RS.Position := 0;
    LBossConfig.LoadFromStream(RS, TEncoding.UTF8);
    FBossConfig := TJSONObject.ParseJSONValue(
      LBossConfig.Text
    ) as TJSONObject;
  finally
    RS.Free;
    LBossConfig.Free;
  end;
end;

procedure TApp.Start(APort: Integer);
begin
  ConfigDatabase;

  FStartedAt := Now;
  THorse.Listen(APort,
    procedure begin
      {$IF defined(CONSOLE) and (not defined(TEST))}
      Writeln(Format('Server is runing on %s:%d', [THorse.Host, THorse.Port]));
      Writeln(Format('Try use Swagger on %s/swagger-ui', [GetBaseURL]));
      Writeln(Format('Interval to start: %dms',[MilliSecondsBetween(Now, STARTED_AT)]));
      Readln;
      {$ENDIF}
    end);
end;

procedure TApp.Stop;
begin
  THorse.StopListen;
end;

function TApp.ValidarLogin(const AUsername, APassword: string): Boolean;
begin
  if Length(FUsuario) * Length(FSenha) = 0
  then Result := True
  else Result := AUsername.Equals(FUsuario) and APassword.Equals(FSenha);
end;

initialization
  STARTED_AT := Now;

end.

