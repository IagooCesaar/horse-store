inherited ViewModeloMdi: TViewModeloMdi
  Caption = 'ViewModeloMdi'
  ClientHeight = 588
  ClientWidth = 796
  FormStyle = fsMDIChild
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  ExplicitWidth = 812
  ExplicitHeight = 627
  TextHeight = 21
  object pModeloClient: TPanel
    Left = 0
    Top = 57
    Width = 796
    Height = 531
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pModeloClient'
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 360
    ExplicitTop = 312
    ExplicitWidth = 185
    ExplicitHeight = 41
  end
  object pModeloTop: TPanel
    Left = 0
    Top = 0
    Width = 796
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pModeloTop'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 894
    object bvlModeloLinha: TBevel
      Left = 0
      Top = 47
      Width = 894
      Height = 10
      Align = alBottom
      Shape = bsBottomLine
      ExplicitTop = 33
    end
    object lbModeloTitulo: TLabel
      AlignWithMargins = True
      Left = 20
      Top = 10
      Width = 184
      Height = 30
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
    end
  end
end
