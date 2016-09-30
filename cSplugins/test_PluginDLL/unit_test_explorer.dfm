object frm_unit_test: Tfrm_unit_test
  Left = 0
  Top = 0
  Caption = 'Unit Test Explorer'
  ClientHeight = 553
  ClientWidth = 617
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    617
    553)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 263
    Top = 230
    Width = 34
    Height = 13
    Caption = 'Saved:'
  end
  object lb_tests: TListBox
    Left = 8
    Top = 8
    Width = 121
    Height = 537
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    TabOrder = 0
    OnClick = lb_testsClick
    ExplicitHeight = 335
  end
  object lb_scans: TListBox
    Left = 135
    Top = 128
    Width = 121
    Height = 417
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    TabOrder = 1
    OnClick = lb_scansClick
  end
  inline Frame_Bericht1: TFrame_Bericht
    Left = 263
    Top = 128
    Width = 346
    Height = 417
    HorzScrollBar.Style = ssHotTrack
    VertScrollBar.Style = ssHotTrack
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoScroll = True
    Color = clBlack
    ParentBackground = False
    ParentColor = False
    PopupMenu = Frame_Bericht1.PopupMenu1
    TabOrder = 2
    TabStop = True
    ExplicitLeft = 263
    ExplicitTop = 128
    ExplicitWidth = 346
    ExplicitHeight = 417
    inherited PB_B: TPaintBox
      Width = 346
      ExplicitWidth = 329
    end
    inherited Panel1: TPanel
      Width = 346
      inherited LBL_Raid24_Info: TLabel
        Left = 229
      end
      inherited BTN_Last24: TSpeedButton
        Left = 313
      end
    end
  end
  object Button1: TButton
    Left = 135
    Top = 8
    Width = 122
    Height = 33
    Caption = 'Refresh List'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 135
    Top = 47
    Width = 122
    Height = 33
    Caption = 'Copy to Sources'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 135
    Top = 86
    Width = 74
    Height = 23
    Caption = 'Delete Test'
    TabOrder = 5
    OnClick = Button3Click
  end
end
