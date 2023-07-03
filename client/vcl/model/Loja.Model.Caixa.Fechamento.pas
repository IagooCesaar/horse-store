unit Loja.Model.Caixa.Fechamento;

interface

uses
  System.SysUtils,
  System.Classes,

  Loja.Model.Caixa.ResumoMeioPagto;

type
  TLojaModelCaixaFechamento = class
  private
    FCodCaixa: Integer;
    FMeiosPagto: TLojaModelCaixaResumoMeioPagtoLista;
  public
    destructor Destroy; override;

    property MeiosPagto: TLojaModelCaixaResumoMeioPagtoLista read FMeiosPagto write FMeiosPagto;
  end;

implementation

{ TLojaModelDtoReqCaixaFechamento }

destructor TLojaModelCaixaFechamento.Destroy;
begin
  if FMeiosPagto <> nil
  then FreeAndNil(FMeiosPagto);

  inherited;
end;

end.
