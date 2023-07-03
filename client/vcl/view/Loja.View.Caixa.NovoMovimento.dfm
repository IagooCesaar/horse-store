inherited ViewCaixaNovoMovimento: TViewCaixaNovoMovimento
  Caption = 'Criar novo movimento caixa'
  ClientHeight = 209
  ClientWidth = 437
  OnCreate = FormCreate
  ExplicitWidth = 449
  ExplicitHeight = 247
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 437
    Height = 153
    ExplicitWidth = 433
    ExplicitHeight = 152
    object Label1: TLabel
      Left = 10
      Top = 15
      Width = 142
      Height = 21
      Caption = 'Valor do movimento'
    end
    object Label2: TLabel
      Left = 10
      Top = 77
      Width = 82
      Height = 21
      Caption = 'Observa'#231#227'o'
    end
    object edtValor: TEdit
      Left = 10
      Top = 42
      Width = 175
      Height = 29
      TabOrder = 0
    end
    object edtObservacao: TEdit
      Left = 10
      Top = 104
      Width = 423
      Height = 29
      TabOrder = 1
    end
  end
  inherited pModeloBotoes: TCategoryButtons
    Top = 153
    Width = 437
    ExplicitTop = 152
    ExplicitWidth = 433
    inherited btnModeloOk: TButton
      Left = 227
      Caption = 'Ok'
      OnClick = btnModeloOkClick
      ExplicitLeft = 227
      ExplicitTop = 9
    end
    inherited btnModeloCancelar: TButton
      Left = 330
      ExplicitLeft = 326
    end
  end
end
