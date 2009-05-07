object FRM_Spielerdaten: TFRM_Spielerdaten
  Left = 508
  Top = 195
  BorderStyle = bsDialog
  Caption = 'Playerinfos'
  ClientHeight = 308
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnPaint = FormPaint
  DesignSize = (
    301
    308)
  PixelsPerInch = 96
  TextHeight = 13
  object LBL_PlayerI1: TLabel
    Left = 4
    Top = 4
    Width = 293
    Height = 29
    AutoSize = False
    Caption = 
      'Gib diese Daten bitte vollst'#228'ndig und korrekt an, sie k'#246'nnen sp'#228 +
      'ter nurnoch bedingt ge'#228'ndert werden!'
    WordWrap = True
  end
  object GB_PlayerI1: TGroupBox
    Left = 4
    Top = 36
    Width = 293
    Height = 165
    Caption = ' OGame '
    TabOrder = 0
    object LBL_PlayerI2: TLabel
      Left = 8
      Top = 44
      Width = 53
      Height = 13
      Caption = 'Universum:'
    end
    object LBL_PlayerI3: TLabel
      Left = 8
      Top = 72
      Width = 51
      Height = 13
      Caption = 'Parameter:'
    end
    object lbl_Speedfaktor: TLabel
      Left = 148
      Top = 44
      Width = 61
      Height = 13
      Hint = 'auch Bruchzahlen m'#246'glich'
      Alignment = taRightJustify
      Caption = 'Speedfaktor:'
    end
    object Label1: TLabel
      Left = 87
      Top = 68
      Width = 94
      Height = 13
      Hint = 'auch Bruchzahlen m'#246'glich'
      Alignment = taRightJustify
      Caption = 'TF Berechnung (%):'
    end
    object E_Uni: TSpinEdit
      Left = 76
      Top = 40
      Width = 53
      Height = 22
      MaxValue = 2147483647
      MinValue = 1
      TabOrder = 1
      Value = 1
      OnChange = E_UniChange
    end
    object CB_OGame_Language: TComboBox
      Left = 8
      Top = 16
      Width = 277
      Height = 21
      Hint = 
        'w'#228'hle hier ob du in den deutschen Unis (ogame.de) oder in den en' +
        'lischen (ogame.or) oder.... spielst'
      Style = csDropDownList
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Items.Strings = (
        'ogame.de'
        'ogame.org'
        'ogame.fr'
        'ogame.com.tr'
        'ogame.nl'
        'ogame.ru'
        'ogame.dk')
    end
    object RB_GalaCount9: TRadioButton
      Tag = 9
      Left = 8
      Top = 108
      Width = 233
      Height = 17
      Caption = '9 Galaxien 499 Sonnensysteme'
      Checked = True
      TabOrder = 5
      TabStop = True
    end
    object RB_GalaCount19: TRadioButton
      Tag = 19
      Left = 8
      Top = 124
      Width = 233
      Height = 17
      Caption = '19 Galaxien 499 Sonnensysteme'
      TabOrder = 6
    end
    object RB_GalaCount50: TRadioButton
      Tag = 50
      Left = 8
      Top = 140
      Width = 233
      Height = 17
      Caption = '50 Galaxien 100 Sonnensysteme'
      TabOrder = 7
    end
    object CH_DefInTF: TCheckBox
      Left = 8
      Top = 88
      Width = 277
      Height = 17
      Caption = 'Verteidigung ins Tr'#252'mmerfeld'
      TabOrder = 4
    end
    object txt_speedfaktor: TEdit
      Left = 216
      Top = 40
      Width = 69
      Height = 21
      TabOrder = 2
      Text = '1.0'
    end
    object cb_TF_calc: TComboBox
      Left = 188
      Top = 64
      Width = 97
      Height = 21
      Hint = 
        'Wieviel Prozent der Kosten einer Flotte kommen ins TF? (auch bel' +
        'iebige Werte m'#246'glich)'
      ItemHeight = 13
      TabOrder = 3
      Text = '30 (default)'
      Items.Strings = (
        '30 (default)'
        '70 (de - Uni70)')
    end
  end
  object BTN_OK: TButton
    Left = 152
    Top = 278
    Width = 77
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = BTN_OKClick
  end
  object BTN_Abbrechen: TButton
    Left = 72
    Top = 278
    Width = 77
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 204
    Width = 293
    Height = 69
    Caption = ' Spieler: '
    TabOrder = 1
    object LBL_PlayerI4: TLabel
      Left = 8
      Top = 20
      Width = 69
      Height = 13
      Caption = 'Ingame Name:'
    end
    object LBL_PlayerI5: TLabel
      Left = 8
      Top = 44
      Width = 61
      Height = 13
      Caption = 'Hauptplanet:'
    end
    object Label5: TLabel
      Left = 208
      Top = 44
      Width = 3
      Height = 13
      Caption = ':'
    end
    object Label6: TLabel
      Left = 252
      Top = 44
      Width = 3
      Height = 13
      Caption = ':'
    end
    object E_Spielername: TEdit
      Left = 88
      Top = 16
      Width = 197
      Height = 21
      TabOrder = 0
    end
    object E_Gala: TEdit
      Left = 180
      Top = 40
      Width = 25
      Height = 21
      TabOrder = 1
      Text = '0'
      OnKeyPress = E_GalaKeyPress
    end
    object E_System: TEdit
      Left = 212
      Top = 40
      Width = 37
      Height = 21
      TabOrder = 2
      Text = '0'
      OnKeyPress = E_GalaKeyPress
    end
    object E_Planet: TEdit
      Left = 256
      Top = 40
      Width = 29
      Height = 21
      TabOrder = 3
      Text = '0'
      OnKeyPress = E_GalaKeyPress
    end
  end
end
