inherited ControllerPrecoVenda: TControllerPrecoVenda
  OnCreate = DataModuleCreate
  inherited mtDados: TFDMemTable
    object mtDadosCOD_ITEM: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'd. Item'
      FieldName = 'COD_ITEM'
    end
    object mtDadosDAT_INI: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Data Inicio'
      FieldName = 'DAT_INI'
    end
    object mtDadosVR_VNDA: TFloatField
      DisplayLabel = 'Valor Venda'
      FieldName = 'VR_VNDA'
      DisplayFormat = '#,##0.00'
    end
  end
  object mtPrecoAtual: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 144
    Top = 33
    object mtPrecoAtualCOD_ITEM: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'd. Item'
      FieldName = 'COD_ITEM'
    end
    object mtPrecoAtualDAT_INI: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Data Inicio'
      FieldName = 'DAT_INI'
    end
    object mtPrecoAtualVR_VNDA: TFloatField
      DisplayLabel = 'Valor Venda'
      FieldName = 'VR_VNDA'
      DisplayFormat = '#,##0.00'
    end
  end
end
