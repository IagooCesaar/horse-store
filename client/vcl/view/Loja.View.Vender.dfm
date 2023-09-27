inherited ViewVender: TViewVender
  Caption = 'Ponto de Venda'
  KeyPreview = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 21
  inherited pModeloClient: TPanel
    ExplicitWidth = 1223
    ExplicitHeight = 599
    object pcPrinc: TPageControl
      Left = 0
      Top = 0
      Width = 1225
      Height = 602
      ActivePage = tsVenda
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 1223
      ExplicitHeight = 599
      object tsVenda: TTabSheet
        Caption = ':: Venda  '
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 1217
          Height = 77
          Align = alTop
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 0
          ExplicitWidth = 1215
          object Label1: TLabel
            Left = 16
            Top = 11
            Width = 195
            Height = 21
            Caption = 'C'#243'digo ou C'#243'digo de Barras'
          end
          object sbInserirItem: TSpeedButton
            Left = 217
            Top = 7
            Width = 137
            Height = 25
            Cursor = crHandPoint
            GroupIndex = 1
            Down = True
            Caption = 'Inserir Item'
            ImageIndex = 1
            Images = dmImagens.imgIco16
          end
          object sbConsultaPreco: TSpeedButton
            Left = 360
            Top = 7
            Width = 137
            Height = 25
            Cursor = crHandPoint
            GroupIndex = 1
            Caption = 'Consultar Pre'#231'o'
            ImageIndex = 2
            Images = dmImagens.imgIco16
          end
          object sbNovaVenda: TSpeedButton
            Left = 503
            Top = 7
            Width = 137
            Height = 25
            Cursor = crHandPoint
            GroupIndex = 1
            Caption = 'Nova Venda'
            ImageIndex = 1
            Images = dmImagens.imgIco16
          end
          object sbBuscar: TSpeedButton
            Left = 640
            Top = 38
            Width = 29
            Height = 29
            Cursor = crHandPoint
            Hint = 'Executar [Enter]'
            ImageIndex = 3
            Images = dmImagens.imgIco16
            ParentShowHint = False
            ShowHint = True
            OnClick = sbBuscarClick
          end
          object edtPesquisa: TEdit
            Left = 16
            Top = 38
            Width = 624
            Height = 29
            Hint = 
              'Pesquisa|Pesquise pelo C'#243'digo do Produto ou pelo C'#243'digo de Barra' +
              's. Voc'#234' tamb'#233'm poder'#225' informar a quantidade desejada seguindo o ' +
              'padr'#227'o "Quantidade * C'#243'digo"'
            TabOrder = 0
            TextHint = 'Ex: 3 * {C'#243'digo} ir'#225' inserir quantidade 3 do item informado'
            OnEnter = MeuBallonInfoOnEnter
            OnKeyDown = edtPesquisaKeyDown
          end
        end
        object GroupBox1: TGroupBox
          Left = 0
          Top = 77
          Width = 1217
          Height = 282
          Align = alClient
          Caption = ':: Itens da venda  '
          TabOrder = 1
          ExplicitWidth = 1215
          ExplicitHeight = 279
          object dbgItens: TDBGrid
            AlignWithMargins = True
            Left = 5
            Top = 26
            Width = 672
            Height = 251
            Align = alClient
            DataSource = dsItens
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            ReadOnly = True
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -16
            TitleFont.Name = 'Segoe UI'
            TitleFont.Style = []
          end
          object pControleItens: TPanel
            Left = 680
            Top = 23
            Width = 535
            Height = 257
            Align = alRight
            BevelOuter = bvNone
            Caption = 'pControleItens'
            ShowCaption = False
            TabOrder = 1
            ExplicitLeft = 678
            ExplicitHeight = 254
            object Label12: TLabel
              Left = 6
              Top = 25
              Width = 71
              Height = 21
              Caption = 'N'#250'm. Seq.'
              FocusControl = dbNUM_SEQ_ITEM
            end
            object Label13: TLabel
              Left = 184
              Top = 25
              Width = 59
              Height = 21
              Caption = 'Situa'#231#227'o'
              FocusControl = dbCOD_SIT1
            end
            object Label14: TLabel
              Left = 6
              Top = 84
              Width = 66
              Height = 21
              Caption = 'C'#243'd. Item'
              FocusControl = dbCOD_ITEM
            end
            object Label15: TLabel
              Left = 112
              Top = 84
              Width = 31
              Height = 21
              Caption = 'Item'
              FocusControl = dbNOM_ITEM
            end
            object Label16: TLabel
              Left = 6
              Top = 143
              Width = 90
              Height = 21
              Caption = 'Quantidade'
              FocusControl = dbQTD_ITEM
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label17: TLabel
              Left = 112
              Top = 143
              Width = 84
              Height = 21
              Caption = 'Pre'#231'o Unit.'
              FocusControl = dbVR_PRECO_UNIT
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label18: TLabel
              Left = 6
              Top = 202
              Width = 78
              Height = 21
              Caption = 'Valor Bruto'
              FocusControl = dbVR_BRUTO
            end
            object Label19: TLabel
              Left = 281
              Top = 144
              Width = 116
              Height = 21
              Caption = 'Valor Desconto'
              FocusControl = dbVR_DESC
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label20: TLabel
              Left = 175
              Top = 202
              Width = 107
              Height = 21
              Caption = 'Valor Total Item'
              FocusControl = dbVR_TOTAL
            end
            object Label21: TLabel
              Left = 362
              Top = 25
              Width = 77
              Height = 21
              Caption = 'N'#250'm. Vnda'
              FocusControl = dbNUM_VNDA1
            end
            object dbnItens: TDBNavigator
              Left = 0
              Top = 0
              Width = 535
              Height = 30
              Cursor = crHandPoint
              DataSource = dsItens
              VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbDelete, nbEdit, nbPost, nbCancel]
              Align = alTop
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
            end
            object dbNUM_SEQ_ITEM: TDBEdit
              Left = 6
              Top = 49
              Width = 172
              Height = 29
              TabStop = False
              DataField = 'NUM_SEQ_ITEM'
              DataSource = dsItens
              ReadOnly = True
              TabOrder = 1
            end
            object dbCOD_SIT1: TDBEdit
              Left = 184
              Top = 49
              Width = 172
              Height = 29
              TabStop = False
              DataField = 'COD_SIT'
              DataSource = dsItens
              ReadOnly = True
              TabOrder = 2
            end
            object dbCOD_ITEM: TDBEdit
              Left = 6
              Top = 108
              Width = 100
              Height = 29
              DataField = 'COD_ITEM'
              DataSource = dsItens
              ReadOnly = True
              TabOrder = 3
            end
            object dbNOM_ITEM: TDBEdit
              Left = 112
              Top = 108
              Width = 409
              Height = 29
              DataField = 'NOM_ITEM'
              DataSource = dsItens
              ReadOnly = True
              TabOrder = 4
            end
            object dbQTD_ITEM: TDBEdit
              Left = 6
              Top = 167
              Width = 100
              Height = 29
              DataField = 'QTD_ITEM'
              DataSource = dsItens
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 5
              OnKeyDown = dbQTD_ITEMKeyDown
            end
            object dbVR_PRECO_UNIT: TDBEdit
              Left = 112
              Top = 167
              Width = 163
              Height = 29
              Hint = 
                'Pre'#231'o Unit'#225'rio|Informe o pre'#231'o unit'#225'rio do produto quando o mesm' +
                'o n'#227'o utilizar tabela de pre'#231'o'
              DataField = 'VR_PRECO_UNIT'
              DataSource = dsItens
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 6
              OnEnter = MeuBallonInfoOnEnter
              OnKeyDown = dbQTD_ITEMKeyDown
            end
            object dbVR_BRUTO: TDBEdit
              Left = 6
              Top = 226
              Width = 163
              Height = 29
              TabStop = False
              DataField = 'VR_BRUTO'
              DataSource = dsItens
              ReadOnly = True
              TabOrder = 8
            end
            object dbVR_DESC: TDBEdit
              Left = 281
              Top = 167
              Width = 163
              Height = 29
              DataField = 'VR_DESC'
              DataSource = dsItens
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 7
              OnKeyDown = dbQTD_ITEMKeyDown
            end
            object dbVR_TOTAL: TDBEdit
              Left = 175
              Top = 225
              Width = 163
              Height = 29
              TabStop = False
              DataField = 'VR_TOTAL'
              DataSource = dsItens
              ReadOnly = True
              TabOrder = 9
            end
            object dbNUM_VNDA1: TDBEdit
              Left = 362
              Top = 49
              Width = 103
              Height = 29
              TabStop = False
              DataField = 'NUM_VNDA'
              DataSource = dsItens
              ReadOnly = True
              TabOrder = 10
            end
          end
        end
        object pBottom: TPanel
          Left = 0
          Top = 359
          Width = 1217
          Height = 207
          Align = alBottom
          BevelOuter = bvNone
          Caption = 'pBottom'
          ShowCaption = False
          TabOrder = 2
          ExplicitTop = 356
          ExplicitWidth = 1215
          object GroupBox3: TGroupBox
            Left = 0
            Top = 0
            Width = 595
            Height = 207
            Align = alClient
            Caption = ':: Meios de pagamento  '
            TabOrder = 0
            ExplicitWidth = 593
            object p1: TPanel
              Left = 97
              Top = 23
              Width = 95
              Height = 182
              Align = alLeft
              BevelOuter = bvNone
              Caption = 'p1'
              ShowCaption = False
              TabOrder = 0
              object btnMeioPagtoCH: TButton
                AlignWithMargins = True
                Left = 4
                Top = 128
                Width = 83
                Height = 32
                Cursor = crHandPoint
                Hint = 'Cheque'
                Margins.Left = 4
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alTop
                Caption = 'CHQ'
                ImageIndex = 6
                Images = dmImagens.imgIco16
                ParentShowHint = False
                ShowHint = True
                TabOrder = 3
                OnClick = btnAdicionarMeioPagtoClick
              end
              object btnMeioPagtoVO: TButton
                AlignWithMargins = True
                Left = 4
                Top = 88
                Width = 83
                Height = 32
                Cursor = crHandPoint
                Hint = 'Voucher'
                Margins.Left = 4
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Vou.'
                ImageIndex = 7
                Images = dmImagens.imgIco16
                ParentShowHint = False
                ShowHint = True
                TabOrder = 2
                OnClick = btnAdicionarMeioPagtoClick
              end
              object btnMeioPagtoCD: TButton
                AlignWithMargins = True
                Left = 4
                Top = 48
                Width = 83
                Height = 32
                Cursor = crHandPoint
                Hint = 'Cart'#227'o de D'#233'bito'
                Margins.Left = 4
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alTop
                Caption = 'D'#233'bito'
                ImageIndex = 5
                Images = dmImagens.imgIco16
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                OnClick = btnAdicionarMeioPagtoClick
              end
              object btnMeioPagtoCC: TButton
                AlignWithMargins = True
                Left = 4
                Top = 8
                Width = 83
                Height = 32
                Cursor = crHandPoint
                Hint = 'Cart'#227'o de Cr'#233'dito'
                Margins.Left = 4
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Cr'#233'dito'
                ImageIndex = 5
                Images = dmImagens.imgIco16
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnClick = btnAdicionarMeioPagtoClick
              end
            end
            object dbgMeiosPagto: TDBGrid
              Left = 192
              Top = 23
              Width = 401
              Height = 182
              Align = alClient
              DataSource = dsMeiosPagto
              Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
              ReadOnly = True
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -16
              TitleFont.Name = 'Segoe UI'
              TitleFont.Style = []
              OnDblClick = dbgMeiosPagtoDblClick
            end
            object Panel2: TPanel
              Left = 2
              Top = 23
              Width = 95
              Height = 182
              Align = alLeft
              BevelOuter = bvNone
              Caption = 'p1'
              ShowCaption = False
              TabOrder = 2
              object btnMeioPagtoPIX: TButton
                AlignWithMargins = True
                Left = 8
                Top = 88
                Width = 83
                Height = 32
                Cursor = crHandPoint
                Hint = 'PIX'
                Margins.Left = 8
                Margins.Top = 8
                Margins.Right = 4
                Margins.Bottom = 0
                Align = alTop
                Caption = 'PIX'
                ImageIndex = 8
                Images = dmImagens.imgIco16
                ParentShowHint = False
                ShowHint = True
                TabOrder = 2
                OnClick = btnAdicionarMeioPagtoClick
              end
              object btnMeioPagtoDN: TButton
                AlignWithMargins = True
                Left = 8
                Top = 48
                Width = 83
                Height = 32
                Cursor = crHandPoint
                Hint = 'Dinheiro'
                Margins.Left = 8
                Margins.Top = 8
                Margins.Right = 4
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Dinh.'
                ImageIndex = 4
                Images = dmImagens.imgIco16
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                OnClick = btnAdicionarMeioPagtoClick
              end
              object btnMeioPagtoRemover: TButton
                AlignWithMargins = True
                Left = 8
                Top = 8
                Width = 83
                Height = 32
                Cursor = crHandPoint
                Hint = 'Remover'
                Margins.Left = 8
                Margins.Top = 8
                Margins.Right = 4
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Rem.'
                ImageIndex = 0
                Images = dmImagens.imgIco16
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnClick = btnMeioPagtoRemoverClick
              end
            end
          end
          object GroupBox2: TGroupBox
            Left = 595
            Top = 0
            Width = 622
            Height = 207
            Align = alRight
            Caption = ':: Totais da venda  '
            TabOrder = 1
            ExplicitLeft = 593
            object Label5: TLabel
              Left = 6
              Top = 32
              Width = 85
              Height = 21
              Caption = 'N'#250'm. Venda'
              FocusControl = dbNUM_VNDA
            end
            object Label6: TLabel
              Left = 127
              Top = 32
              Width = 94
              Height = 21
              Caption = 'C'#243'd. Situa'#231#227'o'
              FocusControl = dbCOD_SIT
            end
            object Label7: TLabel
              Left = 280
              Top = 32
              Width = 85
              Height = 21
              Caption = 'Dat Inclus'#227'o'
              FocusControl = dbDAT_INCL
            end
            object Label8: TLabel
              Left = 449
              Top = 32
              Width = 100
              Height = 21
              Caption = 'Dat Conclus'#227'o'
              FocusControl = dbDAT_CONCL
            end
            object Label9: TLabel
              Left = 6
              Top = 91
              Width = 78
              Height = 21
              Caption = 'Valor Bruto'
              FocusControl = dbVR_BRUTO1
            end
            object Label10: TLabel
              Left = 175
              Top = 91
              Width = 105
              Height = 21
              Caption = 'Valor Desconto'
              FocusControl = dbVR_DESC1
            end
            object Label11: TLabel
              Left = 344
              Top = 88
              Width = 82
              Height = 21
              Caption = 'Valor Total'
              FocusControl = dbVR_TOTAL1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object pModeloBotoes: TCategoryButtons
              Left = 2
              Top = 149
              Width = 618
              Height = 56
              Align = alBottom
              ButtonFlow = cbfVertical
              Categories = <>
              RegularButtonColor = clWhite
              SelectedButtonColor = 15132390
              TabOrder = 0
              TabStop = False
              object btnEfetivar: TButton
                AlignWithMargins = True
                Left = 408
                Top = 8
                Width = 95
                Height = 36
                Cursor = crHandPoint
                Margins.Left = 0
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 8
                Align = alRight
                Caption = 'Efetivar'
                TabOrder = 0
                OnClick = btnEfetivarClick
              end
              object btnCancelar: TButton
                AlignWithMargins = True
                Left = 511
                Top = 8
                Width = 95
                Height = 36
                Cursor = crHandPoint
                Margins.Left = 0
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 8
                Align = alRight
                Caption = 'Cancelar'
                TabOrder = 1
                OnClick = btnCancelarClick
              end
            end
            object dbNUM_VNDA: TDBEdit
              Left = 6
              Top = 56
              Width = 115
              Height = 29
              TabStop = False
              DataField = 'NUM_VNDA'
              DataSource = dsVenda
              ReadOnly = True
              TabOrder = 1
            end
            object dbCOD_SIT: TDBEdit
              Left = 127
              Top = 56
              Width = 147
              Height = 29
              TabStop = False
              DataField = 'COD_SIT'
              DataSource = dsVenda
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
            end
            object dbDAT_INCL: TDBEdit
              Left = 280
              Top = 56
              Width = 163
              Height = 29
              TabStop = False
              DataField = 'DAT_INCL'
              DataSource = dsVenda
              ReadOnly = True
              TabOrder = 3
            end
            object dbDAT_CONCL: TDBEdit
              Left = 449
              Top = 56
              Width = 163
              Height = 29
              TabStop = False
              DataField = 'DAT_CONCL'
              DataSource = dsVenda
              ReadOnly = True
              TabOrder = 4
            end
            object dbVR_BRUTO1: TDBEdit
              Left = 6
              Top = 115
              Width = 163
              Height = 29
              TabStop = False
              DataField = 'VR_BRUTO'
              DataSource = dsVenda
              ReadOnly = True
              TabOrder = 5
            end
            object dbVR_DESC1: TDBEdit
              Left = 175
              Top = 115
              Width = 163
              Height = 29
              TabStop = False
              DataField = 'VR_DESC'
              DataSource = dsVenda
              ReadOnly = True
              TabOrder = 6
            end
            object dbVR_TOTAL1: TDBEdit
              Left = 344
              Top = 115
              Width = 163
              Height = 29
              TabStop = False
              DataField = 'VR_TOTAL'
              DataSource = dsVenda
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 7
            end
          end
        end
      end
      object tsPesquisa: TTabSheet
        Caption = ':: Pesquisa  '
        ImageIndex = 1
        object pVendasGrid: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 104
          Width = 1217
          Height = 462
          Margins.Left = 0
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          Caption = 'Lista de Caixas'
          ShowCaption = False
          TabOrder = 0
          object Panel4: TPanel
            Left = 1
            Top = 429
            Width = 1215
            Height = 32
            Align = alBottom
            BevelOuter = bvNone
            Caption = 'Panel3'
            ShowCaption = False
            TabOrder = 0
            object Label3: TLabel
              AlignWithMargins = True
              Left = 8
              Top = 0
              Width = 320
              Height = 32
              Margins.Left = 8
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Duplo clique para visualizar detalhes da venda'
              Layout = tlCenter
              ExplicitHeight = 21
            end
          end
          object dbgVendas: TDBGrid
            AlignWithMargins = True
            Left = 9
            Top = 9
            Width = 1199
            Height = 412
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alClient
            DataSource = dsVendas
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            ReadOnly = True
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -16
            TitleFont.Name = 'Segoe UI'
            TitleFont.Style = []
            OnDblClick = dbgVendasDblClick
          end
        end
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 1217
          Height = 96
          Align = alTop
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 1
          object Label2: TLabel
            Left = 16
            Top = 16
            Width = 22
            Height = 21
            Caption = 'De:'
            Layout = tlCenter
          end
          object Label4: TLabel
            Left = 16
            Top = 51
            Width = 26
            Height = 21
            Caption = 'At'#233':'
            Layout = tlCenter
          end
          object edtDatIni: TDateTimePicker
            Left = 48
            Top = 16
            Width = 186
            Height = 29
            Date = 45108.000000000000000000
            Time = 0.480846956015739100
            TabOrder = 0
          end
          object edtDatFim: TDateTimePicker
            Left = 48
            Top = 51
            Width = 186
            Height = 29
            Date = 45108.000000000000000000
            Time = 0.480846956015739100
            TabOrder = 1
          end
          object btnPesquisar: TButton
            Left = 259
            Top = 44
            Width = 121
            Height = 36
            Cursor = crHandPoint
            Caption = 'Pesquisar'
            TabOrder = 2
            OnClick = btnPesquisarClick
          end
          object rbtVendaPend: TRadioButton
            Left = 432
            Top = 20
            Width = 137
            Height = 17
            Cursor = crHandPoint
            Caption = 'Pendentes'
            Checked = True
            TabOrder = 3
            TabStop = True
          end
          object rbtVendaCanc: TRadioButton
            Left = 432
            Top = 43
            Width = 137
            Height = 17
            Cursor = crHandPoint
            Caption = 'Canceladas'
            TabOrder = 4
          end
          object rbtVendaEfet: TRadioButton
            Left = 432
            Top = 66
            Width = 137
            Height = 17
            Cursor = crHandPoint
            Caption = 'Efetivadas'
            TabOrder = 5
          end
        end
      end
    end
  end
  inherited pModeloTop: TPanel
    ExplicitWidth = 1223
    inherited bvlModeloLinha: TBevel
      ExplicitWidth = 1225
    end
    inherited lbModeloTitulo: TLabel
      Caption = 'Ponto de Venda'
      ExplicitWidth = 147
    end
  end
  object dsMeiosPagto: TDataSource
    Left = 608
    Top = 8
  end
  object dsVendas: TDataSource
    AutoEdit = False
    Left = 688
    Top = 8
  end
  object dsVenda: TDataSource
    DataSet = ControllerVendas.mtDados
    Left = 864
    Top = 8
  end
  object dsItens: TDataSource
    DataSet = ControllerVendas.mtItens
    Left = 784
    Top = 8
  end
end
