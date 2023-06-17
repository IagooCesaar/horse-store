unit Database.Script;

interface

uses
  System.Classes,
  Database.Interfaces,
  Database.ParamList,
  Database.Tipos,

  FireDAC.UI.Intf, FireDAC.Stan.Async, FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util, FireDAC.Stan.Intf, FireDAC.Comp.Script;

type
 TDatabaseScript = class(TInterfacedObject, IDatabaseScript,
   IDataBaseScriptParamList)
 private
   FConnection: TConnection;
   FScript: TScript;
   FParamList: TDatabaseParamList;
 public
    constructor Create;
    destructor Destroy; override;
    class function New: IDatabaseScript;

    { IDatabaseScript }
    function AddScript(pScriptText: string): IDatabaseScript;
    function ParamList: IDatabaseScriptParamList;
    function ExecuteAll: IDatabaseScript;

    { IDataBaseParamList }
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

implementation

uses
  Database.Factory;

{ TDatabaseScript }

function TDatabaseScript.AddDateTime(pNome: string;
  pValor: variant): IDatabaseScriptParamList;
begin
  Result := Self;
  FParamList.AddDateTime(pNome, pValor);
end;

function TDatabaseScript.AddDateTime(pNome: string;
  pValor: tdatetime): IDatabaseScriptParamList;
begin
  Result := Self;
  FParamList.AddDateTime(pNome, pValor);
end;

function TDatabaseScript.AddFloat(pNome: string;
  pValor: Double): IDatabaseScriptParamList;
begin
  Result := Self;
  FParamList.AddFloat(pNome, pValor);
end;

function TDatabaseScript.AddFloat(pNome: string;
  pValor: variant): IDatabaseScriptParamList;
begin
  Result := Self;
  FParamList.AddFloat(pNome, pValor);
end;

function TDatabaseScript.AddInteger(pNome: string;
  pValor: variant): IDatabaseScriptParamList;
begin
  Result := Self;
  FParamList.AddInteger(pNome, pValor);
end;

function TDatabaseScript.AddInteger(pNome: string;
  pValor: Integer): IDatabaseScriptParamList;
begin
  Result := Self;
  FParamList.AddInteger(pNome, pValor);
end;

function TDatabaseScript.AddString(pNome: string;
  pValor: variant): IDatabaseScriptParamList;
begin
  Result := Self;
  FParamList.AddString(pNome, pValor);
end;

function TDatabaseScript.AddString(pNome,
  pValor: string): IDatabaseScriptParamList;
begin
  Result := Self;
  FParamList.AddString(pNome, pValor);
end;

constructor TDatabaseScript.Create;
begin
  FConnection := TDatabaseFactory.New.Conexao.GetConnection;
  FScript := TScript.Create(nil);
  FScript.Connection := FConnection;

  FParamList := TDatabaseParamList.Create(FScript.Params);
end;

destructor TDatabaseScript.Destroy;
begin
  FScript.Free;
  FConnection.Free;
  FParamList.Free;
  inherited;
end;

function TDatabaseScript.AddScript(pScriptText: string): IDatabaseScript;
begin
  Result := Self;
  FScript.SQLScripts.Add;
  FScript.SQLScripts[FScript.SQLScripts.Count-1].SQL.Text := pScriptText;
end;

function TDatabaseScript.&End: IDatabaseScript;
begin
  Result := Self;
end;

function TDatabaseScript.ExecuteAll: IDatabaseScript;
begin
  Result := Self;
  FScript.ExecuteAll;
end;

class function TDatabaseScript.New: IDatabaseScript;
begin
  Result := Self.Create;
end;

function TDatabaseScript.ParamList: IDatabaseScriptParamList;
begin
  Result := Self;
end;

end.
