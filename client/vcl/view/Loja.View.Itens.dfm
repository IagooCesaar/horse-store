inherited ViewItens: TViewItens
  Caption = 'Cadastro de Itens'
  ClientHeight = 789
  ClientWidth = 1210
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 1222
  ExplicitHeight = 827
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 1210
    Height = 732
    ExplicitLeft = 0
    ExplicitTop = 57
    ExplicitWidth = 1206
    ExplicitHeight = 731
    object grpPesquisa: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 1204
      Height = 174
      Align = alTop
      Caption = ':: Pesquisar  '
      TabOrder = 0
      ExplicitWidth = 1200
      object Label4: TLabel
        Left = 17
        Top = 32
        Width = 50
        Height = 21
        Caption = 'C'#243'digo'
      end
      object edtFiltroCodigo: TEdit
        Left = 17
        Top = 59
        Width = 121
        Height = 29
        NumbersOnly = True
        TabOrder = 0
      end
      object pFiltroDescricao: TPanel
        Left = 144
        Top = 32
        Width = 487
        Height = 56
        BevelOuter = bvNone
        Caption = 'pFiltroDescricao'
        ShowCaption = False
        TabOrder = 1
        DesignSize = (
          487
          56)
        object Label5: TLabel
          Left = 0
          Top = 0
          Width = 67
          Height = 21
          Caption = 'Descri'#231#227'o'
        end
        object rbtFiltroDescricaoContenha: TRadioButton
          Left = 104
          Top = 0
          Width = 100
          Height = 25
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = 'Contenha'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object rbtFiltroDescricaoInicie: TRadioButton
          Left = 204
          Top = 0
          Width = 100
          Height = 25
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = 'Inicie com'
          TabOrder = 1
        end
        object rbtFiltroDescricaoFinalize: TRadioButton
          Left = 304
          Top = 0
          Width = 74
          Height = 25
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = 'Finalize'
          TabOrder = 2
        end
        object edtFiltroDescricao: TEdit
          Left = 0
          Top = 27
          Width = 487
          Height = 29
          Align = alBottom
          TabOrder = 3
        end
        object rbtFiltroDescricaoNaoFiltrar: TRadioButton
          Left = 384
          Top = 0
          Width = 106
          Height = 25
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = 'N'#227'o filtrar'
          TabOrder = 4
        end
      end
      object btnPesquisar: TButton
        Left = 659
        Top = 124
        Width = 121
        Height = 36
        Cursor = crHandPoint
        Caption = 'Pesquisar'
        TabOrder = 2
        OnClick = btnPesquisarClick
      end
      object Panel1: TPanel
        Left = 17
        Top = 104
        Width = 614
        Height = 56
        BevelOuter = bvNone
        Caption = 'pFiltroDescricao'
        ShowCaption = False
        TabOrder = 3
        DesignSize = (
          614
          56)
        object Label6: TLabel
          Left = 0
          Top = 0
          Width = 119
          Height = 21
          Caption = 'C'#243'digo de barras'
        end
        object rbtFiltroCodBarrasContenha: TRadioButton
          Left = 231
          Top = 0
          Width = 100
          Height = 25
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = 'Contenha'
          TabOrder = 0
        end
        object rbtFiltroCodBarrasInicie: TRadioButton
          Left = 331
          Top = 0
          Width = 100
          Height = 25
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = 'Inicie com'
          TabOrder = 1
        end
        object rbtFiltroCodBarrasFinalize: TRadioButton
          Left = 431
          Top = 0
          Width = 74
          Height = 25
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = 'Finalize'
          TabOrder = 2
        end
        object edtFiltroCodBarras: TEdit
          Left = 0
          Top = 27
          Width = 614
          Height = 29
          Align = alBottom
          TabOrder = 3
        end
        object rbtFiltroCodBarrasNaoFiltrar: TRadioButton
          Left = 511
          Top = 0
          Width = 106
          Height = 25
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = 'N'#227'o filtrar'
          Checked = True
          TabOrder = 4
          TabStop = True
        end
      end
    end
    object pGrid: TPanel
      Left = 0
      Top = 180
      Width = 602
      Height = 552
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pGrid'
      ShowCaption = False
      TabOrder = 1
      ExplicitWidth = 598
      ExplicitHeight = 551
      object dbgrdItens: TDBGrid
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 582
        Height = 532
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        DataSource = dsItens
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -16
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object pManut: TPanel
      AlignWithMargins = True
      Left = 602
      Top = 190
      Width = 598
      Height = 532
      Margins.Left = 0
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alRight
      Caption = 'pManut'
      ShowCaption = False
      TabOrder = 2
      ExplicitLeft = 598
      ExplicitHeight = 531
      object Label1: TLabel
        Left = 17
        Top = 55
        Width = 50
        Height = 21
        Caption = 'C'#243'digo'
      end
      object Label2: TLabel
        Left = 144
        Top = 55
        Width = 67
        Height = 21
        Caption = 'Descri'#231#227'o'
      end
      object Label3: TLabel
        Left = 17
        Top = 117
        Width = 119
        Height = 21
        Caption = 'C'#243'digo de barras'
      end
      object dbCOD_ITEM: TDBEdit
        Left = 17
        Top = 82
        Width = 121
        Height = 29
        DataField = 'COD_ITEM'
        DataSource = dsItens
        ReadOnly = True
        TabOrder = 0
      end
      object dbNOM_ITEM: TDBEdit
        Left = 144
        Top = 82
        Width = 378
        Height = 29
        DataField = 'NOM_ITEM'
        DataSource = dsItens
        TabOrder = 1
      end
      object dbNUM_COD_BARR: TDBEdit
        Left = 17
        Top = 144
        Width = 378
        Height = 29
        DataField = 'NUM_COD_BARR'
        DataSource = dsItens
        TabOrder = 2
      end
      object dbnItens: TDBNavigator
        Left = 1
        Top = 1
        Width = 596
        Height = 48
        Cursor = crHandPoint
        DataSource = dsItens
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbEdit, nbPost, nbCancel]
        Align = alTop
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object btnEstoque: TButton
        Left = 17
        Top = 231
        Width = 121
        Height = 36
        Cursor = crHandPoint
        Caption = 'Estoque'
        TabOrder = 6
        OnClick = btnEstoqueClick
      end
      object btnPrecoVenda: TButton
        Left = 144
        Top = 231
        Width = 121
        Height = 36
        Cursor = crHandPoint
        Caption = 'Pre'#231'o Venda'
        TabOrder = 7
        OnClick = btnPrecoVendaClick
      end
      object chbFLG_PERM_SALD_NEG: TDBCheckBox
        Left = 17
        Top = 179
        Width = 192
        Height = 30
        Cursor = crHandPoint
        Caption = 'Permitir saldo negativo'
        DataField = 'FLG_PERM_SALD_NEG'
        DataSource = dsItens
        TabOrder = 3
      end
      object chbFLG_TAB_PRECO: TDBCheckBox
        Left = 215
        Top = 179
        Width = 192
        Height = 30
        Cursor = crHandPoint
        Caption = 'Utiliza tabela de pre'#231'o'
        DataField = 'FLG_TAB_PRECO'
        DataSource = dsItens
        TabOrder = 4
      end
    end
  end
  inherited pModeloTop: TPanel
    Width = 1210
    ExplicitWidth = 1206
    inherited bvlModeloLinha: TBevel
      Width = 1210
      ExplicitWidth = 1222
    end
    inherited lbModeloTitulo: TLabel
      Width = 1170
      Height = 37
      Caption = 'Cadastro de Itens'
      ExplicitWidth = 162
    end
  end
  object dsItens: TDataSource
    OnStateChange = dsItensStateChange
    Left = 40
    Top = 328
  end
end
