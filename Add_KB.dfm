object FRM_Add_Raid: TFRM_Add_Raid
  Left = 793
  Top = 822
  BorderStyle = bsDialog
  Caption = 'Raid hinzuf'#252'gen'
  ClientHeight = 145
  ClientWidth = 473
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
  object Label7: TLabel
    Left = 8
    Top = 112
    Width = 270
    Height = 13
    Caption = 'Hinweis: Die angezeigte Uhrzeit entspricht der Serverzeit!'
  end
  object Label11: TLabel
    Left = 8
    Top = 128
    Width = 123
    Height = 13
    Caption = 'Aktueller Zeitunterschied: '
  end
  object lbl_time_diff: TLabel
    Left = 136
    Top = 128
    Width = 137
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'lbl_time_diff'
  end
  object BTN_OK: TButton
    Left = 384
    Top = 112
    Width = 81
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = BTN_OKClick
  end
  object BTN_Cancel: TButton
    Left = 296
    Top = 112
    Width = 81
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 280
    Top = 4
    Width = 185
    Height = 101
    Caption = ' geplante Beute: '
    TabOrder = 1
    object Label8: TLabel
      Left = 12
      Top = 20
      Width = 28
      Height = 13
      Caption = 'Metall'
    end
    object Label9: TLabel
      Left = 12
      Top = 48
      Width = 30
      Height = 13
      Caption = 'Kristall'
    end
    object Label10: TLabel
      Left = 12
      Top = 76
      Width = 48
      Height = 13
      Caption = 'Deuterium'
    end
    object TXT_Metall: TEdit
      Left = 64
      Top = 16
      Width = 105
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object TXT_Kristall: TEdit
      Left = 64
      Top = 44
      Width = 105
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object TXT_Deuterium: TEdit
      Left = 64
      Top = 72
      Width = 105
      Height = 21
      TabOrder = 2
      Text = '0'
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 4
    Width = 269
    Height = 101
    Caption = ' Raid '
    TabOrder = 0
    object Label3: TLabel
      Left = 152
      Top = 20
      Width = 20
      Height = 13
      Caption = 'Ziel:'
    end
    object Label2: TLabel
      Left = 20
      Top = 20
      Width = 25
      Height = 13
      Caption = 'Start:'
    end
    object Label1: TLabel
      Left = 20
      Top = 48
      Width = 51
      Height = 13
      Caption = 'Ankunft in:'
    end
    object Label4: TLabel
      Left = 108
      Top = 48
      Width = 6
      Height = 13
      Caption = 'h'
    end
    object Label5: TLabel
      Left = 150
      Top = 48
      Width = 16
      Height = 13
      Caption = 'min'
    end
    object Label6: TLabel
      Left = 206
      Top = 48
      Width = 17
      Height = 13
      Caption = 'sec'
    end
    object TXT_Start: TEdit
      Left = 56
      Top = 16
      Width = 73
      Height = 21
      TabOrder = 0
      Text = '1:1:1'
    end
    object TXT_Ziel: TEdit
      Left = 180
      Top = 16
      Width = 77
      Height = 21
      TabOrder = 1
      Text = '1:1:1'
    end
    object cb_ankunftum: TCheckBox
      Left = 12
      Top = 74
      Width = 105
      Height = 17
      Caption = 'oder Ankunft um:'
      TabOrder = 5
      OnClick = cb_ankunftumClick
    end
    object txt_stunde: TEdit
      Left = 76
      Top = 44
      Width = 29
      Height = 21
      TabOrder = 2
      Text = '0'
      OnChange = txt_stundeChange
    end
    object TXT_min: TEdit
      Left = 120
      Top = 44
      Width = 29
      Height = 21
      TabOrder = 3
      Text = '50'
      OnChange = txt_stundeChange
    end
    object TXT_Sec: TEdit
      Left = 176
      Top = 44
      Width = 29
      Height = 21
      TabOrder = 4
      Text = '0'
      OnChange = txt_stundeChange
    end
    object txt_arrival: TEdit
      Left = 128
      Top = 72
      Width = 129
      Height = 21
      TabOrder = 6
      Text = 'txt_arrival'
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 228
    Top = 44
  end
end
