object frmPrinc: TfrmPrinc
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'LOJA API SERVER'
  ClientHeight = 597
  ClientWidth = 610
  Color = clBtnFace
  Constraints.MaxHeight = 655
  Constraints.MaxWidth = 622
  Constraints.MinHeight = 655
  Constraints.MinWidth = 622
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = menuPrinc
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
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
    ExplicitWidth = 590
    ExplicitHeight = 580
    object tsAPI: TTabSheet
      Caption = ':: Configura'#231#245'es da API  '
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 36
        Height = 21
        Caption = 'Porta'
      end
      object Label12: TLabel
        Left = 16
        Top = 192
        Width = 32
        Height = 21
        Caption = 'URL:'
      end
      object lbURL: TLabel
        Left = 104
        Top = 192
        Width = 29
        Height = 21
        Cursor = crHandPoint
        Hint = 'Copiar'
        Caption = 'URL'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlight
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsUnderline]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = lbURLClick
      end
      object edtPorta: TEdit
        Left = 8
        Top = 35
        Width = 121
        Height = 29
        NumbersOnly = True
        TabOrder = 0
        Text = '9000'
        OnChange = edtPortaChange
      end
      object btnIniciar: TButton
        Left = 135
        Top = 35
        Width = 125
        Height = 29
        Cursor = crHandPoint
        Action = acIniciarAPI
        Default = True
        TabOrder = 1
      end
      object btnParar: TButton
        Left = 266
        Top = 35
        Width = 125
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
      end
      object btnSwagger: TButton
        Left = 397
        Top = 35
        Width = 125
        Height = 29
        Cursor = crHandPoint
        Action = acSwagger
        TabOrder = 4
      end
    end
    object tsBancoDados: TTabSheet
      Caption = ':: Acesso ao Banco de Dados  '
      ImageIndex = 1
      DesignSize = (
        586
        545)
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
        object dbServer: TDBEdit
          Left = 155
          Top = 36
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          DataField = 'Server'
          DataSource = dsDBParams
          TabOrder = 0
          ExplicitWidth = 413
        end
        object dbDatabase: TDBEdit
          Left = 155
          Top = 71
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          DataField = 'Database'
          DataSource = dsDBParams
          TabOrder = 1
          ExplicitWidth = 413
        end
        object dbUsername: TDBEdit
          Left = 155
          Top = 106
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          DataField = 'Username'
          DataSource = dsDBParams
          TabOrder = 2
          ExplicitWidth = 413
        end
        object dbPassword: TDBEdit
          Left = 155
          Top = 141
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          DataField = 'Password'
          DataSource = dsDBParams
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
        object dbDriverVendorLib: TDBEdit
          Left = 155
          Top = 36
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          DataField = 'DriverVendorLib'
          DataSource = dsDBParams
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
        object dbPoolMaximumItems: TDBEdit
          Left = 155
          Top = 36
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          DataField = 'PoolMaximumItems'
          DataSource = dsDBParams
          TabOrder = 0
          ExplicitWidth = 413
        end
        object dbPoolCleanupTimeout: TDBEdit
          Left = 155
          Top = 71
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          DataField = 'PoolCleanupTimeout'
          DataSource = dsDBParams
          TabOrder = 1
          ExplicitWidth = 413
        end
        object dbPoolExpireTimeout: TDBEdit
          Left = 155
          Top = 106
          Width = 417
          Height = 29
          Anchors = [akLeft, akTop, akRight]
          DataField = 'PoolExpireTimeout'
          DataSource = dsDBParams
          TabOrder = 2
          ExplicitWidth = 413
        end
      end
      object btnAplicarDBConfig: TButton
        Left = 3
        Top = 439
        Width = 100
        Height = 42
        Cursor = crHandPoint
        Action = acAplicarDBConfig
        Default = True
        TabOrder = 3
      end
      object btnBackup: TButton
        Left = 487
        Top = 439
        Width = 100
        Height = 42
        Cursor = crHandPoint
        Action = acBackup
        Anchors = [akTop, akRight]
        TabOrder = 4
        ExplicitLeft = 483
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
        Height = 182
        Align = alTop
        Caption = 'Defini'#231#245'es gerais'
        TabOrder = 0
        object lbComputadorIP1: TLabel
          Left = 16
          Top = 65
          Width = 127
          Height = 21
          Caption = 'IP do Computador'
          Layout = tlCenter
        end
        object lbComputadorNome1: TLabel
          Left = 16
          Top = 100
          Width = 157
          Height = 21
          Caption = 'Nome do Computador'
          Layout = tlCenter
        end
        object lbComputadorIP: TLabel
          Left = 188
          Top = 65
          Width = 13
          Height = 21
          Caption = 'IP'
          Layout = tlCenter
        end
        object lbComputadorNome: TLabel
          Left = 188
          Top = 100
          Width = 43
          Height = 21
          Caption = 'Nome'
          Layout = tlCenter
        end
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
      Caption = 'Iniciar [F5]'
      ShortCut = 116
      OnExecute = acIniciarAPIExecute
    end
    object acPararAPI: TAction
      Category = 'API'
      Caption = 'Parar [F6]'
      ShortCut = 117
      OnExecute = acPararAPIExecute
    end
    object acSwagger: TAction
      Category = 'API'
      Caption = 'Swagger [F1]'
      ShortCut = 112
      OnExecute = acSwaggerExecute
    end
    object acAplicarDBConfig: TAction
      Category = 'Database'
      Caption = 'Aplicar'
      OnExecute = acAplicarDBConfigExecute
    end
    object acBackup: TAction
      Category = 'Database'
      Caption = 'Backup'
      OnExecute = acBackupExecute
    end
    object acSobre: TAction
      Caption = 'Sobre'
      OnExecute = acSobreExecute
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
  object mtDBParams: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 552
    Top = 480
    object mtDBParamsServer: TStringField
      FieldName = 'Server'
      Size = 60
    end
    object mtDBParamsDatabase: TStringField
      FieldName = 'Database'
      Size = 255
    end
    object mtDBParamsPassword: TStringField
      FieldName = 'Password'
      Size = 60
    end
    object mtDBParamsUsername: TStringField
      FieldName = 'Username'
      Size = 60
    end
    object mtDBParamsDriverVendorLib: TStringField
      FieldName = 'DriverVendorLib'
      Size = 255
    end
    object mtDBParamsPoolMaximumItems: TIntegerField
      FieldName = 'PoolMaximumItems'
    end
    object mtDBParamsPoolCleanupTimeout: TIntegerField
      FieldName = 'PoolCleanupTimeout'
    end
    object mtDBParamsPoolExpireTimeout: TIntegerField
      FieldName = 'PoolExpireTimeout'
    end
  end
  object dsDBParams: TDataSource
    DataSet = mtDBParams
    Left = 448
    Top = 480
  end
  object FDBackup: TFDIBBackup
    DriverLink = DriverFB1
    Left = 356
    Top = 480
  end
  object DriverFB1: TFDPhysFBDriverLink
    Left = 284
    Top = 480
  end
  object menuPrinc: TMainMenu
    Left = 280
    Top = 536
    object mniSobre: TMenuItem
      Action = acSobre
    end
  end
end
