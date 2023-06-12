inherited ViewModeloModal: TViewModeloModal
  BorderStyle = bsDialog
  Caption = 'Modelo Modal'
  ClientHeight = 494
  ClientWidth = 923
  Position = poMainFormCenter
  ExplicitWidth = 939
  ExplicitHeight = 533
  TextHeight = 21
  object pModeloClient: TPanel
    Left = 0
    Top = 0
    Width = 923
    Height = 438
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pModeloClient'
    ShowCaption = False
    TabOrder = 0
  end
  object pModeloBotoes: TCategoryButtons
    Left = 0
    Top = 438
    Width = 923
    Height = 56
    Align = alBottom
    ButtonFlow = cbfVertical
    Categories = <>
    RegularButtonColor = clWhite
    SelectedButtonColor = 15132390
    TabOrder = 1
    object btnModeloOk: TButton
      AlignWithMargins = True
      Left = 717
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
      ExplicitLeft = 713
    end
    object btnModeloCancelar: TButton
      AlignWithMargins = True
      Left = 820
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
      ExplicitLeft = 816
    end
  end
end
