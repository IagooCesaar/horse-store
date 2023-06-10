object ViewLogon: TViewLogon
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Logon'
  ClientHeight = 236
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  TextHeight = 21
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 347
    Height = 216
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alClient
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Panel1'
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 343
    ExplicitHeight = 215
    object pLogin: TPanel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 323
      Height = 192
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      ShowCaption = False
      TabOrder = 0
      ExplicitWidth = 319
      ExplicitHeight = 191
      object Label2: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 307
        Height = 21
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Login'
        ExplicitWidth = 39
      end
      object lbl1: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 70
        Width = 307
        Height = 21
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Senha'
        ExplicitWidth = 43
      end
      object edtLogin: TEdit
        AlignWithMargins = True
        Left = 8
        Top = 33
        Width = 307
        Height = 29
        Margins.Left = 8
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        TabOrder = 0
        TextHint = 'Informe seu usu'#225'rio, c'#243'digo ou e-mail'
        ExplicitWidth = 303
      end
      object edtSenha: TEdit
        AlignWithMargins = True
        Left = 8
        Top = 95
        Width = 307
        Height = 29
        Margins.Left = 8
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Color = clWhite
        PasswordChar = '*'
        TabOrder = 1
        TextHint = 'Informe seu senha de acesso'
        ExplicitWidth = 303
      end
      object pBotoes: TPanel
        AlignWithMargins = True
        Left = 8
        Top = 132
        Width = 307
        Height = 28
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        BevelOuter = bvNone
        Caption = 'pBotoes'
        ParentColor = True
        ShowCaption = False
        TabOrder = 2
        ExplicitWidth = 303
        ExplicitHeight = 27
        object btnEntrar: TButton
          AlignWithMargins = True
          Left = 30
          Top = 0
          Width = 95
          Height = 28
          Cursor = crHandPoint
          Margins.Left = 30
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          Caption = '&Entrar'
          TabOrder = 0
          OnClick = btnEntrarClick
          ExplicitHeight = 27
        end
        object btnSair: TButton
          AlignWithMargins = True
          Left = 182
          Top = 0
          Width = 95
          Height = 28
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 30
          Margins.Bottom = 0
          Align = alRight
          Caption = '&Sair'
          TabOrder = 1
          OnClick = btnSairClick
          ExplicitLeft = 178
          ExplicitHeight = 27
        end
      end
      object pMetodoConexao: TPanel
        Left = 0
        Top = 168
        Width = 323
        Height = 24
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'pMetodoConexao'
        ParentColor = True
        ShowCaption = False
        TabOrder = 3
        ExplicitTop = 167
        ExplicitWidth = 319
        object sbConfig: TSpeedButton
          Left = 0
          Top = 0
          Width = 133
          Height = 24
          Cursor = crHandPoint
          Align = alLeft
          Caption = 'Configurar acesso'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          OnClick = sbConfigClick
        end
      end
    end
  end
end
