object FRM_Stats: TFRM_Stats
  Left = 524
  Top = 190
  Caption = 'FRM_Stats'
  ClientHeight = 663
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    469
    663)
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 92
    Top = 12
    Width = 17
    Height = 17
    Shape = stEllipse
  end
  object Label1: TLabel
    Left = 279
    Top = 12
    Width = 17
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'typ:'
  end
  object Label2: TLabel
    Left = 116
    Top = 12
    Width = 69
    Height = 13
    Caption = 'Datum/Uhrzeit'
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
  object VST_Stats: TVirtualStringTree
    Left = 8
    Top = 36
    Width = 444
    Height = 601
    Anchors = [akLeft, akTop, akRight, akBottom]
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    TabOrder = 1
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
    OnGetText = VST_StatsGetText
    Columns = <
      item
        Alignment = taRightJustify
        Position = 0
        Width = 35
        WideText = '#'
      end
      item
        Position = 1
        Width = 100
        WideText = 'Name'
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 100
        WideText = 'Punkte'
      end
      item
        Position = 3
        Width = 65
        WideText = 'Ally'
      end
      item
        Alignment = taRightJustify
        Position = 4
        Width = 75
        WideText = 'Elemente'
      end
      item
        Alignment = taRightJustify
        Position = 5
        WideText = 'ID'
      end>
  end
  object ComboBox1: TComboBox
    Left = 307
    Top = 8
    Width = 69
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    Enabled = False
    TabOrder = 2
    Items.Strings = (
      'player'
      'ally')
  end
  object ComboBox2: TComboBox
    Left = 379
    Top = 8
    Width = 73
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    Enabled = False
    TabOrder = 3
    Items.Strings = (
      'points'
      'fleets'
      'research')
  end
end
