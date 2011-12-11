object FRM_EditScan: TFRM_EditScan
  Left = 562
  Top = 389
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Add new espionage report....'
  ClientHeight = 315
  ClientWidth = 395
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
    395
    315)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 4
    Width = 30
    Height = 13
    Caption = 'Planet'
  end
  object Label2: TLabel
    Left = 5
    Top = 24
    Width = 37
    Height = 13
    Caption = 'Position'
  end
  object Label3: TLabel
    Left = 5
    Top = 44
    Width = 29
    Height = 13
    Caption = 'Player'
  end
  object Button1: TButton
    Left = 316
    Top = 277
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 240
    Top = 277
    Width = 71
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object TXT_Planet: TEdit
    Left = 52
    Top = 4
    Width = 103
    Height = 21
    TabOrder = 2
  end
  object TXT_Position: TEdit
    Left = 52
    Top = 24
    Width = 103
    Height = 21
    TabOrder = 3
    Text = '1:1:1 M'
  end
  object TXT_Player: TEdit
    Left = 52
    Top = 44
    Width = 103
    Height = 21
    TabOrder = 4
  end
end
