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

  IDataBaseConexao = interface
    ['{5C4CB712-2E3D-42A1-A7C6-EC59B140F320}']
    function SetConnectionDefDriverParams(PParams: TConnectionDefDriverParams): IDatabaseConexao;
    function SetConnectionDefParams(PParams: TConnectionDefParams): IDatabaseConexao;
    function SetConnectionDefPoolParams(PParams: TConnectionDefPoolParams): IDatabaseConexao;

    function IniciaPoolConexoes: IDatabaseConexao;
    function GetConnection: TConnection;
  end;

  IDataBaseParamList = interface
    ['{E6E57637-7ECC-4425-AFE3-8633F9B24B16}']
    function AddString(pNome: string; pValor: string): IDataBaseParamList; overload;
    function AddString(pNome: string; pValor: variant): IDataBaseParamList; overload;
    function AddInteger(pNome: string; pValor: Integer): IDataBaseParamList; overload;
    function AddInteger(pNome: string; pValor: variant): IDataBaseParamList; overload;
    function AddFloat(pNome: string; pValor: Double): IDataBaseParamList; overload;
    function AddFloat(pNome: string; pValor: variant): IDataBaseParamList; overload;
    function AddDateTime(pNome: string; pValor: tdatetime): IDataBaseParamList; overload;
    function AddDateTime(pNome: string; pValor: variant): IDataBaseParamList; overload;
    function &End: IDataBaseSQL;
  end;

  IDataBaseSQL = interface
    ['{D21AC2FA-E4C8-4FD4-8C5E-B7844333825D}']
    function SQL(pSQL: string): IDataBaseSQL;
    function ParamList: IDataBaseParamList;
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

  IDatabaseFactory = interface
    ['{13926824-56E7-4021-9233-E7253913B693}']
    function Conexao: IDataBaseConexao;
    function SQL: IDataBaseSQL;
  end;

implementation

end.
