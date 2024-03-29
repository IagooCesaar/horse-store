unit Loja.Controller.Itens;

interface

uses
  System.SysUtils, System.Classes, Loja.Controller.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  RESTRequest4D,
  DataSet.Serialize,

  Loja.Model.Infra.Types;

type
  TControllerItens = class(TControllerBase)
    mtDadosCOD_ITEM: TIntegerField;
    mtDadosNOM_ITEM: TStringField;
    mtDadosNUM_COD_BARR: TStringField;
    mtDadosFLG_PERM_SALD_NEG: TBooleanField;
    mtDadosFLG_TAB_PRECO: TBooleanField;
    procedure mtDadosBeforePost(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure mtDadosNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    procedure CriarDatasets; override;

    procedure ObterItem(ACodItem: Integer); overload;
    procedure ObterItem(ANumCodBarr: string); overload;
    procedure ObterItens(ACodItem: Integer;
      ANome, ACodBarras: TLhsBracketFilter );
  end;


implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TControllerItens }

procedure TControllerItens.CriarDatasets;
begin
  inherited;

end;

procedure TControllerItens.DataModuleCreate(Sender: TObject);
begin
  inherited;
  mtDados.CreateDataSet;
end;

procedure TControllerItens.mtDadosBeforePost(DataSet: TDataSet);
var LResponse: IResponse;
begin
  inherited;
  if DataSet.ControlsDisabled
  then Exit;

  var LBody := DataSet.ToJSONObject();
  var LRequest := PreparaRequest;

  if (DataSet.State = dsEdit)
  //and (DataSet.FieldByName('cod_item').AsString <> '')
  then begin
    LResponse := LRequest
      .Resource('/itens/{cod_item}')
      .AddUrlSegment('cod_item', DataSet.FieldByName('cod_item').AsString)
      .AddBody(LBody)
      .PUT();
  end
  else begin
    LResponse := LRequest
      .Resource('/itens')
      .AddBody(LBody)
      .POST();
  end;
  try
    DataSet.DisableControls;
    if not(LResponse.StatusCode in [200,201])
    then RaiseException(LResponse, 'Erro ao atualizar o cadastro do item');

    DataSet.MergeFromJSONObject(LResponse.Content);
  finally
    DataSet.EnableControls;
  end;
end;

procedure TControllerItens.mtDadosNewRecord(DataSet: TDataSet);
begin
  inherited;
  if mtDados.ControlsDisabled
  then Exit;

  mtDadosFLG_TAB_PRECO.AsBoolean := True;
  mtDadosFLG_PERM_SALD_NEG.AsBoolean := False;
end;

procedure TControllerItens.ObterItem(ACodItem: Integer);
begin
  var LResponse := PreparaRequest
    .Resource('/itens/{cod_item}')
    .AddUrlSegment('cod_item', ACodItem.ToString)
    .Get();

  if not(LResponse.StatusCode in [200,204])
  then RaiseException(LResponse, 'Falha ao obter dados do item');

  if LResponse.StatusCode = 200
  then Serializar(LResponse);
end;

procedure TControllerItens.ObterItem(ANumCodBarr: string);
begin
  var LResponse := PreparaRequest
    .Resource('/itens/codigo-barras/{num_cod_barr}')
    .AddUrlSegment('num_cod_barr', ANumCodBarr)
    .Get();

  if not(LResponse.StatusCode in [200,204])
  then RaiseException(LResponse, 'Falha ao obter dados do item');

  if LResponse.StatusCode = 200
  then Serializar(LResponse);
end;

procedure TControllerItens.ObterItens(ACodItem: Integer;
  ANome, ACodBarras: TLhsBracketFilter );
begin
  try
    if mtDados.Active
    then mtDados.Close;

    var LRequest := PreparaRequest;

    if ACodItem > 0
    then
    begin
      LRequest
        .Resource('/itens/{cod_item}')
        .AddUrlSegment('cod_item', ACodItem.ToString);
    end
    else
    begin
      LRequest.Resource('/itens');

      if ANome.Valor <> ''
      then LRequest.AddParam(Format('%s%s',['nom_item', ANome.Tipo.ToString]), ANome.Valor);

      if ACodBarras.Valor <> ''
      then LRequest.AddParam(Format('%s%s',['num_cod_barr', ACodBarras.Tipo.ToString]), ACodBarras.Valor);
    end;

    ANome := Default(TLhsBracketFilter);
    ACodBarras := Default(TLhsBracketFilter);

    var LResponse := LRequest.Get();

    if not(LResponse.StatusCode in [200,204])
    then RaiseException(LResponse, 'Falha ao obter lista de itens');

    if LResponse.StatusCode = 200
    then Serializar(LResponse);
  finally
    if not mtDados.Active
    then mtDados.CreateDataSet;
  end;
end;

end.
