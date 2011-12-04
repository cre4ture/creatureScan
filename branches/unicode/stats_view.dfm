object frm_stats_view: Tfrm_stats_view
  Left = 0
  Top = 0
  Caption = 'frm_stats_view'
  ClientHeight = 467
  ClientWidth = 565
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    565
    467)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object vst_stats: TVirtualStringTree
    Left = 8
    Top = 27
    Width = 549
    Height = 432
    Anchors = [akLeft, akTop, akRight, akBottom]
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    TabOrder = 0
    OnGetText = vst_statsGetText
    ExplicitWidth = 444
    Columns = <
      item
        Alignment = taRightJustify
        Position = 0
        Width = 70
        WideText = 'Platz'
      end
      item
        Position = 1
        Width = 120
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
        Width = 100
        WideText = 'ID'
      end
      item
        Position = 4
        Width = 70
        WideText = 'Ally'
      end
      item
        Alignment = taRightJustify
        Position = 5
        Width = 58
        WideText = 'Mitglieder'
      end>
  end
end
