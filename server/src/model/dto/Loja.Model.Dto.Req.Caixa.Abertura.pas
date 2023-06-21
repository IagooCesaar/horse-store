unit Loja.Model.Dto.Req.Caixa.Abertura;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TLojaModelDtoReqCaixaAbertura = class
  private
    FVrAbertura: Currency;
  public
    property VrAbertura: Currency read FVrAbertura write FVrAbertura;
  end;

implementation

end.
