object ViewPrincipal: TViewPrincipal
  Left = 0
  Top = 0
  Caption = 'Loja'
  ClientHeight = 572
  ClientWidth = 876
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnCreate = FormCreate
  TextHeight = 21
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 129
    Height = 553
    Align = alLeft
    BorderWidth = 2
    ButtonHeight = 54
    ButtonWidth = 121
    Caption = 'ToolBar1'
    DrawingStyle = dsGradient
    Flat = False
    Images = dmImagens.imgIco48
    List = True
    ShowCaptions = True
    TabOrder = 0
    ExplicitHeight = 438
    object btnVender: TToolButton
      Left = 0
      Top = 0
      Action = acVender
      Wrap = True
    end
    object btnItens: TToolButton
      Left = 0
      Top = 54
      Action = acItens
      Wrap = True
    end
    object btnComprar: TToolButton
      Left = 0
      Top = 108
      Action = acComprar
      Wrap = True
    end
    object btnLogon: TToolButton
      Left = 0
      Top = 162
      Action = acLogon
    end
  end
  object sbar1: TStatusBar
    Left = 0
    Top = 553
    Width = 876
    Height = 19
    Panels = <>
    ExplicitLeft = 312
    ExplicitTop = 240
    ExplicitWidth = 0
  end
  object acmAcoes: TActionManager
    ActionBars = <
      item
        Items.CaptionOptions = coAll
        Items = <
          item
            Action = acVender
            ImageIndex = 1
          end>
      end
      item
      end>
    Images = dmImagens.imgIco48
    Left = 520
    Top = 360
    StyleName = 'Platform Default'
    object acVender: TAction
      Category = 'ToolBar'
      Caption = 'Vender'
      ImageIndex = 1
      OnExecute = acVenderExecute
    end
    object acSair: TAction
      Category = 'Menu'
      Caption = 'Sair'
      OnExecute = acSairExecute
    end
    object acItens: TAction
      Category = 'ToolBar'
      Caption = 'Itens'
      OnExecute = acItensExecute
    end
    object acComprar: TAction
      Category = 'ToolBar'
      Caption = 'Comprar'
      OnExecute = acComprarExecute
    end
    object acConfiguracoes: TAction
      Category = 'Menu'
      Caption = 'Configura'#231#245'es'
      OnExecute = acConfiguracoesExecute
    end
    object acLogon: TAction
      Category = 'ToolBar'
      Caption = 'Bloquear'
      ImageIndex = 3
      OnExecute = acLogonExecute
    end
  end
  object MainMenu1: TMainMenu
    Images = dmImagens.imgIco16
    Left = 408
    Top = 360
    object mniSair: TMenuItem
      Action = acSair
    end
    object mniConfiguracoes: TMenuItem
      Action = acConfiguracoes
    end
  end
end
