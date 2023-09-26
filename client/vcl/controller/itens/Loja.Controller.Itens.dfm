inherited ControllerItens: TControllerItens
  inherited mtDados: TFDMemTable
    BeforePost = mtDadosBeforePost
    OnNewRecord = mtDadosNewRecord
    object mtDadosCOD_ITEM: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'digo'
      FieldName = 'COD_ITEM'
    end
    object mtDadosNOM_ITEM: TStringField
      DisplayLabel = 'Nome'
      DisplayWidth = 40
      FieldName = 'NOM_ITEM'
      Size = 100
    end
    object mtDadosNUM_COD_BARR: TStringField
      DisplayLabel = 'C'#243'd. Barras'
      FieldName = 'NUM_COD_BARR'
      Size = 14
    end
    object mtDadosFLG_PERM_SALD_NEG: TBooleanField
      DisplayLabel = 'Permite Saldo Negativo'
      FieldName = 'FLG_PERM_SALD_NEG'
    end
    object mtDadosFLG_TAB_PRECO: TBooleanField
      DisplayLabel = 'Utiliza Tab. Pre'#231'o'
      FieldName = 'FLG_TAB_PRECO'
    end
  end
end
