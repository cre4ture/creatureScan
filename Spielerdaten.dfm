object FRM_Spielerdaten: TFRM_Spielerdaten
  Left = 508
  Top = 195
  BorderStyle = bsDialog
  Caption = 'Playerinfos'
  ClientHeight = 425
  ClientWidth = 343
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
    343
    425)
  PixelsPerInch = 96
  TextHeight = 13
  object LBL_PlayerI1: TLabel
    Left = 4
    Top = 4
    Width = 331
    Height = 29
    AutoSize = False
    Caption = 
      'Gib diese Daten bitte vollst'#228'ndig und korrekt an, sie k'#246'nnen sp'#228 +
      'ter nurnoch bedingt ge'#228'ndert werden!'
    WordWrap = True
  end
  object ed: TGroupBox
    Left = 4
    Top = 36
    Width = 331
    Height = 275
    Caption = ' OGame '
    TabOrder = 0
    object LBL_PlayerI2: TLabel
      Left = 48
      Top = 59
      Width = 109
      Height = 13
      Caption = 'Name des Universums:'
    end
    object LBL_PlayerI3: TLabel
      Left = 48
      Top = 102
      Width = 51
      Height = 13
      Caption = 'Parameter:'
    end
    object lbl_Speedfaktor: TLabel
      Left = 48
      Top = 145
      Width = 61
      Height = 13
      Hint = 'auch Bruchzahlen m'#246'glich'
      Alignment = taRightJustify
      Caption = 'Speedfaktor:'
    end
    object Label1: TLabel
      Left = 48
      Top = 169
      Width = 94
      Height = 13
      Hint = 'auch Bruchzahlen m'#246'glich'
      Alignment = taRightJustify
      Caption = 'TF Berechnung (%):'
    end
    object Label2: TLabel
      Left = 48
      Top = 13
      Width = 201
      Height = 13
      Caption = 'OGame Domainname (ohne http://www. !)'
    end
    object CB_OGame_Site: TComboBox
      Left = 48
      Top = 32
      Width = 201
      Height = 21
      Hint = 
        'w'#228'hle hier ob du in den deutschen Unis (ogame.de) oder in den en' +
        'lischen (ogame.or) oder.... spielst'
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = CB_OGame_SiteChange
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
      Left = 48
      Top = 210
      Width = 233
      Height = 17
      Caption = '9 Galaxien 499 Sonnensysteme'
      Checked = True
      TabOrder = 6
      TabStop = True
    end
    object RB_GalaCount19: TRadioButton
      Tag = 19
      Left = 48
      Top = 226
      Width = 233
      Height = 17
      Caption = '19 Galaxien 499 Sonnensysteme'
      TabOrder = 7
    end
    object RB_GalaCount50: TRadioButton
      Tag = 50
      Left = 48
      Top = 242
      Width = 233
      Height = 17
      Caption = '50 Galaxien 100 Sonnensysteme'
      TabOrder = 8
    end
    object CH_DefInTF: TCheckBox
      Left = 48
      Top = 190
      Width = 235
      Height = 17
      Caption = 'Verteidigung ins Tr'#252'mmerfeld'
      TabOrder = 5
    end
    object txt_speedfaktor: TEdit
      Left = 214
      Top = 142
      Width = 69
      Height = 21
      TabOrder = 3
      Text = '1.0'
    end
    object cb_TF_calc: TComboBox
      Left = 186
      Top = 163
      Width = 97
      Height = 21
      Hint = 
        'Wieviel Prozent der Kosten einer Flotte kommen ins TF? (auch bel' +
        'iebige Werte m'#246'glich)'
      ItemHeight = 13
      TabOrder = 4
      Text = '30 (default)'
      Items.Strings = (
        '30 (default)'
        '70 (de - Uni70)')
    end
    object cb_redesign: TCheckBox
      Left = 48
      Top = 119
      Width = 233
      Height = 17
      Caption = 'Redesign (Andromeda, Barym, ...)'
      TabOrder = 2
    end
    object CB_OGame_Universename: TComboBox
      Left = 48
      Top = 75
      Width = 201
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      OnChange = E_UniChange
    end
    object btn_update: TButton
      Left = 256
      Top = 40
      Width = 49
      Height = 49
      Caption = 'Update'
      TabOrder = 9
      OnClick = btn_updateClick
    end
  end
  object BTN_OK: TButton
    Left = 258
    Top = 392
    Width = 77
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = BTN_OKClick
  end
  object BTN_Abbrechen: TButton
    Left = 178
    Top = 392
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
    Top = 317
    Width = 331
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
      Left = 120
      Top = 43
      Width = 3
      Height = 13
      Caption = ':'
    end
    object Label6: TLabel
      Left = 164
      Top = 43
      Width = 3
      Height = 13
      Caption = ':'
    end
    object E_Spielername: TEdit
      Left = 88
      Top = 16
      Width = 233
      Height = 21
      TabOrder = 0
    end
    object E_Gala: TEdit
      Left = 88
      Top = 39
      Width = 29
      Height = 21
      TabOrder = 1
      Text = '0'
      OnKeyPress = E_GalaKeyPress
    end
    object E_System: TEdit
      Left = 124
      Top = 39
      Width = 37
      Height = 21
      TabOrder = 2
      Text = '0'
      OnKeyPress = E_GalaKeyPress
    end
    object E_Planet: TEdit
      Left = 168
      Top = 39
      Width = 29
      Height = 21
      TabOrder = 3
      Text = '0'
      OnKeyPress = E_GalaKeyPress
    end
  end
end
