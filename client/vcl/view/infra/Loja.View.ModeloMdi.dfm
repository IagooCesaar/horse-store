inherited ViewModeloMdi: TViewModeloMdi
  Caption = 'ViewModeloMdi'
  ClientHeight = 676
  ClientWidth = 1158
  FormStyle = fsMDIChild
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  ExplicitWidth = 1174
  ExplicitHeight = 715
  TextHeight = 21
  object pModeloClient: TPanel
    Left = 0
    Top = 57
    Width = 1158
    Height = 619
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pModeloClient'
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 794
    ExplicitHeight = 528
  end
  object pModeloTop: TPanel
    Left = 0
    Top = 0
    Width = 1158
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pModeloTop'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 794
    object bvlModeloLinha: TBevel
      Left = 0
      Top = 47
      Width = 1160
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
