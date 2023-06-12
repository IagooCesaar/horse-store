inherited ViewEstoqueConsulta: TViewEstoqueConsulta
  Caption = 'Consulta de Estoque'
  ClientHeight = 580
  ClientWidth = 823
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 835
  ExplicitHeight = 618
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 823
    Height = 524
    ExplicitWidth = 819
    ExplicitHeight = 523
    object pItem: TPanel
      Left = 0
      Top = 0
      Width = 823
      Height = 145
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pItem'
      ShowCaption = False
      TabOrder = 0
      ExplicitWidth = 819
      DesignSize = (
        823
        145)
      object Label1: TLabel
        Left = 10
        Top = 15
        Width = 50
        Height = 21
        Caption = 'C'#243'digo'
      end
      object Label2: TLabel
        Left = 144
        Top = 15
        Width = 67
        Height = 21
        Caption = 'Descri'#231#227'o'
      end
      object Label3: TLabel
        Left = 10
        Top = 77
        Width = 119
        Height = 21
        Caption = 'C'#243'digo de barras'
      end
      object Label4: TLabel
        Left = 394
        Top = 77
        Width = 88
        Height = 21
        Caption = 'Saldo Atual'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbCOD_ITEM: TDBEdit
        Left = 10
        Top = 42
        Width = 121
        Height = 29
        DataField = 'COD_ITEM'
        DataSource = dsItem
        ReadOnly = True
        TabOrder = 0
      end
      object dbNOM_ITEM: TDBEdit
        Left = 137
        Top = 42
        Width = 378
        Height = 29
        DataField = 'NOM_ITEM'
        DataSource = dsItem
        ReadOnly = True
        TabOrder = 1
      end
      object dbNUM_COD_BARR: TDBEdit
        Left = 10
        Top = 104
        Width = 378
        Height = 29
        DataField = 'NUM_COD_BARR'
        DataSource = dsItem
        ReadOnly = True
        TabOrder = 2
      end
      object dbQTD_SALDO_ATU: TDBEdit
        Left = 394
        Top = 104
        Width = 191
        Height = 29
        DataField = 'QTD_SALDO_ATU'
        DataSource = dsSaldo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
      object btnPesquisar: TButton
        Left = 692
        Top = 84
        Width = 121
        Height = 49
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = 'Realizar Acerto'
        TabOrder = 4
        OnClick = btnPesquisarClick
        ExplicitLeft = 688
      end
    end
    object GroupBox1: TGroupBox
      AlignWithMargins = True
      Left = 10
      Top = 301
      Width = 803
      Height = 213
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      Caption = ':: '#218'ltimos Movimentos'
      DefaultHeaderFont = False
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -16
      HeaderFont.Name = 'Segoe UI'
      HeaderFont.Style = [fsBold]
      TabOrder = 1
      ExplicitWidth = 799
      ExplicitHeight = 212
      object dbgSaldo: TDBGrid
        AlignWithMargins = True
        Left = 10
        Top = 29
        Width = 783
        Height = 174
        Margins.Left = 8
        Margins.Top = 6
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        DataSource = dsMovimentos
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -16
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object GroupBox2: TGroupBox
      AlignWithMargins = True
      Left = 10
      Top = 155
      Width = 803
      Height = 126
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      Caption = ':: '#218'ltimo Fechamento de Saldo'
      DefaultHeaderFont = False
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -16
      HeaderFont.Name = 'Segoe UI'
      HeaderFont.Style = [fsBold]
      TabOrder = 2
      ExplicitWidth = 799
      object DBGrid1: TDBGrid
        AlignWithMargins = True
        Left = 10
        Top = 29
        Width = 783
        Height = 87
        Margins.Left = 8
        Margins.Top = 6
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        DataSource = dsFechamento
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -16
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
  end
  inherited pModeloBotoes: TCategoryButtons
    Top = 524
    Width = 823
    ExplicitTop = 523
    ExplicitWidth = 819
    inherited btnModeloOk: TButton
      Left = 613
      Visible = False
      ExplicitLeft = 609
    end
    inherited btnModeloCancelar: TButton
      Left = 716
      Caption = 'Voltar'
      ExplicitLeft = 712
    end
  end
  object dsItem: TDataSource
    AutoEdit = False
    Left = 24
    Top = 528
  end
  object dsSaldo: TDataSource
    AutoEdit = False
    Left = 80
    Top = 528
  end
  object dsMovimentos: TDataSource
    AutoEdit = False
    Left = 240
    Top = 528
  end
  object dsFechamento: TDataSource
    Left = 152
    Top = 528
  end
end
