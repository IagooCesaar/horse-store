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
    Caption = 'Iniciar'
    TabOrder = 1
    OnClick = btnIniciarClick
  end
  object btnParar: TButton
    Left = 239
    Top = 35
    Width = 98
    Height = 29
    Cursor = crHandPoint
    Caption = 'Parar'
    TabOrder = 2
    OnClick = btnPararClick
  end
end
