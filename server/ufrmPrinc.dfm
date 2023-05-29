object frmPrinc: TfrmPrinc
  Left = 0
  Top = 0
  Caption = 'LOJA API SERVER'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 21
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
    Top = 104
    Width = 361
    Height = 105
    Caption = 'grpAutenticacao'
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
      TabOrder = 1
      Text = 'admin'
    end
    object btnDefinirSenha: TButton
      Left = 223
      Top = 63
      Width = 122
      Height = 26
      Action = acDefinirSenha
      TabOrder = 2
    end
  end
  object aclPrinc: TActionList
    Left = 576
    Top = 24
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
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 576
    Top = 88
  end
end
