inherited ControllerEstoqueSaldo: TControllerEstoqueSaldo
  inherited mtDados: TFDMemTable
    object mtDadosCOD_ITEM: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'digo'
      FieldName = 'COD_ITEM'
    end
    object mtDadosQTD_SALDO_ATU: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Saldo Atual'
      FieldName = 'QTD_SALDO_ATU'
    end
    object mtDadosULTIMO_MOVIMENTOS: TMemoField
      FieldName = 'ULTIMO_MOVIMENTOS'
      Visible = False
      BlobType = ftMemo
    end
    object mtDadosULTIMO_FECHAMENTO: TMemoField
      FieldName = 'ULTIMO_FECHAMENTO'
      Visible = False
      BlobType = ftMemo
    end
  end
  object mtUltFecha: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 160
    Top = 32
    object mtUltFechaCOD_FECH_SALDO: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'd. Fechamento'
      FieldName = 'COD_FECH_SALDO'
    end
    object mtUltFechaCOD_ITEM: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'digo Item'
      FieldName = 'COD_ITEM'
    end
    object mtUltFechaQTD_SALDO: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Qtd. Saldo'
      FieldName = 'QTD_SALDO'
    end
    object mtUltFechaDAT_SALDO: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Data Saldo'
      DisplayWidth = 18
      FieldName = 'DAT_SALDO'
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
    Left = 256
    Top = 32
    object mtMovimentosCOD_ITEM: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'digo Item'
      FieldName = 'COD_ITEM'
    end
    object mtMovimentosQTD_MOV: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Qtd. Movimento'
      FieldName = 'QTD_MOV'
    end
    object mtMovimentosDAT_MOV: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Data Movimento'
      FieldName = 'DAT_MOV'
    end
    object mtMovimentosCOD_TIPO_MOV: TStringField
      Alignment = taCenter
      DisplayLabel = 'Tipo Movimento'
      DisplayWidth = 15
      FieldName = 'COD_TIPO_MOV'
      Size = 15
    end
    object mtMovimentosCOD_ORIG_MOV: TStringField
      Alignment = taCenter
      DisplayLabel = 'Origem Movimento'
      FieldName = 'COD_ORIG_MOV'
    end
    object mtMovimentosDSC_MOT: TStringField
      DisplayLabel = 'Motivo'
      DisplayWidth = 12
      FieldName = 'DSC_MOT'
      Size = 40
    end
    object mtMovimentosCOD_MOV: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'C'#243'digo Mov.'
      FieldName = 'COD_MOV'
    end
  end
end
