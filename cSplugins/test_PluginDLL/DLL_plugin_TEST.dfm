object FRM_MainTest: TFRM_MainTest
  Left = 687
  Top = 502
  Caption = 'DLL_plugin_TEST'
  ClientHeight = 201
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 73
    Width = 32
    Height = 13
    Caption = 'Label1'
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
  object Edit1: TEdit
    Left = 256
    Top = 12
    Width = 137
    Height = 21
    TabOrder = 1
    Text = 'C:\SaveInf.inf'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 92
    Width = 477
    Height = 49
    Caption = 'PluginTests'
    TabOrder = 2
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
      Left = 311
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
    object Button12: TButton
      Left = 249
      Top = 16
      Width = 35
      Height = 25
      Caption = 'UT'
      TabOrder = 5
      OnClick = Button12Click
    end
  end
  object Button5: TButton
    Left = 400
    Top = 12
    Width = 77
    Height = 21
    Caption = 'PluginOptions'
    TabOrder = 3
    OnClick = Button5Click
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 144
    Width = 476
    Height = 49
    Caption = 'GroupBox2'
    TabOrder = 4
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
    object Button11: TButton
      Left = 88
      Top = 16
      Width = 75
      Height = 25
      Caption = 'cshelper_server'
      TabOrder = 2
      OnClick = Button11Click
    end
  end
  object txt_serverURL: TEdit
    Left = 8
    Top = 39
    Width = 469
    Height = 21
    TabOrder = 5
    Text = 'electra.ogame.de'
  end
  object Button10: TButton
    Left = 408
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Button10'
    TabOrder = 6
    OnClick = Button10Click
  end
  object OpenDialog1: TOpenDialog
    Left = 120
    Top = 8
  end
end
