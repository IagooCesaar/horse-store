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
    function GetSwaggerURL: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start(APort: Integer);
    procedure Stop;

    property Context: string read FContext;
    property BaseURL: string read GetBaseURL;
    property SwaggerURL: string read GetSwaggerURL;
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

  Loja.Controller.Registry,
  Loja.Model.Dto.Resp.ApiError;

{ TApp }

  var STARTED_AT: TDateTime;

procedure TApp.ConfigSwagger();
begin
  Swagger
    //.BasePath(GetBaseURL)
    .BasePath('/loja/api')
    .AddBasicSecurity.&End
    .Register
      .Response(Integer(THTTPStatus.NoContent)).Description('No Content').&End
      .Response(Integer(THTTPStatus.BadRequest)).Description('Bad Request')
        .Schema(TLojaModelDTORespApiError)
        .&End
      .Response(Integer(THTTPStatus.NotFound)).Description('Not Found')
        .Schema(TLojaModelDTORespApiError)
        .&End
      .Response(Integer(THTTPStatus.InternalServerError)).Description('Internal Server Error').&End
    .&End
    .AddProtocol(TGBSwaggerProtocol.gbHttp)
    //.AddProtocol(TGBSwaggerProtocol.gbHttps)
    .Info
      .Title('Loja API')
      .Version(Self.Version)
      .Description(Self.Description)
      .Contact
        .Name('Iago C�sar F. Nogueira')
        .Email('iagocesar.nogueira@gmail.com')
      .&End
    .&End
  .&End;
end;

procedure TApp.ConfigDatabase;
var
  LDBDriverParams: TConnectionDefDriverParams;
  LDBParams: TConnectionDefParams;
  LDBPoolParams: TConnectionDefPoolParams;
begin
  LDBDriverParams.DriverDefName := 'FB_DRIVER';
  LDBDriverParams.VendorLib := ''; // Path para fbclient.dll

  LDBParams.ConnectionDefName := 'bd_loja';
  LDBParams.Server := '127.0.0.1';
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

  {$IFDEF Test}
  var RS := TResourceStream.Create(HInstance, 'script_limpa_db', System.Types.RT_RCDATA);
  var LScript := TStringList.Create;
  try
    RS.Position := 0;
    LScript.LoadFromStream(RS, TEncoding.UTF8);
    try
      TDatabaseFactory.New
        .Script
        .AddScript(LScript.Text)
        .ExecuteAll;
    except
       raise Exception.Create('Falha ao executar script de limpeza de banco de dados');
    end;
  finally
    RS.Free;
    LScript.Free;
  end;
  {$ENDIF}
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

  THorse.MaxConnections := StrToIntDef(GetEnvironmentVariable('MAXCONNECTIONS'), 10000);
  THorse.ListenQueue := StrToIntDef(GetEnvironmentVariable('LISTENQUEUE'), 200);

  THorse
    .Use(Compression())
    .Use(Jhonson('UTF-8'))
    .Use(OctetStream)
    .Use(HorseSwagger(FContext+'/swagger-ui', FContext+'/api-docs'))
    .Use(HorseBasicAuthentication(ValidarLogin,
      THorseBasicAuthenticationConfig.New.SkipRoutes([
        FContext+'/api/healthcheck/',
        FContext+'/swagger-ui/',
        FContext+'/api-docs/'
      ])
    ))
    .Use(HandleException);

  //Registro de Rotas
  Loja.Controller.Registry.DoRegistry(FContext);
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

function TApp.GetSwaggerURL: string;
begin
  Result := Copy(
    BaseURL, 0,
    Pos('/api',BaseURL)-1
  )+'/swagger-ui';
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
      ConfigSwagger();

      {$IF defined(CONSOLE) and (not defined(TEST))}
      Writeln(Format('Server is runing on %s:%d', [THorse.Host, THorse.Port]));
      Writeln(Format('Try use Swagger on %s', [SwaggerURL]));
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

