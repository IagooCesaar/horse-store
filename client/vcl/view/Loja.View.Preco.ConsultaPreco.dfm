inherited ViewConsultaPrecoVenda: TViewConsultaPrecoVenda
  Caption = 'Consulta de Pre'#231'o'
  ClientHeight = 494
  ClientWidth = 923
  ExplicitWidth = 939
  ExplicitHeight = 533
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 923
    Height = 438
    ExplicitWidth = 923
    ExplicitHeight = 438
  end
  inherited pModeloBotoes: TCategoryButtons
    Top = 438
    Width = 923
    ExplicitTop = 438
    ExplicitWidth = 923
    inherited btnModeloOk: TButton
      Visible = False
      ExplicitLeft = 713
    end
    inherited btnModeloCancelar: TButton
      Caption = 'Voltar'
      ExplicitLeft = 816
    end
  end
end
