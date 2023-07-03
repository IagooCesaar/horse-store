inherited ViewCaixaFechamento: TViewCaixaFechamento
  Caption = 'Fechamento de Caixa'
  ClientHeight = 358
  ClientWidth = 640
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 652
  ExplicitHeight = 396
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 640
    Height = 302
    ExplicitWidth = 632
    ExplicitHeight = 302
    object Label1: TLabel
      Left = 71
      Top = 96
      Width = 223
      Height = 21
      Alignment = taRightJustify
      Caption = 'Valor total de Dinheiro em caixa:'
    end
    object Label2: TLabel
      Left = 109
      Top = 131
      Width = 185
      Height = 21
      Alignment = taRightJustify
      Caption = 'Valor total de PIX recebido:'
    end
    object Label3: TLabel
      Left = 8
      Top = 166
      Width = 286
      Height = 21
      Alignment = taRightJustify
      Caption = 'Valor total compras no Cart'#227'o de Cr'#233'dito:'
    end
    object Label4: TLabel
      Left = 13
      Top = 201
      Width = 281
      Height = 21
      Alignment = taRightJustify
      Caption = 'Valor total compras no Cart'#227'o de D'#233'bito:'
    end
    object Label5: TLabel
      Left = 78
      Top = 236
      Width = 216
      Height = 21
      Alignment = taRightJustify
      Caption = 'Valor total de Cheque em caixa:'
    end
    object pAviso: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 634
      Height = 57
      Align = alTop
      Caption = 'aviso'
      ShowCaption = False
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 911
      object lbAviso: TLabel
        Left = 1
        Top = 1
        Width = 632
        Height = 55
        Align = alClient
        Alignment = taCenter
        Caption = 
          'Nesta etapa voc'#234' dever'#225' somar manualmente os valores recebidos e' +
          ' pagos por meio de pagamento. Estes dados ser'#227'o confrontados com' +
          ' o que est'#225' salvo no sistema'
        Layout = tlCenter
        WordWrap = True
        ExplicitWidth = 1092
        ExplicitHeight = 42
      end
    end
    object edtDinheiro: TEdit
      Left = 300
      Top = 93
      Width = 332
      Height = 29
      TabOrder = 1
      Text = '0'
    end
    object edtPix: TEdit
      Left = 300
      Top = 128
      Width = 332
      Height = 29
      TabOrder = 2
      Text = '0'
    end
    object edtCartaoCredito: TEdit
      Left = 300
      Top = 163
      Width = 332
      Height = 29
      TabOrder = 3
      Text = '0'
    end
    object edtCartaoDebito: TEdit
      Left = 300
      Top = 198
      Width = 332
      Height = 29
      TabOrder = 4
      Text = '0'
    end
    object edtCheque: TEdit
      Left = 300
      Top = 233
      Width = 332
      Height = 29
      TabOrder = 5
      Text = '0'
    end
  end
  inherited pModeloBotoes: TCategoryButtons
    Top = 302
    Width = 640
    ExplicitTop = 434
    ExplicitWidth = 907
    inherited btnModeloOk: TButton
      Left = 430
      Caption = 'OK'
      OnClick = btnModeloOkClick
      ExplicitLeft = 697
    end
    inherited btnModeloCancelar: TButton
      Left = 533
      ExplicitLeft = 800
    end
  end
end
