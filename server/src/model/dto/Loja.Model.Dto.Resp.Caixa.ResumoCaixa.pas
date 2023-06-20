unit Loja.Model.Dto.Resp.Caixa.ResumoCaixa;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,

  Loja.Model.Entity.Caixa.Types;

type
  TLojaModelDtoRespCaixaResumoCaixaMeioPagto = class;
  TLojaModelDtoRespCaixaResumoCaixaMeioPagtoLista = TObjectList<TLojaModelDtoRespCaixaResumoCaixaMeioPagto>;

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

  TLojaModelDtoRespCaixaResumoCaixaMeioPagto = class
  private
    FCodMeioPagto: TLojaModelEntityCaixaMeioPagamento;
    FVrTotal: Currency;
  public
    property CodMeioPagto: TLojaModelEntityCaixaMeioPagamento read FCodMeioPagto write FCodMeioPagto;
    property VrTotal: Currency read FVrTotal write FVrTotal;
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
