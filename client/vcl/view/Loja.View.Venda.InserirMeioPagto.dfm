inherited ViewVendaInserirMeioPagto: TViewVendaInserirMeioPagto
  Caption = 'Inserir Meio Pagamento'
  ClientHeight = 193
  ClientWidth = 381
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 395
  ExplicitHeight = 229
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 381
    Height = 137
    ExplicitWidth = 379
    ExplicitHeight = 134
    object Label1: TLabel
      Left = 24
      Top = 19
      Width = 117
      Height = 21
      Caption = 'Meio Pagamento'
    end
    object Label2: TLabel
      Left = 24
      Top = 89
      Width = 86
      Height = 21
      Caption = 'Qtd Parcelas'
      FocusControl = dbQTD_PARC
    end
    object Label3: TLabel
      Left = 24
      Top = 54
      Width = 72
      Height = 21
      Caption = 'Valor Total'
      FocusControl = dbVR_TOTAL
    end
    object cmbCOD_MEIO_PAGTO: TDBComboBox
      Left = 147
      Top = 16
      Width = 214
      Height = 29
      DataField = 'COD_MEIO_PAGTO'
      DataSource = dsMeioPagto
      TabOrder = 0
    end
    object dbQTD_PARC: TDBEdit
      Left = 147
      Top = 86
      Width = 214
      Height = 29
      Hint = 
        'Quantidade de Parcelas|Informe a quantidade de parcelas que o Va' +
        'lor Total ser'#225' dividido'
      DataField = 'QTD_PARC'
      DataSource = dsMeioPagto
      TabOrder = 2
      OnEnter = MeuBallonInfoOnEnter
    end
    object dbVR_TOTAL: TDBEdit
      Left = 147
      Top = 51
      Width = 214
      Height = 29
      DataField = 'VR_TOTAL'
      DataSource = dsMeioPagto
      TabOrder = 1
    end
  end
  inherited pModeloBotoes: TCategoryButtons
    Top = 137
    Width = 381
    ExplicitTop = 134
    ExplicitWidth = 379
    inherited btnModeloOk: TButton
      Left = 171
      Caption = 'Ok'
      OnClick = btnModeloOkClick
      ExplicitLeft = 171
      ExplicitTop = 9
    end
    inherited btnModeloCancelar: TButton
      Left = 274
      OnClick = btnModeloCancelarClick
      ExplicitLeft = 272
    end
  end
  object dsMeioPagto: TDataSource
    DataSet = ControllerVendas.mtMeiosPagto
    Left = 32
    Top = 128
  end
end
