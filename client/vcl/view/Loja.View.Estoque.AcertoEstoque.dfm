inherited ViewAcertoEstoque: TViewAcertoEstoque
  Caption = 'Realizar acerto de estoque'
  ClientHeight = 172
  ClientWidth = 554
  ExplicitWidth = 566
  ExplicitHeight = 210
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 554
    Height = 116
    ExplicitWidth = 550
    ExplicitHeight = 115
    object Label1: TLabel
      Left = 15
      Top = 34
      Width = 116
      Height = 21
      Caption = 'Saldo Real Atual:'
    end
    object Label2: TLabel
      Left = 15
      Top = 69
      Width = 49
      Height = 21
      Caption = 'Motivo'
    end
    object edtSaldoReal: TEdit
      Left = 137
      Top = 31
      Width = 400
      Height = 29
      NumbersOnly = True
      TabOrder = 0
      Text = '0'
    end
    object edtMotivo: TEdit
      Left = 137
      Top = 66
      Width = 400
      Height = 29
      MaxLength = 40
      TabOrder = 1
    end
  end
  inherited pModeloBotoes: TCategoryButtons
    Top = 116
    Width = 554
    ExplicitTop = 115
    ExplicitWidth = 550
    inherited btnModeloOk: TButton
      Left = 344
      Caption = 'Salvar'
      OnClick = btnModeloOkClick
      ExplicitLeft = 340
    end
    inherited btnModeloCancelar: TButton
      Left = 447
      ExplicitLeft = 443
    end
  end
end
