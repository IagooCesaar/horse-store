unit Database.Tipos;

interface

uses
  Data.DB, System.Generics.Collections, System.Variants,
  System.SysUtils,

  FireDac.DApt, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet;

type
  TQuery = FireDAC.Comp.Client.TFDQuery;
  TStoredProc = FireDAC.Comp.Client.TFDStoredProc;
  TMemTable = FireDAC.Comp.Client.TFDMemTable;
  TConnection = FireDAC.Comp.Client.TFDConnection;
  TDataSet = Data.DB.TDataSet;

  TParamsConsultaBDValue = record
    FValor: variant;
    FTipo: TFieldType; // ftString, ftInteger, ftFloat, ftDateTime
  end;

  TConnectionDefDriverParams = record
    DriverDefName: string;
    VendorLib: string;
  end;

  TConnectionDefParams = record
    ConnectionDefName: string;
    Server: string;
    Database: string;
    UserName: string;
    Password: string;
    LocalConnection: Boolean;
  end;

  TConnectionDefPoolParams = record
    Pooled: Boolean;
    PoolMaximumItems: Integer;
    PoolCleanupTimeout: Integer;
    PoolExpireTimeout: Integer;
  end;

type
 TParamList = class
  private
    fLista: TObjectDictionary<string, TParamsConsultaBDValue>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    class function CreateNew: TParamList;
    procedure SetParams(pQuery: TFDQuery);
    function Adiciona(pNomPar: string; pType: TFieldType; pValue: variant): TParamList;
    function Clone: TParamList;
    function Value(pNomPar: string): Variant;
    function ToString: string;
    class function VarVoidToNull(Value: Variant): Variant;
    class function VarToInt(Value: Variant): Integer;
    class function VarToString(Value: Variant): String;
    class function VarToFloat(Value: Variant): Double;
    class function VarToDateTime(Value: Variant): TDateTime;
    property Lista: TObjectDictionary<string, TParamsConsultaBDValue> read fLista;
  end;

implementation

{ TParamList }

function TParamList.Adiciona(pNomPar: string; pType: TFieldType;
  pValue: variant): TParamList;
var
  r: TParamsConsultaBDValue;
begin
  r.FValor := pValue;
  r.FTipo  := pType;
  fLista.Add(pNomPar, r);
  result := Self;
end;

procedure TParamList.Clear;
begin
  fLista.Clear;
end;

function TParamList.Clone: TParamList;
var
  Key: string;
begin
  if not assigned(Self) then
     result:= nil
  else begin
    result := TParamList.Create;
    for Key in Self.fLista.Keys do
      result.fLista.Add(Key,fLista.Items[Key]);
  end;
end;

constructor TParamList.Create;
begin
  fLista := TObjectDictionary<string, TParamsConsultaBDValue>.Create;
end;

class function TParamList.CreateNew: TParamList;
begin
  result := TParamList.Create;
end;

destructor TParamList.Destroy;
begin
  fLista.Clear;
  fLista.Free;
  inherited;
end;

procedure TParamList.SetParams(pQuery: TFDQuery);
var
  Key: string;
begin
  for Key in Self.fLista.Keys do
  begin
    pQuery.ParamByName(Key).DataType := fLista.Items[Key].FTipo;
    pQuery.ParamByName(Key).Value := fLista.Items[Key].FValor;
  end;
end;

function TParamList.ToString: string;
var
  Key: string;
begin
  result:= '';
  for Key in Self.fLista.Keys do begin
      if result <> ''
      then result := result + '; ';
      result := result + Key + '=' + '"'+ fLista.Items[Key].FValor + '"';
  end;
end;

function TParamList.Value(pNomPar: string): Variant;
var
  Key: string;
begin
  result:= null;
  for Key in Self.fLista.Keys do
      if Uppercase(Key) = Uppercase(pNomPar) then begin
          case fLista.Items[Key].FTipo of
            ftString:   result := fLista.Items[Key].FValor;
            ftInteger:  result := Integer(fLista.Items[Key].FValor); // aquitem
            ftFloat:    result := fLista.Items[Key].FValor;
            ftDateTime: result := fLista.Items[Key].FValor;
          else
            result := fLista.Items[Key].FValor;
          end;
          break;
      end;
end;

class function TParamList.VarToDateTime(Value: Variant): TDateTime;
begin
  if (Value = Null) then
     Result := 0
  else Result := Value
end;

class function TParamList.VarToFloat(Value: Variant): Double;
begin
  if (Value = Null) then
     Result := 0
  else Result := Value;
end;

class function TParamList.VarToInt(Value: Variant): Integer;
begin
  if (Value = Null) then
     Result := 0
  else Result := Value;
end;

class function TParamList.VarToString(Value: Variant): String;
begin
  if (Value = Null) then
     Result := ''
  else Result := Value;
end;

class function TParamList.VarVoidToNull(Value: Variant): Variant;
var
  ValueModf : Variant;
  mVarType : Word;
begin
  ValueModf := Value;
  mVarType  := VarType(ValueModf);

  if (mVarType = varString) or (mVarType = varUString) then
  begin
    if (Value = '') then
     ValueModf := null;
  end
  else
  if ((mVarType = varDate) or (mVarType = varInteger)) then
     if (Value = 0) then
        ValueModf := null;

  Result := ValueModf;
end;

end.
