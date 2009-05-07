object Frame_Bericht: TFrame_Bericht
  Left = 0
  Top = 0
  Width = 453
  Height = 424
  HorzScrollBar.Style = ssHotTrack
  VertScrollBar.Style = ssHotTrack
  AutoScroll = True
  Color = clBlack
  ParentBackground = False
  ParentColor = False
  PopupMenu = PopupMenu1
  TabOrder = 0
  TabStop = True
  OnMouseWheel = FrameMouseWheel
  object PB_B: TPaintBox
    Left = 0
    Top = 13
    Width = 453
    Height = 292
    Align = alTop
    PopupMenu = PopupMenu1
    OnPaint = PB_BPaint
    ExplicitTop = 19
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 453
    Height = 13
    Align = alTop
    BevelOuter = bvNone
    Color = clMaroon
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    Visible = False
    DesignSize = (
      453
      13)
    object LBL_Raid_Info: TLabel
      Left = 36
      Top = 0
      Width = 71
      Height = 13
      BiDiMode = bdLeftToRight
      Caption = 'LBL_Raid_Info'
      ParentBiDiMode = False
    end
    object BTN_nextRaid: TSpeedButton
      Left = 0
      Top = 0
      Width = 33
      Height = 13
      Caption = '---'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = BTN_nextRaidClick
    end
    object LBL_Raid24_Info: TLabel
      Left = 336
      Top = 0
      Width = 83
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'LBL_Raid24_Info'
    end
    object BTN_Last24: TSpeedButton
      Left = 420
      Top = 0
      Width = 33
      Height = 13
      Anchors = [akTop, akRight]
      Caption = '---'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = BTN_Last24Click
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 36
    Top = 16
    object Copy1: TMenuItem
      Caption = 'Copy'
      OnClick = Copy1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object KopiereinTabellenform1: TMenuItem
      Caption = 'Kopiere in Tabellenform'
      OnClick = KopiereinTabellenform1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Ansicht1: TMenuItem
      Caption = 'Ansicht'
      object Normal1: TMenuItem
        Caption = 'Normal'
        Checked = True
        RadioItem = True
        OnClick = Normal1Click
        object Leerstellenweglassen1: TMenuItem
          Caption = 'feste Gr'#246#223'e'
          OnClick = Leerstellenweglassen1Click
        end
      end
      object Raidansicht1: TMenuItem
        Tag = 1
        Caption = 'Raidansicht'
        RadioItem = True
        OnClick = Normal1Click
      end
      object Kurzansicht1: TMenuItem
        Tag = 2
        Caption = 'Kurzansicht'
        RadioItem = True
        OnClick = Normal1Click
      end
    end
    object BerechneRohstoffe1: TMenuItem
      Caption = 'Berechne Rohstoffe'
      ShortCut = 66
      OnClick = BerechneRohstoffe1Click
    end
    object ZeigeProduktion1: TMenuItem
      Caption = 'Zeige Produktion'
      Checked = True
      OnClick = ZeigeProduktion1Click
    end
    object ZeigeSpeicherkapazitt1: TMenuItem
      Caption = 'Zeige Speicherkapazit'#228't'
      OnClick = ZeigeSpeicherkapazitt1Click
    end
  end
  object tim_next_fleet: TTimer
    Interval = 100
    OnTimer = tim_next_fleetTimer
    Left = 4
    Top = 16
  end
  object Timer2: TTimer
    Interval = 5000
    OnTimer = Timer2Timer
    Left = 4
    Top = 60
  end
end
