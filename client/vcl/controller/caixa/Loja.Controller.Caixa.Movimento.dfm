inherited ControllerCaixaMovimento: TControllerCaixaMovimento
  inherited mtDados: TFDMemTable
    object mtDadosCOD_MEIO_PAGTO: TStringField
      Alignment = taCenter
      DisplayLabel = 'Meio Pagamento'
      FieldName = 'COD_MEIO_PAGTO'
      Size = 25
    end
    object mtDadosCOD_TIPO_MOV: TStringField
      Alignment = taCenter
      DisplayLabel = 'Tipo Movimento'
      FieldName = 'COD_TIPO_MOV'
      Size = 25
    end
    object mtDadosCOD_ORIG_MOV: TStringField
      Alignment = taCenter
      DisplayLabel = 'Origem Movimento'
      FieldName = 'COD_ORIG_MOV'
      Size = 25
    end
    object mtDadosVR_MOV: TCurrencyField
      DisplayLabel = 'Valor Movimento'
      FieldName = 'VR_MOV'
      DisplayFormat = 'R$ #,##0.00'
    end
    object mtDadosDAT_MOV: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Data Movimento'
      FieldName = 'DAT_MOV'
    end
    object mtDadosDSC_OBS: TStringField
      DisplayLabel = 'Observa'#231#227'o'
      FieldName = 'DSC_OBS'
      Size = 60
    end
    object mtDadosCOD_MOV: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'd. Movimento'
      FieldName = 'COD_MOV'
    end
    object mtDadosCOD_CAIXA: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'd. Caixa'
      FieldName = 'COD_CAIXA'
    end
  end
end
