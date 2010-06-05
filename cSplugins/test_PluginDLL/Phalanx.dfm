object FRM_Phalanx: TFRM_Phalanx
  Left = 273
  Top = 145
  Width = 698
  Height = 457
  Caption = 'FRM_Phalanx'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    682
    422)
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 96
    Top = 8
    Width = 21
    Height = 21
    Shape = stCircle
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Read'
    TabOrder = 0
    OnClick = Button1Click
  end
  object vst_fleets: TVirtualStringTree
    Left = 8
    Top = 39
    Width = 666
    Height = 209
    Anchors = [akLeft, akTop, akRight, akBottom]
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    TabOrder = 1
    OnFocusChanged = vst_fleetsFocusChanged
    OnGetText = vst_fleetsGetText
    Columns = <
      item
        Position = 0
        Width = 150
        WideText = 'Datum'
      end
      item
        Position = 1
        Width = 100
        WideText = 'StartPos'
      end
      item
        Position = 2
        Width = 100
        WideText = 'ZielPos'
      end
      item
        Position = 3
        Width = 125
        WideText = 'Typ'
      end
      item
        Position = 4
        Width = 100
        WideText = 'Spieler'
      end
      item
        Alignment = taRightJustify
        Position = 5
        Width = 75
        WideText = 'ID'
      end>
  end
  inline Frame_Bericht1: TFrame_Bericht
    Left = 8
    Top = 256
    Width = 668
    Height = 155
    HorzScrollBar.Style = ssHotTrack
    VertScrollBar.Style = ssHotTrack
    Anchors = [akLeft, akRight, akBottom]
    Color = clBlack
    ParentBackground = False
    ParentColor = False
    PopupMenu = Frame_Bericht1.PopupMenu1
    TabOrder = 2
    TabStop = True
    inherited PB_B: TPaintBox
      Width = 651
    end
    inherited Panel1: TPanel
      Width = 651
      inherited LBL_Raid24_Info: TLabel
        Left = 337
      end
      inherited BTN_Last24: TSpeedButton
        Left = 421
      end
    end
  end
  object ComboBox1: TComboBox
    Left = 136
    Top = 8
    Width = 145
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 3
    Text = 'ComboBox1'
    Items.Strings = (
      'fist_none'
      'fist_events'
      'fist_phalanx')
  end
end
