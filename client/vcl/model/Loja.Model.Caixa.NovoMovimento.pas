unit Loja.Model.Caixa.NovoMovimento;

interface

uses
  System.Classes;

type
  TLojaModelCaixaNovoMovimento = class
  private
    FVrMov: Currency;
    FDscObs: String;
  public
    property VrMov: Currency read FVrMov write FVrMov;
    property DscObs: String read FDscObs write FDscObs;
  end;

implementation

end.
