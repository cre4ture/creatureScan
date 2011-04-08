object FRM_Suche: TFRM_Suche
  Left = 251
  Top = 277
  Width = 879
  Height = 386
  Caption = 'Suche in dem Universumsabbild nach...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 340
    Width = 871
    Height = 19
    Panels = <
      item
        Width = 60
      end
      item
        Style = psOwnerDraw
        Text = '0'
        Width = 100
      end
      item
        Width = 50
      end>
    OnMouseDown = StatusBar1MouseDown
    OnDrawPanel = StatusBar1DrawPanel
  end
  object P_Top: TPanel
    Left = 0
    Top = 0
    Width = 871
    Height = 101
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      871
      101)
    object BTN_Suche: TButton
      Left = 778
      Top = 20
      Width = 83
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Suche'
      Default = True
      TabOrder = 1
      OnClick = BTN_SucheClick
    end
    object CH_Del_Result: TCheckBox
      Left = 778
      Top = 48
      Width = 77
      Height = 17
      Hint = 
        'Wenn aktiviert, dann wird das vorherige Ergebniss gel'#246'scht, anso' +
        'nsten bleibt es zus'#228'tzlich zum neuen!'
      Anchors = [akTop, akRight]
      Caption = 'Erg. l'#246'schen'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 2
    end
    object BTN_Schliesen: TButton
      Left = 778
      Top = 68
      Width = 83
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Schlie'#223'en'
      TabOrder = 3
      OnClick = BTN_SchliesenClick
    end
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 771
      Height = 101
      ActivePage = ts_specials
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      object Search_Normal: TTabSheet
        Caption = 'Player / Planet / Ally'
        OnShow = Search_NormalShow
        DesignSize = (
          763
          73)
        object Label1: TLabel
          Left = 4
          Top = 4
          Width = 32
          Height = 13
          Caption = 'Player:'
        end
        object Label2: TLabel
          Left = 4
          Top = 28
          Width = 59
          Height = 13
          Caption = 'Planetname:'
        end
        object Label8: TLabel
          Left = 4
          Top = 52
          Width = 33
          Height = 13
          Caption = 'Allianz:'
        end
        object TXT_Player: TEdit
          Left = 68
          Top = 4
          Width = 501
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
        object TXT_Planet: TEdit
          Left = 68
          Top = 26
          Width = 501
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
        end
        object TXT_ally: TEdit
          Left = 68
          Top = 48
          Width = 501
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
        end
        object GroupBox4: TGroupBox
          Left = 576
          Top = 0
          Width = 185
          Height = 73
          Anchors = [akTop, akRight]
          Caption = ' Koordinatenfilter '
          TabOrder = 3
          object cb_koords: TComboBox
            Left = 12
            Top = 20
            Width = 161
            Height = 21
            ItemHeight = 0
            TabOrder = 0
            Text = 'cb_koords'
            OnChange = cb_koordsChange
            OnEnter = cb_koordsEnter
          end
          object cb_negativearea: TCheckBox
            Left = 12
            Top = 48
            Width = 161
            Height = 17
            Caption = 'negativ'
            TabOrder = 1
          end
        end
      end
      object Search_Status: TTabSheet
        Caption = 'Status / TFs / Statistiken'
        ImageIndex = 1
        DesignSize = (
          763
          73)
        object GroupBox1: TGroupBox
          Left = 0
          Top = 0
          Width = 237
          Height = 73
          Caption = ' Status '
          TabOrder = 0
          DesignSize = (
            237
            73)
          object lbl_statusinfo: TLabel
            Left = 100
            Top = 16
            Width = 61
            Height = 13
            Caption = 'lbl_statusinfo'
          end
          object TXT_Status: TEdit
            Left = 8
            Top = 12
            Width = 85
            Height = 21
            Anchors = [akTop, akRight]
            TabOrder = 0
            OnKeyPress = TXT_StatusKeyPress
          end
          object CH_Status_Genau: TCheckBox
            Left = 8
            Top = 36
            Width = 209
            Height = 17
            Hint = 'zb: wenn nach i gesucht wird, wird kein iI gefunden!'
            Anchors = [akTop, akRight]
            Caption = 'nur genaue '#220'bereinstimmung im Status'
            Checked = True
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 1
          end
          object cb_status_neg: TCheckBox
            Left = 8
            Top = 48
            Width = 97
            Height = 17
            Caption = 'negativ'
            TabOrder = 2
          end
        end
        object GroupBox2: TGroupBox
          Left = 240
          Top = 0
          Width = 117
          Height = 73
          Caption = ' TFs '
          TabOrder = 1
          object Label3: TLabel
            Left = 12
            Top = 20
            Width = 67
            Height = 13
            Caption = 'Mindestgr'#246#223'e:'
          end
          object TXT_TF: TEdit
            Left = 12
            Top = 40
            Width = 93
            Height = 21
            TabOrder = 0
            Text = '0'
          end
        end
        object GroupBox3: TGroupBox
          Left = 360
          Top = 0
          Width = 401
          Height = 73
          Anchors = [akLeft, akTop, akRight]
          Caption = ' Statistiken '
          TabOrder = 2
          DesignSize = (
            401
            73)
          object Label4: TLabel
            Left = 12
            Top = 20
            Width = 34
            Height = 13
            Caption = 'Punkte'
          end
          object Label5: TLabel
            Left = 12
            Top = 48
            Width = 26
            Height = 13
            Caption = 'Flotte'
          end
          object cb_punkte_gk: TComboBox
            Left = 112
            Top = 16
            Width = 57
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 1
            Text = '-'
            Items.Strings = (
              '-'
              '>'
              '<')
          end
          object cb_flotte_gk: TComboBox
            Left = 112
            Top = 44
            Width = 57
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 4
            Text = '-'
            Items.Strings = (
              '-'
              '>'
              '<')
          end
          object cb_punkte_pp: TComboBox
            Left = 52
            Top = 16
            Width = 57
            Height = 21
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 0
            Text = '(Platz)'
            Items.Strings = (
              '(Platz)'
              '(Punkte)')
          end
          object cb_flotte_pp: TComboBox
            Left = 52
            Top = 44
            Width = 57
            Height = 21
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 3
            Text = '(Platz)'
            Items.Strings = (
              '(Platz)'
              '(Punkte)')
          end
          object txt_punkte: TEdit
            Left = 172
            Top = 16
            Width = 217
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 2
            Text = '0'
          end
          object txt_flotte: TEdit
            Left = 172
            Top = 44
            Width = 217
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 5
            Text = '0'
          end
        end
      end
      object ts_specials: TTabSheet
        Caption = 'Specials'
        ImageIndex = 2
        object cb_lpa: TCheckBox
          Left = 8
          Top = 8
          Width = 145
          Height = 17
          Caption = 'getLPA (lastPointActivity)'
          TabOrder = 0
        end
      end
    end
  end
  object VST_Result: TVirtualStringTree
    Left = 0
    Top = 101
    Width = 871
    Height = 239
    Align = alClient
    ClipboardFormats.Strings = (
      'CSV'
      'HTML Format'
      'Plain text'
      'Rich Text Format'
      'Rich Text Format Without Objects'
      'Unicode text'
      'Virtual Tree Data')
    Header.AutoSizeIndex = -1
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.PopupMenu = VTHeaderPopupMenu1
    Images = ImageList1
    PopupMenu = PopupMenu1
    TabOrder = 2
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect, toMiddleClickSelect, toMultiSelect, toRightClickSelect]
    OnBeforeItemPaint = VST_ResultBeforeItemPaintX
    OnCompareNodes = VST_ResultCompareNodes
    OnDblClick = VST_ResultDblClickX
    OnFocusChanged = VST_ResultFocusChanged
    OnGetText = VST_ResultGetText
    OnPaintText = VST_ResultPaintText
    OnGetImageIndex = VST_ResultGetImageIndex
    OnHeaderClick = VST_ResultHeaderClick
    Columns = <
      item
        Position = 0
        Width = 120
        WideText = 'Player'
      end
      item
        Position = 2
        Width = 80
        WideText = 'Koordinaten'
      end
      item
        Position = 4
        Width = 40
        WideText = 'Allianz'
      end
      item
        Position = 5
        Width = 100
        WideText = 'Planetenname'
      end
      item
        Position = 6
        Width = 40
        WideText = 'Scan'
      end
      item
        Alignment = taRightJustify
        Position = 8
        WideText = 'Platz'
      end
      item
        Alignment = taRightJustify
        Position = 9
        Width = 80
        WideText = 'Punkte'
      end
      item
        Alignment = taRightJustify
        Position = 10
        WideText = 'Fleetplatz'
      end
      item
        Alignment = taRightJustify
        Position = 11
        Width = 70
        WideText = 'Fleetpunkte'
      end
      item
        Alignment = taRightJustify
        Position = 12
        WideText = 'Allyplatz'
      end
      item
        Alignment = taRightJustify
        Position = 13
        Width = 46
        WideText = 'Allypunkte'
      end
      item
        Alignment = taRightJustify
        Position = 3
        Width = 40
        WideText = 'TF'
      end
      item
        Position = 1
        Width = 45
        WideText = 'Status'
      end
      item
        Position = 7
        WideText = 'Datum'
      end
      item
        Position = 14
        WideText = 'LPA'
      end
      item
        Position = 15
        WideText = 'LPI'
      end>
  end
  object ImageList1: TImageList
    Left = 64
    Top = 184
    Bitmap = {
      494C010104000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
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
      0000000000000000000000000000000000000101010001010100030303000202
      02001C110A004F391D00614A1C006F572000725D240078612A00604A26002014
      0C00010101000303030001010100030303000101010001010100010101000101
      0100010101000101010003030300070707000606060004040400010101000101
      0100010101000101010001010100010101000101010001010100030303000202
      02001C110A004F391D00614A1C006F572000725D240078612A00604A26002014
      0C00010101000303030001010100030303000101010001010100010101000101
      0100010101000101010003030300070707000606060004040400010101000101
      0100010101000101010001010100010101000101010001010100070403006B4D
      2A00A9863A00876B29005D491D004E3918004B3A190068572A00755F2700977D
      3700654B28000704020001010100020202000101010001010100010101000202
      02000D0D0D001F1F1F0030303000393939003B3B3B0031313100161616000808
      08000101010001010100010101000101010001010100FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000004B3A190068572A00755F2700977D
      3700654B280007040200010101000202020001010100FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000003B3B3B0031313100161616000808
      0800010101000101010001010100010101000101010004030200916F3800B293
      3D00A1824700A4815300805F4200533A2B004A3D2B0064553D0088724C008C76
      43009A833F00755A2F0008050400020202000101010001010100080808001A1A
      1A002D2D2D0043434300585858005E5E5E005D5D5D00535353003E3E3E002626
      26001212120001010100010101000101010001010100FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF0000004A3D2B0064553D0088724C008C76
      43009A833F00755A2F00080504000202020001010100FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF0000005D5D5D00535353003E3E3E002626
      260012121200010101000101010001010100020202006E512C00B6963C007160
      34006D533F008D6C5A008E6F5A0060483B005A43370064574300605038008670
      4F0086734600847435004E3A1E0001010100010101000B0B0B002A2A2A003F3F
      3F00585858006D6D6D006E6E6E0064646400626262004F4F4F00383838002E2E
      2E002D2D2D0015151500010101000101010002020200FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF0000005A43370064574300605038008670
      4F0086734600847435004E3A1E000101010001010100FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000626262004F4F4F00383838002E2E
      2E002D2D2D0015151500010101000101010015090400D0B35300868E50007C8E
      700069594B006F594F00806A550088766000A988740081675300826751009074
      5C008C7354008975470076632B00150C0700050505003B3B3B00555555007B7B
      7B0077777700747474006C6C6C00717171007171710060606000434343003B3B
      3B003B3B3B002E2E2E000C0C0C000101010015090400FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000A988740081675300826751009074
      5C008C7354008975470076632B00150C070005050500FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF0000007171710060606000434343003B3B
      3B003B3B3B002E2E2E000C0C0C00010101006A523300B9BA520080824D00AE92
      6D0086665900886B59009F8A6F00C3A58C00B49B8600A3897400907662008168
      5900604A3A00675E3F005B532000422F180031313100666666009E9E9E009A9A
      9A00888888008383830088888800858585007777770067676700575757005151
      5100313131001E1E1E0007070700010101006A523300FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000B49B8600A3897400907662008168
      5900604A3A00675E3F005B532000422F180031313100FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF0000007777770067676700575757005151
      5100313131001E1E1E000707070001010100A8925300B7BB6800ADB28300C19E
      8200C28A7900B08C7900A5958700A99E8900A4958100A0907C009D836F007961
      5100685341004A4327005B4E2000533D19007F7F7F009C9C9C00A5A5A500A8A8
      A8009C9C9C00B4B4B40094949400A6A6A6008B8B8B0073737300767676006E6E
      6E0026262600141414001010100001010100A8925300FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000A4958100A0907C009D836F007961
      5100685341004A4327005B4E2000533D19007F7F7F00FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF0000008B8B8B0073737300767676006E6E
      6E0026262600141414001010100001010100C5B06A00D8D78100E7CDA000F0BC
      9900D6A68E00C4A897008F8D7B00939189008587800093897E00A7907A00644C
      3F00674839005C4D30005050240059471D00ABABAB00C2C2C200AFAFAF00B0B0
      B000BBBBBB00C0C0C0006B6B6B00A9A9A9009393930088888800999999005858
      58003D3D3D001B1B1B001212120008080800C5B06A00FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000008587800093897E00A7907A00644C
      3F00674839005C4D30005050240059471D00ABABAB00FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000009393930088888800999999005858
      58003D3D3D001B1B1B001212120008080800C2AE7000FCF99D00EAC59900EDBA
      9C00E0A99100CCAE9900A99A90008E8C870080817B00827B700096856E00664C
      400062483800513F25005652280055431B00B4B4B400CCCCCC00BBBBBB00B1B1
      B100C7C7C700CFCFCF009B9B9B0097979700878787007C7C7C006F6F6F004141
      41001E1E1E0015151500191919000E0E0E00C2AE7000FCF99D00EAC59900EDBA
      9C00E0A99100CCAE9900A99A90008E8C870080817B00827B700096856E00664C
      400062483800513F25005652280055431B00B4B4B400CCCCCC00BBBBBB00B1B1
      B100C7C7C700CFCFCF009B9B9B0097979700878787007C7C7C006F6F6F004141
      41001E1E1E0015151500191919000E0E0E009D8B6200F3E78000E0B47C00F6C0
      9A00F6BBA000E0AF9E00C9A99A00B39C8E007E766400A58B75007C6654006751
      3F0045322400574D300057512700493A1B009A9A9A00E2E2E200DADADA00B9B9
      B900C4C4C400D3D3D300CCCCCC00B0B0B0009898980076767600646464001919
      19000F0F0F0012121200242424000C0C0C009D8B6200F3E78000E0B47C00F6C0
      9A00F6BBA000E0AF9E00C9A99A00B39C8E007E766400A58B75007C6654006751
      3F0045322400574D300057512700493A1B009A9A9A00E2E2E200DADADA00B9B9
      B900C4C4C400D3D3D300CCCCCC00B0B0B0009898980076767600646464001919
      19000F0F0F0012121200242424000C0C0C0055412A00FBFB9900F4DB9500FADE
      B100FCCAAA00FBBDA800E2AB9900BB8F7E00BD907D00B3897500593A33004D31
      280032201600403F2700514D21002C1F110061616100DFDFDF00D8D8D800C7C7
      C700D7D7D700D6D6D600C8C8C800B4B4B40094949400969696004D4D4D001111
      1100131313002F2F2F003D3D3D000D0D0D0055412A00FBFB9900F4DB9500FADE
      B100FCCAAA00FBBDA800E2AB9900BB8F7E00BD907D00B3897500593A33004D31
      280032201600403F2700514D21002C1F110061616100DFDFDF00D8D8D800C7C7
      C700D7D7D700D6D6D600C8C8C800B4B4B40094949400969696004D4D4D001111
      1100131313002F2F2F003D3D3D000D0D0D0009050300DAC98500FDFCA800FBEE
      AE00FCD4A900FCC09E00E19E8600BD837200D29B8300A2755F00674938004E41
      2C003F4027004B472100584A23000603020012121200D0D0D000DADADA00DADA
      DA00D9D9D900CCCCCC00C1C1C100AEAEAE00AFAFAF007C7C7C002C2C2C001717
      1700191919002B2B2B00272727000101010009050300DAC98500FDFCA800FBEE
      AE00FCD4A900FCC09E00E19E8600BD837200D29B8300A2755F00674938004E41
      2C003F4027004B472100584A23000603020012121200D0D0D000DADADA00DADA
      DA00D9D9D900CCCCCC00C1C1C100AEAEAE00AFAFAF007C7C7C002C2C2C001717
      1700191919002B2B2B0027272700010101000302020046352200F7F39C00FEF8
      A100F1C58B00EEB28500C28D6E00A7796300B58569009A7258006D573D00584C
      30005F502B006054270021170D00050404000101010060606000DDDDDD00DBDB
      DB00DADADA00C9C9C900BFBFBF00BBBBBB0085858500313131001E1E1E001F1F
      1F00313131002323230009090900010101000302020046352200F7F39C00FEF8
      A100F1C58B00EEB28500C28D6E00A7796300B58569009A7258006D573D00584C
      30005F502B006054270021170D00050404000101010060606000DDDDDD00DBDB
      DB00DADADA00C9C9C900BFBFBF00BBBBBB0085858500313131001E1E1E001F1F
      1F00313131002323230009090900010101000202020002010100624C3200F6EF
      8B00F7E07E00C49A5F009B754C008E704E00A68A60009A835600756338006F5E
      2F005F522600271D1000010101000101010001010100020202007D7D7D00D5D5
      D500C4C4C400BCBCBC00C3C3C300ADADAD00535353003F3F3F00242424003030
      3000333333000E0E0E0001010100010101000202020002010100624C3200F6EF
      8B00F7E07E00C49A5F009B754C008E704E00A68A60009A835600756338006F5E
      2F005F522600271D1000010101000101010001010100020202007D7D7D00D5D5
      D500C4C4C400BCBCBC00C3C3C300ADADAD00535353003F3F3F00242424003030
      3000333333000E0E0E0001010100010101000101010002020200010101003B2A
      1A00C8B36400F6DF7200E5C45D00CDAE5700B8984900A3863C008A7533005444
      200018100A000202020001010100030303000101010001010100020202005252
      5200BCBCBC00CECECE00C7C7C700B0B0B000616161003E3E3E003F3F3F005454
      5400151515000101010001010100010101000101010002020200010101003B2A
      1A00C8B36400F6DF7200E5C45D00CDAE5700B8984900A3863C008A7533005444
      200018100A000202020001010100030303000101010001010100020202005252
      5200BCBCBC00CECECE00C7C7C700B0B0B000616161003E3E3E003F3F3F005454
      5400151515000101010001010100010101000404040001010100010101000101
      01000502020038251500785D350092723900836531005742240020150C000201
      0100010101000404040004040400010101000101010001010100010101000101
      01000B0B0B004D4D4D007F7F7F0096969600737373004F4F4F00222222000202
      0200010101000101010001010100010101000404040001010100010101000101
      01000502020038251500785D350092723900836531005742240020150C000201
      0100010101000404040004040400010101000101010001010100010101000101
      01000B0B0B004D4D4D007F7F7F0096969600737373004F4F4F00222222000202
      020001010100010101000101010001010100424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 92
    Top = 184
    object Spionieren1: TMenuItem
      Caption = 'Spionieren'
      ShortCut = 16467
      OnClick = Spionieren1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Kopieren1: TMenuItem
      Caption = 'Kopieren'
      ShortCut = 16451
      OnClick = Kopieren1Click
    end
    object KoordinatenKopieren1: TMenuItem
      Caption = 'Koordinaten kopieren'
      OnClick = KoordinatenKopieren1Click
    end
    object Lschen: TMenuItem
      Caption = 'L'#246'schen'
      ShortCut = 46
      OnClick = LschenClick
    end
    object LscheallenichtMonde1: TMenuItem
      Caption = 'L'#246'sche alle nicht Monde'
      OnClick = LscheallenichtMonde1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object AllybeinolleXdesuchen1: TMenuItem
      Caption = 'Ally bei nolleX.de suchen'
      OnClick = AllybeinolleXdesuchen1Click
    end
    object PlayerbeinolleXdesuchen1: TMenuItem
      Caption = 'Player bei nolleX.de suchen'
      OnClick = PlayerbeinolleXdesuchen1Click
    end
  end
  object VTHeaderPopupMenu1: TVTHeaderPopupMenu
    Left = 120
    Top = 184
  end
  object tim_take_focus_again: TTimer
    Enabled = False
    Interval = 300
    OnTimer = tim_take_focus_againTimer
    Left = 208
    Top = 192
  end
end
