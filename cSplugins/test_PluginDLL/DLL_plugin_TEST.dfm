object FRM_MainTest: TFRM_MainTest
  Left = 451
  Top = 206
  Caption = 'DLL_plugin_TEST'
  ClientHeight = 170
  ClientWidth = 485
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 120
    Top = 16
    Width = 19
    Height = 13
    Caption = 'Uni:'
  end
  object Label3: TLabel
    Left = 208
    Top = 16
    Width = 40
    Height = 13
    Caption = 'SaveInf:'
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 101
    Height = 25
    Caption = 'Load plugin'
    TabOrder = 0
    OnClick = Button1Click
  end
  object SE_Uni: TSpinEdit
    Left = 144
    Top = 12
    Width = 57
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 17
  end
  object Edit1: TEdit
    Left = 256
    Top = 12
    Width = 137
    Height = 21
    TabOrder = 2
    Text = 'C:\SaveInf.inf'
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 60
    Width = 477
    Height = 49
    Caption = 'PluginTests'
    TabOrder = 3
    object Button2: TButton
      Left = 8
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Sources'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 88
      Top = 16
      Width = 75
      Height = 25
      Caption = 'System_test'
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 168
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Scan_test'
      TabOrder = 2
      OnClick = Button4Click
    end
    object Button6: TButton
      Left = 248
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Stats_test'
      TabOrder = 3
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 392
      Top = 16
      Width = 75
      Height = 25
      Caption = 'UniCheck'
      TabOrder = 4
      OnClick = Button7Click
    end
  end
  object Button5: TButton
    Left = 400
    Top = 12
    Width = 77
    Height = 21
    Caption = 'PluginOptions'
    TabOrder = 4
    OnClick = Button5Click
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 112
    Width = 477
    Height = 49
    Caption = 'GroupBox2'
    TabOrder = 5
    object Button8: TButton
      Left = 8
      Top = 16
      Width = 75
      Height = 25
      Caption = 'ScanGen'
      TabOrder = 0
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 248
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Phalanx_test'
      TabOrder = 1
      OnClick = Button9Click
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 88
    Top = 8
  end
end
