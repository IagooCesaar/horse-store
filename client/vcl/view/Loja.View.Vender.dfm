inherited ViewVender: TViewVender
  Caption = 'Ponto de Venda'
  ClientHeight = 772
  ClientWidth = 1231
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 1243
  ExplicitHeight = 810
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 1231
    Height = 715
    ExplicitLeft = 0
    ExplicitTop = 57
    ExplicitWidth = 1227
    ExplicitHeight = 546
    object pcPrinc: TPageControl
      Left = 0
      Top = 0
      Width = 1231
      Height = 715
      ActivePage = tsPesquisa
      Align = alClient
      TabOrder = 0
      ExplicitHeight = 547
      object tsVenda: TTabSheet
        Caption = ':: Venda  '
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 1223
          Height = 89
          Align = alTop
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 0
          ExplicitLeft = 2
          ExplicitTop = -6
          object Label1: TLabel
            Left = 16
            Top = 24
            Width = 195
            Height = 21
            Caption = 'C'#243'digo ou C'#243'digo de Barras'
          end
          object sbInserirItem: TSpeedButton
            Left = 217
            Top = 20
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
            Top = 20
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
            Top = 20
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
            Top = 51
            Width = 29
            Height = 29
            Cursor = crHandPoint
            ImageIndex = 3
            Images = dmImagens.imgIco16
            OnClick = sbBuscarClick
          end
          object edtPesquisa: TEdit
            Left = 16
            Top = 51
            Width = 624
            Height = 29
            TabOrder = 0
            TextHint = 'Ex: 3 * {C'#243'digo} ir'#225' inserir quantidade 3 do item informado'
            OnKeyDown = edtPesquisaKeyDown
          end
        end
        object GroupBox1: TGroupBox
          Left = 0
          Top = 89
          Width = 1223
          Height = 271
          Align = alClient
          Caption = ':: Itens da venda  '
          TabOrder = 1
          ExplicitLeft = 520
          ExplicitTop = 200
          ExplicitWidth = 185
          ExplicitHeight = 105
          object dbgItens: TDBGrid
            Left = 2
            Top = 23
            Width = 684
            Height = 246
            Align = alClient
            DataSource = dsItens
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -16
            TitleFont.Name = 'Segoe UI'
            TitleFont.Style = []
          end
          object Panel3: TPanel
            Left = 686
            Top = 23
            Width = 535
            Height = 246
            Align = alRight
            Caption = 'Panel3'
            ShowCaption = False
            TabOrder = 1
            ExplicitLeft = 688
            ExplicitTop = 89
            ExplicitHeight = 326
            object DBNavigator1: TDBNavigator
              Left = 1
              Top = 1
              Width = 533
              Height = 32
              DataSource = dsItens
              VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
              Align = alTop
              TabOrder = 0
            end
          end
        end
        object pBottom: TPanel
          Left = 0
          Top = 360
          Width = 1223
          Height = 319
          Align = alBottom
          BevelOuter = bvNone
          Caption = 'pBottom'
          ShowCaption = False
          TabOrder = 2
          ExplicitTop = 192
          object GroupBox3: TGroupBox
            Left = 0
            Top = 0
            Width = 680
            Height = 319
            Align = alClient
            Caption = ':: Meios de pagamento  '
            TabOrder = 0
            ExplicitLeft = -6
            ExplicitTop = 4
            ExplicitWidth = 1118
            ExplicitHeight = 279
            object p1: TPanel
              Left = 2
              Top = 23
              Width = 185
              Height = 294
              Align = alLeft
              Caption = 'p1'
              TabOrder = 0
              ExplicitLeft = -4
              object btnMeioPagtoCH: TButton
                AlignWithMargins = True
                Left = 9
                Top = 249
                Width = 167
                Height = 32
                Cursor = crHandPoint
                Margins.Left = 8
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Cheque'
                ImageIndex = 6
                Images = dmImagens.imgIco16
                TabOrder = 6
                OnClick = btnAdicionarMeioPagtoClick
                ExplicitTop = 9
              end
              object btnMeioPagtoVO: TButton
                AlignWithMargins = True
                Left = 9
                Top = 209
                Width = 167
                Height = 32
                Cursor = crHandPoint
                Margins.Left = 8
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Voucher'
                ImageIndex = 7
                Images = dmImagens.imgIco16
                TabOrder = 5
                OnClick = btnAdicionarMeioPagtoClick
                ExplicitLeft = 17
                ExplicitTop = 17
              end
              object btnMeioPagtoCD: TButton
                AlignWithMargins = True
                Left = 9
                Top = 169
                Width = 167
                Height = 32
                Cursor = crHandPoint
                Margins.Left = 8
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Cart'#227'o D'#233'bito'
                ImageIndex = 5
                Images = dmImagens.imgIco16
                TabOrder = 4
                OnClick = btnAdicionarMeioPagtoClick
                ExplicitLeft = 17
                ExplicitTop = 17
              end
              object btnMeioPagtoCC: TButton
                AlignWithMargins = True
                Left = 9
                Top = 129
                Width = 167
                Height = 32
                Cursor = crHandPoint
                Margins.Left = 8
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Cart'#227'o Cr'#233'dito'
                ImageIndex = 5
                Images = dmImagens.imgIco16
                TabOrder = 3
                OnClick = btnAdicionarMeioPagtoClick
                ExplicitLeft = 17
                ExplicitTop = 17
              end
              object btnMeioPagtoPIX: TButton
                AlignWithMargins = True
                Left = 9
                Top = 89
                Width = 167
                Height = 32
                Cursor = crHandPoint
                Margins.Left = 8
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alTop
                Caption = 'PIX'
                ImageIndex = 8
                Images = dmImagens.imgIco16
                TabOrder = 2
                OnClick = btnAdicionarMeioPagtoClick
                ExplicitLeft = 7
              end
              object btnMeioPagtoDN: TButton
                AlignWithMargins = True
                Left = 9
                Top = 49
                Width = 167
                Height = 32
                Cursor = crHandPoint
                Margins.Left = 8
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Dinheiro'
                ImageIndex = 4
                Images = dmImagens.imgIco16
                TabOrder = 1
                OnClick = btnAdicionarMeioPagtoClick
                ExplicitLeft = 7
              end
              object btnMeioPagtoRemover: TButton
                AlignWithMargins = True
                Left = 9
                Top = 9
                Width = 167
                Height = 32
                Cursor = crHandPoint
                Margins.Left = 8
                Margins.Top = 8
                Margins.Right = 8
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Remover'
                ImageIndex = 0
                Images = dmImagens.imgIco16
                TabOrder = 0
                ExplicitLeft = 17
                ExplicitTop = 17
              end
            end
            object dbgMeiosPagto: TDBGrid
              Left = 187
              Top = 23
              Width = 491
              Height = 294
              Align = alClient
              DataSource = dsMeiosPagto
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -16
              TitleFont.Name = 'Segoe UI'
              TitleFont.Style = []
            end
          end
          object GroupBox2: TGroupBox
            Left = 680
            Top = 0
            Width = 543
            Height = 319
            Align = alRight
            Caption = ':: Totais da venda  '
            TabOrder = 1
            ExplicitHeight = 279
            object pModeloBotoes: TCategoryButtons
              Left = 2
              Top = 261
              Width = 539
              Height = 56
              Align = alBottom
              ButtonFlow = cbfVertical
              Categories = <>
              RegularButtonColor = clWhite
              SelectedButtonColor = 15132390
              TabOrder = 0
              TabStop = False
              ExplicitLeft = 0
              ExplicitTop = 434
              ExplicitWidth = 907
              object btnEfetivar: TButton
                AlignWithMargins = True
                Left = 329
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
              end
              object btnCancelar: TButton
                AlignWithMargins = True
                Left = 432
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
              end
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
          Width = 1223
          Height = 575
          Margins.Left = 0
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          Caption = 'Lista de Caixas'
          ShowCaption = False
          TabOrder = 0
          ExplicitWidth = 1219
          ExplicitHeight = 406
          object Panel4: TPanel
            Left = 1
            Top = 542
            Width = 1221
            Height = 32
            Align = alBottom
            BevelOuter = bvNone
            Caption = 'Panel3'
            ShowCaption = False
            TabOrder = 0
            ExplicitTop = 373
            ExplicitWidth = 1217
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
            Width = 1205
            Height = 525
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
          Width = 1223
          Height = 96
          Align = alTop
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 1
          ExplicitWidth = 1219
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
    Width = 1231
    ExplicitWidth = 1227
    inherited bvlModeloLinha: TBevel
      Width = 1231
      ExplicitWidth = 1231
    end
    inherited lbModeloTitulo: TLabel
      Width = 1191
      Height = 37
      Caption = 'Ponto de Venda'
      ExplicitWidth = 147
    end
  end
  object dsVenda: TDataSource
    AutoEdit = False
    Left = 472
    Top = 8
  end
  object dsItens: TDataSource
    Left = 528
    Top = 8
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
end
