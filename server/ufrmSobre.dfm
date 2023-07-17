object frmSobre: TfrmSobre
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Sobre'
  ClientHeight = 269
  ClientWidth = 444
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 21
  object lbTitulo: TLabel
    Left = 0
    Top = 0
    Width = 444
    Height = 30
    Align = alTop
    Alignment = taCenter
    Caption = 'HORSE STORE API'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    ExplicitWidth = 180
  end
  object Label1: TLabel
    AlignWithMargins = True
    Left = 10
    Top = 40
    Width = 424
    Height = 50
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    AutoSize = False
    Caption = 
      'API Rest desenvolvida com Delphi 11 Community Edition + Framewor' +
      'k Horse'
    WordWrap = True
    ExplicitLeft = 24
    ExplicitTop = 55
    ExplicitWidth = 401
  end
  object Label2: TLabel
    Left = 24
    Top = 128
    Width = 42
    Height = 21
    Caption = 'Autor:'
  end
  object Label3: TLabel
    Left = 24
    Top = 155
    Width = 47
    Height = 21
    Caption = 'E-mail:'
  end
  object Label4: TLabel
    Left = 24
    Top = 182
    Width = 60
    Height = 21
    Caption = 'Telefone:'
  end
  object Label5: TLabel
    Left = 120
    Top = 128
    Width = 157
    Height = 21
    Caption = 'Iago C'#233'sar F. Nogueira'
  end
  object Label7: TLabel
    Left = 120
    Top = 182
    Width = 119
    Height = 21
    Caption = '(35) 99815-5841'
  end
  object Label8: TLabel
    Left = 24
    Top = 240
    Width = 83
    Height = 21
    Caption = 'Reposit'#243'rio:'
  end
  object lbEmail: TLabel
    Left = 120
    Top = 155
    Width = 218
    Height = 21
    Cursor = crHandPoint
    Hint = 'Acessar'
    Caption = 'iagocesar.nogueira@gmail.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsUnderline]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = lbEmailClick
  end
  object lbRepositorio: TLabel
    Left = 120
    Top = 240
    Width = 306
    Height = 21
    Cursor = crHandPoint
    Hint = 'Acessar'
    Caption = 'https://github.com/IagooCesaar/horse-store'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsUnderline]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = lbRepositorioClick
  end
end
