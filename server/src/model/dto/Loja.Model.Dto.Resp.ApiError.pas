unit Loja.Model.Dto.Resp.ApiError;

interface

type
  TLojaModelDTORespApiError = class
  private
    Ferror: string;
    Funit: string;
  public
    property error: string read Ferror write Ferror;
    property &unit: string read Funit write Funit;
  end;

implementation

end.

