inherited ViewItens: TViewItens
  Caption = 'Cadastro de Itens'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 21
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 50
    Height = 21
    Caption = 'C'#243'digo'
  end
  object Label2: TLabel
    Left = 135
    Top = 8
    Width = 67
    Height = 21
    Caption = 'Descri'#231#227'o'
  end
  object Label3: TLabel
    Left = 8
    Top = 70
    Width = 119
    Height = 21
    Caption = 'C'#243'digo de barras'
  end
  object dbCOD_ITEM: TDBEdit
    Left = 8
    Top = 35
    Width = 121
    Height = 29
    DataField = 'COD_ITEM'
    DataSource = dsItens
    TabOrder = 0
  end
  object dbNOM_ITEM: TDBEdit
    Left = 135
    Top = 35
    Width = 378
    Height = 29
    DataField = 'NOM_ITEM'
    DataSource = dsItens
    TabOrder = 1
  end
  object dbNUM_COD_BARR: TDBEdit
    Left = 8
    Top = 97
    Width = 378
    Height = 29
    DataField = 'NUM_COD_BARR'
    DataSource = dsItens
    TabOrder = 2
  end
  object Button1: TButton
    Left = 648
    Top = 97
    Width = 121
    Height = 49
    Caption = 'Button1'
    TabOrder = 3
    OnClick = Button1Click
  end
  object dbgrdItens: TDBGrid
    Left = 8
    Top = 152
    Width = 865
    Height = 460
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = dsItens
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object dsItens: TDataSource
    Left = 32
    Top = 544
  end
end
