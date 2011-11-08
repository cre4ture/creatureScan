object Explorer: TExplorer
  Left = 72
  Top = 79
  Caption = 'Galaxie-Explorer'
  ClientHeight = 438
  ClientWidth = 474
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object LBL_SysHead: TLabel
    Left = 0
    Top = 47
    Width = 474
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'LBL_SysHead'
    ExplicitWidth = 68
  end
  object PaintBox1: TPaintBox
    Left = 0
    Top = 29
    Width = 474
    Height = 18
    Align = alTop
    OnClick = PaintBox1DblClick
    OnMouseMove = PaintBox1MouseMove
    OnPaint = PaintBox1Paint
  end
  object VST_System: TVirtualStringTree
    Left = 0
    Top = 60
    Width = 474
    Height = 359
    Align = alClient
    BorderStyle = bsNone
    Color = clBlack
    Colors.HotColor = clHighlightText
    Colors.UnfocusedSelectionColor = clHighlight
    Colors.UnfocusedSelectionBorderColor = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Header.AutoSizeIndex = 6
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
    Header.PopupMenu = VTHeaderPopupMenu1
    HotCursor = crHandPoint
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 1
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toExtendedFocus, toRightClickSelect, toSimpleDrawSelection]
    OnAfterCellPaint = VST_SystemAfterCellPaint
    OnAfterItemErase = VST_SystemAfterItemErase
    OnBeforeCellPaint = VST_SystemBeforeCellPaint
    OnClick = VST_SystemClick
    OnDblClick = VST_SystemDblClick
    OnFocusChanged = VST_SystemFocusChanged
    OnGetText = VST_SystemGetText
    OnPaintText = VST_SystemPaintText
    OnGetPopupMenu = VST_SystemGetPopupMenu
    OnMouseMove = VST_SystemMouseMove
    Columns = <
      item
        Alignment = taCenter
        Position = 0
        Width = 30
        WideText = 'Pos'
      end
      item
        Alignment = taCenter
        Position = 1
        Width = 150
        WideText = 'Planet'
      end
      item
        Position = 2
        Width = 40
        WideText = 'Mond'
      end
      item
        Alignment = taRightJustify
        Position = 3
        Width = 27
        WideText = 'TF'
      end
      item
        Alignment = taCenter
        Position = 4
        Width = 120
        WideText = 'Spieler'
      end
      item
        Alignment = taCenter
        Position = 5
        Width = 70
        WideText = 'Allianz'
      end
      item
        Position = 6
        Width = 37
        WideText = 'Notizen'
      end
      item
        Alignment = taRightJustify
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 7
        WideText = 'Punkte'
      end
      item
        Alignment = taRightJustify
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 8
        WideText = 'Platz'
      end
      item
        Alignment = taRightJustify
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 9
        WideText = 'Flottenpunkte'
      end
      item
        Alignment = taRightJustify
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 10
        WideText = 'Flottenplatz'
      end
      item
        Alignment = taRightJustify
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 11
        WideText = 'Allypunkte'
      end
      item
        Alignment = taRightJustify
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 12
        WideText = 'Allyplatz'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus]
        Position = 13
        WideText = 'PlayerID'
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 474
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    OnResize = Panel1Resize
    object BTN_GalaLeft: TSpeedButton
      Left = 137
      Top = 4
      Width = 21
      Height = 21
      Caption = '<--'
      Flat = True
      OnClick = BTN_GalaLeftClick
    end
    object BTN_SysRight: TSpeedButton
      Left = 308
      Top = 4
      Width = 21
      Height = 21
      Caption = '-->'
      Flat = True
      OnClick = BTN_SysRightClick
    end
    object BTN_GalaRight: TSpeedButton
      Left = 196
      Top = 4
      Width = 21
      Height = 21
      Caption = '-->'
      Flat = True
      OnClick = BTN_GalaRightClick
    end
    object BTN_SysLeft: TSpeedButton
      Left = 252
      Top = 4
      Width = 21
      Height = 21
      Caption = '<--'
      Flat = True
      OnClick = BTN_SysLeftClick
    end
    object SB_PasteScan: TSpeedButton
      Left = 335
      Top = 4
      Width = 126
      Height = 21
      Caption = 'Spios einlesen'
      Flat = True
      OnClick = SB_PasteScanClick
    end
    object SB_Links: TSpeedButton
      Left = 224
      Top = 4
      Width = 21
      Height = 21
      OnClick = SB_LinksClick
    end
    object SB_PasteSystem: TSpeedButton
      Left = 4
      Top = 4
      Width = 126
      Height = 21
      Caption = 'System einlesen'
      Flat = True
      OnClick = SB_PasteSystemClick
    end
    object TXT_Galaxy: TEdit
      Left = 164
      Top = 4
      Width = 29
      Height = 21
      MaxLength = 2
      TabOrder = 0
      Text = '1'
      OnKeyDown = TXT_SonnensystemKeyDown
      OnKeyPress = TXT_GalaxyKeyPress
    end
    object TXT_Sonnensystem: TEdit
      Left = 276
      Top = 4
      Width = 29
      Height = 21
      MaxLength = 3
      TabOrder = 1
      Text = '1'
      OnKeyDown = TXT_SonnensystemKeyDown
      OnKeyPress = TXT_GalaxyKeyPress
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 419
    Width = 474
    Height = 19
    Panels = <
      item
        Width = 60
      end
      item
        Alignment = taCenter
        Width = 483
      end>
    OnMouseDown = StatusBar1MouseDown
  end
  object Edit1: TEdit
    Left = 136
    Top = 108
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit1'
    Visible = False
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 204
    Top = 152
    object Suche1: TMenuItem
      Caption = 'Planeten Suchen ...'
      Default = True
      OnClick = Suche1Click
    end
    object spionage1: TMenuItem
      Caption = 'Spiosonde schicken'
      OnClick = spionage1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Notiz1: TMenuItem
      Caption = 'Notiz...'
      OnClick = Notiz1Click
    end
    object Raid1: TMenuItem
      Caption = 'Raid...'
      OnClick = Raid1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PlayerbeinollexdeSuchen1: TMenuItem
      Caption = 'Player bei nolleX.de suchen'
      OnClick = PlayerbeinollexdeSuchen1Click
    end
    object Allybeinollexdesuchen1: TMenuItem
      Caption = 'Ally bei nolleX.de suchen'
      OnClick = Allybeinollexdesuchen1Click
    end
    object Playernamenkopieren1: TMenuItem
      Caption = 'Playernamen kopieren'
      OnClick = Playernamenkopieren1Click
    end
    object ZuFavoriten1: TMenuItem
      Caption = 'Zu Favoriten'
      OnClick = ZuFavoriten1Click
    end
  end
  object IL_Explorer_symbols: TImageList
    Left = 236
    Top = 152
    Bitmap = {
      494C010101000400140010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000A69A8D00332D
      2400513D28008D88820000000000000000000000000000000000FFFEFE00F3EF
      EA00F0E5DA00F7F0EA00FEFEFD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B4B1AD00948C8300362F
      240021120200ACA6A1000000000000000000D6CEC500AC937A008E653C00B972
      2C00DA863100E2872D00E6984C00FCEFE2000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000635648000C080100251D
      1200160C0000938B8200DAD5CF0065544300512E0C00A25F1E00E2883100E78F
      3A00E58D3800E58C3600E78F3900EEB882000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F8F6F600918476003523
      1000140B010042382D00452A0F004B2A0800C2712100DF873100E1893300DA85
      3000D1843800E8944200E9954400F2BE8B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFC00A1948700C2B2A3001610
      0600090800000A0800004F2D09008F51130064380C00B4723000D7883B00E897
      4800DB924800E5924100EA994A00F7D6B7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EEEAE600765C4400A08A7300271E
      10000C0A0000814F1E00E3AC7500683C11006A3F1400E1944700EA9A4C00DD90
      4500E79F5600ED9F5400EBA25B00FAF1E9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E5E1DD0085705B002113
      0300794D2000CE955C00F8E8DA00C78E5600DA8A3C00E7944200EA9A4E00D996
      5400ECA05500EEA96600F6D2AE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FBFAF900563F27005935
      1200BC6D2100CE8A4800E1B78E0093633300AC682500E6964700EA9D5300D189
      4400ED9F5400F0B27500FEFCF800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B8ADA200522F0E009F5A
      1800A0581200B7691D00BB763200C8894B00DA955000E2944900E1974E00CD87
      4300EFAC6900FBEBDC0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007E664D00774514009351
      1000A75D1400B3651800AB621A00C9782A00DA975600A7794B007E522800E4A4
      6400F9E3CD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F1EFED006A41180076410D007B44
      0C009B551200AB5F1400A6601A00C16F1F00CB7C3000BA814A00CC915600F5D4
      B400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CBBFB300623A120067390B006B3B
      0B008A4C0F008C4F1300A05F1E00AC692800C77A3000E28D3800F0CDAA000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C5B19D0046280900542E09006C3C
      0C0074400D0080470E00894C1100A15A1500C3793000F4DCC400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D1C6BC00371D0800422408004B29
      080056300900723F0D00874C1100B9885800F4E9DF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F4F1EF00432E1A00391F08004325
      08004C2A0800855D3400DCCBBA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7E3DF00ACA19800B1A4
      9700D9D0C7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00C3C10000000000008300000000000000
      8000000000000000800000000000000000000000000000000000000000000000
      8001000000000000800100000000000080030000000000008007000000000000
      000F000000000000001F000000000000003F000000000000007F000000000000
      01FF00000000000087FF00000000000000000000000000000000000000000000
      000000000000}
  end
  object PM_Notizen: TPopupMenu
    Images = FRM_Notizen.ImageList1
    Left = 268
    Top = 152
    object musternotiz1: TMenuItem
      Caption = 'muster_notiz'
      OnClick = musternotiz1Click
    end
  end
  object pop_Links: TPopupMenu
    OnPopup = pop_LinksPopup
    Left = 232
    Top = 12
    object Lesezeichenhinzufgen1: TMenuItem
      Caption = 'Lesezeichen hinzuf'#252'gen...'
      OnClick = Lesezeichenhinzufgen1Click
    end
    object Bearbeiten1: TMenuItem
      Caption = 'Lesezeichen bearbeiten...'
      OnClick = Bearbeiten1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object ffneSysteminOGame1: TMenuItem
      Caption = #246'ffne System in OGame'
      OnClick = ffneSysteminOGame1Click
    end
    object folgeeingelesenenSystemen1: TMenuItem
      Caption = 'folge eingelesenen Systemen'
      OnClick = folgeeingelesenenSystemen1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
  end
  object VTHeaderPopupMenu1: TVTHeaderPopupMenu
    Left = 48
    Top = 88
  end
  object IL_ScanSize: TImageList
    Height = 13
    Width = 6
    Left = 144
    Top = 196
    Bitmap = {
      494C010106000900140006000D00FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000180000001A0000000100200000000000C009
      0000000000000000000000000000000000008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000008080800080808000FF000000FF000000FF000000FF0000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000008080800080808000FF000000FF000000FF000000FF0000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FF000000FF000000FF00
      0000FF0000008080800080808000FF000000FF000000FF000000FF0000008080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FF000000FF000000FF00
      0000FF0000008080800080808000FF000000FF000000FF000000FF0000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FF000000FF000000FF00
      0000FF0000008080800080808000FF000000FF000000FF000000FF0000008080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FF000000FF000000FF00
      0000FF0000008080800080808000FF000000FF000000FF000000FF0000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FF000000FF000000FF00
      0000FF0000008080800080808000FF000000FF000000FF000000FF0000008080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000FF000000FF000000FF00
      0000FF0000008080800080808000FF000000FF000000FF000000FF0000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      800080808000000000000000000000000000000000008080800080808000FF00
      0000FF000000FF000000FF000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      800080808000000000000000000000000000000000008080800080808000FF00
      0000FF000000FF000000FF000000808080000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      800080808000FF000000FF000000FF000000FF0000008080800080808000FF00
      0000FF000000FF000000FF000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      800080808000FF000000FF000000FF000000FF0000008080800080808000FF00
      0000FF000000FF000000FF000000808080000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      800080808000808080008080800080808000424D3E000000000000003E000000
      28000000180000001A0000000100010000000000680000000000000000000000
      000000000000000000000000FFFFFF0000000000780000007800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FC000000FDE79E00FDE79E00FC000000FDE79E00FDE79E00FC000000
      FDE78000FDE78000FC000000FDE00000FDE00000FC0000000000000000000000
      0000000000000000000000000000}
  end
end
