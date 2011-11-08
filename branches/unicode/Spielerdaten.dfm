object FRM_Spielerdaten: TFRM_Spielerdaten
  Left = 484
  Top = 212
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
    Height = 277
    Caption = ' OGame '
    TabOrder = 0
    object LBL_PlayerI2: TLabel
      Left = 16
      Top = 67
      Width = 109
      Height = 13
      Caption = 'Name des Universums:'
    end
    object LBL_PlayerI3: TLabel
      Left = 16
      Top = 110
      Width = 51
      Height = 13
      Caption = 'Parameter:'
    end
    object lbl_Speedfaktor: TLabel
      Left = 16
      Top = 129
      Width = 61
      Height = 13
      Hint = 'auch Bruchzahlen m'#246'glich'
      Alignment = taRightJustify
      Caption = 'Speedfaktor:'
    end
    object Label2: TLabel
      Left = 16
      Top = 21
      Width = 201
      Height = 13
      Caption = 'OGame Domainname (ohne http://www. !)'
    end
    object Label3: TLabel
      Left = 232
      Top = 32
      Width = 81
      Height = 49
      Alignment = taCenter
      AutoSize = False
      Caption = 'Dein Uni fehlt? Versuche ein Update:'
      WordWrap = True
    end
    object Label8: TLabel
      Left = 16
      Top = 224
      Width = 113
      Height = 13
      Caption = 'Anzahl Sonnensysteme:'
    end
    object Label9: TLabel
      Left = 16
      Top = 200
      Width = 79
      Height = 13
      Caption = 'Anzahl Galaxien:'
    end
    object Label1: TLabel
      Left = 16
      Top = 176
      Width = 134
      Height = 13
      Caption = '%-Anteil Verteidigung ins TF:'
    end
    object Label7: TLabel
      Left = 16
      Top = 152
      Width = 101
      Height = 13
      Caption = '%-Anteil Flotte ins TF:'
    end
    object CB_OGame_Site: TComboBox
      Left = 16
      Top = 40
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
    object cb_fleet_TF_calc: TComboBox
      Left = 218
      Top = 147
      Width = 97
      Height = 21
      Hint = 
        'Wieviel Prozent der Kosten einer Flotte kommen ins TF? (auch bel' +
        'iebige Werte m'#246'glich)'
      ItemHeight = 13
      TabOrder = 4
      Text = '30 (default)'
      Items.Strings = (
        '30 (normal)')
    end
    object CB_OGame_Universename: TComboBox
      Left = 16
      Top = 83
      Width = 201
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      OnChange = E_UniChange
    end
    object btn_update: TButton
      Left = 240
      Top = 80
      Width = 65
      Height = 25
      Caption = 'Update'
      TabOrder = 2
      OnClick = btn_updateClick
    end
    object cb_def_TF_calc: TComboBox
      Left = 218
      Top = 171
      Width = 97
      Height = 21
      Hint = 
        'Wieviel Prozent der Kosten einer Flotte kommen ins TF? (auch bel' +
        'iebige Werte m'#246'glich)'
      ItemHeight = 13
      TabOrder = 5
      Text = '0 (default)'
      Items.Strings = (
        '0 (normal)')
    end
    object cb_redesign: TCheckBox
      Left = 16
      Top = 247
      Width = 297
      Height = 17
      Caption = 'Redesign vollst'#228'ndig aktiv'
      TabOrder = 8
    end
    object cb_gala_count: TComboBox
      Left = 218
      Top = 195
      Width = 97
      Height = 21
      Hint = 
        'Wieviel Prozent der Kosten einer Flotte kommen ins TF? (auch bel' +
        'iebige Werte m'#246'glich)'
      ItemHeight = 13
      TabOrder = 6
      Text = '9 (normal)'
      Items.Strings = (
        '9 (normal)')
    end
    object cb_solsys_count: TComboBox
      Left = 218
      Top = 219
      Width = 97
      Height = 21
      Hint = 
        'Wieviel Prozent der Kosten einer Flotte kommen ins TF? (auch bel' +
        'iebige Werte m'#246'glich)'
      ItemHeight = 13
      TabOrder = 7
      Text = '499 (normal)'
      Items.Strings = (
        '499 (normal)')
    end
    object cb_speed: TComboBox
      Left = 218
      Top = 123
      Width = 97
      Height = 21
      Hint = 
        'Wieviel Prozent der Kosten einer Flotte kommen ins TF? (auch bel' +
        'iebige Werte m'#246'glich)'
      ItemHeight = 13
      TabOrder = 3
      Text = '1.0'
      Items.Strings = (
        '1.0'
        '2.0'
        '4.0')
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
