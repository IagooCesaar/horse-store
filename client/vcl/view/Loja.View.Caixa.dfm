inherited ViewCaixa: TViewCaixa
  Caption = 'Controle de Caixa'
  ClientHeight = 612
  ClientWidth = 1220
  OnCreate = FormCreate
  ExplicitWidth = 1232
  ExplicitHeight = 650
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 1220
    Height = 555
    ExplicitLeft = 0
    ExplicitTop = 57
    ExplicitWidth = 1216
    ExplicitHeight = 554
    object pcPrinc: TPageControl
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 1204
      Height = 539
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      ActivePage = tsCaixa
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 1200
      ExplicitHeight = 538
      object tsCaixa: TTabSheet
        Caption = ':: Caixa  '
        object pVerCaixaAberto: TPanel
          Left = 0
          Top = 0
          Width = 1196
          Height = 49
          Align = alTop
          Caption = 'pVerCaixaAberto'
          Color = clCream
          ParentBackground = False
          ShowCaption = False
          TabOrder = 0
          ExplicitWidth = 1192
          object sbVerCaixaAberto: TSpeedButton
            Left = 1
            Top = 1
            Width = 1194
            Height = 47
            Cursor = crHandPoint
            Align = alClient
            Caption = 'Visualizar dados do caixa aberto atualmente'
            OnClick = sbVerCaixaAbertoClick
            ExplicitLeft = 24
            ExplicitTop = 11
            ExplicitWidth = 305
            ExplicitHeight = 22
          end
        end
        object pResumo: TPanel
          AlignWithMargins = True
          Left = 8
          Top = 57
          Width = 1180
          Height = 192
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          BevelOuter = bvNone
          Caption = 'pResumo'
          ShowCaption = False
          TabOrder = 1
          ExplicitWidth = 1176
          object grpResumo: TGridPanel
            Left = 0
            Top = 38
            Width = 1180
            Height = 108
            Align = alClient
            Caption = 'grpResumo'
            ColumnCollection = <
              item
                Value = 16.700000000000000000
              end
              item
                Value = 16.660000000000000000
              end
              item
                Value = 16.660000000000000000
              end
              item
                Value = 16.660000000000000000
              end
              item
                Value = 16.660000000000000000
              end
              item
                Value = 16.660000000000010000
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
              end
              item
                Column = 5
                Control = FrameCaixaResumoMeioPagto6
                Row = 0
              end>
            RowCollection = <
              item
                Value = 100.000000000000000000
              end>
            ShowCaption = False
            TabOrder = 0
            ExplicitWidth = 1176
            inline FrameCaixaResumoMeioPagto1: TFrameCaixaResumoMeioPagto
              AlignWithMargins = True
              Left = 5
              Top = 5
              Width = 189
              Height = 98
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
              ExplicitWidth = 188
              ExplicitHeight = 98
              inherited pCliente: TPanel
                Width = 189
                Height = 98
                ExplicitWidth = 188
                ExplicitHeight = 98
                inherited lbMeioPagto: TLabel
                  Width = 165
                end
                inherited lbValor: TLabel
                  Left = 10
                  Width = 165
                  ExplicitLeft = 111
                end
              end
            end
            inline FrameCaixaResumoMeioPagto2: TFrameCaixaResumoMeioPagto
              AlignWithMargins = True
              Left = 202
              Top = 5
              Width = 188
              Height = 98
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
              ExplicitLeft = 201
              ExplicitTop = 5
              ExplicitWidth = 188
              ExplicitHeight = 98
              inherited pCliente: TPanel
                Width = 188
                Height = 98
                ExplicitWidth = 188
                ExplicitHeight = 98
                inherited lbMeioPagto: TLabel
                  Width = 164
                end
                inherited lbValor: TLabel
                  Left = 10
                  Width = 164
                  ExplicitLeft = 110
                end
              end
            end
            inline FrameCaixaResumoMeioPagto3: TFrameCaixaResumoMeioPagto
              AlignWithMargins = True
              Left = 398
              Top = 5
              Width = 188
              Height = 98
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
              ExplicitLeft = 397
              ExplicitTop = 5
              ExplicitWidth = 187
              ExplicitHeight = 98
              inherited pCliente: TPanel
                Width = 188
                Height = 98
                ExplicitWidth = 187
                ExplicitHeight = 98
                inherited lbMeioPagto: TLabel
                  Width = 164
                end
                inherited lbValor: TLabel
                  Left = 10
                  Width = 164
                  ExplicitLeft = 110
                end
              end
            end
            inline FrameCaixaResumoMeioPagto4: TFrameCaixaResumoMeioPagto
              AlignWithMargins = True
              Left = 594
              Top = 5
              Width = 188
              Height = 98
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
              ExplicitLeft = 592
              ExplicitTop = 5
              ExplicitWidth = 188
              ExplicitHeight = 98
              inherited pCliente: TPanel
                Width = 188
                Height = 98
                ExplicitWidth = 188
                ExplicitHeight = 98
                inherited lbMeioPagto: TLabel
                  Width = 164
                end
                inherited lbValor: TLabel
                  Left = 10
                  Width = 164
                  ExplicitLeft = 110
                end
              end
            end
            inline FrameCaixaResumoMeioPagto5: TFrameCaixaResumoMeioPagto
              AlignWithMargins = True
              Left = 790
              Top = 5
              Width = 189
              Height = 98
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
              ExplicitLeft = 788
              ExplicitTop = 5
              ExplicitWidth = 187
              ExplicitHeight = 98
              inherited pCliente: TPanel
                Width = 189
                Height = 98
                ExplicitWidth = 187
                ExplicitHeight = 98
                inherited lbMeioPagto: TLabel
                  Width = 165
                end
                inherited lbValor: TLabel
                  Left = 10
                  Width = 165
                  ExplicitLeft = 111
                end
              end
            end
            inline FrameCaixaResumoMeioPagto6: TFrameCaixaResumoMeioPagto
              AlignWithMargins = True
              Left = 987
              Top = 5
              Width = 188
              Height = 98
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
              TabOrder = 5
              StyleElements = []
              ExplicitLeft = 983
              ExplicitTop = 5
              ExplicitWidth = 188
              ExplicitHeight = 98
              inherited pCliente: TPanel
                Width = 188
                Height = 98
                ExplicitWidth = 188
                ExplicitHeight = 98
                inherited lbMeioPagto: TLabel
                  Width = 164
                end
                inherited lbValor: TLabel
                  Left = 10
                  Width = 164
                  ExplicitLeft = 110
                end
              end
            end
          end
          object pAcoes: TPanel
            Left = 0
            Top = 146
            Width = 1180
            Height = 46
            Margins.Left = 8
            Margins.Top = 0
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alBottom
            BevelOuter = bvNone
            Caption = 'pAcoes'
            ShowCaption = False
            TabOrder = 1
            ExplicitWidth = 1176
            object btnCriarSangria: TButton
              AlignWithMargins = True
              Left = 387
              Top = 8
              Width = 121
              Height = 38
              Cursor = crHandPoint
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 8
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Sangria'
              TabOrder = 3
              OnClick = btnCriarMovimentoClick
            end
            object btnCriarReforco: TButton
              AlignWithMargins = True
              Left = 258
              Top = 8
              Width = 121
              Height = 38
              Cursor = crHandPoint
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 8
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Refor'#231'o'
              TabOrder = 2
              OnClick = btnCriarMovimentoClick
            end
            object btnFechamento: TButton
              AlignWithMargins = True
              Left = 129
              Top = 8
              Width = 121
              Height = 38
              Cursor = crHandPoint
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 8
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Fechamento'
              TabOrder = 1
              OnClick = btnFechamentoClick
            end
            object btnAbertura: TButton
              AlignWithMargins = True
              Left = 0
              Top = 8
              Width = 121
              Height = 38
              Cursor = crHandPoint
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 8
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Abertura'
              TabOrder = 0
              OnClick = btnAberturaClick
            end
            object btnAtualizar: TButton
              AlignWithMargins = True
              Left = 516
              Top = 8
              Width = 121
              Height = 38
              Cursor = crHandPoint
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 8
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Atualizar Lista'
              TabOrder = 4
              OnClick = btnAtualizarClick
            end
          end
          object pDados: TPanel
            Left = 0
            Top = 0
            Width = 1180
            Height = 38
            Align = alTop
            BevelOuter = bvNone
            Caption = 'pDados'
            ShowCaption = False
            TabOrder = 2
            ExplicitWidth = 1176
            object Label4: TLabel
              AlignWithMargins = True
              Left = 0
              Top = 8
              Width = 84
              Height = 22
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 4
              Margins.Bottom = 8
              Align = alLeft
              Caption = 'C'#243'd. Caixa:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
              Layout = tlCenter
              ExplicitHeight = 21
            end
            object dbtCOD_CAIXA: TDBText
              AlignWithMargins = True
              Left = 88
              Top = 8
              Width = 106
              Height = 22
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 4
              Margins.Bottom = 8
              Align = alLeft
              AutoSize = True
              DataField = 'COD_CAIXA'
              DataSource = dsCaixa
              ExplicitHeight = 21
            end
            object dbtCOD_SIT: TDBText
              AlignWithMargins = True
              Left = 276
              Top = 8
              Width = 90
              Height = 22
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 4
              Margins.Bottom = 8
              Align = alLeft
              AutoSize = True
              DataField = 'COD_SIT'
              DataSource = dsCaixa
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
              ExplicitHeight = 21
            end
            object Label5: TLabel
              AlignWithMargins = True
              Left = 202
              Top = 8
              Width = 70
              Height = 22
              Margins.Left = 4
              Margins.Top = 8
              Margins.Right = 4
              Margins.Bottom = 8
              Align = alLeft
              Caption = 'Situa'#231#227'o:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
              Layout = tlCenter
              ExplicitHeight = 21
            end
            object Label6: TLabel
              AlignWithMargins = True
              Left = 374
              Top = 8
              Width = 85
              Height = 22
              Margins.Left = 4
              Margins.Top = 8
              Margins.Right = 4
              Margins.Bottom = 8
              Align = alLeft
              Caption = 'Dat. Abert.:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
              Layout = tlCenter
              ExplicitHeight = 21
            end
            object dbtDAT_ABERT: TDBText
              AlignWithMargins = True
              Left = 463
              Top = 8
              Width = 102
              Height = 22
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 4
              Margins.Bottom = 8
              Align = alLeft
              AutoSize = True
              DataField = 'DAT_ABERT'
              DataSource = dsCaixa
              ExplicitHeight = 21
            end
            object Label7: TLabel
              AlignWithMargins = True
              Left = 573
              Top = 8
              Width = 73
              Height = 22
              Margins.Left = 4
              Margins.Top = 8
              Margins.Right = 4
              Margins.Bottom = 8
              Align = alLeft
              Caption = 'Vr. Abert.:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
              Layout = tlCenter
              ExplicitHeight = 21
            end
            object dbtVR_ABERT: TDBText
              AlignWithMargins = True
              Left = 650
              Top = 8
              Width = 94
              Height = 22
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 4
              Margins.Bottom = 8
              Align = alLeft
              AutoSize = True
              DataField = 'VR_ABERT'
              DataSource = dsCaixa
              ExplicitHeight = 21
            end
            object Label8: TLabel
              AlignWithMargins = True
              Left = 752
              Top = 8
              Width = 87
              Height = 22
              Margins.Left = 4
              Margins.Top = 8
              Margins.Right = 4
              Margins.Bottom = 8
              Align = alLeft
              Caption = 'Dat. Fecha.:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
              Layout = tlCenter
              ExplicitHeight = 21
            end
            object dbtDAT_FECHA: TDBText
              AlignWithMargins = True
              Left = 843
              Top = 8
              Width = 105
              Height = 22
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 4
              Margins.Bottom = 8
              Align = alLeft
              AutoSize = True
              DataField = 'DAT_FECHA'
              DataSource = dsCaixa
              ExplicitHeight = 21
            end
            object Label9: TLabel
              AlignWithMargins = True
              Left = 956
              Top = 8
              Width = 75
              Height = 22
              Margins.Left = 4
              Margins.Top = 8
              Margins.Right = 4
              Margins.Bottom = 8
              Align = alLeft
              Caption = 'Vr. Fecha.:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Segoe UI'
              Font.Style = [fsBold]
              ParentFont = False
              Layout = tlCenter
              ExplicitHeight = 21
            end
            object dbtVR_FECHA: TDBText
              AlignWithMargins = True
              Left = 1035
              Top = 8
              Width = 97
              Height = 22
              Margins.Left = 0
              Margins.Top = 8
              Margins.Right = 4
              Margins.Bottom = 8
              Align = alLeft
              AutoSize = True
              DataField = 'VR_FECHA'
              DataSource = dsCaixa
              ExplicitHeight = 21
            end
          end
        end
        object pMovimentos: TPanel
          AlignWithMargins = True
          Left = 0
          Top = 257
          Width = 1196
          Height = 246
          Margins.Left = 0
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Movimentos'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          ExplicitWidth = 1192
          ExplicitHeight = 245
          object dbgMovimentos: TDBGrid
            AlignWithMargins = True
            Left = 8
            Top = 8
            Width = 1180
            Height = 230
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
          Width = 1196
          Height = 96
          Align = alTop
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 0
          ExplicitWidth = 1200
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
          Width = 1196
          Height = 399
          Margins.Left = 0
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          Caption = 'Lista de Caixas'
          ShowCaption = False
          TabOrder = 1
          ExplicitWidth = 1200
          ExplicitHeight = 400
          object Panel3: TPanel
            Left = 1
            Top = 367
            Width = 1198
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
              Height = 21
              Margins.Left = 8
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Duplo clique para visualizar detalhes do caixa'
              Layout = tlCenter
            end
          end
          object dbgCaixas: TDBGrid
            AlignWithMargins = True
            Left = 9
            Top = 9
            Width = 1182
            Height = 350
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
    Width = 1220
    ExplicitWidth = 1216
    inherited bvlModeloLinha: TBevel
      Width = 1220
      ExplicitWidth = 878
    end
    inherited lbModeloTitulo: TLabel
      Width = 1180
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
