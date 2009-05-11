object FRM_KB_List: TFRM_KB_List
  Left = 236
  Top = 404
  Caption = 'Raid Liste'
  ClientHeight = 305
  ClientWidth = 786
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 25
    Width = 786
    Height = 234
    ActivePage = TS_KB_laufend
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object TS_KB_laufend: TTabSheet
      Caption = 'aktuell'
      object VST_RAID: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 778
        Height = 206
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
        Header.MainColumn = 1
        Header.Options = [hoAutoResize, hoColumnResize, hoDblClickResize, hoDrag, hoVisible]
        Images = IL_mission
        PopupMenu = PopupMenu1
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSpanColumns, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect, toRightClickSelect]
        TreeOptions.StringOptions = [toAutoAcceptEditChange]
        OnBeforeCellPaint = VST_RAIDBeforeCellPaint
        OnChange = VST_RAIDChange
        OnClick = VST_RAIDClick
        OnCompareNodes = VST_RAIDCompareNodes
        OnDblClick = VST_RAIDDblClick
        OnGetText = VST_RAIDGetText
        OnGetImageIndex = VST_RAIDGetImageIndex
        OnHeaderClick = VST_RAIDHeaderClick
        OnInitChildren = VST_RAIDInitChildren
        OnInitNode = VST_RAIDInitNode
        OnKeyUp = VST_RAIDKeyUp
        Columns = <
          item
            Position = 0
            Width = 224
            WideText = 'Ankunft'
          end
          item
            Position = 1
            Width = 100
            WideText = 'Startplanet'
          end
          item
            Position = 2
            Width = 125
            WideText = 'Spieler'
          end
          item
            Position = 3
            Width = 100
            WideText = 'Zielplanet'
          end
          item
            Position = 4
            Width = 125
            WideText = 'Spieler'
          end
          item
            Position = 5
            Width = 100
            WideText = 'Auftrag'
          end
          item
            Position = 6
            Width = 10
            WideText = 'Username'
          end>
      end
    end
    object TS_KB_fertig: TTabSheet
      Caption = 'History'
      ImageIndex = 1
      object VST_HISTORY: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 778
        Height = 206
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
        Header.MainColumn = 1
        Header.Options = [hoAutoResize, hoColumnResize, hoDblClickResize, hoDrag, hoVisible]
        Images = IL_mission
        PopupMenu = PopupMenu1
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSpanColumns, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect, toRightClickSelect]
        TreeOptions.StringOptions = [toAutoAcceptEditChange]
        OnBeforeCellPaint = VST_RAIDBeforeCellPaint
        OnChange = VST_RAIDChange
        OnClick = VST_RAIDClick
        OnCompareNodes = VST_RAIDCompareNodes
        OnDblClick = VST_RAIDDblClick
        OnGetText = VST_RAIDGetText
        OnGetImageIndex = VST_RAIDGetImageIndex
        OnHeaderClick = VST_RAIDHeaderClick
        OnKeyUp = VST_RAIDKeyUp
        Columns = <
          item
            Position = 0
            Width = 150
            WideText = 'Ankunft'
          end
          item
            Position = 1
            Width = 100
            WideText = 'Startplanet'
          end
          item
            Position = 2
            Width = 125
            WideText = 'Spieler'
          end
          item
            Position = 3
            Width = 150
            WideText = 'Zielplanet'
          end
          item
            Position = 4
            Width = 125
            WideText = 'Spieler'
          end
          item
            Position = 5
            Width = 124
            WideText = 'Auftrag'
          end>
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 286
    Width = 786
    Height = 19
    Panels = <
      item
        Text = 'Beute:'
        Width = 40
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
    OnResize = StatusBar1Resize
  end
  object Panel1: TPanel
    Left = 0
    Top = 259
    Width = 786
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lbl_flotte: TLabel
      Left = 109
      Top = 0
      Width = 677
      Height = 27
      Align = alClient
      AutoSize = False
      Caption = 'lbl_flotte'
      WordWrap = True
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 109
      Height = 27
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        109
        27)
      object btn_pasteEvents: TButton
        Left = 4
        Top = 2
        Width = 99
        Height = 23
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Ereignisse einlesen'
        TabOrder = 0
        OnClick = paste1Click
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 786
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      786
      25)
    object lbl_servertime: TLabel
      Left = 584
      Top = 0
      Width = 165
      Height = 24
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      BiDiMode = bdRightToLeft
      Caption = '00.00.0000 00:00:00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
    end
    object Label2: TLabel
      Left = 528
      Top = 6
      Width = 50
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Serverzeit:'
    end
    object btn_time_sync: TButton
      Left = 755
      Top = 0
      Width = 30
      Height = 24
      Anchors = [akTop, akRight]
      Caption = 'q'
      Font.Charset = SYMBOL_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Webdings'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btn_time_syncClick
    end
    object ProgressBar1: TProgressBar
      Left = 584
      Top = 0
      Width = 165
      Height = 24
      Anchors = [akTop, akRight]
      TabOrder = 1
      Visible = False
    end
  end
  object ListRefresh: TTimer
    OnTimer = ListRefreshTimer
    Left = 20
    Top = 56
  end
  object PopupMenu1: TPopupMenu
    Left = 76
    Top = 56
    object entf1: TMenuItem
      Caption = 'L'#246'schen'
      ShortCut = 46
      OnClick = entf1Click
    end
    object Kopieren1: TMenuItem
      Caption = 'Kopieren'
      ShortCut = 16451
      OnClick = Kopieren1Click
    end
    object Bearbeiten1: TMenuItem
      Caption = 'Bearbeiten'
      ShortCut = 16453
      OnClick = Bearbeiten1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object paste1: TMenuItem
      Caption = 'Paste Events'
      ShortCut = 16470
      OnClick = paste1Click
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 168
    Top = 96
  end
  object IL_mission: TImageList
    Left = 256
    Top = 116
    Bitmap = {
      494C010107000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      000000000000000000000000000000000000141B19001C505F00185464001855
      6400185564001855640018556400195665001956650019566500195564001853
      620017526100175060001848500014131200181C0E002F6011002C660D002E66
      0E002E660E002E670D002E670D002F680E002E670D002E670F002E660E002C64
      0E002C620F002A610E002B55120014130F001D1A10005F5C1800646317006664
      1700686419006764180066651800676518006665180066651800656417006462
      170063611600615E17005755140019140E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000206173000E4F600016627700176B
      8100186F8300197187001A7388001C7488001B7389001B738A001A7187001A6F
      8500186B810018677B00145B6E001D5160003A7218001E5E05002E770A003382
      0D0035860E0037890F00378B0F003A8C10003A8C0F00388C0D003A8A0E003686
      0E0034840D00317B0D00276D070033631600726F1D00615F0F0075741700817F
      190083821A0087861B0088881C0089891B0089881A008A891B0089871C008583
      1A00818119007A7A18006F6D140065631A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000207386001050630015677C001871
      88001A778F001D7F970020849E0020859F002185A1001F859E001F809B001C7B
      92001A748A00176A810010546400247386003F8B1800205D05002F7C0B00388B
      0C003C921000439D120052A7250048A5160053AE290045A31600419F13003E97
      1200398D0E0034810B0022630400458D1D0088842000625F0F007B7A16008886
      1A008F8D1D0096961F009D9C22009F9D22009F9E22009E9D22009A9920009392
      1F008B8A1C00827F1800656512008A8821000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000023788B000C4E5E000F586A001462
      75001A6E8500247E9500A4CDD4008BBECD008AC0CC00A2CAD3001F7D97001D73
      8A0016667C00105B6D000C4E5F00287C8E00458E1B001E5A040025680500558E
      36009AC28800C1DCB5008ECB71006AB5430077C05200BADBA80080BB63004994
      22002F7D0A00276C05001F5C0400489520008A8922005D5D0F006A6911007673
      16008581190091901E009C9B2100A09E2300A0A024009E9E2200979521008B8A
      1A007D7B16006E6D120060600F00929025000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000025798C000D4E5F0010596D001668
      7D001E798F002188A400A9D5DF002D9AB500309FBA00A5D2DD00238DAB001E7E
      9800186D8200125E70000C4E60002A7F9200468F1C001E5B0300256C0500B3CC
      A500E9F2E4008BC96C0066BE3800AADF93006BC53C0093D67100EDF6E700E0F0
      DA005F9D41002A7106001F5C02004D9820008D8B2300666418008D8D4A008788
      2D00908E1D00A1A12300B0AD2700C0BE4E00C3C25300B5B12900A9A825009897
      20008B89250094914C006D6B1F00969426000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000267B8D000D506100115C6F00176B
      80002F89A0008CC5D300DBEEF30043ABC90051B5CE00DBEEF30091CAD6003593
      A80019738800146274000B4F60002B819400468F1D001F5C040033751200D8E6
      D30077BB56009BD27E007DD45000D3F1C300A3E284005CCA2000A2DD8700ECF5
      E6007FB466002C7609001F5D04004E9822008D8C230063641600E5E6D900CCCA
      9F0096951F00ADAC2700BBBA2E00F2F2D400F6F5E300C2C23C00B5B52700A0A1
      2300BEBE7F00EDEEE2006F702600979529000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000257A8D000C4F6100125C70006BA1
      AE00C9E0E6007ABFD100ADDBE60063C0D80077C8DD009CD4E30078C2D200CEE6
      EC007AAFBB00176378000E4F60002B829500468E1D001F5D0300518B3A006AA4
      4C00419F1200C1E6AC0065CD3100D1F3BD00A0E680005CD0230059C42200B4DE
      9D009AC384002D770700205E0300509923008E8B24005F5F0E00B8B88E00EBEC
      D900A5A43800B5B43500CAC85100F8F9E900FAFBEC00D2D06200BEBD3700A9AA
      3300E7E6C800CACCA70062610E00989729000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000267B8D000C4E610092B3BC00C4D9
      DE00328DA6007FBFD000F8FDFA007BC8DF008DD2E000F7FCFB006BBACE003A98
      B200D5E7EB0086AFB7000E4F5F002B82950047901D001F5E0300277007003183
      0C0045A1180092D670006AD1340093E36C00B7ED9900ABE68C0056C61C0052AF
      220087BA6C002A760900205E0400509923008E8C2400625F100089883F00F7F6
      EE00F4F2E300F4F5E300F6F8E500FAFAF000FCFBF100F8F8E800F4F7E200F3F3
      E200F8F6EE009F9C5B006261100099972A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000267B8E003A7A8A00A6CFD70047AE
      C90034B4D600D1F1F600C5F1F8007CD8F00073D6EF00D6F5FA00C1EBF50035B9
      DD004DBBD6008DC1CD002B7388002D829500478F1E002F7B0B004AAB1B005AC6
      20006DE32C0075EF3700E2FBD200F1FDEA00F3FEE900E4FCDB0076EE37006CE7
      2D0063D425004FB51E0031810C00529A25008E8C240079781600A4A52600EAEA
      C300FCFAEC00FDFCEF00FFFDF100FEFDEF00FDFDF000FDFDF100FDFCF000FDFA
      ED00F4F4D700B0AF2E00827F1A00989629000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000278197002487A1009CCDDA00D0EC
      F3005CCBE800CCEFF600CFF2F90074DCF6006FDBF500DFF6FC00B9ECF60054CA
      E900C8ECF300A7D5DE002A8BA600328598004B991D0046A2150051B91E005FD3
      240070EF2E008EF85600F1FEE900F1FEE800EEFEE800E3FDD60087F94D0073F4
      2F0066E1280055C21F004AA91800569E2800959427009B9B2000AFAF2800C9C6
      3600EDEEA600FBFCF100FFFEF000FFFEF000FFFEEF00FFFDF100FDFDEF00F3F4
      B900D4D43C00B8B72A00A1A124009D9A2F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000029849B002185A0002894B00077C4
      D600E6F6FB00DDF5FA00FCFEFE00DBF5FB00E0F7FC00FCFEFD00CEF1F800E6F5
      FB0089D0E000289AB7002287A200318596004C9C200045A4150050B71D005BCF
      23006BEA2C00B6FA8E00E9FDDC00C1FDA40099FD64008CFB5300A9FB7F007CF3
      3B0064DD270054C01F0048A91500569D2900989527009E9C2100AEAE2600C3C2
      2F00DCDA3E00F2F19500FCFBD800FEFDF000FEFEF000FCFADF00F2F3A100E5E4
      4400D0CD3100B7B62900A3A125009D9A2E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000288298002285A0002592AE002CA1
      C0004BBED900ADE4F100E9F8FA00FBFDFC00F9FEFB00E8F8FB00B3E6F50052C5
      E0002BA8CA002896B3002186A0002D8093004C9C1F0046A314004FB51B005AC8
      230066E229008EF45B0092FA5E00B4FD8E00D9FDC900EEFEE700F1FDE9009BEF
      710061D4250053BA1D0047A6170050992400959325009D9C2200ADAC2500BDBC
      2B00D3D33300E2E13700E6E63D00F8FAD500FBFBE200E7EA4600E8E53900DCDA
      3600C7C62E00B3B22900A09F240099972B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000237B920021849D00238FAA002899
      B7002EA8C90034B5D8003DC0E1004BC6E5004DC6E60040C2E30033B8DB002EAE
      CF002B9FBC002691AD001F849F0028798E0047971B0046A315004CAF1A0055BF
      1D0098E27300E0F8D100EEFCE600F0FDEA00F0FDE800EFFCE700EFFCE900C6EF
      B00058C621004FB41C0046A417004A961F008F8E23009A9B2100A8A72400B4B3
      2A00C4C52E00D6D53300E0DC3600E7E76800E9E76F00E0DF3600D9D83500CDCC
      3100BCBB2C00ACAC2600A09D2300959027000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000022748A0021829C00218BA6002690
      AC00299AB8002BA2C0002DA8C8002EABCB002EAACB002EA8C9002CA4C4002A9D
      BB002794B100228DA8001F849E00246D8100418E1900479F15004BAE17004EB3
      1B008BD167009EDE7F00A1E27F00A2E48000A1E38000A0E27F009FE07E0097DA
      750057BA21004AAE1A0044A31400438A1A00888422009C9A2100A5A42400ABAA
      2700B6B52A00BEBD2C00C6C42F00C9C73000C9C82F00C7C62E00C2C12C00BAB9
      2A00B0AF2700A7A525009D9C2200898422000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001F6476001D829C002287A200218A
      A500238CA8002691AD002794B0002896B2002795B1002894B0002893AF00258E
      AA00248BA6002289A2001E84A100215962003B781500419F140049A718004AAB
      170049AE18004EB31D0050B61C0051B91D0050B81C0051B81D004FB61D004CB0
      1B004AAD17004AA7180046A61400386C150074701E009B991E00A1A02200A4A3
      2400A7A62500ADAB2700AEAD2900B0B02900AFAF2700AFAE2700AEAC2800AAA9
      2600A5A42500A1A124009E9D20006C6B1C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000161C1D0022657600216C7F00216C
      8000206C7F00216D8000216D8000216D8000216D8000226D8000216D8000206B
      7F00206C7F00216B7E001D5F6E0013151600161F0C003C7B17003E8418003D86
      16003E8616003E8517003E8616003E8717003E8617003F8717003E8616003E85
      18003E8517003D8416003675150015180E001F1E0E0077732000807F1E00817E
      2100817E1F00837F1F00817E2000827E1F00827F2000827F2000827F2000807E
      1F007F7E1F00817C200072711C001C180D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000171412002F2D2C002D2B2A002A28
      2800262524002524230025232300252423002524230026242400262424002524
      2300252323002523230025222100151110001C1B10004D631F00526C2000536D
      2000526C1F00526C1F00536D2000536E2000536E2000526D2000526D2000516B
      1F00506A1E004F691D00465A1E0016160D00181D130022594300206045002161
      450020604400216145002061450021614500216145002161450021604500205F
      44001F5E43001E5C41001F5139001513110017171D002B346E002D3679002D37
      78002C3778002D3678002D3778002D3779002C3678002D3778002C3678002C35
      77002B3674002A347300282F5F00151212002D2B2A001F202000232323002424
      2400242424002424240025252500242424002F2F2F0028282800252525002424
      2400242424002222220021212100272524005C7724004D6B1C005F822200668A
      280067902500699126006A9326006C9428006C9529006C9328006B922800698F
      2700678C27006285250057791F00506821002A6E5100135B3C001F705100237A
      5800257D5A0026805C0027825D0027835E0027825E0027825E0026815D00257E
      5B00237B5800207453001D674A00265E4300323F820028347D00324092003543
      9B0034449F003646A1003747A3003646A4003647A4003847A3003647A3003644
      A10034449C00334294002F3B8A002C316900282725001B1C1B00222121002323
      2300262626002727270028282800282828005050500029292900272727002626
      260025252500222222001C1D1E002D2C2C00688D2A004E6C1A00628523007196
      2F00B2CA8900D8E5C400D1E2B5009DBF61007EA92F007CA82E0079A32D00749C
      2A006E952800668A260051711D006C8F2A002B825D00155C4000217552002681
      5B00298961002C9168002F966D002F986D0030996D0030986C002C9468002A8D
      630027855E00237A560016604200328260003645980028377D00334098003745
      A3003848AB003B50B0005E6DC4004C5CC1005361C1005B6AC4003C4FB400384B
      AC003747A50034439A0029377F003744930029272600202020001D1D1E001E1E
      1E00232323002B2B2B00282828003D3D3D004949490029292900272727003434
      3400434343001E1E1E001C1C1C002F2E2D0070912C004D691A0059772400CAD4
      B800F0F4EB00F1F5EA00F2F6EB00F3F7EA00ABC676007DA82D0077A02C006D93
      2A0063862300597820004C6B190072942F002E88620015583E00196447002F7A
      5D0039896A002F8E670034996E00389B7400379C7400359A720030926B003A90
      6D00358062001A68480015593F00348B66003A489A0029357B002D3985002E3D
      91005C69AE00CBCFEB00F5F6FA00717FCC00808BD300F4F7FA00C5C9E5005865
      B200304097002C3B870028347A003A4997002A2827001C1B1C001D1D1E002121
      210025252500373737002D2D2D0060606000363636002D2D2D00404040005656
      5600252525001E1E1E001C1C1C00302F2E0071922D004D6A1B0089A06200F0F3
      EA00F1F4EB00F3F7EB00F4F8EA00F4F8EC00E9F2DA0090BE3D0092BB4A0082A9
      3E00688D24005B7C21004F6B1B0075982F003089640015593F001B674800B0CC
      C100C2DCD10098CDBB00D0E9E000CFECDF00D1ECE100D1EAE1009FD2BD00C4DF
      D400B2D0C4001B6A4C0015593D0037906A003A4A9B0028357B002C3A87006470
      AB00EBECF600C7CCED006E7FD6004A5DCF004B60D0007482DD00D0D4F000E7E9
      F2005B67AE002F3B8C00273579003B4A9A002A2828001C1B1C001E1E1E002222
      2200272727002C2C2C00464646005F5F5F00303030004B4B4B00616161002D2D
      2D0024242400202020001C1C1C003231300071922D004D6B1A00A4B68700F1F4
      EB00F2F6EA00F3F7EB00F5F9EB00F5FAEC00F4FAE800A2CF5000A0C956008FB6
      49006E9528005E8022004F6C1B00789A3100318B6600155A3F001B6949005F9C
      820099CAB900A8D9C500A8DDC700EDF8F500ECF9F400ABE2CC00A5DAC7009DD1
      BB0063A389001E6F4D00135A3D0039926C003A499B0029367C003C479000DFE1
      ED00B6BDE5004B5DC90097A2E8006D7FE5007886E800929FE5004A5ED100C0C7
      E900D7DBEB003543920028367A003D4B9B002B2929001C1B1B001E1D1E002222
      22002828280030303000656565004C4C4C005555550067676700373737002A2A
      2A00252525002B2B2B00202020003534340070912C004E6A1B0092A86C00F0F4
      EA00F2F6EB00F4F8EC00F5FBEB00F4FAEB00EDF9DE009ED146008FC4350081AE
      31006F9727005F812200506C1C00799A3000318A6500135A3D007BA8950081B1
      9F00E3F1EC009CD5BD00ABE2CD009FE0C600A0E0C500AFE5CF00A1D9C200E1F2
      EB007DB29D007DAE9900155C3F0039936D003A499C0029357C008088B600E8E9
      F3004C5DBC00ADB5E700EEF3FA006E80E8007A8AE900F1F3FA00A0ABE7005867
      C900EDEFF600767EB40027367A003D4C9C002C2A2A001C1B1B00272627003131
      310028282800494949006C6C6C00606060006B6B6B003E3E3E00343434004747
      4700555555003C3C3C001F1F1F003A38380071922C004F6C1B00607F2900DBE3
      CC00F2F6EB00F4F8EC00F5FAEC00F5FAEC00C9E79200C3E28C0093C33D0084B2
      330070952D005F812200506C1C00799A3100318C660039705900E2ECEA0083B5
      A100F3F8F800E3F4ED0085D6B300CCEEE000CCEEE2008CD6BA00E4F5EF00F2FA
      F7007CB19E00EAEFEB002E6D55003A936D003B499C0029357C008B93BB0099A2
      CD004655BC00C6CDEE00818FE700687AEA006176E8008897EA00BEC7EB004858
      C300A6AFD6008D97BF0028357A003D4C9C002E2C2B00212020002A2A2B002E2E
      2E0037373700696969006D6D6D006D6D6D005C5C5C005E5E5E00696969005151
      5100343434002D2D2D00252525003C3B3A0072922D006184230081AF34009ECD
      4A00DAF2AD00EEFBD600EBFCCE00D3FA8F00D5F59900F7FDEC00E1F5B900E0F2
      BE00A9D8580087B73400668B2500799B3300308B670047896F00E0F1EA0087D0
      B200BBF0DB00A5EACD00B4F3DC00B7F0DB00B6F2D700B3F5DB00A7EBD000BEF2
      DE0083D4B500E2F5EC003E87690039936E003A4A9B00314197004756C3004A5F
      D8005268EC005571F3005370F900C7CEFC00BBC4FC005571FA005A70F8005469
      F2004D64E2004558CB00324199003F4C9B00302E2D00282728002C2C2C003131
      3100525252006D6D6D006D6D6D006D6D6D006B6B6B00565656003E3E3E003838
      3800333333002F2F2F002E2E2E00403F3E00779A2D007AA52F0089BB340099CF
      3A00ABE94100B3F24700B7F74700C6FA6F00F8FCEC00F9FEEE00F8FDEC00F7FD
      EE00AFE05A008EC1370080AB30007E9F370035936D0056AA8600A9DAC80092D9
      BD00C9F3E100A5F0D400E0FAEF00F4FDFA00F7FCFC00E0FAF100A7EFD300C5F3
      E20093E0C200ACE0CD004DA684003D9672003B4DA5003C50B800A7B0E500BFC8
      F5005970F800DCE5FC00A7B6FB00627BFA00637EF900B2BFFC00D7DCFC005873
      F700CBD3FA00A6B0E7003D50BB00414F9D0032302F00282828002C2C2C003535
      35006A6A6A006D6D6D006C6C6C005A5A5A00404040003A3A3A00393939003838
      3800343434002E2E2E002D2D2D00403F3E00789D2F007CA72D0088B83400AAD5
      6000B8EA6000B2F14400B6F54600B7F74800CFF88700F7FDEB00F8FDED00F7FD
      EE00ADDC59008DC135007EAC2F007D9D370036956F0055AB87009DD6C00090D7
      BB00A1E9CC0089EBC3009DEFCE009EF1D0009CF1CF009FF1CE008BECC400A2ED
      CF0094DEBF00A5DBC4004DA783003D9571003E4EA9003C50BA007F8CD900F1F3
      FA006E81F90092A3FB00F4F4FD008295FD008CA0FD00F1F3FE00869CFA007A8C
      FA00F1F4FC007483DC003F50BB0042509D0033313100292829002B2B2C003939
      3900686868005D5D5D0043434300383838003939390039393900383838003636
      3600424242002E2E2E002E2E2E00403E3E00769C2E007CA72D0087B6320097C8
      3E00A6DE4400AEEB4300B2F04500B4F34500DBF9AA00F1FCDF00F1FBDE00F0F9
      DF00A9D7540091BE41007CAB2D007A9A320036926B0054AA8600D6EEE400B6E5
      D200BCEDD900BEF2DE00C0F6E0006BEAB5006FE7B900C1F4E200BDF4DE00BDF0
      DC00BAE7D700D6EEE5004BA780003A916D003D4DA9003C4FBA00485AC800CCD3
      F300D8DFFB006179FA00768CFC006A7FFD006E84FD007187FD006C81FA00DDE4
      FC00C3CAF1004359CC003D4FBB003D4B9A0033313000292829002B2B2C002D2D
      2D00333333003434340036363600373737004242420037373700363636003333
      33002F2F2F002C2C2C00303030003F3E3E0071962B007BA72D0084B231008EBE
      350099CF3A00A5DE4100ABE74300ADE94400B0EC4900B0E94B00ABE34900A1D7
      4400D1E9A900EBF3DD0093B7540073962F00328C670031996D0049AA86004DB7
      8C0054C597005AD4A200A7EACE007CE4B9007BE5BA00A0EACD005AD7A40057CC
      9B004FBE90004BAF880032997000348B67003B4AA7003C4FBA003F53C300576C
      D300DDE0F800E5EAFA00AAB5FB00647BF9006680FA00ADB7FC00E9EEFC00D7DB
      F5005567D9004356C6003D4EBA0038479600343232002928290029292A004545
      45003B3B3B002F2F2F0031313100333333003838380031313100303030002E2E
      2E002C2C2C002C2C2C0033333300403E3E00698E2A0079A42E0082AF310087B5
      32008EBF35009ECB4B00BCE07F009BD23E009BD23C009CD03B0097CA3A0091C3
      3700D6E7BB00F2F7E6009ABC60006A8B2A002D84600030956B00329F730035A5
      780039B07F003DB9860041C08C0040C28E0043C48E0041C18C003EBD89003CB4
      830039A97C0031A074002F976C002F7F5D003947A0003D4EB6003E53C1004055
      C7004E62D200A3AFE800DEE2F8007A88EA008594EC00DCE2F6009DA8EB004E61
      D5004357CB003F53C2003C4EB80034418F0038363400302F3000292A2A003D3E
      3D00353534002D2D2D002D2D2D002E2F2F002D2E2E002D2E2E002D2D2D002C2C
      2C002B2B2B002D2D2D003A3A39003C3B39005E7A260076A32C007FAB300081AE
      310083B0320087B6310088B7350089BA340088BA33008AB8340088B7330083B4
      310086B23A008FB649007CA92C00586F2400277153002E936900329B6F00329E
      730032A1730035A6770036A87A0038AA7B0037A97B0037A97C0037A8790034A3
      7600309F7300319B71002E986C0026654800363D8D003A4EB4003E51BC003F52
      BF004153C2004153C8004354C8004057CB004257C8004355CA004256C9004054
      C4003F53BF003F52BD003D4FBA002E3671001B16130038373500302E2F002B2B
      2A002D2B2B002E2C2B002F2D2C00302D2D00312E2E00322F2E0031302D003130
      2D002F2D2E00323031003B383900181515001F1F11005F7C2600658627006686
      2800658628006586290065872700658729006486280065872800658628006587
      270066862800658527005C7724001B190F001A1E1600297354002C7B58002C7B
      5A002C7B59002B7A59002C7B5A002D7B5A002C7B5A002D7B5A002D7B5A002C7A
      59002B7A59002C7A59002B6B4E001317130017182100333F8800344192003541
      9100354191003641910037429200354293003540940035429300354291003541
      920034419000354190002F397F0016131600424D3E000000000000003E000000
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
  object tim_time_sync_auto: TTimer
    OnTimer = tim_time_sync_autoTimer
    Left = 480
    Top = 168
  end
end
