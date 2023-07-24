inherited ControllerVendas: TControllerVendas
  inherited mtDados: TFDMemTable
    object mtDadosNUM_VNDA: TIntegerField
      DisplayLabel = 'N'#250'm. Venda'
      FieldName = 'NUM_VNDA'
    end
    object mtDadosCOD_SIT: TStringField
      DisplayLabel = 'C'#243'd. Situa'#231#227'o'
      FieldName = 'COD_SIT'
    end
    object mtDadosDAT_INCL: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Dat Inclus'#227'o'
      FieldName = 'DAT_INCL'
    end
    object mtDadosDAT_CONCL: TDateTimeField
      Alignment = taCenter
      AutoGenerateValue = arAutoInc
      DisplayLabel = 'Dat Conclus'#227'o'
      FieldName = 'DAT_CONCL'
    end
    object mtDadosVR_BRUTO: TFloatField
      DisplayLabel = 'Valor Bruto'
      FieldName = 'VR_BRUTO'
      DisplayFormat = '#,##0.00'
    end
    object mtDadosVR_DESC: TFloatField
      DisplayLabel = 'Valor Desconto'
      FieldName = 'VR_DESC'
      DisplayFormat = '#,##0.00'
    end
    object mtDadosVR_TOTAL: TFloatField
      DisplayLabel = 'Valor Total'
      FieldName = 'VR_TOTAL'
      DisplayFormat = '#,##0.00'
    end
  end
  object mtVendas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 136
    Top = 32
    object mtVendasNUM_VNDA: TIntegerField
      DisplayLabel = 'N'#250'm. Venda'
      FieldName = 'NUM_VNDA'
    end
    object mtVendasCOD_SIT: TStringField
      DisplayLabel = 'C'#243'd. Situa'#231#227'o'
      FieldName = 'COD_SIT'
    end
    object mtVendasDAT_INCL: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Dat Inclus'#227'o'
      FieldName = 'DAT_INCL'
    end
    object mtVendasDAT_CONCL: TDateTimeField
      Alignment = taCenter
      AutoGenerateValue = arAutoInc
      DisplayLabel = 'Dat Conclus'#227'o'
      FieldName = 'DAT_CONCL'
    end
    object mtVendasVR_BRUTO: TFloatField
      DisplayLabel = 'Valor Bruto'
      FieldName = 'VR_BRUTO'
      DisplayFormat = '#,##0.00'
    end
    object mtVendasVR_DESC: TFloatField
      DisplayLabel = 'Valor Desconto'
      FieldName = 'VR_DESC'
      DisplayFormat = '#,##0.00'
    end
    object mtVendasVR_TOTAL: TFloatField
      DisplayLabel = 'Valor Total'
      FieldName = 'VR_TOTAL'
      DisplayFormat = '#,##0.00'
    end
  end
  object mtItens: TFDMemTable
    BeforePost = mtItensBeforePost
    BeforeDelete = mtItensBeforeDelete
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 216
    Top = 32
    object mtItensNUM_VNDA: TIntegerField
      DisplayLabel = 'N'#250'm. Venda'
      DisplayWidth = 5
      FieldName = 'NUM_VNDA'
    end
    object mtItensNUM_SEQ_ITEM: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'N'#250'm. Seq.'
      DisplayWidth = 8
      FieldName = 'NUM_SEQ_ITEM'
    end
    object mtItensCOD_ITEM: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'd. Item'
      DisplayWidth = 8
      FieldName = 'COD_ITEM'
    end
    object mtItensNOM_ITEM: TStringField
      DisplayLabel = 'Item'
      DisplayWidth = 40
      FieldName = 'NOM_ITEM'
      Size = 100
    end
    object mtItensCOD_SIT: TStringField
      Alignment = taCenter
      DisplayLabel = 'Situa'#231#227'o'
      DisplayWidth = 15
      FieldName = 'COD_SIT'
      Size = 22
    end
    object mtItensQTD_ITEM: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Quantidade'
      DisplayWidth = 8
      FieldName = 'QTD_ITEM'
      OnChange = mtItensQTD_ITEMChange
    end
    object mtItensVR_PRECO_UNIT: TFloatField
      DisplayLabel = 'Pre'#231'o Unit.'
      DisplayWidth = 10
      FieldName = 'VR_PRECO_UNIT'
      DisplayFormat = '#,##0.00'
    end
    object mtItensVR_BRUTO: TFloatField
      DisplayLabel = 'Valor Bruto'
      DisplayWidth = 10
      FieldName = 'VR_BRUTO'
      DisplayFormat = '#,##0.00'
    end
    object mtItensVR_DESC: TFloatField
      DisplayLabel = 'Valor Desconto'
      DisplayWidth = 10
      FieldName = 'VR_DESC'
      OnChange = mtItensVR_DESCChange
      DisplayFormat = '#,##0.00'
    end
    object mtItensVR_TOTAL: TFloatField
      DisplayLabel = 'Valor Total'
      DisplayWidth = 10
      FieldName = 'VR_TOTAL'
      DisplayFormat = '#,##0.00'
    end
  end
  object mtMeiosPagto: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 296
    Top = 32
    object mtMeiosPagtoNUM_VNDA: TIntegerField
      Alignment = taLeftJustify
      DisplayLabel = 'N'#250'm. Venda'
      FieldName = 'NUM_VNDA'
      Visible = False
    end
    object mtMeiosPagtoNUM_SEQ_MEIO_PAGTO: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'N'#250'm. Seq'
      FieldName = 'NUM_SEQ_MEIO_PAGTO'
    end
    object mtMeiosPagtoCOD_MEIO_PAGTO: TStringField
      DisplayLabel = 'Meio Pagto'
      FieldName = 'COD_MEIO_PAGTO'
    end
    object mtMeiosPagtoQTD_PARC: TIntegerField
      DisplayLabel = 'Qtd Parcelas'
      FieldName = 'QTD_PARC'
    end
    object mtMeiosPagtoVR_TOTAL: TFloatField
      DisplayLabel = 'Valor Total'
      FieldName = 'VR_TOTAL'
      DisplayFormat = '#,##0.00'
    end
  end
end
