inherited ViewEstoqueConsulta: TViewEstoqueConsulta
  Caption = 'Consulta de Estoque'
  ClientHeight = 366
  ClientWidth = 616
  ExplicitWidth = 632
  ExplicitHeight = 405
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 616
    Height = 310
  end
  inherited pModeloBotoes: TCategoryButtons
    Top = 310
    Width = 616
    inherited btnModeloOk: TButton
      Left = 406
      Visible = False
    end
    inherited btnModeloCancelar: TButton
      Left = 509
      Caption = 'Voltar'
      Visible = False
    end
  end
end
