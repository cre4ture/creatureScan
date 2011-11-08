object FRM_SelectLanguage: TFRM_SelectLanguage
  Left = 484
  Top = 469
  BorderStyle = bsDialog
  Caption = 'Sprachauswahl'
  ClientHeight = 93
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LBL_SprachA1: TLabel
    Left = 8
    Top = 8
    Width = 95
    Height = 13
    Caption = 'language / Sprache'
  end
  object LBL_SprachA2: TLabel
    Left = 8
    Top = 32
    Width = 257
    Height = 26
    AutoSize = False
    Caption = 
      'HINWEIS: Die Sprache des creatureScan ist unabh'#228'ngig von der Spr' +
      'ache des Spiels!'
    WordWrap = True
  end
  object CB_SprachA: TComboBox
    Left = 108
    Top = 4
    Width = 161
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = CB_SprachAChange
  end
  object BTN_OK: TButton
    Left = 192
    Top = 64
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = BTN_OKClick
  end
  object BTN_Abbrechen: TButton
    Left = 112
    Top = 64
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
  end
end
