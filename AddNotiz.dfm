object FRM_AddNotiz: TFRM_AddNotiz
  Left = 441
  Top = 367
  BorderStyle = bsDialog
  Caption = 'Hinzuf'#252'gen einer Notiz'
  ClientHeight = 152
  ClientWidth = 244
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 4
    Top = 56
    Width = 27
    Height = 13
    Caption = 'Notiz:'
  end
  object Label3: TLabel
    Left = 4
    Top = 100
    Width = 47
    Height = 13
    Caption = 'Typ/Icon:'
  end
  object LBL_PLanet: TLabel
    Left = 60
    Top = 5
    Width = 20
    Height = 13
    Caption = 'N/A'
  end
  object LBL_Spieler: TLabel
    Left = 60
    Top = 21
    Width = 20
    Height = 13
    Caption = 'N/A'
  end
  object LBL_Allianz: TLabel
    Left = 60
    Top = 37
    Width = 20
    Height = 13
    Caption = 'N/A'
  end
  object TXT_Notiz: TEdit
    Left = 4
    Top = 72
    Width = 237
    Height = 21
    TabOrder = 0
  end
  object CB_Icon: TComboBox
    Left = 56
    Top = 96
    Width = 185
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 1
  end
  object Button1: TButton
    Left = 168
    Top = 124
    Width = 73
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 88
    Top = 124
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 3
  end
  object RB_Planet: TRadioButton
    Left = 4
    Top = 4
    Width = 57
    Height = 17
    Caption = 'Planet:'
    Checked = True
    TabOrder = 4
    TabStop = True
  end
  object RB_Spieler: TRadioButton
    Left = 4
    Top = 20
    Width = 57
    Height = 17
    Caption = 'Spieler:'
    TabOrder = 5
  end
  object RB_Allianz: TRadioButton
    Left = 4
    Top = 36
    Width = 57
    Height = 17
    Caption = 'Allianz:'
    TabOrder = 6
  end
end
