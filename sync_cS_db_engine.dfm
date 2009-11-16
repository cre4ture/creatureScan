object frm_sync_cS_db_engine: Tfrm_sync_cS_db_engine
  Left = 0
  Top = 0
  Caption = 'Sync mit php...'
  ClientHeight = 228
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    371
    228)
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
    Top = 112
    Width = 21
    Height = 13
    Caption = 'Log:'
  end
  object cb_servers: TComboBox
    Left = 8
    Top = 24
    Width = 209
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 224
    Top = 24
    Width = 57
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Neu...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 288
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
    Top = 132
    Width = 355
    Height = 89
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 82
    Width = 355
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
  end
  object btn_sync: TButton
    Left = 8
    Top = 51
    Width = 355
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'SYNC'
    TabOrder = 5
    OnClick = btn_syncClick
  end
end
