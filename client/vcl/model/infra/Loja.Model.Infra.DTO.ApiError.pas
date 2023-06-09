unit Loja.Model.Infra.DTO.ApiError;

interface

type
  TLojaModelInfraDTOApiError = class
  private
    Ferror: string;
    Funit: string;
  public
    property error: string read Ferror write Ferror;
    property &unit: string read Funit write Funit;
  end;

implementation

end.

