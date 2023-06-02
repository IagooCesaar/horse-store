inherited ViewModeloModal: TViewModeloModal
  BorderStyle = bsDialog
  Caption = 'Modelo Modal'
  ClientHeight = 496
  ClientWidth = 931
  Position = poMainFormCenter
  ExplicitWidth = 943
  ExplicitHeight = 534
  TextHeight = 15
  object pModeloClient: TPanel
    Left = 0
    Top = 0
    Width = 931
    Height = 440
    Align = alClient
    Caption = 'pModeloClient'
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 927
    ExplicitHeight = 439
  end
  object pModeloBotoes: TPanel
    Left = 0
    Top = 440
    Width = 931
    Height = 56
    Cursor = crHandPoint
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    ExplicitTop = 439
    ExplicitWidth = 927
    object btnModeloOk: TButton
      AlignWithMargins = True
      Left = 724
      Top = 9
      Width = 95
      Height = 38
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      TabOrder = 0
      ExplicitLeft = 720
    end
    object btnModeloCancelar: TButton
      AlignWithMargins = True
      Left = 827
      Top = 9
      Width = 95
      Height = 38
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 823
    end
  end
end
