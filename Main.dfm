object FRM_Main: TFRM_Main
  Left = 269
  Top = 125
  Width = 549
  Height = 463
  Caption = 'creatureScan'
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
    Width = 541
    Height = 398
    Align = alClient
    BevelOuter = bvNone
    Color = clBlack
    TabOrder = 0
    Visible = False
    OnResize = P_ExplorerDockResize
    inline Frame_Bericht2: TFrame_Bericht
      Left = 0
      Top = 269
      Width = 541
      Height = 129
      HorzScrollBar.Style = ssHotTrack
      VertScrollBar.Style = ssHotTrack
      Align = alBottom
      Color = clBlack
      ParentBackground = False
      ParentColor = False
      PopupMenu = Frame_Bericht2.PopupMenu1
      TabOrder = 0
      TabStop = True
      inherited PB_B: TPaintBox
        Width = 524
      end
      inherited Panel1: TPanel
        Width = 524
        inherited LBL_Raid24_Info: TLabel
          Left = 354
        end
        inherited BTN_Last24: TSpeedButton
          Left = 438
        end
      end
    end
  end
  object P_Scan: TPanel
    Left = 0
    Top = 0
    Width = 541
    Height = 398
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 437
      Top = 0
      Height = 398
      Align = alRight
      MinSize = 20
      ResizeStyle = rsLine
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 437
      Height = 398
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      inline Frame_Bericht1: TFrame_Bericht
        Left = 0
        Top = 0
        Width = 437
        Height = 351
        HorzScrollBar.Style = ssHotTrack
        VertScrollBar.Style = ssHotTrack
        Align = alClient
        Color = clBlack
        ParentBackground = False
        ParentColor = False
        PopupMenu = Frame_Bericht1.PopupMenu1
        TabOrder = 0
        TabStop = True
        OnDblClick = Frame_Bericht1PB_BDblClick
        inherited PB_B: TPaintBox
          Width = 437
          OnDblClick = Frame_Bericht1PB_BDblClick
        end
        inherited Panel1: TPanel
          Width = 437
          inherited LBL_Raid24_Info: TLabel
            Left = 308
          end
          inherited BTN_Last24: TSpeedButton
            Left = 396
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
        Top = 351
        Width = 437
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
        Width = 437
        Height = 351
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
        object sb_start_bg: TShape
          Left = 0
          Top = 0
          Width = 437
          Height = 351
          Align = alClient
          Brush.Color = clBlack
          Pen.Style = psClear
          Pen.Width = 0
        end
        object lbl_dbl_click: TLabel
          Left = 0
          Top = 0
          Width = 437
          Height = 351
          Align = alClient
          AutoSize = False
          Transparent = False
          OnDblClick = BTN_GalaxieClick
        end
        object lbl_title: TLabel
          Left = 8
          Top = 16
          Width = 213
          Height = 39
          Caption = 'creatureScan v'
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -32
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          OnDblClick = Frame_Bericht1PB_BDblClick
        end
        object Label1: TLabel
          Left = 8
          Top = 80
          Width = 24
          Height = 13
          Caption = 'Wiki:'
          Color = clBlack
          ParentColor = False
          OnDblClick = Frame_Bericht1PB_BDblClick
        end
        object lbl_wiki_link: TLabel
          Left = 104
          Top = 80
          Width = 194
          Height = 13
          Cursor = crHandPoint
          Caption = 'http://www.creatureScan.creax.de/wiki/'
          Color = clBlack
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentColor = False
          ParentFont = False
          OnClick = LblWikiLinkClick
        end
        object Label3: TLabel
          Left = 8
          Top = 99
          Width = 32
          Height = 13
          Caption = 'Forum:'
          Color = clBlack
          ParentColor = False
          OnDblClick = Frame_Bericht1PB_BDblClick
        end
        object lbl_forum_link: TLabel
          Left = 104
          Top = 99
          Width = 171
          Height = 13
          Cursor = crHandPoint
          Caption = 'http://www.creatureScan.creax.de/'
          Color = clBlack
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsUnderline]
          ParentColor = False
          ParentFont = False
          OnClick = LblWikiLinkClick
        end
        object Label5: TLabel
          Left = 8
          Top = 128
          Width = 56
          Height = 13
          Caption = 'Quick Start:'
          Color = clBlack
          ParentColor = False
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
          Color = clBlack
          ParentColor = False
          WordWrap = True
          OnDblClick = BTN_GalaxieClick
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
          Color = clBlack
          ParentColor = False
          WordWrap = True
          OnDblClick = BTN_GalaxieClick
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
          Color = clBlack
          ParentColor = False
          WordWrap = True
          OnDblClick = BTN_GalaxieClick
        end
        object Label9: TLabel
          Left = 8
          Top = 256
          Width = 263
          Height = 41
          AutoSize = False
          Caption = 'Die Spionageberichte werden dann hier im Hauptfenster angezeigt.'
          Color = clBlack
          ParentColor = False
          WordWrap = True
          OnDblClick = BTN_GalaxieClick
        end
        object ico_active: TImage
          Left = 300
          Top = 152
          Width = 37
          Height = 41
          Picture.Data = {
            055449636F6E0000010001002020000001002000A81000001600000028000000
            2000000040000000010020000000000000000000000000000000000000000000
            00000000FFFFFF0000A6F41700A8FD7500A3FD75009DFD75009BFD6E0095FD67
            008FFC600099FC6400A5FD7100A8FD7000A8FD6F00B2FD7000B7FD7100BBFD71
            00C5FD7200CFFD7400CAFC5B009FF8250000DF08FFFFFF000000DF080022EE0F
            0035F4180043F8220059F92E006FFB3C007EFC4B008DFC5C0098FC59FFFFFF00
            FFFFFF0000A6F41700A5FD8B0094E8FF008CE1FF0081D5FE0075C9FC0069BBFB
            005EAEFA0053A1F9004B96F8009CE4F700A0E5F700A7E6F600AEE7F600B7E9F7
            00C0ECF700CCF0F800D9F3FA00E8F8FC009A9DFF00252DFE000317FB000729F9
            000F3BF7001A52F600296BF6003E86F70056A5F90071C5FC009FFED200A9FC5F
            FFFFFF0000A1F92E0092E7FF0091E7FF0087DCFD0070C3FC0067B8FB005AAAF9
            004F9CF8004490F7003B82F7003074F60085C4F600ADE7F600B7E9F700C0EBF7
            00CBEFF800D7F3FA00E6F7FC00F5FCFE00F7FCFE00CEE0FC007794F9000D35F8
            001648F700215EF6003478F7004893F80060B1FA007CD1FD0096E8FF00AEFEBD
            FFFFFF000093F92D0092E6FE0092E5FD0092E5FB007BCDFA0058A7F9004C9AF8
            00438CF700397FF7002F72F6002565F6001D56F600578AF700AEDBF700CAEFF8
            00D6F2F900E4F6FB00F2FBFD00FBFDFF00EBF8FC00DAF4FA00CCEFF900A4D3F7
            005991F600296BF6003C84F70052A1F9006BBDFB0086DCFF0099E9FF00B1FEBD
            FFFFFF00009FF92D0092E5FC0092E4FB0093E3FA0094E3F90078C4F800428CF8
            00387DF7002E71F7002562F6001E57F7001749F7000F3DF7002E54F8009AB7F9
            00E1F6FB00EFFAFD00FFFFFF00EFFAFD00E0F5FB00D1F1F900C3ECF800B6E9F7
            00A8E5F60089CDF7005FAAF8005AAAF90073C7FC008FE5FF009CEAFF00B1FEBE
            FFFFFF0000A1FD880092E4FB0093E4F90096E4F90098E3F8009BE3F70081C7F6
            002E72F7002562F7001E57F7001749F7000F3DF7000A31F8000625F9001127FB
            00717DFD00FBFDFF00F3FBFE00E4F6FB00D6F2F900C7EFF800BBEAF700B0E8F7
            00A5E6F6009DE4F70092DFF80083D4FB0082D6FE0095E8FF009FEAFF00B6FED5
            00BDFC610068BAFA0093E3F90095E3F80098E3F8009CE4F700A0E5F700A4E5F6
            0091CEF600235BF7001749F7000F3DF7000B31F8000626F900041BFB00010FFC
            000004FE00454AFE00BECDFC00DAF4FA00CDF0F800C0EBF700B5E9F700AAE6F6
            00A0E5F7009AE3F70094E4F90091E5FB0090E5FF0098E9FF00A1EBFF00ABEDFF
            00C0FEC10086FC610068B5F80099E4F7009CE4F700A0E4F700A4E5F600AAE6F6
            00AFE8F600A2D6F700224FF7000B32F8000727F900031CFA000111FC000007FE
            000002FF00010DFD00253AFB0085A5F900C4EEF800B9EAF700AEE7F600A5E6F6
            009DE4F70097E3F80094E3FA0091E5FD0092E7FF009AE9FF00A4EBFF00BAFED6
            00C0FC610077EE0F0076FB45009CFC5A00B2FD8500A5E6F600BAFECA00BDFD87
            00B7E9F700BEEBF700B1D9F8002F51F900041EFA000113FB000009FD000000FF
            000009FD000214FB000522FA00092EF800618EF700A1D6F600A9E6F600A1E5F7
            009BE4F80096E3F90092E4FA0092E6FE00A1FED200A8FD7500B1FD7600B8FC61
            FFFFFF00FFFFFF00FFFFFF00FFFFFF000099F21400BAFD6F00BCFC5C00BCF92E
            00BEEBF700C5EEF800CFF0F900BFD9FA004457FB00000BFD000002FF000007FE
            000111FC00031DFA00082AF9000E38F8001648F7003D77F60095D7F6009DE4F7
            0098E4F80093E3F900A0FECD009DFD7300A1FC5FFFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000AEF31600C4FD7100CDFD89
            00C5EEF800CDF0F900D7F3FA00E1F6FB00D2DEFD00585CFF000005FF00000EFC
            000319FB000625F9000B32F8001241F7001B51F7002562F7003174F60072BAF7
            0096E3F80092E4FB00A1FECE009EFD7400A1FC5FFFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF000039E309001D677C00ACDAF700C4EEF8
            00CDF0F800D6F2F900E0F5FB00EBF8FC00F6FCFE00F0F3FF004D58FD000518FB
            000522FA000A2DF9000E3BF7001749F7001F59F600296BF600387EF7004994F8
            0067B7F9008ADDFB0092E5FE0093E8FF00A7FED400B1FC5FFFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF000039E309001A5C90001240F700133BF800CBEFF8
            00D4F2F900DDF5FB00E8F8FC00F3FBFE00FFFFFF00F3FBFE00E7F7FC005871FA
            000729F9000C35F8001343F7001A52F6002562F7003074F6003E86F7004D9BF8
            005EAEFA0078CCFC008EE3FF0096E8FF009EEAFF00B2FED500BAFC60FFFFFF00
            FFFFFF00FFFFFF00FFFFFF000050EF10001240F7000D36F8000A2DF9003351F9
            00D4ECFA00E7F7FC00F1FAFD00FDFEFF00F5FCFE00EAF8FC00DEF5FB00D3F2F9
            00789EF8000F3DF700184BF7001F5AF600296BF600367CF7004490F70054A3F9
            0067B8FB0079CDFD008DE3FF0098E9FF00A0EAFF00A8ECFF00BAFEC0FFFFFF00
            FFFFFF00818181000040DF06001F755A000C34F800092DF8000625F900031CFA
            005E71FB00E3EEFD00FAFDFF00F8FDFF00EDF9FD00E2F6FB00D7F3FA00CDF0F8
            00BDE7F80076A6F7002960F6002462F6003073F6003D85F7004B97F8005AAAF9
            006DBFFB0080D4FE0093E8FF009AE9FF00A2EBFF00A9ECFF00BBFED700C3FC61
            FFFFFF00181818000012442C000D37F700092EF8000626F900041EFA000214FB
            00010DFD00898EFE00FBFDFF00F0FAFD00E6F7FC00DAF4FA00D0F1F900C6EEF8
            00BDEBF700B5E9F70074AEF7002E6EF600357AF600438CF70052A1F90062B4FA
            0073C6FC0086DCFF0095E8FF009CEAFF00A4EBFF00ABEDFF00B3EEFF00C5FEC1
            FFFFFF00D3D3D300002D556F000A2FF8000727F900041FFA000216FB00000EFC
            000007FE000000FF008E95FE00E9F8FC00DDF5FB00D3F2F900CAEFF800C1ECF7
            00B8EAF700AFE8F600A9E6F6008CCEF600458EF7004995F80058A7F90068BAFA
            007ACEFD008DE2FF0097E9FF009EEAFF00A5ECFF00ADEDFF00B4EFFF00C6FEC1
            FFFFFF00FFFFFF0000ABCC42005F80F9000520FA000317FB000110FC000109FE
            000001FF000006FE001724FC0093A8FB00D7F3FA00CDF0F900C4EEF800BCEBF7
            00B3E8F600ABE7F600A5E6F6009FE4F7007EC9F8005DABF8005EAEFA006FC1FB
            0081D5FE0093E8FF0099E9FF00A0EBFF00A7ECFF00AEEEFF00B5EFFF00C6FEC2
            FFFFFF00FFFFFF0000D9FA2F00BBD6FA00273DFB000111FC000009FD000002FF
            000005FF00010CFD000113FB001B33FA00BEDEF900C7EFF800BFECF700B7E9F7
            00B0E8F700A8E6F600A2E5F6009DE4F70098E3F8008CDBF9006CBDFB0075C8FC
            0086DCFF0095E8FF009BEAFF00A2EBFF00A9ECFF00B0EEFF00B7EFFF00C8FEC2
            FFFFFF00FFFFFF0000D4F41800E4FD9000A5B5FC00000BFD000005FF000002FF
            000009FD000111FC00031AFB000523F900193CF900A6CFF800BAEAF700B3E9F7
            00ACE7F600A5E6F6009FE4F7009BE4F80096E4F80093E3F90089DCFB0082D7FD
            008DE2FF0097E9FF009DEAFF00A4EBFF00AAEDFF00B1EEFF00C2FED900C6FC62
            FFFFFF00FFFFFF00FFFFFF0000E5FA3100EBF7FD007379FE000000FF000007FE
            00010EFC000217FB000521FA000829F9000B33F8004977F700A2D6F700AEE7F6
            00A8E6F600A2E5F6009DE4F70099E4F80096E3F90093E4FA0092E5FC0091E5FE
            0092E8FF0099E9FF009FEAFF00A5ECFF00ACEDFF00B2EEFF00C4FEC1FFFFFF00
            FFFFFF00FFFFFF00FFFFFF0000F4F41800F5FD9600DEDEFF002328FE00010DFD
            000113FB00031DFA000626F9000A2FF8000E3AF7001445F700477EF700ABE7F6
            00A5E6F600A0E5F7009BE3F70097E3F80094E3F90092E5FB0091E5FD0091E7FF
            0094E8FF009AE9FF00A1EBFF00A7ECFF00ADEDFF00BFFED800C5FC61FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF0000F5F51A00FAFD9700C5CFFD000212FC
            00031AFB000623FA00082CF8000D36F8001240F700184CF700235CF60065A3F6
            009ADDF7009DE4F70099E4F70097E3F90093E3FA0092E5FB0091E6FD0092E7FF
            0096E8FF009CEAFF00A2EBFF00A8ECFF00BAFED700C0FC61FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000F5F51900EAFD7900C8FB46
            000622FA000729F9000B31F8000F3BF7001547F700184EF600205BF600296BF6
            006FB5F7009CE4F70097E4F80094E3F90092E4FB0091E5FC0092E6FE0092E8FF
            0098E9FF009EEAFF00B1FED400B4FD7700BBFC61FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000DFF418
            0080F82600092EF8000E38F8001342F700194DF7001E57F600205BF6002766F6
            003476F70065ADF70094E1F80093E3F90092E4FB0092E5FD0091E7FF0094E8FF
            009AE9FF00ACFED400AFFC60FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            00CCF823002048F800113EF7001648F7001B53F600215EF600296BF6002C6CF6
            003376F7003C82F70084D2F90093E4FA0091E5FB0091E6FD0092E7FF0096E8FF
            009BE9FF00AEFEBDFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000C8F417
            00D3FD8C005F8AF7001343F700184EF6001F58F6002565F600296BF7003074F7
            00367FEA004EA79C0067B7F90089DBFB0092E5FC0092E6FE0092E7FF0097E9FF
            009DEAFF00AEFED400B2FC60FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000CEFA2F
            00C4EEF800A2D1F7004073F7001C54F600225FF6002666F6002B6DF7003B88CA
            004498A60070EF100088FD670071C3FB008DE1FD0091E7FF0093E8FF0099E9FF
            009EEAFF00A4EBFF00B5FEBEFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000CEFA2F
            00B2DEF800A5D7F7008EC4F7001F5AF6002361F600296AF7003177E6004CAB9D
            FFFFFF00FFFFFF000087F824006FC2FC0086DAFE0091E7FF0095E8FF009AE9FF
            00A0EAFF00A5ECFF00B6FEBFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000CEFA2F
            00BBEAF700A8DDF7008EC4FF008EC4FF002564FE002869F7003F87DF005EB480
            FFFFFF00FFFFFF000086F2130096FD7A0083D9FF0090E5FF0097E9FF009CEAFF
            00A1EBFF00A6ECFF00B8FEBFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000C9FA2F
            00B8EAF700B2E8F700ABE6F600A8E5F60089CBF7005499E30061AA98FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00009BF417009DFD870093E8FF0098E9FF009DEAFF
            00A2EBFF00A8ECFF00BAFEBFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000BCF417
            00C4FD8700B0E8F700AAE6F600A5E6F600A5FEAD0098FB48FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF000097F31600A1FD8B009AE9FF009FEAFF
            00A4EBFF00B6FED500BAFC60FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFFFF800000038000000180000001800000010000000100000000
            80000001E000000FFE00003FFC00003FF800000FE0000007E0000003E0000003
            C0000001C0000001C0000001C0000001C0000003E0000003E0000007F000000F
            FE00003FFF00007FFF00007FFE00007FFE00C03FFE01C03FFE01E03FFE03E03F
            FE0FF07F}
          Visible = False
        end
        object ico_inactive: TImage
          Left = 340
          Top = 152
          Width = 37
          Height = 41
          Picture.Data = {
            055449636F6E0000010001002020000001002000A81000001600000028000000
            2000000040000000010020000000000000000000000000000000000000000000
            00000000FFFFFF00ABABAB17AEAEAE75AAAAAA75A6A6A675A5A5A56EA0A0A067
            9C9C9C60A3A3A364ACACAC71AEAEAE70AEAEAE6FB5B5B570B9B9B971BCBCBC71
            C3C3C372CACACA74C6C6C65BA6A6A6252F2F2F08FFFFFF002F2F2F084B4B4B0F
            5A5A5A18656565227575752E8585853C9090904B9A9A9A5CA2A2A259FFFFFF00
            FFFFFF00ABABAB17ACACAC8B9B9B9BFF949494FF8A8A8AFE7E7E7EFC737373FB
            686868FA5E5E5EF9565656F8A0A0A0F7A3A3A3F7A8A8A8F6AEAEAEF6B4B4B4F7
            BBBBBBF7C5C5C5F8CFCFCFFADBDBDBFC909090FF242424FE070707FB0E0E0EF9
            171717F7242424F6343434F6494949F7616161F97B7B7BFCA8A8A8D2AEAEAE5F
            FFFFFF00A8A8A82E9A9A9AFF999999FF8F8F8FFD7A7A7AFC717171FB656565F9
            5A5A5AF84F4F4FF7464646F73B3B3BF6898989F6ADADADF6B4B4B4F7BBBBBBF7
            C4C4C4F8CDCDCDFAD9D9D9FCE5E5E5FEE6E6E6FEC3C3C3FC757575F9151515F8
            1F1F1FF72C2C2CF63F3F3FF7535353F86A6A6AFA858585FD9D9D9DFFB2B2B2BD
            FFFFFF009E9E9E2D999999FE999999FD999999FB848484FA626262F9575757F8
            4E4E4EF7444444F73A3A3AF6303030F6272727F65C5C5CF7ABABABF7C3C3C3F8
            CDCDCDF9D7D7D7FBE2E2E2FDE9E9E9FFDDDDDDFCD0D0D0FAC5C5C5F9A2A2A2F7
            5E5E5EF6343434F6474747F75D5D5DF9757575FB8F8F8FFF9F9F9FFFB5B5B5BD
            FFFFFF00A7A7A72D999999FC999999FB999999FA9A9A9AF97F7F7FF84D4D4DF8
            434343F7393939F72F2F2FF6282828F7202020F7181818F7333333F8959595F9
            D5D5D5FBE0E0E0FDEDEDEDFFE0E0E0FDD4D4D4FBC9C9C9F9BEBEBEF8B4B4B4F7
            A9A9A9F68E8E8EF7686868F8656565F97D7D7DFC979797FFA1A1A1FFB5B5B5BE
            FFFFFF00A9A9A988999999FB9A9A9AF99C9C9CF99D9D9DF89F9F9FF7878787F6
            393939F72F2F2FF7282828F7202020F7181818F7121212F80C0C0CF9141414FB
            6B6B6BFDE9E9E9FFE3E3E3FED7D7D7FBCDCDCDF9C1C1C1F8B7B7B7F7AFAFAFF7
            A7A7A7F6A1A1A1F7989898F88B8B8BFB8A8A8AFE9C9C9CFFA3A3A3FFB8B8B8D5
            BDBDBD61727272FA999999F99B9B9BF89D9D9DF8A0A0A0F7A3A3A3F7A6A6A6F6
            939393F62C2C2CF7202020F7181818F7121212F80C0C0CF9090909FB040404FC
            010101FE414141FEB3B3B3FCD0D0D0FAC6C6C6F8BBBBBBF7B3B3B3F7AAAAAAF6
            A3A3A3F79E9E9EF79A9A9AF9989898FB989898FF9E9E9EFFA5A5A5FFADADADFF
            BFBFBFC195959561717171F89E9E9EF7A0A0A0F7A3A3A3F7A6A6A6F6AAAAAAF6
            AEAEAEF6A1A1A1F7292929F7121212F80D0D0DF9080808FA040404FC010101FE
            000000FF030303FD272727FB828282F9BFBFBFF8B6B6B6F7AEAEAEF6A7A7A7F6
            A1A1A1F79C9C9CF89A9A9AFA989898FD9A9A9AFFA0A0A0FFA7A7A7FFBBBBBBD6
            BFBFBF618888880F8A8A8A45A5A5A55AB5B5B585A7A7A7F6BBBBBBCABDBDBD87
            B4B4B4F7BABABAF7ADADADF8333333F9090909FA050505FB020202FD000000FF
            020202FD060606FB0B0B0BFA101010F8646464F7A1A1A1F6AAAAAAF6A4A4A4F7
            9F9F9FF89C9C9CF9999999FA999999FEA9A9A9D2AEAEAE75B4B4B476B9B9B961
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00A1A1A114BBBBBB6FBCBCBC5CBBBBBB2E
            BABABAF7BFBFBFF8C7C7C7F9B7B7B7FA434343FB020202FD000000FF010101FE
            040404FC080808FA0F0F0FF9161616F81F1F1FF7454545F6989898F6A1A1A1F7
            9D9D9DF8999999F9A8A8A8CDA6A6A673A9A9A95FFFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B0B0B016C2C2C271C8C8C889
            BFBFBFF8C6C6C6F9CDCDCDFAD5D5D5FBC5C5C5FD525252FF010101FF030303FC
            070707FB0C0C0CF9121212F81B1B1BF7252525F72F2F2FF73C3C3CF6797979F7
            9C9C9CF8999999FBA9A9A9CEA7A7A774A9A9A95FFFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00595959092B2B2B7CA9A9A9F7BFBFBFF8
            C6C6C6F8CDCDCDF9D4D4D4FBDDDDDDFCE6E6E6FEDFDFDFFF4A4A4AFD090909FB
            0B0B0BFA111111F9171717F7202020F7292929F6343434F6434343F7545454F8
            717171F9929292FB999999FE9A9A9AFFADADADD4B4B4B45FFFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF0059595909262626901A1A1AF71A1A1AF8C4C4C4F8
            CBCBCBF9D2D2D2FBDBDBDBFCE3E3E3FEEDEDEDFFE3E3E3FEDADADAFC575757FA
            0E0E0EF9141414F81C1C1CF7242424F62F2F2FF73B3B3BF6494949F7585858F8
            686868FA818181FC969696FF9D9D9DFFA3A3A3FFB5B5B5D5BBBBBB60FFFFFF00
            FFFFFF00FFFFFF00FFFFFF006C6C6C101A1A1AF7151515F8111111F9363636F9
            CACACAFADADADAFCE2E2E2FDEBEBEBFFE5E5E5FEDCDCDCFCD3D3D3FBCACACAF9
            777777F8181818F7212121F7292929F6343434F6414141F74F4F4FF75F5F5FF9
            717171FB828282FD959595FF9E9E9EFFA4A4A4FFAAAAAAFFBBBBBBC0FFFFFF00
            FFFFFF00818181005D5D5D062F2F2F5A141414F8101010F80C0C0CF9080808FA
            5B5B5BFBD5D5D5FDE9E9E9FFE7E7E7FFDEDEDEFDD6D6D6FBCDCDCDFAC6C6C6F8
            B8B8B8F8787878F7323232F62F2F2FF63B3B3BF6484848F7565656F8656565F9
            777777FB898989FE9A9A9AFFA0A0A0FFA6A6A6FFABABABFFBCBCBCD7C1C1C161
            FFFFFF00181818001B1B1B2C151515F7101010F80C0C0CF9090909FA060606FB
            030303FD808080FEE9E9E9FFE1E1E1FDD9D9D9FCD0D0D0FAC8C8C8F9C0C0C0F8
            B9B9B9F7B3B3B3F7787878F7383838F6404040F64E4E4EF75D5D5DF96C6C6CFA
            7C7C7CFC8F8F8FFF9C9C9CFFA1A1A1FFA7A7A7FFADADADFFB3B3B3FFC3C3C3C1
            FFFFFF00D3D3D3003232326F111111F80D0D0DF9090909FA060606FB030303FC
            010101FE000000FF858585FEDBDBDBFCD2D2D2FBCACACAF9C3C3C3F8BCBCBCF7
            B5B5B5F7AEAEAEF6AAAAAAF6909090F6505050F7545454F8626262F9727272FA
            838383FD959595FF9E9E9EFFA3A3A3FFA8A8A8FFAEAEAEFFB4B4B4FFC4C4C4C1
            FFFFFF00FFFFFF00A6A6A6425F5F5FF90A0A0AFA070707FB040404FC030303FE
            000000FF010101FE181818FC8D8D8DFBCDCDCDFAC6C6C6F9BFBFBFF8B8B8B8F7
            B1B1B1F6ABABABF6A7A7A7F6A2A2A2F7858585F8676767F8686868FA787878FB
            8A8A8AFE9A9A9AFF9F9F9FFFA4A4A4FFAAAAAAFFAFAFAFFFB4B4B4FFC4C4C4C2
            FFFFFF00FFFFFF00D0D0D02FB3B3B3FA292929FB040404FC020202FD000000FF
            010101FF030303FD050505FB1E1E1EFAB7B7B7F9C1C1C1F8BBBBBBF7B4B4B4F7
            AFAFAFF7A9A9A9F6A5A5A5F6A1A1A1F79D9D9DF8939393F9757575FB7E7E7EFC
            8F8F8FFF9C9C9CFFA1A1A1FFA6A6A6FFABABABFFB0B0B0FFB6B6B6FFC5C5C5C2
            FFFFFF00FFFFFF00CBCBCB18D9D9D9909C9C9CFC020202FD010101FF000000FF
            020202FD040404FC080808FB0B0B0BF91F1F1FF9A3A3A3F8B7B7B7F7B2B2B2F7
            ACACACF6A7A7A7F6A2A2A2F79F9F9FF89C9C9CF8999999F9919191FB8B8B8BFD
            959595FF9E9E9EFFA2A2A2FFA7A7A7FFACACACFFB1B1B1FFC1C1C1D9C3C3C362
            FFFFFF00FFFFFF00FFFFFF00D9D9D931DDDDDDFD6C6C6CFE000000FF010101FE
            040404FC060606FB0B0B0BFA0E0E0EF9131313F84E4E4EF7A1A1A1F7AEAEAEF6
            A9A9A9F6A5A5A5F6A1A1A1F79E9E9EF89C9C9CF99A9A9AFA999999FC989898FE
            9A9A9AFF9F9F9FFFA3A3A3FFA8A8A8FFADADADFFB2B2B2FFC2C2C2C1FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00E2E2E218E5E5E596CECECEFF222222FE030303FD
            050505FB080808FA0C0C0CF9111111F8161616F71D1D1DF74E4E4EF7ABABABF6
            A7A7A7F6A3A3A3F79F9F9FF79C9C9CF89A9A9AF9999999FB989898FD999999FF
            9B9B9BFFA0A0A0FFA5A5A5FFAAAAAAFFAEAEAEFFBFBFBFD8C2C2C261FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00E3E3E31AE9E9E997B9B9B9FD050505FC
            080808FB0C0C0CFA0F0F0FF8151515F81A1A1AF7212121F72D2D2DF66B6B6BF6
            9D9D9DF7A1A1A1F79E9E9EF79C9C9CF9999999FA999999FB999999FD9A9A9AFF
            9D9D9DFFA1A1A1FFA6A6A6FFAAAAAAFFBBBBBBD7BFBFBF61FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E3E3E319DDDDDD79C4C4C446
            0C0C0CFA0E0E0EF9121212F8171717F71E1E1EF7222222F62A2A2AF6343434F6
            767676F7A0A0A0F79C9C9CF89A9A9AF9999999FB989898FC999999FE9A9A9AFF
            9E9E9EFFA3A3A3FFB5B5B5D4B7B7B777BBBBBB61FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D3D3D318
            90909026101010F8161616F81C1C1CF7222222F7282828F62A2A2AF6323232F6
            3E3E3EF76D6D6DF79A9A9AF8999999F9999999FB999999FD999999FF9B9B9BFF
            A0A0A0FFB1B1B1D4B3B3B360FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            C7C7C723262626F8191919F71F1F1FF7252525F62C2C2CF6343434F6363636F6
            3E3E3EF7474747F78B8B8BF99A9A9AFA989898FB999999FD9A9A9AFF9D9D9DFF
            A0A0A0FFB2B2B2BDFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C3C3C317
            CDCDCD8C616161F71C1C1CF7222222F6292929F6303030F6343434F73B3B3BF7
            424242EA5B5B5B9C717171F9919191FB999999FC999999FE9A9A9AFF9E9E9EFF
            A2A2A2FFB2B2B2D4B5B5B560FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C8C8C82F
            BFBFBFF8A0A0A0F7464646F7262626F62D2D2DF6313131F6363636F7474747CA
            515151A683838310979797677A7A7AFB959595FD999999FF9A9A9AFF9F9F9FFF
            A3A3A3FFA7A7A7FFB7B7B7BEFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C8C8C82F
            AFAFAFF8A4A4A4F78F8F8FF7292929F62E2E2EF6343434F73C3C3CE65B5B5B9D
            FFFFFF00FFFFFF0095959524797979FC8E8E8EFE999999FF9C9C9CFFA0A0A0FF
            A4A4A4FFA8A8A8FFB8B8B8BFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C8C8C82F
            B7B7B7F7A7A7A7F78F8F8FFF8F8F8FFF303030FE333333F74A4A4ADF69696980
            FFFFFF00FFFFFF0093939313A1A1A17A8C8C8CFF989898FF9E9E9EFFA1A1A1FF
            A5A5A5FFA9A9A9FFBABABABFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C5C5C52F
            B5B5B5F7B1B1B1F7ABABABF6A9A9A9F68D8D8DF75D5D5DE36A6A6A98FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00A3A3A317A6A6A6879A9A9AFF9E9E9EFFA2A2A2FF
            A6A6A6FFAAAAAAFFBBBBBBBFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BABABA17
            C2C2C287AFAFAFF7AAAAAAF6A7A7A7F6ACACACADA2A2A248FFFFFF00FFFFFF00
            FFFFFF00FFFFFF00FFFFFF00FFFFFF00A0A0A016A9A9A98BA0A0A0FFA3A3A3FF
            A7A7A7FFB8B8B8D5BBBBBB60FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00
            FFFFFF00FFFFFFFF800000038000000180000001800000010000000100000000
            80000001E000000FFE00003FFC00003FF800000FE0000007E0000003E0000003
            C0000001C0000001C0000001C0000001C0000003E0000003E0000007F000000F
            FE00003FFF00007FFF00007FFE00007FFE00C03FFE01C03FFE01E03FFE03E03F
            FE0FF07F}
          Visible = False
        end
      end
    end
    object Panel1: TPanel
      Left = 440
      Top = 0
      Width = 101
      Height = 398
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        101
        398)
      object lst_others: TListView
        Left = 3
        Top = 84
        Width = 96
        Height = 230
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
        Width = 47
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Caption = 'C&opy'
        TabOrder = 2
        OnClick = BTN_CopyClick
      end
      object BTN_Liste: TButton
        Left = 2
        Top = 320
        Width = 96
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Scan &Liste'
        TabOrder = 3
        OnClick = BTN_ListeClick
      end
      object BTN_Suche: TButton
        Left = 2
        Top = 368
        Width = 96
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Su&chen'
        TabOrder = 5
        OnClick = BTN_SucheClick
      end
      object BTN_Universum: TButton
        Left = 2
        Top = 344
        Width = 96
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        Caption = '&Universum'
        TabOrder = 4
        OnClick = BTN_UniversumClick
      end
      object btn_last: TButton
        Left = 2
        Top = 60
        Width = 45
        Height = 18
        Caption = '<<'
        TabOrder = 6
        OnClick = btn_lastClick
      end
      object btn_next: TButton
        Left = 53
        Top = 60
        Width = 45
        Height = 18
        Caption = '>>'
        TabOrder = 7
        OnClick = btn_nextClick
      end
      object Button1: TButton
        Left = 56
        Top = 32
        Width = 41
        Height = 25
        Caption = 'sim'
        TabOrder = 8
        OnClick = Button1Click
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 398
    Width = 541
    Height = 19
    Panels = <
      item
        Text = '<normal>'
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
        Width = 253
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
      object phpSync1: TMenuItem
        Caption = 'php-Sync'
        OnClick = phpSync1Click
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
      object ZwischenablagefrMondScans1: TMenuItem
        Caption = 'Zwischenablage f'#252'r (Mond?)Scans'
        ShortCut = 16461
        OnClick = ZwischenablagefrMondScans1Click
      end
    end
    object Funktionen1: TMenuItem
      Caption = 'Fun&ktionen'
      object Scanslschen1: TMenuItem
        Caption = 'Scans l'#246'schen...'
        ShortCut = 49228
        OnClick = Scanslschen1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object PostErrorReport1: TMenuItem
        Caption = 'fehlerhaftes Einlesen melden...'
        OnClick = PostErrorReport1Click
      end
      object SaveClipboardtoFile1: TMenuItem
        Caption = 'Save Clipboard to File (Old)'
        OnClick = SaveClipboardtoFile1Click
      end
    end
    object Galaxie1: TMenuItem
      Caption = '<Galaxie>'
      OnClick = BTN_GalaxieClick
    end
    object Scan1: TMenuItem
      Caption = 'Scan'
      object nchstenAuswhlen1: TMenuItem
        Caption = 'n'#228'chsten ausw'#228'hlen'
        OnClick = btn_nextClick
      end
      object vorherigenauswhlen1: TMenuItem
        Caption = 'vorherigen ausw'#228'hlen'
        OnClick = btn_lastClick
      end
    end
    object Info1: TMenuItem
      Caption = '&?'
      object Forum1: TMenuItem
        Caption = 'Forum'
        OnClick = Forum1Click
      end
      object Wiki1: TMenuItem
        Caption = 'Wiki'
        OnClick = Wiki1Click
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object Update1: TMenuItem
        Caption = 'Update'
        object Softupdate1: TMenuItem
          Caption = 'Quick Updates'
          OnClick = Softupdate1Click
        end
        object updatecheck2: TMenuItem
          Caption = 'Version Update Check'
          OnClick = updatecheck1Click
        end
      end
      object Info2: TMenuItem
        Caption = 'Info'
        OnClick = Info1Click
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
        OnClick = frmevents1Click
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
    Left = 296
    Top = 263
  end
  object IL_ScanSize: TImageList
    Height = 13
    Width = 6
    Left = 468
    Top = 120
    Bitmap = {
      494C010106000800040006000D00FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
    OnPopup = PopupMenu1Popup
    Left = 468
    Top = 156
    object Lschen1: TMenuItem
      Caption = 'L'#246'schen'
      ShortCut = 46
      OnClick = BTN_DeleteClick
    end
  end
  object popup_auftrag: TPopupMenu
    Left = 264
    Top = 264
    object Angriff1: TMenuItem
      Tag = 1
      Caption = 'Angriff...'
      OnClick = Angriff1Click
    end
    object Spionage1: TMenuItem
      Tag = 2
      Caption = 'Spionage (direct)'
      OnClick = Spionage1Click
    end
    object Spionage2: TMenuItem
      Caption = 'Spionage...'
      OnClick = Spionage2Click
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object Raideintragen1: TMenuItem
      Caption = 'Raid eintragen...'
      OnClick = Raideintragen1Click
    end
    object Expedition1: TMenuItem
      Caption = 'Expedition...'
      OnClick = Expedition1Click
    end
  end
end
