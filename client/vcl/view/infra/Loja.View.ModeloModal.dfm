inherited ViewModeloModal: TViewModeloModal
  BorderStyle = bsDialog
  Caption = 'Modelo Modal'
  ClientHeight = 492
  ClientWidth = 915
  Position = poMainFormCenter
  ExplicitWidth = 931
  ExplicitHeight = 531
  TextHeight = 21
  object pModeloClient: TPanel
    Left = 0
    Top = 0
    Width = 915
    Height = 436
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pModeloClient'
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 919
    ExplicitHeight = 437
  end
  object pModeloBotoes: TCategoryButtons
    Left = 0
    Top = 436
    Width = 915
    Height = 56
    Align = alBottom
    ButtonFlow = cbfVertical
    Categories = <>
    RegularButtonColor = clWhite
    SelectedButtonColor = 15132390
    TabOrder = 1
    TabStop = False
    ExplicitTop = 437
    ExplicitWidth = 919
    object btnModeloOk: TButton
      AlignWithMargins = True
      Left = 713
      Top = 8
      Width = 95
      Height = 36
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      TabOrder = 0
      ExplicitLeft = 709
    end
    object btnModeloCancelar: TButton
      AlignWithMargins = True
      Left = 816
      Top = 8
      Width = 95
      Height = 36
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 812
    end
  end
end
