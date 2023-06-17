unit Database.Factory;

interface

uses
  System.Classes,
  Database.Interfaces,
  Database.Conexao,
  Database.SQL,
  Database.Script;

type
  TDatabaseFactory = class(TInterfacedObject, IDatabaseFactory)
  private
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IDatabaseFactory;

    { IDatabaseFactory }
    function Conexao: IDataBaseConexao;
    function SQL: IDataBaseSQL;
    function Script: IDatabaseScript;
  end;

implementation

{ TDatabaseFactory }

constructor TDatabaseFactory.Create;
begin

end;

function TDatabaseFactory.Conexao: IDataBaseConexao;
begin
  Result := TDatabaseConexao.New;
end;

function TDatabaseFactory.Script: IDatabaseScript;
begin
  Result := TDatabaseScript.New;
end;

function TDatabaseFactory.SQL: IDataBaseSQL;
begin
  Result := TDatabaseSQL.New;
end;

destructor TDatabaseFactory.Destroy;
begin

  inherited;
end;

class function TDatabaseFactory.New: IDatabaseFactory;
begin
  Result := Self.Create;
end;

end.
