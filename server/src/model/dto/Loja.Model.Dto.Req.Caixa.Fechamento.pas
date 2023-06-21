unit Loja.Model.Dto.Req.Caixa.Fechamento;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TLojaModelDtoReqCaixaFechamento = class
  private
    FCodCaixa: Integer;
  public
    property CodCaixa: Integer read FCodCaixa write FCodCaixa;
  end;

implementation

end.
