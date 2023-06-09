inherited ViewConfiguracoes: TViewConfiguracoes
  Caption = 'Configura'#231#245'es'
  ClientHeight = 270
  ClientWidth = 444
  OnCreate = FormCreate
  ExplicitWidth = 456
  ExplicitHeight = 308
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 444
    Height = 214
    ExplicitWidth = 444
    ExplicitHeight = 338
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 36
      Height = 21
      Caption = 'Tema'
    end
    object Label2: TLabel
      Left = 8
      Top = 70
      Width = 77
      Height = 21
      Caption = 'URL da API'
    end
    object Label3: TLabel
      Left = 8
      Top = 132
      Width = 57
      Height = 21
      Caption = 'Timeout'
    end
    object cmbTemas: TComboBox
      Left = 8
      Top = 35
      Width = 345
      Height = 29
      Style = csDropDownList
      TabOrder = 0
      OnSelect = cmbTemasSelect
    end
    object edtUrl: TEdit
      Left = 8
      Top = 97
      Width = 345
      Height = 29
      TabOrder = 1
      Text = 'edtUrl'
    end
    object edtTimeout: TEdit
      Left = 8
      Top = 159
      Width = 121
      Height = 29
      NumbersOnly = True
      TabOrder = 2
      Text = 'edtTimeout'
    end
  end
  inherited pModeloBotoes: TCategoryButtons
    Top = 214
    Width = 444
    Color = clBtnShadow
    ExplicitTop = 337
    ExplicitWidth = 440
    inherited btnModeloOk: TButton
      Left = 234
      Caption = 'Aplicar'
      OnClick = btnModeloOkClick
      ExplicitLeft = 230
    end
    inherited btnModeloCancelar: TButton
      Left = 337
      ExplicitLeft = 333
    end
  end
end
