object frm_sync_cS_db_engine: Tfrm_sync_cS_db_engine
  Left = 249
  Top = 288
  Width = 369
  Height = 372
  Caption = 'Sync mit php...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    361
    347)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 69
    Height = 13
    Caption = 'W'#228'hle Server:'
  end
  object Label2: TLabel
    Left = 8
    Top = 152
    Width = 21
    Height = 13
    Caption = 'Log:'
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 136
    Height = 13
    Caption = 'Zeit bis zum n'#228'chsten Sync: '
  end
  object lbl_countdown: TLabel
    Left = 184
    Top = 72
    Width = 169
    Height = 13
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '<aus>'
  end
  object cb_servers: TComboBox
    Left = 8
    Top = 24
    Width = 191
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    OnChange = cb_serversChange
  end
  object Button1: TButton
    Left = 206
    Top = 24
    Width = 67
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Neu...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 278
    Top = 24
    Width = 75
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Bearbeiten...'
    TabOrder = 2
    OnClick = Button2Click
  end
  object mem_log: TMemo
    Left = 8
    Top = 168
    Width = 345
    Height = 169
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 122
    Width = 345
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
  end
  object btn_sync: TButton
    Left = 8
    Top = 91
    Width = 345
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'SYNC'
    TabOrder = 5
    OnClick = btn_syncClick
  end
  object cb_default: TCheckBox
    Left = 8
    Top = 49
    Width = 257
    Height = 17
    Caption = 'Auto-sync mit diesem Server (Intervall in Min):'
    TabOrder = 6
    OnClick = cb_defaultClick
  end
  object se_time: TSpinEdit
    Left = 256
    Top = 48
    Width = 97
    Height = 22
    Anchors = [akTop, akRight]
    MaxValue = 0
    MinValue = 0
    TabOrder = 7
    Value = 15
  end
  object tim_start_autosync: TTimer
    Enabled = False
    OnTimer = tim_start_autosyncTimer
    Left = 168
    Top = 120
  end
  object XPManifest1: TXPManifest
    Left = 216
    Top = 120
  end
end
