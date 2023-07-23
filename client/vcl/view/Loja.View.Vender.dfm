inherited ViewVender: TViewVender
  Caption = 'Ponto de Venda'
  ClientWidth = 1231
  ExplicitWidth = 1243
  TextHeight = 21
  inherited pModeloClient: TPanel
    Width = 1231
    ExplicitLeft = 0
    ExplicitTop = 57
    ExplicitWidth = 1227
    ExplicitHeight = 548
    object pcPrinc: TPageControl
      Left = 0
      Top = 0
      Width = 1231
      Height = 548
      ActivePage = tsVenda
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 1227
      object tsVenda: TTabSheet
        Caption = 'tsVenda'
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 1223
          Height = 105
          Align = alTop
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 0
          ExplicitWidth = 1219
          object Label1: TLabel
            Left = 16
            Top = 24
            Width = 195
            Height = 21
            Caption = 'C'#243'digo ou C'#243'digo de Barras'
          end
          object sbInserir: TSpeedButton
            Left = 217
            Top = 20
            Width = 137
            Height = 25
            GroupIndex = 1
            Down = True
            Caption = 'Inserir Item'
            ImageIndex = 1
            Images = dmImagens.imgIco16
          end
          object SpeedButton1: TSpeedButton
            Left = 360
            Top = 20
            Width = 137
            Height = 25
            GroupIndex = 1
            Caption = 'Consultar Pre'#231'o'
            ImageIndex = 2
            Images = dmImagens.imgIco16
          end
          object SpeedButton2: TSpeedButton
            Left = 503
            Top = 20
            Width = 137
            Height = 25
            GroupIndex = 1
            Caption = 'Nova Venda'
            ImageIndex = 1
            Images = dmImagens.imgIco16
          end
          object edtPesquisa: TEdit
            Left = 16
            Top = 51
            Width = 624
            Height = 29
            TabOrder = 0
            TextHint = 'Ex: 3 * {C'#243'digo} ir'#225' inserir quantidade 3 do item informado'
          end
        end
      end
      object tsPesquisa: TTabSheet
        Caption = 'tsPesquisa'
        ImageIndex = 1
      end
    end
  end
  inherited pModeloTop: TPanel
    Width = 1231
    ExplicitWidth = 1227
    inherited bvlModeloLinha: TBevel
      Width = 1231
      ExplicitWidth = 1231
    end
    inherited lbModeloTitulo: TLabel
      Width = 1191
      Height = 37
      Caption = 'Ponto de Venda'
      ExplicitWidth = 147
    end
  end
end
