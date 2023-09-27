inherited ViewModeloMdi: TViewModeloMdi
  Caption = 'ViewModeloMdi'
  ClientHeight = 659
  ClientWidth = 1225
  FormStyle = fsMDIChild
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  ExplicitWidth = 1239
  ExplicitHeight = 695
  TextHeight = 21
  object pModeloClient: TPanel
    Left = 0
    Top = 57
    Width = 1225
    Height = 602
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pModeloClient'
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 1156
    ExplicitHeight = 616
  end
  object pModeloTop: TPanel
    Left = 0
    Top = 0
    Width = 1225
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pModeloTop'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 1156
    object bvlModeloLinha: TBevel
      Left = 0
      Top = 47
      Width = 1225
      Height = 10
      Align = alBottom
      Shape = bsBottomLine
      ExplicitTop = 33
      ExplicitWidth = 894
    end
    object lbModeloTitulo: TLabel
      AlignWithMargins = True
      Left = 20
      Top = 10
      Width = 1185
      Height = 37
      Margins.Left = 20
      Margins.Top = 10
      Margins.Right = 20
      Margins.Bottom = 0
      Align = alClient
      Caption = 'T'#237'tulo do formul'#225'rio'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Pitch = fpVariable
      Font.Style = []
      Font.Quality = fqAntialiased
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 184
      ExplicitHeight = 30
    end
  end
end
