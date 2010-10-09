object frm_report_basket: Tfrm_report_basket
  Left = 151
  Top = 234
  Width = 608
  Height = 418
  Caption = 'Mond?Scans Zwischenablage'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    592
    383)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 220
    Height = 13
    Caption = 'Zwischenablage f'#252'r unklare Spionageberichte:'
  end
  object vst_reports: TVirtualStringTree
    Left = 8
    Top = 32
    Width = 217
    Height = 316
    Anchors = [akLeft, akTop, akBottom]
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    TabOrder = 0
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnFocusChanged = vst_reportsFocusChanged
    OnFreeNode = vst_reportsFreeNode
    OnGetText = vst_reportsGetText
    OnGetNodeDataSize = vst_reportsGetNodeDataSize
    Columns = <
      item
        Position = 0
        Width = 80
        WideText = 'Koordinaten'
      end
      item
        Position = 1
        Width = 130
        WideText = 'Einlese-Zeit'
      end>
  end
  object Button1: TButton
    Left = 8
    Top = 353
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Mond!'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 353
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Kein Mond!'
    TabOrder = 2
    OnClick = Button2Click
  end
  inline Frame_Bericht1: TFrame_Bericht
    Left = 232
    Top = 32
    Width = 350
    Height = 316
    HorzScrollBar.Style = ssHotTrack
    VertScrollBar.Style = ssHotTrack
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBlack
    ParentBackground = False
    ParentColor = False
    PopupMenu = Frame_Bericht1.PopupMenu1
    TabOrder = 3
    TabStop = True
    inherited PB_B: TPaintBox
      Width = 350
    end
    inherited Panel1: TPanel
      Width = 350
      inherited LBL_Raid24_Info: TLabel
        Left = 233
      end
      inherited BTN_Last24: TSpeedButton
        Left = 317
      end
    end
  end
end
