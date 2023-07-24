inherited ViewVender: TViewVender
  Caption = 'Ponto de Venda'
  ClientWidth = 1231
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 1243
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 1231
    ExplicitLeft = 0
    ExplicitTop = 57
    ExplicitWidth = 1227
    ExplicitHeight = 547
    object pcPrinc: TPageControl
      Left = 0
      Top = 0
      Width = 1231
      Height = 547
      ActivePage = tsPesquisa
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 1227
      object tsVenda: TTabSheet
        Caption = 'tsVenda'
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 1223
          Height = 89
          Align = alTop
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 0
          ExplicitWidth = 1219
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
        object Panel2: TPanel
          Left = 0
          Top = 415
          Width = 1223
          Height = 96
          Align = alBottom
          Caption = 'Panel2'
          TabOrder = 1
          ExplicitWidth = 1219
        end
        object Panel3: TPanel
          Left = 688
          Top = 89
          Width = 535
          Height = 326
          Align = alRight
          Caption = 'Panel3'
          TabOrder = 2
          ExplicitLeft = 684
          object DBNavigator1: TDBNavigator
            Left = 1
            Top = 1
            Width = 533
            Height = 32
            DataSource = dsItens
            Align = alTop
            TabOrder = 0
          end
        end
        object dbgItens: TDBGrid
          Left = 0
          Top = 89
          Width = 688
          Height = 326
          Align = alClient
          DataSource = dsItens
          TabOrder = 3
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -16
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
      end
      object tsPesquisa: TTabSheet
        Caption = 'tsPesquisa'
        ImageIndex = 1
        object pVendasGrid: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 104
          Width = 1223
          Height = 407
          Margins.Left = 0
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          Caption = 'Lista de Caixas'
          ShowCaption = False
          TabOrder = 0
          ExplicitHeight = 408
          object Panel4: TPanel
            Left = 1
            Top = 374
            Width = 1221
            Height = 32
            Align = alBottom
            BevelOuter = bvNone
            Caption = 'Panel3'
            ShowCaption = False
            TabOrder = 0
            ExplicitTop = 375
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
            Height = 357
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
      ExplicitWidth = 1191
    end
  end
  object dsVenda: TDataSource
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
    Left = 688
    Top = 8
  end
end
