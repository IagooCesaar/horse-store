inherited ViewConsultaPrecoVenda: TViewConsultaPrecoVenda
  Caption = 'Consulta de Pre'#231'o'
  ClientHeight = 494
  ClientWidth = 923
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 935
  ExplicitHeight = 532
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 923
    Height = 438
    object pItem: TPanel
      Left = 0
      Top = 0
      Width = 923
      Height = 145
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pItem'
      ShowCaption = False
      TabOrder = 0
      ExplicitWidth = 919
      object Label1: TLabel
        Left = 10
        Top = 15
        Width = 50
        Height = 21
        Caption = 'C'#243'digo'
      end
      object Label2: TLabel
        Left = 137
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
        Caption = 'Pre'#231'o Atual'
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
        DataField = 'VR_VNDA'
        DataSource = dsPrecoAtual
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
    end
    object pcPrecos: TPageControl
      AlignWithMargins = True
      Left = 10
      Top = 155
      Width = 903
      Height = 273
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      ActivePage = tsHistorico
      Align = alClient
      TabOrder = 1
      OnChange = pcPrecosChange
      ExplicitWidth = 899
      ExplicitHeight = 272
      object tsHistorico: TTabSheet
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Caption = ':: Hist'#243'rico de Pre'#231'os  '
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 895
          Height = 44
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 0
          object Label5: TLabel
            Left = 10
            Top = 10
            Width = 219
            Height = 21
            Caption = 'Exibir pre'#231'os v'#225'lidos a partir de:'
          end
          object edtDatIniPrecoVenda: TDateTimePicker
            Left = 235
            Top = 8
            Width = 186
            Height = 29
            Date = 45094.000000000000000000
            Time = 0.671491319444612600
            Kind = dtkDateTime
            TabOrder = 0
            OnChange = edtDatIniPrecoVendaChange
          end
        end
        object dbgHistorico: TDBGrid
          Left = 0
          Top = 44
          Width = 895
          Height = 193
          Align = alClient
          DataSource = dsHistoricoPreco
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -16
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
      end
      object tsNovoPreco: TTabSheet
        Caption = ':: Novo Pre'#231'o  '
        ImageIndex = 1
        object Label6: TLabel
          Left = 10
          Top = 10
          Width = 81
          Height = 21
          Caption = 'Novo pre'#231'o'
        end
        object Label7: TLabel
          Left = 215
          Top = 10
          Width = 98
          Height = 21
          Caption = 'In'#237'cio vig'#234'ncia'
        end
        object btnCadastrar: TButton
          Left = 215
          Top = 88
          Width = 186
          Height = 36
          Cursor = crHandPoint
          Caption = 'Cadastrar novo pre'#231'o'
          TabOrder = 0
          OnClick = btnCadastrarClick
        end
        object dbVR_VNDA: TDBEdit
          Left = 10
          Top = 37
          Width = 199
          Height = 29
          DataField = 'VR_VNDA'
          DataSource = dsNovoPreco
          TabOrder = 1
        end
        object edtDatIniVig: TDateTimePicker
          Left = 215
          Top = 37
          Width = 186
          Height = 29
          Date = 45094.000000000000000000
          Time = 0.671491319444612600
          Kind = dtkDateTime
          TabOrder = 2
        end
      end
    end
  end
  inherited pModeloBotoes: TCategoryButtons
    Top = 438
    Width = 923
    inherited btnModeloOk: TButton
      Visible = False
    end
    inherited btnModeloCancelar: TButton
      Caption = 'Voltar'
    end
  end
  object dsItem: TDataSource
    Left = 32
    Top = 440
  end
  object dsPrecoAtual: TDataSource
    AutoEdit = False
    Left = 96
    Top = 440
  end
  object dsHistoricoPreco: TDataSource
    AutoEdit = False
    Left = 184
    Top = 440
  end
  object dsNovoPreco: TDataSource
    Left = 280
    Top = 440
  end
end
