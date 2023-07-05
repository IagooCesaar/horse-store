unit Loja.Controller.Venda;

interface

uses
  Horse,
  Horse.Commons,
  Horse.JsonInterceptor.Helpers;

procedure Registry(const AContext: string);
procedure ConfigSwagger;

const C_UnitName = 'Loja.Controller.Venda';

implementation

uses
  System.SysUtils,
  GBSwagger.Model.Interfaces,

  Loja.Model.Factory;

procedure Registry(const AContext: string);
begin

  ConfigSwagger;
end;

procedure ConfigSwagger;
begin

end;

end.
