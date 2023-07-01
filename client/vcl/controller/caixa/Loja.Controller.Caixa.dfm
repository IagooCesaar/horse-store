inherited ControllerCaixa: TControllerCaixa
  Height = 187
  inherited mtDados: TFDMemTable
    object mtDadosCOD_CAIXA: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'd. Caixa'
      FieldName = 'COD_CAIXA'
    end
    object mtDadosCOD_SIT: TStringField
      Alignment = taCenter
      DisplayLabel = 'Situa'#231#227'o'
      FieldName = 'COD_SIT'
    end
    object mtDadosDAT_ABERT: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Data Abertura'
      FieldName = 'DAT_ABERT'
    end
    object mtDadosDAT_FECHA: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Data Fechamento'
      FieldName = 'DAT_FECHA'
    end
    object mtDadosVR_ABERT: TCurrencyField
      DisplayLabel = 'Valor Abertura'
      FieldName = 'VR_ABERT'
      DisplayFormat = 'R$ #,##0.00'
    end
    object mtDadosVR_FECHA: TCurrencyField
      DisplayLabel = 'Valor Fechamento'
      FieldName = 'VR_FECHA'
      DisplayFormat = 'R$ #,##0.00'
    end
  end
  object mtCaixaAberto: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 136
    Top = 32
    object mtCaixaAbertoCOD_CAIXA: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'd. Caixa'
      FieldName = 'COD_CAIXA'
    end
    object mtCaixaAbertoCOD_SIT: TStringField
      Alignment = taCenter
      DisplayLabel = 'Situa'#231#227'o'
      FieldName = 'COD_SIT'
    end
    object mtCaixaAbertoDAT_ABERT: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Data Abertura'
      FieldName = 'DAT_ABERT'
    end
    object mtCaixaAbertoDAT_FECHA: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Data Fechamento'
      FieldName = 'DAT_FECHA'
    end
    object mtCaixaAbertoVR_ABERT: TCurrencyField
      DisplayLabel = 'Valor Abertura'
      FieldName = 'VR_ABERT'
      DisplayFormat = 'R$ #,##0.00'
    end
    object mtCaixaAbertoVR_FECHA: TCurrencyField
      DisplayLabel = 'Valor Fechamento'
      FieldName = 'VR_FECHA'
      DisplayFormat = 'R$ #,##0.00'
    end
  end
  object mtResumoCaixa: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 256
    Top = 32
    object mtResumoCaixaCOD_CAIXA: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'd. Caixa'
      FieldName = 'COD_CAIXA'
    end
    object mtResumoCaixaCOD_SIT: TStringField
      Alignment = taCenter
      DisplayLabel = 'Situa'#231#227'o'
      FieldName = 'COD_SIT'
    end
    object mtResumoCaixaMEIOS_PAGTO: TMemoField
      FieldName = 'MEIOS_PAGTO'
      Visible = False
      BlobType = ftMemo
    end
    object mtResumoCaixaVR_SALDO: TCurrencyField
      DisplayLabel = 'Valor Saldo'
      FieldName = 'VR_SALDO'
      DisplayFormat = 'R$ #,##0.00'
    end
  end
  object mtResumoMeiosPagto: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 256
    Top = 96
    object mtResumoMeiosPagtoCOD_MEIO_PAGTO: TStringField
      Alignment = taCenter
      DisplayLabel = 'Meio Pagamento'
      FieldName = 'COD_MEIO_PAGTO'
      Size = 25
    end
    object mtResumoMeiosPagtoVR_TOTAL: TCurrencyField
      DisplayLabel = 'Valor Total'
      FieldName = 'VR_TOTAL'
      DisplayFormat = 'R$ #,##0.00'
    end
  end
  object mtMovimentos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 136
    Top = 96
    object mtMovimentosCOD_MEIO_PAGTO: TStringField
      Alignment = taCenter
      DisplayLabel = 'Meio Pagamento'
      FieldName = 'COD_MEIO_PAGTO'
      Size = 25
    end
    object mtMovimentosCOD_TIPO_MOV: TStringField
      Alignment = taCenter
      DisplayLabel = 'Tipo Movimento'
      FieldName = 'COD_TIPO_MOV'
      Size = 25
    end
    object mtMovimentosCOD_ORIG_MOV: TStringField
      Alignment = taCenter
      DisplayLabel = 'Origem Movimento'
      FieldName = 'COD_ORIG_MOV'
      Size = 25
    end
    object mtMovimentosVR_MOV: TCurrencyField
      DisplayLabel = 'Valor Movimento'
      FieldName = 'VR_MOV'
      DisplayFormat = 'R$ #,##0.00'
    end
    object mtMovimentosDAT_MOV: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Data Movimento'
      FieldName = 'DAT_MOV'
    end
    object mtMovimentosDSC_OBS: TStringField
      DisplayLabel = 'Observa'#231#227'o'
      FieldName = 'DSC_OBS'
      Size = 60
    end
    object mtMovimentosCOD_MOV: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'd. Movimento'
      FieldName = 'COD_MOV'
    end
    object mtMovimentosCOD_CAIXA: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'd. Caixa'
      FieldName = 'COD_CAIXA'
    end
  end
end
