inherited ViewModeloModal: TViewModeloModal
  BorderStyle = bsDialog
  Caption = 'Modelo Modal'
  ClientHeight = 495
  ClientWidth = 927
  Position = poMainFormCenter
  ExplicitWidth = 943
  ExplicitHeight = 534
  TextHeight = 21
  object pModeloClient: TPanel
    Left = 0
    Top = 0
    Width = 927
    Height = 439
    Align = alClient
    BevelOuter = bvSpace
    Caption = 'pModeloClient'
    ShowCaption = False
    TabOrder = 0
  end
  object pModeloBotoes: TPanel
    Left = 0
    Top = 439
    Width = 927
    Height = 56
    Cursor = crHandPoint
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
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
