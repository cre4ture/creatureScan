object FRM_SelectUser: TFRM_SelectUser
  Left = 726
  Top = 742
  BorderStyle = bsDialog
  Caption = 'Select user'
  ClientHeight = 145
  ClientWidth = 211
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 65
    Height = 13
    Caption = 'Select a user:'
  end
  object Label2: TLabel
    Left = 16
    Top = 32
    Width = 181
    Height = 29
    AutoSize = False
    Caption = 
      '(to create a new user, simply type the name in the box and press' +
      ' OK)'
    WordWrap = True
  end
  object ComboBox1: TComboBox
    Left = 16
    Top = 64
    Width = 181
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = ComboBox1Change
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 88
    Width = 181
    Height = 17
    Caption = 'don'#39't ask again'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 124
    Top = 108
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 16
    Top = 108
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
