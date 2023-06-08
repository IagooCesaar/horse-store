inherited ViewConfiguracoes: TViewConfiguracoes
  Caption = 'ViewConfiguracoes'
  OnCreate = FormCreate
  TextHeight = 15
  inherited pModeloClient: TPanel
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 28
      Height = 15
      Caption = 'Tema'
    end
    object cmbTemas: TComboBox
      Left = 9
      Top = 26
      Width = 145
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnSelect = cmbTemasSelect
    end
  end
end
