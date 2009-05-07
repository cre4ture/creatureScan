object FRM_Scan: TFRM_Scan
  Left = 334
  Top = 174
  Caption = 'FRM_Scan'
  ClientHeight = 434
  ClientWidth = 913
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    913
    434)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 560
    Top = 16
    Width = 20
    Height = 13
    Caption = 'Soll:'
  end
  inline Frame_Bericht1: TFrame_Bericht
    Left = 106
    Top = 34
    Width = 343
    Height = 387
    HorzScrollBar.Style = ssHotTrack
    VertScrollBar.Style = ssHotTrack
    Anchors = [akLeft, akTop, akBottom]
    AutoScroll = True
    Color = clBlack
    ParentBackground = False
    ParentColor = False
    PopupMenu = Frame_Bericht1.PopupMenu1
    TabOrder = 0
    ExplicitLeft = 106
    ExplicitTop = 34
    ExplicitWidth = 343
    ExplicitHeight = 387
    inherited PB_B: TPaintBox
      Width = 343
      Height = 332
      ExplicitWidth = 343
      ExplicitHeight = 332
    end
    inherited Panel1: TPanel
      Width = 343
      ExplicitWidth = 343
      inherited LBL_Raid24_Info: TLabel
        Left = 228
        ExplicitLeft = 228
      end
      inherited BTN_Last24: TSpeedButton
        Left = 312
        ExplicitLeft = 312
      end
    end
  end
  object btn_read: TButton
    Left = 4
    Top = 4
    Width = 96
    Height = 25
    Caption = 'Read'
    TabOrder = 1
    OnClick = btn_readClick
  end
  object ListBox1: TListBox
    Left = 4
    Top = 36
    Width = 97
    Height = 385
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    TabOrder = 2
    OnClick = ListBox1Click
  end
  object VST_tests: TVirtualStringTree
    Left = 455
    Top = 96
    Width = 101
    Height = 325
    Anchors = [akLeft, akTop, akBottom]
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    TabOrder = 3
    OnDblClick = VST_testsDblClick
    OnFreeNode = VST_testsFreeNode
    OnGetText = VST_testsGetText
    Columns = <
      item
        Position = 0
        Width = 67
        WideText = 'Pos'
      end
      item
        Position = 1
        Width = 30
        WideText = 'OK'
      end>
  end
  object Button2: TButton
    Left = 459
    Top = 65
    Width = 45
    Height = 25
    Caption = 'Add'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 510
    Top = 65
    Width = 45
    Height = 25
    Caption = 'Delete'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 168
    Top = 3
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 6
    OnClick = Button4Click
  end
  object SpinEdit1: TSpinEdit
    Left = 248
    Top = 3
    Width = 77
    Height = 22
    MaxValue = 2147483647
    MinValue = 0
    TabOrder = 7
    Value = 0
    OnChange = SpinEdit1Change
  end
  object Button5: TButton
    Left = 328
    Top = 3
    Width = 75
    Height = 25
    Caption = 'Button5'
    TabOrder = 8
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 456
    Top = 34
    Width = 99
    Height = 25
    Caption = 'Teste alle!'
    TabOrder = 9
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 456
    Top = 3
    Width = 99
    Height = 25
    Caption = 'Select Directory'
    TabOrder = 10
    OnClick = Button7Click
  end
  inline Frame_Bericht2: TFrame_Bericht
    Left = 562
    Top = 34
    Width = 343
    Height = 387
    HorzScrollBar.Style = ssHotTrack
    VertScrollBar.Style = ssHotTrack
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoScroll = True
    Color = clBlack
    ParentBackground = False
    ParentColor = False
    PopupMenu = Frame_Bericht1.PopupMenu1
    TabOrder = 11
    ExplicitLeft = 562
    ExplicitTop = 34
    ExplicitWidth = 343
    ExplicitHeight = 387
    inherited PB_B: TPaintBox
      Width = 343
      ExplicitWidth = 451
    end
    inherited Panel1: TPanel
      Width = 343
      ExplicitWidth = 343
      inherited LBL_Raid24_Info: TLabel
        Left = 226
        ExplicitLeft = 228
      end
      inherited BTN_Last24: TSpeedButton
        Left = 310
        ExplicitLeft = 312
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 128
    Top = 65535
  end
end
