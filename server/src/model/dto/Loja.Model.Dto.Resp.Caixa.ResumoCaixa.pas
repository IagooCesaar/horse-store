unit Loja.Model.Dto.Resp.Caixa.ResumoCaixa;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Caixa.Types,
  Loja.Model.Dto.Resp.Caixa.ResumoCaixa.MeioPagto;

type
  TLojaModelDtoRespCaixaResumoCaixa = class
  private
    FCodCaixa: Integer;
    FMeiosPagto: TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista;
    FCodSit: TLojaModelEntityCaixaSituacao;
    FVrSaldo: Currency;
  public
    destructor Destroy; override;

    property CodCaixa: Integer read FCodCaixa write FCodCaixa;
    property CodSit: TLojaModelEntityCaixaSituacao read FCodSit write FCodSit;
    property VrSaldo: Currency read FVrSaldo write FVrSaldo;
    property MeiosPagto: TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista read FMeiosPagto write FMeiosPagto;
  end;

  TLojaModelDtoRespCaixaResumoCaixaLista = TObjectList<TLojaModelDtoRespCaixaResumoCaixa>;

implementation

{ TLojaModelDtoRespCaixaResumoCaixa }

destructor TLojaModelDtoRespCaixaResumoCaixa.Destroy;
begin
  if FMeiosPagto <> nil
  then FreeAndNil(FMeiosPagto);
  inherited;
end;

end.
