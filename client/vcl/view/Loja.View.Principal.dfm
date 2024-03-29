object ViewPrincipal: TViewPrincipal
  Left = 0
  Top = 0
  Caption = 'Loja'
  ClientHeight = 567
  ClientWidth = 856
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = menuPrinc
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 21
  object tbAcoes: TToolBar
    Left = 0
    Top = 0
    Width = 129
    Height = 548
    Align = alLeft
    AutoSize = True
    BorderWidth = 2
    ButtonHeight = 54
    ButtonWidth = 121
    Caption = 'tbAcoes'
    DrawingStyle = dsGradient
    Images = dmImagens.imgIco48
    List = True
    ShowCaptions = True
    TabOrder = 0
    ExplicitHeight = 545
    object btnVender: TToolButton
      AlignWithMargins = True
      Left = 0
      Top = 0
      Cursor = crHandPoint
      Action = acVender
      Wrap = True
    end
    object btnCaixa: TToolButton
      AlignWithMargins = True
      Left = 0
      Top = 54
      Cursor = crHandPoint
      Action = acCaixa
      Wrap = True
    end
    object btnComprar: TToolButton
      AlignWithMargins = True
      Left = 0
      Top = 108
      Cursor = crHandPoint
      Action = acComprar
      Wrap = True
    end
    object btnItens: TToolButton
      AlignWithMargins = True
      Left = 0
      Top = 162
      Cursor = crHandPoint
      Action = acItens
      Wrap = True
    end
    object btnLogon: TToolButton
      AlignWithMargins = True
      Left = 0
      Top = 216
      Cursor = crHandPoint
      Action = acLogon
    end
  end
  object sbar1: TStatusBar
    Left = 0
    Top = 548
    Width = 856
    Height = 19
    Panels = <>
    ExplicitTop = 545
    ExplicitWidth = 854
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
    Left = 184
    Top = 80
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
      ImageIndex = 4
      OnExecute = acItensExecute
    end
    object acComprar: TAction
      Category = 'ToolBar'
      Caption = 'Comprar'
      ImageIndex = 5
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
    object acCaixa: TAction
      Category = 'ToolBar'
      Caption = 'Caixa'
      ImageIndex = 6
      OnExecute = acCaixaExecute
    end
    object acSobre: TAction
      Category = 'Menu'
      Caption = 'Sobre'
      OnExecute = acSobreExecute
    end
  end
  object menuPrinc: TMainMenu
    Images = dmImagens.imgIco16
    Left = 184
    Top = 8
    object mniSair: TMenuItem
      Action = acSair
    end
    object mniConfiguracoes: TMenuItem
      Action = acConfiguracoes
    end
    object mniSobre: TMenuItem
      Action = acSobre
    end
  end
end
