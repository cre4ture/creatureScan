object FRM_FireFoxOptions: TFRM_FireFoxOptions
  Left = 381
  Top = 309
  Width = 364
  Height = 120
  Caption = 'FireFoxOptions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    356
    86)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 273
    Top = 55
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 193
    Top = 55
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 4
    Width = 345
    Height = 45
    Caption = ' FoxGame (http://foxgame.mozdev.org/)'
    TabOrder = 2
    object CH_FoxGame: TCheckBox
      Left = 12
      Top = 20
      Width = 325
      Height = 17
      Caption = 'Unterst'#252'tzung aktivieren'
      TabOrder = 0
    end
  end
end
