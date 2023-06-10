unit Loja.Model.Infra.Types;

interface

type
  TLhsBracketsType = (Equal, NotEqual, LessThan, LessThanOrEqual, GreaterThan, GreaterThanOrEqual, Range, Like,
    Contains, StartsWith, EndsWith);

  TLhsBracketsTypeHelper = record helper for TLhsBracketsType
    function ToString: string;
  end;

  TLhsBracketFilter = record
     Valor: string;
     Tipo: TLhsBracketsType;
  end;

implementation

{ TLhsBracketsTypeHelper }

function TLhsBracketsTypeHelper.ToString: string;
begin
  case Self of
    TLhsBracketsType.Equal:
      Result := '[eq]';
    TLhsBracketsType.NotEqual:
      Result := '[ne]';
    TLhsBracketsType.LessThan:
      Result := '[lt]';
    TLhsBracketsType.LessThanOrEqual:
      Result := '[lte]';
    TLhsBracketsType.GreaterThan:
      Result := '[gt]';
    TLhsBracketsType.GreaterThanOrEqual:
      Result := '[gte]';
    TLhsBracketsType.Range:
      Result := '[range]';
    TLhsBracketsType.Like:
      Result := '[like]';
    TLhsBracketsType.Contains:
      Result := '[contains]';
    TLhsBracketsType.StartsWith:
      Result := '[startsWith]';
    TLhsBracketsType.EndsWith:
      Result := '[endsWith]';
  end;
end;

end.
