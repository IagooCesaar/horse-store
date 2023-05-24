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
  object aclPrinc: TActionList
    Left = 24
    Top = 88
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
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 304
    Top = 224
  end
end
