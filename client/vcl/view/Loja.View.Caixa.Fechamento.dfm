inherited ViewCaixaFechamento: TViewCaixaFechamento
  Caption = 'Fechamento de Caixa'
  ClientHeight = 491
  ClientWidth = 911
  ExplicitWidth = 927
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 911
    Height = 435
    ExplicitWidth = 911
    ExplicitHeight = 435
  end
  inherited pModeloBotoes: TCategoryButtons
    Top = 435
    Width = 911
    ExplicitTop = 435
    ExplicitWidth = 911
    inherited btnModeloOk: TButton
      Left = 701
      Caption = 'OK'
      ExplicitLeft = 701
    end
    inherited btnModeloCancelar: TButton
      Left = 804
      ExplicitLeft = 804
    end
  end
end
