unit Database.ParamList;

interface

uses
  System.Classes,
  System.Variants,

  Data.DB,

  Database.Interfaces,
  Database.Tipos;

type
  TDatabaseParamList = class
  private
    FParams: TParams;
    procedure AddNull(pTipo: TFieldType; pNome: string; pValor: variant);
    function VarVoidToNull(pValor: Variant): Variant;
  public
    { IDataBaseParamList2 }
    constructor Create(pParams: TParams);
    procedure AddString(pNome: string; pValor: string); overload;
    procedure AddString(pNome: string; pValor: variant); overload;
    procedure AddInteger(pNome: string; pValor: Integer); overload;
    procedure AddInteger(pNome: string; pValor: variant); overload;
    procedure AddFloat(pNome: string; pValor: Double); overload;
    procedure AddFloat(pNome: string; pValor: variant); overload;
    procedure AddDateTime(pNome: string; pValor: tdatetime); overload;
    procedure AddDateTime(pNome: string; pValor: variant); overload;
  end;

implementation

uses
  Horse,
  Horse.Exception;

{ TDatabaseParamList }

procedure  TDatabaseParamList.AddDateTime(pNome: string;
  pValor: tdatetime);
begin
  if FParams.FindParam(pNome) = nil then Exit;
  FParams.ParamByName(pNome).AsDateTime := pValor;
end;

procedure  TDatabaseParamList.AddDateTime(pNome: string;
  pValor: variant);
begin
  if FParams.FindParam(pNome) = nil then Exit;
  pValor := VarVoidToNull(pValor);

  if not(pValor = null) then
    AddFloat(pNome, TDateTime(pValor))
  else
    AddNull(ftDateTime, pNome, pValor);
end;

procedure  TDatabaseParamList.AddFloat(pNome: string;
  pValor: variant);
begin
  if FParams.FindParam(pNome) = nil then Exit;
  FParams.ParamByName(pNome).AsFloat := pValor;
end;

procedure  TDatabaseParamList.AddFloat(pNome: string;
  pValor: Double);
begin
  if FParams.FindParam(pNome) = nil then Exit;
  if pValor > 0 then
    AddFloat(pNome, Double(pValor))
  else
    AddNull(ftFloat, pNome, pValor);
end;

procedure  TDatabaseParamList.AddInteger(pNome: string;
  pValor: Integer);
begin
  if FParams.FindParam(pNome) = nil then Exit;
  FParams.ParamByName(pNome).AsInteger := pValor;
end;

procedure  TDatabaseParamList.AddInteger(pNome: string;
  pValor: variant);
begin
  if FParams.FindParam(pNome) = nil then Exit;
  pValor := VarVoidToNull(pValor);

  if not(pValor = null) then
    AddFloat(pNome, Integer(pValor))
  else
    AddNull(ftInteger, pNome, pValor);
end;

procedure TDatabaseParamList.AddNull(pTipo: TFieldType; pNome: string;
  pValor: variant);
begin
  if not VarIsNull(pValor) then
    raise EHorseException.New
            .Error('O parâmetro ('+pNome+') deve ser, obrigatoriamento, do tipo Nulo ou '+ FieldTypeNames[pTipo])
            .&Unit(Self.UnitName);
  FParams.ParamByName(pNome).DataType := pTipo;
  FParams.ParamByName(pNome).Value := Null;
end;

procedure  TDatabaseParamList.AddString(pNome, pValor: string);
begin
  if FParams.FindParam(pNome) = nil then Exit;

  FParams.ParamByName(pNome).DataType := ftString;
  FParams.ParamByName(pNome).AsString := pValor;
end;

procedure TDatabaseParamList.AddString(pNome: string;
  pValor: variant);
begin
  if FParams.FindParam(pNome) = nil then Exit;
  pValor := VarVoidToNull(pValor);

  if not(pValor = null)  then
    AddString(pNome, String(pValor))
  else
    AddNull(ftString, pNome, pValor);
end;

constructor TDatabaseParamList.Create(pParams: TParams);
begin
  FParams := pParams;
end;

function TDatabaseParamList.VarVoidToNull(pValor: Variant): Variant;
var i: integer;
begin
  i := VarType(pValor);

  case VarType(pValor) of
    varString, varUString:
      if pValor = ''
      then Result := null
      else Result := pValor;

   varDate, varInteger:
     if pValor = 0
     then Result := null
     else Result := pValor;

  else
    Result := pValor;
  end;
end;

end.
