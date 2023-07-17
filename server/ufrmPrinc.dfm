object frmPrinc: TfrmPrinc
  Left = 0
  Top = 0
  Caption = 'LOJA API SERVER'
  ClientHeight = 597
  ClientWidth = 610
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 21
  object pcPrinc: TPageControl
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 594
    Height = 581
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    ActivePage = tsAPI
    Align = alClient
    TabOrder = 0
    object tsAPI: TTabSheet
      Caption = ':: Configura'#231#245'es da API  '
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 36
        Height = 21
        Caption = 'Porta'
      end
      object edtPorta: TEdit
        Left = 8
        Top = 35
        Width = 121
        Height = 29
        NumbersOnly = True
        TabOrder = 0
        Text = '9000'
      end
      object btnIniciar: TButton
        Left = 135
        Top = 35
        Width = 98
        Height = 29
        Cursor = crHandPoint
        Action = acIniciarAPI
        TabOrder = 1
      end
      object btnParar: TButton
        Left = 239
        Top = 35
        Width = 98
        Height = 29
        Cursor = crHandPoint
        Action = acPararAPI
        TabOrder = 2
      end
      object grpAutenticacao: TGroupBox
        Left = 8
        Top = 70
        Width = 361
        Height = 105
        Caption = 'Autentica'#231#227'o API'
        TabOrder = 3
        object Label2: TLabel
          Left = 8
          Top = 28
          Width = 54
          Height = 21
          Caption = 'Usu'#225'rio'
          Layout = tlCenter
        end
        object Label3: TLabel
          Left = 8
          Top = 63
          Width = 43
          Height = 21
          Caption = 'Senha'
          Layout = tlCenter
        end
        object edtUsuario: TEdit
          Left = 96
          Top = 28
          Width = 121
          Height = 29
          TabOrder = 0
          Text = 'admin'
        end
        object edtSenha: TEdit
          Left = 96
          Top = 63
          Width = 121
          Height = 29
          PasswordChar = '*'
          TabOrder = 1
          Text = 'admin'
        end
        object btnDefinirSenha: TButton
          Left = 223
          Top = 63
          Width = 122
          Height = 26
          Cursor = crHandPoint
          Action = acDefinirSenha
          TabOrder = 2
        end
      end
      object btnSwagger: TButton
        Left = 343
        Top = 35
        Width = 106
        Height = 29
        Cursor = crHandPoint
        Action = acSwagger
        TabOrder = 4
      end
    end
    object tsBancoDados: TTabSheet
      Caption = ':: Acesso ao Banco de Dados  '
      ImageIndex = 1
      object grpDBParams: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 580
        Height = 182
        Align = alTop
        Caption = 'Banco de Dados'
        TabOrder = 0
        ExplicitWidth = 576
        DesignSize = (
          580
          182)
        object Label4: TLabel
          Left = 16
          Top = 71
          Width = 111
          Height = 21
          Caption = 'Banco de Dados'
          Layout = tlCenter
        end
        object Label5: TLabel
          Left = 16
          Top = 36
          Width = 59
          Height = 21
          Caption = 'Servidor'
          Layout = tlCenter
        end
        object Label6: TLabel
          Left = 16
          Top = 106
          Width = 54
          Height = 21
          Caption = 'Usu'#225'rio'
          Layout = tlCenter
        end
        object Label7: TLabel
          Left = 16
          Top = 141
          Width = 43
          Height = 21
          Caption = 'Senha'
          Layout = tlCenter
        end
        object edtDBParamServidor: TEdit
          Left = 155
          Top = 36
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          ExplicitWidth = 413
        end
        object edtDBParamBanco: TEdit
          Left = 155
          Top = 71
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          ExplicitWidth = 413
        end
        object edtDBParamUsuario: TEdit
          Left = 155
          Top = 106
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          ExplicitWidth = 413
        end
        object edtDBParamSenha: TEdit
          Left = 155
          Top = 141
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          PasswordChar = '*'
          TabOrder = 3
          ExplicitWidth = 413
        end
      end
      object grpDBDriverParams: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 191
        Width = 580
        Height = 82
        Align = alTop
        Caption = 'Driver de Acesso'
        TabOrder = 1
        ExplicitWidth = 576
        DesignSize = (
          580
          82)
        object Label9: TLabel
          Left = 16
          Top = 36
          Width = 43
          Height = 21
          Caption = 'Driver'
          Layout = tlCenter
        end
        object edtDBDriverPath: TEdit
          Left = 155
          Top = 36
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          ExplicitWidth = 413
        end
      end
      object grpDBPoolParams: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 279
        Width = 580
        Height = 154
        Align = alTop
        Caption = 'Pool de Conex'#245'es'
        TabOrder = 2
        ExplicitWidth = 576
        DesignSize = (
          580
          154)
        object Label8: TLabel
          Left = 16
          Top = 71
          Width = 124
          Height = 21
          Caption = 'Clean Up Timeout'
          Layout = tlCenter
        end
        object Label10: TLabel
          Left = 16
          Top = 36
          Width = 107
          Height = 21
          Caption = 'Maximum Itens'
          Layout = tlCenter
        end
        object Label11: TLabel
          Left = 16
          Top = 106
          Width = 103
          Height = 21
          Caption = 'Expire Timeout'
          Layout = tlCenter
        end
        object edtDBPoolMaxItems: TEdit
          Left = 155
          Top = 36
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          NumbersOnly = True
          TabOrder = 0
          ExplicitWidth = 413
        end
        object edtedtDBPoolCleanup: TEdit
          Left = 155
          Top = 71
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          NumbersOnly = True
          TabOrder = 1
          ExplicitWidth = 413
        end
        object edtDBPoolExpire: TEdit
          Left = 155
          Top = 106
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          NumbersOnly = True
          TabOrder = 2
          ExplicitWidth = 413
        end
      end
      object btnAplicarDBConfig: TButton
        Left = 3
        Top = 439
        Width = 102
        Height = 42
        Action = acAplicarDBConfig
        TabOrder = 3
      end
    end
    object tsOutros: TTabSheet
      Caption = ':: Outras Configura'#231#245'es  '
      ImageIndex = 2
      object GroupBox1: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 580
        Height = 105
        Align = alTop
        Caption = 'Defini'#231#245'es gerais'
        TabOrder = 0
        ExplicitTop = 0
        object chbAutoIniciar: TCheckBox
          Left = 16
          Top = 32
          Width = 121
          Height = 17
          Cursor = crHandPoint
          Caption = 'Auto Iniciar'
          TabOrder = 0
          OnClick = chbAutoIniciarClick
        end
      end
    end
  end
  object aclPrinc: TActionList
    Left = 352
    Top = 536
    object acIniciarAPI: TAction
      Category = 'API'
      Caption = 'Iniciar'
      OnExecute = acIniciarAPIExecute
    end
    object acPararAPI: TAction
      Category = 'API'
      Caption = 'Parar'
      OnExecute = acPararAPIExecute
    end
    object acDefinirSenha: TAction
      Category = 'API'
      Caption = 'Definir Senha'
      OnExecute = acDefinirSenhaExecute
    end
    object acSwagger: TAction
      Category = 'API'
      Caption = 'Swagger'
      OnExecute = acSwaggerExecute
    end
    object acAplicarDBConfig: TAction
      Category = 'Database'
      Caption = 'Aplicar'
      OnExecute = acAplicarDBConfigExecute
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    OnMinimize = ApplicationEvents1Minimize
    Left = 448
    Top = 536
  end
  object trayPrinc: TTrayIcon
    Hint = 'LOJA API SERVER'
    OnDblClick = trayPrincDblClick
    Left = 552
    Top = 536
  end
end
