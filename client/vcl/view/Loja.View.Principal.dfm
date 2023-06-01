object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Loja'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  TextHeight = 21
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 90
    Height = 441
    Align = alLeft
    AutoSize = True
    ButtonHeight = 90
    ButtonWidth = 90
    Caption = 'ToolBar1'
    List = True
    AllowTextButtons = True
    TabOrder = 0
    object btnVender: TToolButton
      Left = 0
      Top = 0
      Action = acVender
    end
  end
  object aclPrinc: TActionList
    Left = 368
    Top = 328
    object acVender: TAction
      Caption = 'Vender'
      OnExecute = acVenderExecute
    end
  end
end
