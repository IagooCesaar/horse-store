inherited ViewItens: TViewItens
  Caption = 'Cadastro de Itens'
  ClientHeight = 792
  ClientWidth = 1222
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 1238
  ExplicitHeight = 831
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 1222
    Height = 735
    ExplicitLeft = 0
    ExplicitTop = 57
    ExplicitWidth = 1222
    ExplicitHeight = 735
    object Label1: TLabel
      Left = 256
      Top = 344
      Width = 50
      Height = 21
      Caption = 'C'#243'digo'
    end
    object Label2: TLabel
      Left = 383
      Top = 344
      Width = 67
      Height = 21
      Caption = 'Descri'#231#227'o'
    end
    object Label3: TLabel
      Left = 256
      Top = 406
      Width = 119
      Height = 21
      Caption = 'C'#243'digo de barras'
    end
    object dbCOD_ITEM: TDBEdit
      Left = 256
      Top = 371
      Width = 121
      Height = 29
      DataField = 'COD_ITEM'
      DataSource = dsItens
      TabOrder = 0
    end
    object dbgrdItens: TDBGrid
      Left = 256
      Top = 488
      Width = 861
      Height = 227
      DataSource = dsItens
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
    object dbNOM_ITEM: TDBEdit
      Left = 383
      Top = 371
      Width = 378
      Height = 29
      DataField = 'NOM_ITEM'
      DataSource = dsItens
      TabOrder = 2
    end
    object dbNUM_COD_BARR: TDBEdit
      Left = 256
      Top = 433
      Width = 378
      Height = 29
      DataField = 'NUM_COD_BARR'
      DataSource = dsItens
      TabOrder = 3
    end
    object grpPesquisa: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 1216
      Height = 174
      Align = alTop
      Caption = ':: Pesquisar  '
      TabOrder = 4
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
      object Panel1: TPanel
        Left = 144
        Top = 32
        Width = 393
        Height = 56
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 1
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
          Width = 113
          Height = 25
          Cursor = crHandPoint
          Caption = 'Contenha'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object rbtFiltroDescricaoInicie: TRadioButton
          Left = 204
          Top = 0
          Width = 113
          Height = 25
          Cursor = crHandPoint
          Caption = 'Inicie com'
          TabOrder = 1
        end
        object rbtFiltroDescricaoFinalize: TRadioButton
          Left = 304
          Top = 0
          Width = 113
          Height = 25
          Cursor = crHandPoint
          Caption = 'Finalize'
          TabOrder = 2
        end
        object edtFiltroDescricao: TEdit
          Left = 1
          Top = 26
          Width = 391
          Height = 29
          Align = alBottom
          TabOrder = 3
        end
      end
      object btnPesquisar: TButton
        Left = 632
        Top = 36
        Width = 121
        Height = 49
        Caption = 'btnPesquisar'
        TabOrder = 2
        OnClick = btnPesquisarClick
      end
    end
  end
  inherited pModeloTop: TPanel
    Width = 1222
    ExplicitWidth = 1222
    inherited bvlModeloLinha: TBevel
      Width = 1222
      ExplicitWidth = 1222
    end
    inherited lbModeloTitulo: TLabel
      Width = 162
      Caption = 'Cadastro de Itens'
      ExplicitWidth = 162
    end
  end
  object dsItens: TDataSource
    Left = 520
    Top = 8
  end
end
