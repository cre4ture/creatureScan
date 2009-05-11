object FRM_Main: TFRM_Main
  Left = 676
  Top = 115
  Caption = 'creatureScan'
  ClientHeight = 449
  ClientWidth = 533
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object P_ExplorerDock: TPanel
    Left = 0
    Top = 0
    Width = 533
    Height = 430
    Align = alClient
    BevelOuter = bvNone
    Color = clBlack
    TabOrder = 0
    Visible = False
    OnResize = P_ExplorerDockResize
    inline Frame_Bericht2: TFrame_Bericht
      Left = 0
      Top = 301
      Width = 533
      Height = 129
      HorzScrollBar.Style = ssHotTrack
      VertScrollBar.Style = ssHotTrack
      Align = alBottom
      AutoScroll = True
      Color = clBlack
      ParentBackground = False
      ParentColor = False
      PopupMenu = Frame_Bericht2.PopupMenu1
      TabOrder = 0
      TabStop = True
      ExplicitTop = 301
      ExplicitWidth = 533
      ExplicitHeight = 129
      inherited PB_B: TPaintBox
        Width = 517
        ExplicitWidth = 533
      end
      inherited Panel1: TPanel
        Width = 517
        ExplicitWidth = 517
        inherited LBL_Raid24_Info: TLabel
          Left = 354
          ExplicitLeft = 353
        end
        inherited BTN_Last24: TSpeedButton
          Left = 438
          ExplicitLeft = 437
        end
      end
    end
  end
  object P_Scan: TPanel
    Left = 0
    Top = 0
    Width = 533
    Height = 430
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 429
      Top = 0
      Height = 430
      Align = alRight
      MinSize = 20
      ResizeStyle = rsLine
      ExplicitHeight = 474
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 429
      Height = 430
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      inline Frame_Bericht1: TFrame_Bericht
        Left = 0
        Top = 0
        Width = 429
        Height = 383
        HorzScrollBar.Style = ssHotTrack
        VertScrollBar.Style = ssHotTrack
        Align = alClient
        AutoScroll = True
        Color = clBlack
        ParentBackground = False
        ParentColor = False
        PopupMenu = Frame_Bericht1.PopupMenu1
        TabOrder = 0
        TabStop = True
        OnDblClick = Frame_Bericht1PB_BDblClick
        ExplicitWidth = 429
        ExplicitHeight = 383
        inherited PB_B: TPaintBox
          Width = 429
          OnDblClick = Frame_Bericht1PB_BDblClick
          ExplicitWidth = 429
        end
        inherited Panel1: TPanel
          Width = 429
          ExplicitWidth = 429
          inherited LBL_Raid24_Info: TLabel
            Left = 308
            ExplicitLeft = 308
          end
          inherited BTN_Last24: TSpeedButton
            Left = 396
            ExplicitLeft = 396
          end
        end
        inherited PopupMenu1: TPopupMenu
          Left = 180
          Top = 192
        end
        inherited tim_next_fleet: TTimer
          OnTimer = Frame_Bericht1Timer1Timer
          Left = 12
        end
        inherited Timer2: TTimer
          OnTimer = Frame_Bericht1Timer2Timer
          Left = 12
        end
      end
      object P_WF: TPanel
        Left = 0
        Top = 383
        Width = 429
        Height = 47
        Align = alBottom
        BevelInner = bvLowered
        Color = 9098579
        ParentBackground = False
        TabOrder = 1
        OnResize = P_WFResize
        object LBL_WF_1: TLabel
          Left = 164
          Top = 2
          Width = 93
          Height = 42
          Alignment = taCenter
          AutoSize = False
          WordWrap = True
        end
        object LBL_WF_0_1: TLabel
          Left = 2
          Top = 2
          Width = 159
          Height = 15
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Wellenangriff: (nur Ressourcen!)'
          WordWrap = True
        end
        object LBL_WF_2: TLabel
          Left = 245
          Top = 2
          Width = 93
          Height = 42
          Alignment = taCenter
          AutoSize = False
          WordWrap = True
        end
        object LBL_WF_3: TLabel
          Left = 344
          Top = 2
          Width = 77
          Height = 42
          Alignment = taCenter
          AutoSize = False
          WordWrap = True
        end
        object LBL_WF_0_2: TLabel
          Left = 4
          Top = 16
          Width = 156
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Schlachtschiffe:'
        end
        object LBL_WF_0_3: TLabel
          Left = 4
          Top = 28
          Width = 156
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'gr.Transporter:'
        end
        object btn_fight_start: TButton
          Tag = 2
          Left = 12
          Top = 20
          Width = 61
          Height = 21
          Caption = 'fleet'
          TabOrder = 0
          OnClick = btn_fight_startClick
        end
      end
      object p_startscreen: TPanel
        Left = 0
        Top = 0
        Width = 429
        Height = 383
        Align = alClient
        BevelOuter = bvNone
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnDblClick = Frame_Bericht1PB_BDblClick
        object lbl_title: TLabel
          Left = 8
          Top = 16
          Width = 213
          Height = 39
          Caption = 'creatureScan v'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -32
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label1: TLabel
          Left = 8
          Top = 80
          Width = 24
          Height = 13
          Caption = 'Wiki:'
        end
        object Label2: TLabel
          Left = 104
          Top = 80
          Width = 167
          Height = 13
          Cursor = crHandPoint
          Caption = 'http://creatureScan.creax.de/wiki/'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentFont = False
          OnClick = Label4Click
        end
        object Label3: TLabel
          Left = 8
          Top = 99
          Width = 32
          Height = 13
          Caption = 'Forum:'
        end
        object Label4: TLabel
          Left = 104
          Top = 99
          Width = 144
          Height = 13
          Cursor = crHandPoint
          Caption = 'http://creatureScan.creax.de/'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentFont = False
          OnClick = Label4Click
        end
        object Label5: TLabel
          Left = 8
          Top = 128
          Width = 56
          Height = 13
          Caption = 'Quick Start:'
          Visible = False
        end
        object Label6: TLabel
          Left = 8
          Top = 147
          Width = 263
          Height = 41
          AutoSize = False
          Caption = 
            'Spionageberichte und Sonnensysteme werden automatisch eingelesen' +
            ': Im Browser: Strg+A, Strg+C '
          Visible = False
          WordWrap = True
        end
        object Label7: TLabel
          Left = 8
          Top = 185
          Width = 263
          Height = 31
          AutoSize = False
          Caption = 
            'Mit der Scanliste kann man seine Spionagebrichte verwalten und s' +
            'ortieren.'
          Visible = False
          WordWrap = True
        end
        object Label8: TLabel
          Left = 8
          Top = 222
          Width = 263
          Height = 28
          AutoSize = False
          Caption = 
            'Mit dem Galaxy-Explorer kann man durch die Sonnensysteme klicken' +
            '.'
          Visible = False
          WordWrap = True
        end
        object Label9: TLabel
          Left = 8
          Top = 256
          Width = 263
          Height = 41
          AutoSize = False
          Caption = 'Die Spionageberichte werden dann hier im Hauptfenster angezeigt.'
          Visible = False
          WordWrap = True
        end
      end
    end
    object Panel1: TPanel
      Left = 432
      Top = 0
      Width = 101
      Height = 430
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        101
        430)
      object lst_others: TListView
        Left = 3
        Top = 63
        Width = 96
        Height = 297
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            AutoSize = True
            Caption = 'Scans vom Plani'
          end>
        HideSelection = False
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        PopupMenu = PopupMenu1
        SmallImages = IL_ScanSize
        SortType = stData
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = lst_othersColumnClick
        OnCompare = lst_othersCompare
        OnKeyDown = lst_othersKeyDown
        OnSelectItem = lst_othersSelectItem
      end
      object BTN_Paste: TButton
        Left = 2
        Top = 3
        Width = 96
        Height = 26
        Anchors = [akLeft, akTop, akRight]
        Caption = '&paste Scans'
        TabOrder = 1
        OnClick = BTN_PasteClick
      end
      object BTN_Copy: TButton
        Left = 2
        Top = 32
        Width = 96
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Caption = 'C&opy'
        TabOrder = 2
        OnClick = BTN_CopyClick
      end
      object BTN_Liste: TButton
        Left = 2
        Top = 360
        Width = 96
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Scan &Liste'
        TabOrder = 3
        OnClick = BTN_ListeClick
      end
      object BTN_Suche: TButton
        Left = 2
        Top = 408
        Width = 96
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Su&chen'
        TabOrder = 5
        OnClick = BTN_SucheClick
      end
      object BTN_Universum: TButton
        Left = 2
        Top = 384
        Width = 96
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        Caption = '&Universum'
        TabOrder = 4
        OnClick = BTN_UniversumClick
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 430
    Width = 533
    Height = 19
    Panels = <
      item
        Text = '<topmost>'
        Width = 60
      end
      item
        Text = '0'
        Width = 0
      end
      item
        Text = 'Count'
        Width = 110
      end
      item
        Text = 'Systeme'
        Width = 110
      end
      item
        Width = 500
      end>
    OnMouseDown = StatusBar1MouseDown
    OnDrawPanel = StatusBar1DrawPanel
  end
  object MainMenu1: TMainMenu
    Left = 284
    Top = 44
    object Datenbank1: TMenuItem
      Caption = '&Datenbank'
      ShortCut = 16453
      object Einstellungen1: TMenuItem
        Caption = 'Einstellungen'
        ShortCut = 16463
        OnClick = Einstellungen1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Export1: TMenuItem
        Caption = 'Export in Datei'
        ShortCut = 16453
        OnClick = Export1Click
      end
      object Import2: TMenuItem
        Caption = 'Import aus Datei'
        ShortCut = 16457
        OnClick = Import2Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object alsandererBenutzerneustarten1: TMenuItem
        Caption = 'als anderer Benutzer neustarten'
        ShortCut = 49218
        OnClick = alsandererBenutzerneustarten1Click
      end
      object Beenden1: TMenuItem
        Caption = 'Beenden'
        ShortCut = 16450
        OnClick = Beenden1Click
      end
    end
    object Statistiken1: TMenuItem
      Caption = 'Statistiken'
      object Einlesen1: TMenuItem
        Caption = 'Einlesen...'
        ShortCut = 16468
        OnClick = Einlesen1Click
      end
    end
    object Fenster1: TMenuItem
      Caption = '&Fenster'
      object NeuerGalaxyExplorer1: TMenuItem
        Caption = 'extra Galaxieansicht'
        ShortCut = 16455
        OnClick = NeuerGalaxyExplorer1Click
      end
      object neueSuche1: TMenuItem
        Caption = 'neue Suche...'
        ShortCut = 16454
        OnClick = neueSuche1Click
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object NetConnections1: TMenuItem
        Caption = 'Netz-Syncronisation'
        ShortCut = 16459
        OnClick = NetConnections1Click
      end
      object Flottenbersicht1: TMenuItem
        Caption = 'Flotten'#252'bersicht'
        ShortCut = 16452
        OnClick = Flottenbersicht1Click
      end
      object Notizen1: TMenuItem
        Caption = 'Notizen'
        ShortCut = 16462
        OnClick = Notizen1Click
      end
      object Universumsbersicht1: TMenuItem
        Caption = 'Universums'#252'bersicht'
        ShortCut = 16469
        OnClick = Universumsbersicht1Click
      end
      object Listenansicht1: TMenuItem
        Caption = 'Listenansicht'
        ShortCut = 16460
        OnClick = Listenansicht1Click
      end
    end
    object Funktionen1: TMenuItem
      Caption = 'Fun&ktionen'
      object SuchenErsetzen1: TMenuItem
        Caption = 'Suchen && Ersetzen...'
        ShortCut = 16466
        OnClick = SuchenErsetzen1Click
      end
      object Scanslschen1: TMenuItem
        Caption = 'Scans l'#246'schen...'
        ShortCut = 49228
        OnClick = Scanslschen1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object SaveClipboardtoFile1: TMenuItem
        Caption = 'Save Clipboard to File'
        OnClick = SaveClipboardtoFile1Click
      end
    end
    object Galaxie1: TMenuItem
      Caption = '<Galaxie>'
      OnClick = BTN_GalaxieClick
    end
    object Info1: TMenuItem
      Caption = '&?'
      object Info2: TMenuItem
        Caption = 'Info'
        OnClick = Info1Click
      end
      object updatecheck1: TMenuItem
        Caption = 'update check'
        OnClick = updatecheck1Click
      end
    end
    object Dir: TMenuItem
      Caption = 'Dir'
      OnClick = DirClick
    end
    object Test1: TMenuItem
      Caption = 'Test'
      object Languagefile1: TMenuItem
        Caption = 'Languagefile'
        OnClick = Languagefile1Click
      end
      object NewScan1: TMenuItem
        Caption = 'NewScan'
        ShortCut = 49230
        OnClick = NewScan1Click
      end
      object POST1: TMenuItem
        Caption = 'POST'
        ShortCut = 16505
        OnClick = POST1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object VergleicheScanDateimitDB1: TMenuItem
        Caption = 'Vergleiche ScanDatei mit DB'
        ShortCut = 16506
        OnClick = VergleicheScanDateimitDB1Click
      end
      object VergelicheSysDateimitDB1: TMenuItem
        Caption = 'Vergleiche SysDatei mit DB'
        ShortCut = 16507
        OnClick = VergelicheSysDateimitDB1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object writeunitsinconstsxml1: TMenuItem
        Caption = 'write units in consts.xml'
        OnClick = writeunitsinconstsxml1Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object exportxml1: TMenuItem
        Caption = 'export xml'
      end
      object selectkoordranges1: TMenuItem
        Caption = 'selectkoordranges#'
      end
      object ScansDatumLschen1: TMenuItem
        Caption = 'Scans eines Datums L'#246'schen'
        OnClick = ScansDatumLschen1Click
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object frmevents1: TMenuItem
        Caption = 'frm_events'
      end
    end
  end
  object TrayIconPopup: TPopupMenu
    OnPopup = TrayIconPopupPopup
    Left = 283
    Top = 92
    object MainWindow1: TMenuItem
      Caption = 'MainWindow'
      Default = True
      OnClick = MainWindow1Click
    end
    object Zwischenablageberwachen1: TMenuItem
      Caption = 'Zwischenablage '#252'berwachen'
      Checked = True
      OnClick = Zwischenablageberwachen1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Close1: TMenuItem
      Caption = 'Close'
      OnClick = Beenden1Click
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'creatureScan Export-Files|*.csef;*.cssys;*.csscan|cSdbSysFiles|*' +
      '.cssys|cSdbScanFiles|*.csscan'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 252
    Top = 44
  end
  object TIM_Start: TTimer
    OnTimer = TIM_StartTimer
    Left = 12
    Top = 236
  end
  object il_trayicon: TImageList
    Left = 12
    Top = 276
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      00000000000000000000000000000000000000000000C0C0C000BABABA00B4B4
      B400ADADAD00A4A4A4009B9B9B009D9D9D008B8B8B0026262600090909001010
      10003C3C3C0081818100ADADAD00000000000000000000CAF30000C1F10000B7
      EF0000ACED00009FEA000092E7000595E4000885C800081A4900030414000509
      2300092E6B000375C80000ADED00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BCBCBC00B6B6B600B0B0B000A9A9
      A900A1A1A100989898009D9D9D00A5A5A500B3B3B300C9C9C9007A7A7A002222
      22005151510095959500B0B0B0000000000000C3F20000BAF00000B1EE0000A6
      EC00009AE900008EE2000596E40008A2E50008B7EA0005D9F30001868E000817
      410008428800008BDF0000B1EE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B2B2B200ADADAD00A6A6A6009F9F
      9F00898989006B6B6B005E5E5E00B1B1B100C3C3C300DDDDDD00C8C8C800ADAD
      AD00757575009E9E9E00B2B2B2000000000000B5EF0000ACED0000A2EB000097
      E900017ED200065DAB000852960009B3E90006CFF00001F7FC0005D7F30009AF
      E6000669B5000096E80000B4EF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A9A9A900A3A3A3009D9D9D009898
      98006A6A6A004F4F4F00353535001E1E1E00AEAEAE00D6D6D600BCBCBC00A8A8
      A8009C9C9C00A1A1A100B3B3B300C7C7C70000A7EC00009EEA000094E800028E
      E100065CA900084085000927600007133B0003BECE0003EBF90007C4ED0008A6
      E6000494E400009BE90000B6EF0000D5F6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009C9C9C009E9E
      9E009A9A9A0038383800232323000F0F0F000000000067676700B3B3B300A3A3
      A3009B9B9B00A4A4A400000000000000000000000000000000000393E5000697
      E5000894DA00092A6500081743000508200000000100066A860009B6EA00089E
      E5000392E500009FEA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009E9E9E00A3A3
      A300ABABAB00A6A6A60014141400040404000A0A0A001F1F1F003A3A3A009F9F
      9F009B9B9B00A7A7A700000000000000000000000000000000000697E400089F
      E50009ABE70008AAD900060C2A0001020A000305150007143C00082C67000799
      E4000192E60000A3EB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006666660053535300ABAB
      AB00B4B4B400C2C2C200D3D3D300030303001313130029292900474747006C6C
      6C009B9B9B00A9A9A900B6B6B60000000000000000000658A50008458B0009AA
      E70008B9EA0007CDF00003E7F70001010800060B2800081D4E0008387A00065E
      AC000091E60000A6EC0000BBF000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000052525200404040006464
      6400BEBEBE00CDCDCD00E0E0E000CACACA002D2D2D0035353500525252007777
      77009E9E9E00ABABAB00B7B7B700000000000000000008448A0009317000095E
      920007C7EE0004DEF50000FBFD0004DCEF0007244B0009275F0008448A00056A
      BB000095E80000A9EC0000BCF000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000040404000303030002020
      20007C7C7C00D9D9D900D9D9D900C7C7C700B6B6B6004B4B4B005D5D5D008181
      8100A0A0A000ACACAC00B8B8B800000000000000000009327100092359000715
      3F0005819D0002F0FA0002F0FA0006D5F20008BCEB00093E7C00074F99000375
      C8000099E90000ABED0000BDF100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000047474700242424001616
      160009090900CCCCCC00CFCFCF00BEBEBE00B1B1B100A6A6A600707070008B8B
      8B00A2A2A200ADADAD00B8B8B8000000000000000000093C730008184500060D
      2D000304140000E5E70004E1F50007C8EE0009B3E90008A3E6000663AF000180
      D300009CEA0000ADED0000BEF100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B5B5B5001A1A1A000D0D
      0D000202020007070700B0B0B000B7B7B700ACACAC00A3A3A3009D9D9D009595
      9500A4A4A400AFAFAF00B9B9B900000000000000000008BBEA00071033000407
      1C00010105000203100006BBD90008BEEB0009ACE700089EE5000595E500008B
      E000009FEA0000AFEE0000BFF100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A9A9A9000606
      0600030303000E0E0E0022222200A9A9A900A8A8A800A1A1A1009C9C9C009C9C
      9C00A5A5A500AFAFAF000000000000000000000000000000000005B4CE000203
      0E000101060004071E0007183E0009ABDF0008A7E600079BE4000494E4000092
      E80000A1EB0000B0EE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000008080800141414002323230045454500A3A3A3009F9F9F009B9B9B009E9E
      9E00000000000000000000000000000000000000000000000000000000000000
      000003041300060C2A000818440009397200099FE3000698E5000392E5000095
      E800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DBDB
      DB000F0F0F001B1B1B002B2B2B003D3D3D00676767009E9E9E009B9B9B00A0A0
      A000A8A8A80000000000000000000000000000000000000000000000000001F3
      FB0005081F0007113700081E5000092F6C00085BA2000696E4000192E6000098
      E90000A5EC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D3D3
      D300A5A5A50022222200313131000000000000000000848484009B9B9B00A1A1
      A100A9A9A90000000000000000000000000000000000000000000000000003E7
      F70006AECD000817410008245B0000000000000000000479C9000092E600009A
      E90000A7EC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CBCB
      CB00C0C0C000535353000000000000000000000000000000000099999900A2A2
      A200ABABAB0000000000000000000000000000000000000000000000000005DB
      F40007CAEF00084C7C0000000000000000000000000000000000008FE500009C
      EA0000A9EC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0080018001000000000001000100000000
      00010001000000000000000000000000C003C00300000000C003C00300000000
      8001800100000000800180010000000080018001000000008001800100000000
      8001800100000000C003C00300000000F00FF00F00000000E007E00700000000
      E187E18700000000E3C7E3C70000000000000000000000000000000000000000
      000000000000}
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 180
    Top = 144
  end
  object TIM_afterClipboardchange: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TIM_afterClipboardchangeTimer
    Left = 12
    Top = 196
  end
  object XMLDocument1: TXMLDocument
    Options = [doNodeAutoCreate, doNodeAutoIndent, doAttrNull, doAutoPrefix, doNamespaceDecl]
    Left = 180
    Top = 96
    DOMVendorDesc = 'MSXML'
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'bin'
    Filter = 'clipbrd(*.bin)|.bin'
    Left = 220
    Top = 44
  end
  object TIM_FakeCV: TTimer
    Enabled = False
    OnTimer = TIM_FakeCVTimer
    Left = 12
    Top = 148
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 368
    Top = 295
  end
  object IL_ScanSize: TImageList
    Height = 13
    Width = 6
    Left = 468
    Top = 120
    Bitmap = {
      494C010106000900040006000D00FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000180000001A0000000100200000000000C009
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF0000000000000000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF0000000000000000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF0000000000000000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF0000000000000000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF0000000000000000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF0000000000000000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF0000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF0000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      28000000180000001A0000000100010000000000680000000000000000000000
      000000000000000000000000FFFFFF0000000000780000007800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FC000000FDE79E00FDE79E00FC000000FDE79E00FDE79E00FC000000
      FDE78000FDE78000FC000000FDE00000FDE00000FC0000000000000000000000
      0000000000000000000000000000}
  end
  object PopupMenu1: TPopupMenu
    Left = 468
    Top = 76
    object Lschen1: TMenuItem
      Caption = 'L'#246'schen'
      ShortCut = 46
      OnClick = BTN_DeleteClick
    end
  end
  object popup_auftrag: TPopupMenu
    Left = 80
    Top = 336
    object Angriff1: TMenuItem
      Tag = 1
      Caption = 'Angriff'
      OnClick = Angriff1Click
    end
    object Spionage1: TMenuItem
      Tag = 2
      Caption = 'Spionage'
      OnClick = Spionage1Click
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object Raideintragen1: TMenuItem
      Caption = 'Raid eintragen...'
      OnClick = Raideintragen1Click
    end
  end
end
