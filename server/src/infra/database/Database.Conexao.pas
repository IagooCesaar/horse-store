unit Database.Conexao;

interface

uses
  System.Classes,
  Database.Interfaces,
  Database.Tipos;

type
  TDatabaseConexao = class(TNoRefCountObject, IDataBaseConexao)
  private
    FParams: TConnectionDefParams;
    FDriverParams: TConnectionDefDriverParams;
    FPoolParams: TConnectionDefPoolParams;

    class var FConexao: TDatabaseConexao;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IDataBaseConexao;
    class destructor UnInitialize;

    { IDataBaseConexao }
    function SetConnectionDefDriverParams(PParams: TConnectionDefDriverParams): IDatabaseConexao;
    function SetConnectionDefParams(PParams: TConnectionDefParams): IDatabaseConexao;
    function SetConnectionDefPoolParams(PParams: TConnectionDefPoolParams): IDatabaseConexao;

    function IniciaPoolConexoes: IDatabaseConexao;
    function GetConnection: TConnection;
  end;

implementation

uses
  System.SysUtils,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,

  //FIREBIRD
  FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB,
  FireDAC.Phys.IBWrapper;

{ TDatabaseConexao }

constructor TDatabaseConexao.Create;
begin

end;

destructor TDatabaseConexao.Destroy;
begin

  inherited;
end;

function TDatabaseConexao.GetConnection: TConnection;
begin
  Result := TConnection.Create(nil);
  Result.ConnectionDefName := FParams.ConnectionDefName;
end;

function TDatabaseConexao.IniciaPoolConexoes: IDatabaseConexao;
// fonte: https://github.com/antoniojmsjr/MultithreadingFireDAC
var
  LConnection: TFDCustomConnection;
  LFBConnectionDefParams: TFDPhysFBConnectionDefParams; // FIREBIRD CONNECTION PARAMS
  LFDStanConnectionDef: IFDStanConnectionDef;
  LFDStanDefinition: IFDStanDefinition;
begin
  Result := Self;

  //PARA CRIAR OU ALTERAR É NECESSÁRIO FECHAR A O FDMANGER REFERENTE A ConnectionDefName
  FDManager.CloseConnectionDef(FParams.ConnectionDefName);

  FDManager.ActiveStoredUsage := [auRunTime];
  FDManager.ConnectionDefFileAutoLoad := False;
  FDManager.DriverDefFileAutoLoad := False;
  FDManager.SilentMode := True; //DESATIVA O CICLO DE MENSAGEM COM O WINDOWS PARA APRESENTAR A AMPULHETA DE PROCESSANDO.
  //FDManager.Open;

  //DRIVER
  LFDStanDefinition := FDManager.DriverDefs.FindDefinition(FDriverParams.DriverDefName);
  if not Assigned(FDManager.DriverDefs.FindDefinition(FDriverParams.DriverDefName)) then
  begin
    LFDStanDefinition := FDManager.DriverDefs.Add;
    LFDStanDefinition.Name := FDriverParams.DriverDefName;
  end;
  LFDStanDefinition.AsString['BaseDriverID'] := 'FB'; //DRIVER BASE
  if not FDriverParams.VendorLib.Trim.IsEmpty then
    LFDStanDefinition.AsString['VendorLib'] := FDriverParams.VendorLib; //DEFINE O CAMINHO DA DLL CLIENT DO FIREBIRD.

  //CONNECTION
  LFDStanConnectionDef := FDManager.ConnectionDefs.FindConnectionDef(FParams.ConnectionDefName);
  if not Assigned(FDManager.ConnectionDefs.FindConnectionDef(FParams.ConnectionDefName)) then
  begin
    LFDStanConnectionDef := FDManager.ConnectionDefs.AddConnectionDef;
    LFDStanConnectionDef.Name := FParams.ConnectionDefName;
  end;

  //DEFINIÇÃO DE CONEXÃO: PRIVADO :: https://docwiki.embarcadero.com/RADStudio/Sydney/en/Defining_Connection_(FireDAC)
  LFBConnectionDefParams := TFDPhysFBConnectionDefParams(LFDStanConnectionDef.Params);
  LFBConnectionDefParams.DriverID := FDriverParams.DriverDefName;
  LFBConnectionDefParams.Database := FParams.Database;
  LFBConnectionDefParams.UserName := FParams.UserName;
  LFBConnectionDefParams.Password := FParams.Password;
  LFBConnectionDefParams.Server := FParams.Server;
  LFBConnectionDefParams.Protocol := TIBProtocol.ipLocal;
  if not FParams.LocalConnection then
    LFBConnectionDefParams.Protocol := TIBProtocol.ipTCPIP;

  LFBConnectionDefParams.Pooled := FPoolParams.Pooled;
  LFBConnectionDefParams.PoolMaximumItems := FPoolParams.PoolMaximumItems;
  LFBConnectionDefParams.PoolCleanupTimeout := FPoolParams.PoolCleanupTimeout;
  LFBConnectionDefParams.PoolExpireTimeout := FPoolParams.PoolExpireTimeout;

  //WriteOptions
  LConnection := TFDCustomConnection.Create(nil);
  try
    LConnection.FetchOptions.Mode := TFDFetchMode.fmAll; //fmAll
    LConnection.ResourceOptions.AutoConnect := False;
//    lConnection.ResourceOptions.AutoReconnect := True;  //PERDA DE PERFORMANCE COM THREAD

    with LConnection.FormatOptions.MapRules.Add do
    begin
      SourceDataType := dtDateTime; { TFDParam.DataType }
      TargetDataType := dtDateTimeStamp; { Firebird TIMESTAMP }
    end;

    LFDStanConnectionDef.WriteOptions(LConnection.FormatOptions,
                                      LConnection.UpdateOptions,
                                      LConnection.FetchOptions,
                                      LConnection.ResourceOptions);
  finally
    LConnection.Free;
  end;

  if (FDManager.State <> TFDPhysManagerState.dmsActive) then
    FDManager.Open;
end;

class function TDatabaseConexao.New: IDataBaseConexao;
begin
  if not Assigned(FConexao)
  then FConexao := TDatabaseConexao.Create;
  Result := FConexao;
end;

function TDatabaseConexao.SetConnectionDefDriverParams(
  PParams: TConnectionDefDriverParams): IDatabaseConexao;
begin
  Result := Self;
  FDriverParams := PParams;
end;

function TDatabaseConexao.SetConnectionDefParams(
  PParams: TConnectionDefParams): IDatabaseConexao;
begin
  Result := Self;
  FParams := PParams;
end;

function TDatabaseConexao.SetConnectionDefPoolParams(
  PParams: TConnectionDefPoolParams): IDatabaseConexao;
begin
  Result := Self;
  FPoolParams := PParams;
end;

class destructor TDatabaseConexao.UnInitialize;
begin
  if FConexao <> nil
  then FreeAndNil(FConexao);
end;

end.
