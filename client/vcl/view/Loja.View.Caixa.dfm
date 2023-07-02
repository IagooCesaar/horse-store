inherited ViewCaixa: TViewCaixa
  Caption = 'ViewCaixa'
  ClientHeight = 614
  ClientWidth = 870
  OnCreate = FormCreate
  ExplicitWidth = 882
  ExplicitHeight = 652
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 870
    Height = 557
    ExplicitLeft = 0
    ExplicitTop = 57
    ExplicitWidth = 866
    ExplicitHeight = 556
    object pcPrinc: TPageControl
      Left = 0
      Top = 0
      Width = 870
      Height = 557
      ActivePage = tsLista
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 866
      ExplicitHeight = 556
      object tsCaixa: TTabSheet
        Caption = ':: Caixa  '
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 862
          Height = 49
          Align = alTop
          Caption = 'Panel2'
          Color = clCream
          ParentBackground = False
          ShowCaption = False
          TabOrder = 0
          ExplicitWidth = 858
          object SpeedButton1: TSpeedButton
            Left = 1
            Top = 1
            Width = 860
            Height = 47
            Cursor = crHandPoint
            Align = alClient
            Caption = 'Visualizar dados do caixa aberto atualmente'
            OnClick = SpeedButton1Click
            ExplicitLeft = 24
            ExplicitTop = 11
            ExplicitWidth = 305
            ExplicitHeight = 22
          end
        end
        object pResumo: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 57
          Width = 862
          Height = 152
          Margins.Left = 0
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alTop
          Caption = 'pResumo'
          ShowCaption = False
          TabOrder = 1
          ExplicitWidth = 858
          object GridPanel1: TGridPanel
            Left = 1
            Top = 1
            Width = 860
            Height = 104
            Align = alClient
            Caption = 'GridPanel1'
            ColumnCollection = <
              item
                Value = 20.000000000000000000
              end
              item
                Value = 20.000000000000000000
              end
              item
                Value = 20.000000000000000000
              end
              item
                Value = 20.000000000000000000
              end
              item
                Value = 20.000000000000000000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = FrameCaixaResumoMeioPagto1
                Row = 0
              end
              item
                Column = 1
                Control = FrameCaixaResumoMeioPagto2
                Row = 0
              end
              item
                Column = 2
                Control = FrameCaixaResumoMeioPagto3
                Row = 0
              end
              item
                Column = 3
                Control = FrameCaixaResumoMeioPagto4
                Row = 0
              end
              item
                Column = 4
                Control = FrameCaixaResumoMeioPagto5
                Row = 0
              end>
            RowCollection = <
              item
                Value = 100.000000000000000000
              end>
            ShowCaption = False
            TabOrder = 0
            ExplicitWidth = 856
            inline FrameCaixaResumoMeioPagto1: TFrameCaixaResumoMeioPagto
              AlignWithMargins = True
              Left = 5
              Top = 5
              Width = 164
              Height = 94
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              StyleElements = []
              ExplicitLeft = 5
              ExplicitTop = 5
              ExplicitWidth = 164
              ExplicitHeight = 94
              inherited pCliente: TPanel
                Width = 164
                Height = 94
                ExplicitWidth = 164
                ExplicitHeight = 94
                inherited lbMeioPagto: TLabel
                  Width = 140
                end
                inherited lbValor: TLabel
                  Left = 10
                  Width = 140
                  ExplicitLeft = 277
                end
              end
            end
            inline FrameCaixaResumoMeioPagto2: TFrameCaixaResumoMeioPagto
              AlignWithMargins = True
              Left = 177
              Top = 5
              Width = 163
              Height = 94
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              StyleElements = []
              ExplicitLeft = 177
              ExplicitTop = 5
              ExplicitWidth = 163
              ExplicitHeight = 94
              inherited pCliente: TPanel
                Width = 163
                Height = 94
                ExplicitWidth = 163
                ExplicitHeight = 94
                inherited lbMeioPagto: TLabel
                  Width = 139
                end
                inherited lbValor: TLabel
                  Left = 10
                  Width = 139
                  ExplicitLeft = 276
                end
              end
            end
            inline FrameCaixaResumoMeioPagto3: TFrameCaixaResumoMeioPagto
              AlignWithMargins = True
              Left = 348
              Top = 5
              Width = 164
              Height = 94
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              StyleElements = []
              ExplicitLeft = 348
              ExplicitTop = 5
              ExplicitWidth = 164
              ExplicitHeight = 94
              inherited pCliente: TPanel
                Width = 164
                Height = 94
                ExplicitWidth = 164
                ExplicitHeight = 94
                inherited lbMeioPagto: TLabel
                  Width = 140
                end
                inherited lbValor: TLabel
                  Left = 10
                  Width = 140
                  ExplicitLeft = 277
                end
              end
            end
            inline FrameCaixaResumoMeioPagto4: TFrameCaixaResumoMeioPagto
              AlignWithMargins = True
              Left = 520
              Top = 5
              Width = 163
              Height = 94
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              StyleElements = []
              ExplicitLeft = 520
              ExplicitTop = 5
              ExplicitWidth = 163
              ExplicitHeight = 94
              inherited pCliente: TPanel
                Width = 163
                Height = 94
                ExplicitWidth = 163
                ExplicitHeight = 94
                inherited lbMeioPagto: TLabel
                  Width = 139
                end
                inherited lbValor: TLabel
                  Left = 10
                  Width = 139
                  ExplicitLeft = 276
                end
              end
            end
            inline FrameCaixaResumoMeioPagto5: TFrameCaixaResumoMeioPagto
              AlignWithMargins = True
              Left = 691
              Top = 5
              Width = 164
              Height = 94
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              StyleElements = []
              ExplicitLeft = 691
              ExplicitTop = 5
              ExplicitWidth = 164
              ExplicitHeight = 94
              inherited pCliente: TPanel
                Width = 164
                Height = 94
                ExplicitWidth = 164
                ExplicitHeight = 94
                inherited lbMeioPagto: TLabel
                  Width = 140
                end
                inherited lbValor: TLabel
                  Left = 10
                  Width = 140
                  ExplicitLeft = 277
                end
              end
            end
          end
          object pAcoes: TPanel
            Left = 1
            Top = 105
            Width = 860
            Height = 46
            Align = alBottom
            Caption = 'pAcoes'
            TabOrder = 1
            ExplicitWidth = 856
            object Button1: TButton
              AlignWithMargins = True
              Left = 388
              Top = 9
              Width = 121
              Height = 36
              Cursor = crHandPoint
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 8
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Sangria'
              TabOrder = 3
            end
            object Button2: TButton
              AlignWithMargins = True
              Left = 259
              Top = 9
              Width = 121
              Height = 36
              Cursor = crHandPoint
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 8
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Refor'#231'o'
              TabOrder = 2
            end
            object Button3: TButton
              AlignWithMargins = True
              Left = 130
              Top = 9
              Width = 121
              Height = 36
              Cursor = crHandPoint
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 8
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Fechamento'
              TabOrder = 1
            end
            object Button4: TButton
              AlignWithMargins = True
              Left = 1
              Top = 9
              Width = 121
              Height = 36
              Cursor = crHandPoint
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 8
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Abertura'
              TabOrder = 0
            end
          end
        end
        object pMovimentos: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 217
          Width = 862
          Height = 304
          Margins.Left = 0
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          Caption = 'Movimentos'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          ExplicitWidth = 858
          ExplicitHeight = 303
          object dbgMovimentos: TDBGrid
            AlignWithMargins = True
            Left = 9
            Top = 9
            Width = 844
            Height = 286
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alClient
            DataSource = dsMovimentos
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
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
      object tsLista: TTabSheet
        Caption = ':: Lista de Caixas  '
        ImageIndex = 1
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 862
          Height = 96
          Align = alTop
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 0
          object Label1: TLabel
            Left = 16
            Top = 16
            Width = 22
            Height = 21
            Caption = 'De:'
            Layout = tlCenter
          end
          object Label2: TLabel
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
        end
        object pCaixasGrid: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 104
          Width = 862
          Height = 417
          Margins.Left = 0
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          Caption = 'Lista de Caixas'
          ShowCaption = False
          TabOrder = 1
          object Panel3: TPanel
            Left = 1
            Top = 384
            Width = 860
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
              Width = 313
              Height = 32
              Margins.Left = 8
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Duplo clique para visualizar detalhes do caixa'
              Layout = tlCenter
              ExplicitHeight = 21
            end
          end
          object dbgCaixas: TDBGrid
            AlignWithMargins = True
            Left = 9
            Top = 9
            Width = 844
            Height = 367
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alClient
            DataSource = dsCaixas
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            ReadOnly = True
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -16
            TitleFont.Name = 'Segoe UI'
            TitleFont.Style = []
            OnDblClick = dbgCaixasDblClick
          end
        end
      end
    end
  end
  inherited pModeloTop: TPanel
    Width = 870
    ExplicitWidth = 866
    inherited bvlModeloLinha: TBevel
      Width = 870
      ExplicitWidth = 878
    end
    inherited lbModeloTitulo: TLabel
      Width = 830
      Height = 37
      Caption = 'Controle de Caixa'
      ExplicitWidth = 164
    end
  end
  object dsCaixas: TDataSource
    AutoEdit = False
    Left = 696
  end
  object dsMovimentos: TDataSource
    AutoEdit = False
    Left = 776
  end
  object dsCaixa: TDataSource
    AutoEdit = False
    Left = 632
  end
end
