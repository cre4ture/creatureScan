object FRM_Filter: TFRM_Filter
  Left = 428
  Top = 224
  Width = 325
  Height = 266
  Caption = 'Filter'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    309
    231)
  PixelsPerInch = 96
  TextHeight = 13
  object Fav_Pages: TPageControl
    Left = 0
    Top = 0
    Width = 309
    Height = 193
    ActivePage = TS_Koordinaten
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TS_Alter: TTabSheet
      Caption = 'Altersfilter'
      object Label3: TLabel
        Left = 92
        Top = 20
        Width = 28
        Height = 13
        Caption = 'Tage:'
      end
      object Label4: TLabel
        Left = 92
        Top = 44
        Width = 43
        Height = 13
        Caption = 'Stunden:'
      end
      object Label5: TLabel
        Left = 92
        Top = 68
        Width = 41
        Height = 13
        Caption = 'Minuten:'
      end
      object Label2: TLabel
        Left = 4
        Top = 20
        Width = 75
        Height = 13
        Caption = 'maximales Alter:'
      end
      object CH_AltersFilter_active: TCheckBox
        Left = 4
        Top = 0
        Width = 53
        Height = 17
        Caption = 'Aktiv'
        TabOrder = 0
      end
      object TXT_AlterTage: TEdit
        Left = 160
        Top = 16
        Width = 37
        Height = 21
        TabOrder = 1
        Text = '0'
      end
      object TXT_AlterStunden: TEdit
        Left = 160
        Top = 40
        Width = 37
        Height = 21
        TabOrder = 2
        Text = '3'
      end
      object TXT_AlterMinuten: TEdit
        Left = 160
        Top = 64
        Width = 37
        Height = 21
        TabOrder = 3
        Text = '1'
      end
    end
    object TS_Ress: TTabSheet
      Caption = 'Ressourcen'
      ImageIndex = 1
      object LBL_Ges: TLabel
        Left = 4
        Top = 32
        Width = 39
        Height = 13
        Caption = 'mehr als'
      end
      object CH_ges: TCheckBox
        Left = 4
        Top = 4
        Width = 113
        Height = 17
        Caption = 'gesammt (M+K+D):'
        TabOrder = 0
      end
      object TXT_ges: TEdit
        Left = 52
        Top = 28
        Width = 73
        Height = 21
        TabOrder = 1
        Text = '200000'
      end
    end
    object TS_Def_Fleet_Stat: TTabSheet
      Caption = 'Def / Fleet / Status'
      ImageIndex = 2
      object CB_Def: TComboBox
        Left = 100
        Top = 4
        Width = 45
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = '<'
        Items.Strings = (
          '<'
          '>')
      end
      object CH_Def: TCheckBox
        Left = 4
        Top = 4
        Width = 81
        Height = 17
        Caption = 'Verteidigung'
        TabOrder = 1
      end
      object CH_Fleet: TCheckBox
        Left = 4
        Top = 28
        Width = 53
        Height = 17
        Caption = 'Flotte'
        TabOrder = 2
      end
      object CB_Fleet: TComboBox
        Left = 100
        Top = 28
        Width = 45
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 3
        Text = '<'
        Items.Strings = (
          '<'
          '>')
      end
      object TXT_Def: TEdit
        Left = 152
        Top = 4
        Width = 121
        Height = 21
        TabOrder = 4
        Text = '100'
      end
      object TXT_Fleet: TEdit
        Left = 152
        Top = 28
        Width = 121
        Height = 21
        TabOrder = 5
        Text = '100'
      end
      object GroupBox1: TGroupBox
        Left = 4
        Top = 56
        Width = 293
        Height = 61
        Caption = ' Statusfilter '
        TabOrder = 6
        object Label6: TLabel
          Left = 8
          Top = 20
          Width = 96
          Height = 13
          Caption = 'folgende Stati filtern:'
        end
        object Label8: TLabel
          Left = 160
          Top = 40
          Width = 32
          Height = 13
          Caption = 'Label8'
        end
        object TXT_Status_mit: TEdit
          Left = 160
          Top = 16
          Width = 121
          Height = 21
          TabOrder = 0
          OnKeyPress = TXT_Status_mitKeyPress
        end
        object cb_stat_negativ: TCheckBox
          Left = 8
          Top = 36
          Width = 97
          Height = 17
          Caption = 'Filter negativ'
          TabOrder = 1
        end
      end
    end
    object TS_Koordinaten: TTabSheet
      Caption = 'Koordinaten'
      ImageIndex = 3
      object Label11: TLabel
        Left = 4
        Top = 4
        Width = 66
        Height = 13
        Caption = 'Filterbereiche:'
      end
      object Label1: TLabel
        Left = 4
        Top = 84
        Width = 293
        Height = 77
        AutoSize = False
        Caption = 
          'Zum Bearbeiten des Filters, verwende den Haken "aktuellen Filter' +
          ' anzeigen/editieren" im Fenster Universums'#252'bersicht'
        WordWrap = True
      end
      object CB_KoordB: TComboBox
        Left = 4
        Top = 24
        Width = 193
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'area1'
        OnChange = CB_KoordBChange
        Items.Strings = (
          'area1'
          'area2')
      end
      object Button3: TButton
        Left = 108
        Top = 48
        Width = 89
        Height = 25
        Caption = 'L'#246'schen'
        TabOrder = 1
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 4
        Top = 48
        Width = 93
        Height = 25
        Caption = 'Neu'
        TabOrder = 2
        OnClick = Button4Click
      end
    end
  end
  object Button1: TButton
    Left = 229
    Top = 196
    Width = 77
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 149
    Top = 196
    Width = 77
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
  end
end
