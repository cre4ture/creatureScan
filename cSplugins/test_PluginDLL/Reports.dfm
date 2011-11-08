object FRM_ScanGen: TFRM_ScanGen
  Left = 449
  Top = 240
  Width = 269
  Height = 137
  Caption = 'FRM_ScanGen'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 20
    Width = 38
    Height = 13
    Caption = 'Interval:'
  end
  object Label2: TLabel
    Left = 132
    Top = 20
    Width = 40
    Height = 13
    Caption = 'Reports:'
  end
  object SpinEdit1: TSpinEdit
    Left = 12
    Top = 36
    Width = 113
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 1000
    OnChange = SpinEdit1Change
  end
  object CheckBox1: TCheckBox
    Left = 12
    Top = 64
    Width = 73
    Height = 17
    Caption = 'active'
    TabOrder = 1
    OnClick = CheckBox1Click
  end
  object SpinEdit2: TSpinEdit
    Left = 132
    Top = 36
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 1
  end
  object Button1: TButton
    Left = 92
    Top = 64
    Width = 75
    Height = 25
    Caption = '1x'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 68
    Top = 8
  end
end
