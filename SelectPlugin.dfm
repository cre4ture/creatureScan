object FRM_SelectPlugin: TFRM_SelectPlugin
  Left = 620
  Top = 839
  BorderStyle = bsDialog
  Caption = 'Plugin-Auswahl'
  ClientHeight = 120
  ClientWidth = 317
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
  DesignSize = (
    317
    120)
  PixelsPerInch = 96
  TextHeight = 13
  object LBL_PluginA1: TLabel
    Left = 4
    Top = 4
    Width = 309
    Height = 53
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Um m'#246'glichst alle Browser und Sprachen zu unterst'#252'tzen, werden P' +
      'lugins f'#252'r das Einlesen der Scanberichte und Sonnensysteme verwe' +
      'ndet!'
    WordWrap = True
  end
  object LBL_PluginA2: TLabel
    Left = 4
    Top = 68
    Width = 32
    Height = 13
    Caption = 'Plugin:'
  end
  object CB_PluginA: TComboBox
    Left = 72
    Top = 64
    Width = 241
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 0
    TabOrder = 0
  end
  object BTN_OK: TButton
    Left = 236
    Top = 90
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = BTN_OKClick
  end
  object BTN_Abbrechen: TButton
    Left = 156
    Top = 90
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
  end
end
