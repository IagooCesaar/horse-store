unit Database.Interfaces;

interface

uses
  Data.DB,
  FireDAC.Comp.Client,
  DataBase.Tipos,
  System.Classes;

type

  TDatabaseAmbiente = (aPROD, aHOMO, aDESE);

  IDataBaseSQL = interface;
  IDatabaseScript = interface;

  IDataBaseConexao = interface
    ['{5C4CB712-2E3D-42A1-A7C6-EC59B140F320}']
    function SetConnectionDefDriverParams(PParams: TConnectionDefDriverParams): IDatabaseConexao;
    function SetConnectionDefParams(PParams: TConnectionDefParams): IDatabaseConexao;
    function SetConnectionDefPoolParams(PParams: TConnectionDefPoolParams): IDatabaseConexao;

    function IniciaPoolConexoes: IDatabaseConexao;
    function GetConnection: TConnection;
  end;

  IDatabaseSQLParamList = interface
    ['{A681B8EA-616D-479B-ACBF-F82214ECA72A}']
    function AddString(pNome: string; pValor: string): IDatabaseSQLParamList; overload;
    function AddString(pNome: string; pValor: variant): IDatabaseSQLParamList; overload;
    function AddInteger(pNome: string; pValor: Integer): IDatabaseSQLParamList; overload;
    function AddInteger(pNome: string; pValor: variant): IDatabaseSQLParamList; overload;
    function AddFloat(pNome: string; pValor: Double): IDatabaseSQLParamList; overload;
    function AddFloat(pNome: string; pValor: Currency): IDataBaseSQLParamList; overload;
    function AddFloat(pNome: string; pValor: variant): IDatabaseSQLParamList; overload;
    function AddDateTime(pNome: string; pValor: tdatetime): IDatabaseSQLParamList; overload;
    function AddDateTime(pNome: string; pValor: variant): IDatabaseSQLParamList; overload;
    function &End: IDataBaseSQL;
  end;

  IDatabaseScriptParamList = interface
    ['{D122DECD-083D-4062-8804-58032817A281}']
    function AddString(pNome: string; pValor: string): IDatabaseScriptParamList; overload;
    function AddString(pNome: string; pValor: variant): IDatabaseScriptParamList; overload;
    function AddInteger(pNome: string; pValor: Integer): IDatabaseScriptParamList; overload;
    function AddInteger(pNome: string; pValor: variant): IDatabaseScriptParamList; overload;
    function AddFloat(pNome: string; pValor: Double): IDatabaseScriptParamList; overload;
    function AddFloat(pNome: string; pValor: variant): IDatabaseScriptParamList; overload;
    function AddDateTime(pNome: string; pValor: tdatetime): IDatabaseScriptParamList; overload;
    function AddDateTime(pNome: string; pValor: variant): IDatabaseScriptParamList; overload;
    function &End: IDatabaseScript;
  end;

  IDataBaseSQL = interface
    ['{D21AC2FA-E4C8-4FD4-8C5E-B7844333825D}']
    function SQL(pSQL: string): IDataBaseSQL;
    function ParamList: IDatabaseSQLParamList;
    function Open: TDataSet; overload;
    function Open(pSQL: string): TDataSet; overload;
    function ExecSQL: IDataBaseSQL; overload;
    function ExecSQL(pSQL: string): IDataBaseSQL; overload;
    function CriaQuery: TQuery;
    function GetConexao: TConnection;
    function QueryGetValueFirstField(pSQLText: String): variant;
    function GeraProximoCodigo(pFieldName, pTable: String; const pWhere: string = '';
      const pIncrement: Integer = 1): Integer; overload;
    function GeraProximoCodigo(PGenerator: string): Integer; overload;
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
  end;

  IDatabaseScript = interface
    ['{A0F83FA6-54C7-44FE-87F5-9DB40A018095}']
    function AddScript(pScriptText: string): IDatabaseScript;
    function ParamList: IDatabaseScriptParamList;
    function ExecuteAll: IDatabaseScript;
  end;

  IDatabaseFactory = interface
    ['{13926824-56E7-4021-9233-E7253913B693}']
    function Conexao: IDataBaseConexao;
    function SQL: IDataBaseSQL;
    function Script: IDatabaseScript;
  end;

implementation

end.
