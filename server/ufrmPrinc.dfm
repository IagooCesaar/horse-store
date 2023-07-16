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
    Left = 0
    Top = 0
    Width = 610
    Height = 597
    ActivePage = tsBancoDados
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 867
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
          Left = 3
          Top = 31
          Width = 54
          Height = 21
          Caption = 'Usu'#225'rio'
        end
        object Label3: TLabel
          Left = 3
          Top = 58
          Width = 43
          Height = 21
          Caption = 'Senha'
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
    end
  end
  object aclPrinc: TActionList
    Left = 24
    Top = 368
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
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    OnMinimize = ApplicationEvents1Minimize
    Left = 120
    Top = 368
  end
  object trayPrinc: TTrayIcon
    Hint = 'LOJA API SERVER'
    OnDblClick = trayPrincDblClick
    Left = 224
    Top = 368
  end
end
