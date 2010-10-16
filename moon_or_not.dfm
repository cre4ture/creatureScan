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
  OnShow = FormShow
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
    PopupMenu = PopupMenu1
    TabOrder = 0
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
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
    Width = 113
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Mond (Strg+M)'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 128
    Top = 353
    Width = 121
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Planet (Strg+P)'
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
  object cb_only_planets: TCheckBox
    Left = 272
    Top = 358
    Width = 297
    Height = 17
    Hint = 'n'#252'tzlich zb. in einem sehr jungen Universum'
    Anchors = [akLeft, akTop, akRight]
    Caption = 'nicht mehr Fragen (alles keine Mondscans)'
    TabOrder = 4
    OnClick = cb_only_planetsClick
  end
  object PopupMenu1: TPopupMenu
    Left = 104
    Top = 144
    object diesisteinMond1: TMenuItem
      Caption = 'dies ist ein Mondscan!'
      ShortCut = 16461
      OnClick = diesisteinMond1Click
    end
    object diesisteinPlanetscan1: TMenuItem
      Caption = 'dies ist ein Planetscan!'
      ShortCut = 16464
      OnClick = diesisteinPlanetscan1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Lschen1: TMenuItem
      Caption = 'L'#246'schen'
      ShortCut = 46
      OnClick = Lschen1Click
    end
    object allemarkieren1: TMenuItem
      Caption = 'Alle markieren'
      ShortCut = 16449
      OnClick = allemarkieren1Click
    end
  end
end
