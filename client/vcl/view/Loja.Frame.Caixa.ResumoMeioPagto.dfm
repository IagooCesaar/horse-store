object FrameCaixaResumoMeioPagto: TFrameCaixaResumoMeioPagto
  Left = 0
  Top = 0
  Width = 279
  Height = 124
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  StyleElements = []
  object pCliente: TPanel
    Left = 0
    Top = 0
    Width = 279
    Height = 124
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'pCliente'
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object lbMeioPagto: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 255
      Height = 25
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      Caption = 'lbMeioPagto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
      ExplicitWidth = 115
    end
    object lbValor: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 55
      Width = 255
      Height = 25
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      Alignment = taRightJustify
      Caption = 'lbValor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
      ExplicitLeft = 201
      ExplicitWidth = 64
    end
  end
end
