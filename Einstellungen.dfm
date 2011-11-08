object FRM_Einstellungen: TFRM_Einstellungen
  Left = 305
  Top = 220
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Einstellungen'
  ClientHeight = 233
  ClientWidth = 532
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  DesignSize = (
    532
    233)
  PixelsPerInch = 96
  TextHeight = 13
  object Label10: TLabel
    Left = 36
    Top = 160
    Width = 28
    Height = 13
    Caption = 'Datei:'
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 531
    Height = 200
    ActivePage = TS_Farben
    Anchors = [akLeft, akTop, akRight, akBottom]
    MultiLine = True
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    object TS_allgemein: TTabSheet
      Caption = 'Allgemein'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label17: TLabel
        Left = 4
        Top = 64
        Width = 78
        Height = 13
        Caption = 'Aktuelles Plugin:'
      end
      object LBL_Plugin: TLabel
        Left = 112
        Top = 64
        Width = 54
        Height = 13
        Caption = 'LBL_Plugin'
      end
      object Label18: TLabel
        Left = 4
        Top = 116
        Width = 101
        Height = 13
        Caption = 'Aktuelle Sprachdatei:'
      end
      object LBL_Sprachdatei: TLabel
        Left = 112
        Top = 116
        Width = 82
        Height = 13
        Caption = 'LBL_Sprachdatei'
      end
      object CH_AutoUpdate: TCheckBox
        Left = 4
        Top = 132
        Width = 245
        Height = 17
        Caption = 'automatischer Updatecheck bei Programmstart'
        TabOrder = 4
      end
      object BTN_ChangeSpielerdaten: TButton
        Left = 4
        Top = 4
        Width = 141
        Height = 25
        Caption = #196'ndere Spielerdaten...'
        TabOrder = 0
        OnClick = BTN_ChangeSpielerdatenClick
      end
      object BTN_LangPlugin: TButton
        Left = 4
        Top = 36
        Width = 141
        Height = 25
        Caption = 'W'#228'hle Plugin....'
        TabOrder = 1
        OnClick = BTN_LangPluginClick
      end
      object BTN_Sprachdatei: TButton
        Left = 4
        Top = 84
        Width = 141
        Height = 25
        Caption = 'W'#228'hle Sprachdatei....'
        TabOrder = 3
        OnClick = BTN_SprachdateiClick
      end
      object GroupBox8: TGroupBox
        Left = 308
        Top = 8
        Width = 217
        Height = 57
        Caption = ' Trayicon '
        TabOrder = 5
        object CH_MiniSysTray: TCheckBox
          Left = 8
          Top = 16
          Width = 201
          Height = 17
          Caption = 'Schlie'#223'en = Minimieren in Systemtray'
          TabOrder = 0
        end
        object cb_start_systray: TCheckBox
          Left = 8
          Top = 32
          Width = 197
          Height = 17
          Hint = 'Das Programm verschwindet direkt nach dem Start in den Systray'
          Caption = 'Start im Hintergrund'
          TabOrder = 1
        end
      end
      object btn_plugin_options: TButton
        Left = 148
        Top = 36
        Width = 137
        Height = 25
        Caption = 'Plugin Einstellungen'
        TabOrder = 2
        OnClick = btn_plugin_optionsClick
      end
    end
    object TS_ScansSysteme: TTabSheet
      Caption = 'Scans/Systeme'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 337
        Height = 151
        Caption = ' Scans '
        TabOrder = 0
        DesignSize = (
          337
          151)
        object Label13: TLabel
          Left = 28
          Top = 36
          Width = 55
          Height = 13
          Caption = 'der maximal'
        end
        object Label14: TLabel
          Left = 136
          Top = 36
          Width = 178
          Height = 13
          Caption = 'Stunden alt ist (0 = ohne Begrenzung)'
        end
        object CH_AddNewScan: TCheckBox
          Left = 8
          Top = 16
          Width = 325
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'jeden neuen Scan gleich in Liste aufnehemen,'
          TabOrder = 0
        end
        object CH_ShowCountScan: TCheckBox
          Left = 8
          Top = 56
          Width = 325
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Best'#228'tigung beim Einlesen von Scans'
          TabOrder = 2
        end
        object CH_AutoDelete: TCheckBox
          Left = 8
          Top = 72
          Width = 325
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'automatisches L'#246'schen von Scans gel'#246'schter Planeten'
          TabOrder = 3
        end
        object TXT_maxhourstoadd: TEdit
          Left = 92
          Top = 32
          Width = 41
          Height = 21
          TabOrder = 1
          Text = '48'
          OnKeyPress = KeyPress_OnlyNumbers
        end
        object cb_check_solsys_data_for_moon: TCheckBox
          Left = 8
          Top = 104
          Width = 313
          Height = 17
          Caption = #252'berpr'#252'fe vor Mondfrage das Sonnesystem'
          TabOrder = 5
        end
        object cb_no_moon: TCheckBox
          Left = 8
          Top = 88
          Width = 313
          Height = 17
          Caption = 'Mondfrage deaktivieren (unklar -> kein Mond)'
          TabOrder = 4
        end
      end
      object GroupBox12: TGroupBox
        Left = 343
        Top = 0
        Width = 177
        Height = 42
        Caption = ' Scanliste/Favoriten '
        TabOrder = 1
        object cb_auto_fav_list: TCheckBox
          Left = 8
          Top = 16
          Width = 166
          Height = 17
          Caption = 'Liste automatisch verwalten'
          TabOrder = 0
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Automatisches Einlesen'
      ImageIndex = 10
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox2: TGroupBox
        Left = 0
        Top = 4
        Width = 333
        Height = 85
        Caption = ' '#220'berwachen der Zwischenablage '
        TabOrder = 0
        object Label11: TLabel
          Left = 8
          Top = 56
          Width = 175
          Height = 13
          Caption = 'UrlName: (http://<xxx>.ogame.de/...)'
        end
        object CH_Clipboard: TCheckBox
          Left = 8
          Top = 20
          Width = 317
          Height = 17
          Caption = 'Aktiviert'
          TabOrder = 0
        end
        object CH_Unicheck: TCheckBox
          Left = 8
          Top = 38
          Width = 317
          Height = 17
          Hint = 
            'Vor dem automatischen Einlesen der Daten auf das richtige Univer' +
            'sum pr'#252'fen.'
          Caption = 'Uni-Check (ob die Daten aus dem richtigen Uni sind)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = CH_UnicheckClick
        end
        object txt_UniCheckName: TEdit
          Left = 192
          Top = 56
          Width = 121
          Height = 21
          TabOrder = 2
          Text = 'txt_UniCheckName'
        end
      end
      object GroupBox11: TGroupBox
        Left = 338
        Top = 4
        Width = 181
        Height = 69
        Caption = ' Linux/Wine '
        TabOrder = 1
        object Label2: TLabel
          Left = 8
          Top = 40
          Width = 59
          Height = 13
          Caption = 'Intervall(ms):'
        end
        object CB_FakeClipbrdViewer: TCheckBox
          Left = 8
          Top = 16
          Width = 161
          Height = 17
          Hint = 
            'Die Zwischenablage wird in einem festen Zeitabstand '#228'uf '#196'nderung' +
            'en gepr'#252'ft'
          Caption = 'Fake ClipbrdViewer'
          TabOrder = 0
        end
        object TXT_FakeCVIntervall: TEdit
          Left = 76
          Top = 36
          Width = 97
          Height = 21
          TabOrder = 1
          Text = '1000'
          OnKeyPress = KeyPress_OnlyNumbers
        end
      end
      object GroupBox16: TGroupBox
        Left = 338
        Top = 76
        Width = 181
        Height = 69
        Caption = ' cSHelper TCP-Listener '
        TabOrder = 2
        object Label31: TLabel
          Left = 8
          Top = 40
          Width = 59
          Height = 13
          Caption = 'Portnummer:'
        end
        object cb_cshelper_listener: TCheckBox
          Left = 8
          Top = 16
          Width = 161
          Height = 17
          Hint = 
            'Am angegebenen Port wird auf eingehende Verbindungen zum cS-Help' +
            'er und die Daten gewartet.'
          Caption = 'Port ge'#246'ffnet'
          TabOrder = 0
        end
        object txt_cshelper_listener_port: TEdit
          Left = 76
          Top = 36
          Width = 97
          Height = 21
          TabOrder = 1
          Text = '32432'
          OnKeyPress = KeyPress_OnlyNumbers
        end
      end
      object CH_Beep: TCheckBox
        Left = 8
        Top = 100
        Width = 317
        Height = 17
        Caption = 'Spiele Sound ab wenn Scan/System/Stats erkannt wurde(n)'
        TabOrder = 3
      end
      object txt_beep_sound_file: TEdit
        Left = 64
        Top = 120
        Width = 189
        Height = 21
        TabOrder = 4
        Text = 'beep'
      end
      object btn_play1: TButton
        Left = 256
        Top = 120
        Width = 29
        Height = 21
        Caption = 'play'
        TabOrder = 5
        OnClick = btn_play1Click
      end
      object btn_select1: TButton
        Left = 288
        Top = 120
        Width = 21
        Height = 21
        Caption = '...'
        TabOrder = 6
        OnClick = btn_select1Click
      end
    end
    object TS_GalaxieExplorer: TTabSheet
      Caption = 'Galaxie-Explorer'
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox7: TGroupBox
        Left = 4
        Top = 4
        Width = 137
        Height = 93
        Caption = ' Zeitangaben '
        TabOrder = 0
        object Label6: TLabel
          Left = 8
          Top = 16
          Width = 121
          Height = 33
          AutoSize = False
          Caption = 'F'#252'r alle die '#246'fters am Tag die Galaxien scannen:'
          WordWrap = True
        end
        object RB_Explorer_genaueZeitangabe: TRadioButton
          Left = 8
          Top = 48
          Width = 125
          Height = 17
          Caption = 'genaue Zeitangabe'
          TabOrder = 0
        end
        object RB_Explorer_nurDatum: TRadioButton
          Left = 8
          Top = 64
          Width = 125
          Height = 17
          Caption = 'nur Datumsangabe'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
      end
      object GroupBox9: TGroupBox
        Left = 148
        Top = 4
        Width = 125
        Height = 93
        Caption = ' '
        TabOrder = 1
        object CH_explorer_MouseOver: TCheckBox
          Left = 12
          Top = 16
          Width = 105
          Height = 17
          Hint = 'Auswahl erfolgt ohne Mausklick'
          Caption = 'Mouseover aktiv'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
      end
      object GroupBox10: TGroupBox
        Left = 4
        Top = 100
        Width = 185
        Height = 49
        Caption = ' Tr'#252'mmerfeldmarkierung '
        TabOrder = 2
        object LBL_TF1: TLabel
          Left = 8
          Top = 24
          Width = 47
          Height = 13
          Caption = 'ab Gr'#246#223'e:'
        end
        object TXT_TF_markierung_groesse: TEdit
          Left = 72
          Top = 20
          Width = 101
          Height = 21
          TabOrder = 0
          Text = '20000'
        end
      end
      object GroupBox14: TGroupBox
        Left = 312
        Top = 4
        Width = 201
        Height = 101
        Caption = ' Farben f'#252'r u, n, i Status der Spieler '
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
        object Shape4: TShape
          Left = 8
          Top = 16
          Width = 185
          Height = 81
          Brush.Color = clBlack
        end
        object sh_lbl_inactive: TShape
          Left = 16
          Top = 72
          Width = 169
          Height = 17
          Brush.Color = 74
        end
        object sh_lbl_noob: TShape
          Left = 16
          Top = 48
          Width = 169
          Height = 17
          Brush.Color = 11520
        end
        object sh_lbl_vacation: TShape
          Left = 16
          Top = 24
          Width = 169
          Height = 17
          Brush.Color = clNavy
        end
        object lbl_vacation: TLabel
          Left = 16
          Top = 24
          Width = 169
          Height = 13
          Hint = 'W'#228'hle hier die Farbe Schwarz, um diese Funktion zu deaktivieren!'
          Alignment = taCenter
          AutoSize = False
          Caption = 'Urlaubsmodus <click>'
          Color = clNavy
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = lbl_vacationClick
        end
        object lbl_noob: TLabel
          Left = 16
          Top = 48
          Width = 169
          Height = 13
          Hint = 'W'#228'hle hier die Farbe Schwarz, um diese Funktion zu deaktivieren!'
          Alignment = taCenter
          AutoSize = False
          Caption = 'Noobstatus <click>'
          Color = 11520
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = lbl_vacationClick
        end
        object lbl_inactive: TLabel
          Left = 16
          Top = 72
          Width = 169
          Height = 13
          Hint = 'W'#228'hle hier die Farbe Schwarz, um diese Funktion zu deaktivieren!'
          Alignment = taCenter
          AutoSize = False
          Caption = 'Inaktive Spieler <click>'
          Color = clMaroon
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          OnClick = lbl_vacationClick
        end
      end
    end
    object TS_FleetDef: TTabSheet
      Caption = 'Fleet/Def Punkte'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object LBL_FD: TLabel
        Left = 188
        Top = 72
        Width = 161
        Height = 37
        AutoSize = False
        WordWrap = True
      end
      object Label8: TLabel
        Left = 188
        Top = 4
        Width = 329
        Height = 65
        AutoSize = False
        Caption = 
          'Info: Diese Punkte werden f'#252'r die Punkteberechnung der Spalten F' +
          'lotte, Verteidigung und der Ress/Def Spalte in der Scanliste ver' +
          'wendet. Somit ist es m'#246'glich die Gewichtung der einzelnen Einhei' +
          'ten individuell anzupassen.'
        WordWrap = True
      end
      object LB_FD: TListBox
        Left = 4
        Top = 4
        Width = 177
        Height = 133
        ItemHeight = 13
        TabOrder = 0
        OnClick = LB_FDClick
      end
      object TXT_FD: TEdit
        Left = 188
        Top = 116
        Width = 161
        Height = 21
        TabOrder = 1
        Text = '0'
        OnChange = TXT_FDChange
        OnKeyPress = KeyPress_OnlyNumbers
      end
    end
    object TS_Angriffsberechnung: TTabSheet
      Caption = 'Angriffsberechnung'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox3: TGroupBox
        Left = 4
        Top = 0
        Width = 413
        Height = 33
        Caption = ' '
        TabOrder = 0
        object RB_Dragologic: TRadioButton
          Left = 4
          Top = 12
          Width = 161
          Height = 17
          Caption = 'Normal (nach Dragosimlogik)'
          TabOrder = 0
        end
        object RB_PlanDBlogic: TRadioButton
          Left = 172
          Top = 12
          Width = 117
          Height = 17
          Caption = 'Nach PlanDB Logik'
          TabOrder = 1
        end
      end
      object GroupBox4: TGroupBox
        Left = 4
        Top = 36
        Width = 413
        Height = 113
        Caption = '    '
        TabOrder = 1
        object Label3: TLabel
          Left = 216
          Top = 48
          Width = 67
          Height = 13
          Caption = 'Ladekapazit'#228't'
        end
        object Label4: TLabel
          Left = 304
          Top = 48
          Width = 92
          Height = 13
          Caption = 'Treibstoffverbrauch'
          Visible = False
        end
        object Label5: TLabel
          Left = 8
          Top = 20
          Width = 84
          Height = 13
          Caption = 'Flottenstartplanet:'
        end
        object Label7: TLabel
          Left = 8
          Top = 48
          Width = 28
          Height = 13
          Caption = 'Name'
        end
        object Label1: TLabel
          Left = 200
          Top = 20
          Width = 39
          Height = 13
          Caption = 'Flugzeit:'
        end
        object TXT_Schlachter_Laderaum: TEdit
          Left = 216
          Top = 64
          Width = 85
          Height = 21
          TabOrder = 3
          Text = '0'
          OnKeyPress = KeyPress_OnlyNumbers
        end
        object TXT_Transporter_Laderaum: TEdit
          Left = 216
          Top = 84
          Width = 85
          Height = 21
          TabOrder = 6
          Text = '0'
          OnKeyPress = KeyPress_OnlyNumbers
        end
        object TXT_Schlachter_Treibstoff: TEdit
          Left = 304
          Top = 64
          Width = 85
          Height = 21
          TabOrder = 4
          Text = '0'
          Visible = False
          OnKeyPress = KeyPress_OnlyNumbers
        end
        object TXT_Transporter_Treibstoff: TEdit
          Left = 304
          Top = 84
          Width = 85
          Height = 21
          TabOrder = 7
          Text = '0'
          Visible = False
          OnKeyPress = KeyPress_OnlyNumbers
        end
        object TXT_RaidStart: TEdit
          Left = 100
          Top = 17
          Width = 89
          Height = 21
          TabOrder = 0
          Text = '1:1:1'
          OnKeyPress = TXT_RaidStartKeyPress
        end
        object TXT_SS: TEdit
          Left = 8
          Top = 64
          Width = 205
          Height = 21
          TabOrder = 2
        end
        object TXT_gT: TEdit
          Left = 8
          Top = 84
          Width = 205
          Height = 21
          TabOrder = 5
        end
        object TXT_Flugzeit: TEdit
          Left = 272
          Top = 16
          Width = 117
          Height = 21
          TabOrder = 1
          Text = '00:50:00'
        end
      end
    end
    object TS_Websim: TTabSheet
      Caption = 'Websim'
      ImageIndex = 11
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox15: TGroupBox
        Left = 0
        Top = 0
        Width = 353
        Height = 153
        Caption = ' Meine Forschungen '
        TabOrder = 0
        object Label12: TLabel
          Left = 8
          Top = 24
          Width = 73
          Height = 13
          Caption = 'Waffentechnik:'
        end
        object Label25: TLabel
          Left = 8
          Top = 48
          Width = 67
          Height = 13
          Caption = 'Schildtechnik:'
        end
        object Label26: TLabel
          Left = 8
          Top = 72
          Width = 71
          Height = 13
          Caption = 'Panzertechnik:'
        end
        object Label27: TLabel
          Left = 144
          Top = 24
          Width = 112
          Height = 13
          Caption = 'Verbrennungstriebwerk:'
        end
        object Label28: TLabel
          Left = 144
          Top = 48
          Width = 76
          Height = 13
          Caption = 'Impulstriebwerk:'
        end
        object Label29: TLabel
          Left = 144
          Top = 72
          Width = 86
          Height = 13
          Caption = 'Hyperraumantrieb:'
        end
        object Label30: TLabel
          Left = 8
          Top = 104
          Width = 209
          Height = 13
          Caption = 'Startplanet, siehe Tab "Angriffsberechnung"'
        end
        object se_tech_0: TSpinEdit
          Left = 88
          Top = 24
          Width = 41
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
        object se_tech_1: TSpinEdit
          Left = 88
          Top = 48
          Width = 41
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 0
        end
        object se_tech_2: TSpinEdit
          Left = 88
          Top = 72
          Width = 41
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 2
          Value = 0
        end
        object se_engine_0: TSpinEdit
          Left = 264
          Top = 24
          Width = 41
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 3
          Value = 0
        end
        object se_engine_1: TSpinEdit
          Left = 264
          Top = 48
          Width = 41
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 4
          Value = 0
        end
        object se_engine_2: TSpinEdit
          Left = 264
          Top = 72
          Width = 41
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 5
          Value = 0
        end
      end
    end
    object TS_Farben: TTabSheet
      Caption = 'Farben'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TC_Farben: TTabControl
        Left = 8
        Top = 8
        Width = 481
        Height = 89
        TabOrder = 0
        Tabs.Strings = (
          'Scanberichte'
          'Sonnensysteme/Sensorphalax/Forschungen'
          'Statistiken'
          'Punkte')
        TabIndex = 0
        OnChange = TC_FarbenChange
        OnChanging = TC_FarbenChanging
        DesignSize = (
          481
          89)
        object PB_ColorsScan: TPaintBox
          Left = 4
          Top = 52
          Width = 469
          Height = 17
          Anchors = [akLeft, akRight, akBottom]
          OnPaint = TXT_ColorMaxChange
        end
        object ALabel6: TLabel
          Left = 8
          Top = 32
          Width = 37
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = #196'lter als'
        end
        object LBL_Scan_Start: TLabel
          Left = 4
          Top = 72
          Width = 81
          Height = 13
          Anchors = [akLeft, akBottom]
          AutoSize = False
          Caption = '0'
        end
        object ALabel9: TLabel
          Left = 120
          Top = 32
          Width = 175
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = ' Stunden wird komplett rot angezeigt:'
        end
        object LBL_Scan_End: TLabel
          Left = 380
          Top = 72
          Width = 94
          Height = 13
          Alignment = taRightJustify
          Anchors = [akRight, akBottom]
          AutoSize = False
          Caption = '340'
        end
        object LBL_Scan_half: TLabel
          Left = 148
          Top = 72
          Width = 185
          Height = 13
          Alignment = taCenter
          Anchors = [akLeft, akRight, akBottom]
          AutoSize = False
          Caption = '170'
        end
        object TXT_ColorMax: TEdit
          Left = 68
          Top = 28
          Width = 45
          Height = 21
          Anchors = [akLeft, akBottom]
          TabOrder = 0
          Text = '340'
          OnChange = TXT_ColorMaxChange
          OnKeyPress = KeyPress_OnlyNumbers
        end
      end
    end
    object TS_Direktverbindung: TTabSheet
      Caption = 'Rechte'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label15: TLabel
        Left = 4
        Top = 112
        Width = 293
        Height = 37
        AutoSize = False
        Caption = 
          'Hinweis: um diese '#196'nderungen zu '#252'bernehmen, muss jede Verbindung' +
          ' erneut aufgebaut werden!'
        WordWrap = True
      end
      object GroupBox5: TGroupBox
        Left = 4
        Top = 3
        Width = 293
        Height = 106
        Caption = ' Rechte der Verbindung zum Server '
        TabOrder = 0
        object sync_scans: TCheckBox
          Left = 8
          Top = 16
          Width = 201
          Height = 17
          Caption = 'synchronisiere Scanberichte'
          TabOrder = 0
        end
        object sync_systems: TCheckBox
          Left = 8
          Top = 48
          Width = 201
          Height = 17
          Caption = 'synchronisiere Sonnensysteme'
          TabOrder = 3
        end
        object CH_Chat: TCheckBox
          Left = 8
          Top = 84
          Width = 49
          Height = 17
          Caption = 'Chat'
          TabOrder = 6
        end
        object BTN_ScanGalaxy_Rights: TButton
          Left = 184
          Top = 16
          Width = 97
          Height = 29
          Caption = 'Gala-Rechte'
          TabOrder = 2
          OnClick = BTN_ScanGalaxy_RightsClick
        end
        object sync_Raids: TCheckBox
          Left = 8
          Top = 32
          Width = 121
          Height = 17
          Caption = 'synchronisiere Raids'
          TabOrder = 1
        end
        object BTN_SystemGalaxie_rights: TButton
          Left = 184
          Top = 48
          Width = 97
          Height = 17
          Caption = 'Gala-Rechte'
          TabOrder = 4
          OnClick = BTN_ScanGalaxy_RightsClick
        end
        object sync_Stats: TCheckBox
          Left = 8
          Top = 64
          Width = 177
          Height = 17
          Caption = 'synchronisiere Statistiken'
          TabOrder = 5
        end
      end
      object GroupBox6: TGroupBox
        Left = 300
        Top = 3
        Width = 193
        Height = 106
        Caption = ' Server '
        TabOrder = 1
        object Label16: TLabel
          Left = 28
          Top = 36
          Width = 22
          Height = 13
          Caption = 'Port:'
        end
        object ch_startupServer: TCheckBox
          Left = 8
          Top = 16
          Width = 173
          Height = 17
          BiDiMode = bdLeftToRight
          Caption = 'starte Server bei Programmstart'
          ParentBiDiMode = False
          TabOrder = 0
        end
        object Button3: TButton
          Left = 8
          Top = 60
          Width = 177
          Height = 37
          Caption = 'Benutzerverwaltung'
          TabOrder = 2
          OnClick = Button3Click
        end
        object TXT_ServerStartPort: TEdit
          Left = 60
          Top = 32
          Width = 81
          Height = 21
          TabOrder = 1
          Text = '44456'
          OnKeyPress = KeyPress_OnlyNumbers
        end
      end
    end
    object TS_Notizen: TTabSheet
      Caption = 'Notizen'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Button4: TButton
        Left = 4
        Top = 4
        Width = 165
        Height = 25
        Caption = 'Typen/Bilder - Einstellungen...'
        TabOrder = 0
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 4
        Top = 32
        Width = 165
        Height = 25
        Caption = 'Lade Standard Typen/Bilder'
        TabOrder = 1
        OnClick = Button5Click
      end
    end
    object TS_SuchLink: TTabSheet
      Caption = 'Such-Link'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label19: TLabel
        Left = 4
        Top = 4
        Width = 361
        Height = 37
        AutoSize = False
        Caption = 
          'Hier kann der Link angegeben werden der bei einem klick auf "Spi' +
          'eler bei XXX.de suchen" aufgerufen wird:'
        WordWrap = True
      end
      object Label20: TLabel
        Left = 4
        Top = 36
        Width = 35
        Height = 13
        Caption = 'Link f'#252'r'
      end
      object Label21: TLabel
        Left = 4
        Top = 112
        Width = 148
        Height = 13
        Caption = 'Name (zum anzeigen im Men'#252'):'
      end
      object Label22: TLabel
        Left = 4
        Top = 60
        Width = 32
        Height = 13
        Caption = 'Spieler'
      end
      object Label23: TLabel
        Left = 4
        Top = 84
        Width = 42
        Height = 13
        BiDiMode = bdLeftToRight
        Caption = 'Allianzen'
        ParentBiDiMode = False
      end
      object Label24: TLabel
        Left = 4
        Top = 136
        Width = 299
        Height = 13
        Caption = 'Variablen: %P = Playername %A = Allianzname %U = Universum'
      end
      object TXT_Spielersuche: TEdit
        Left = 68
        Top = 56
        Width = 425
        Height = 21
        TabOrder = 0
      end
      object TXT_SuchenName: TEdit
        Left = 344
        Top = 108
        Width = 149
        Height = 21
        TabOrder = 2
      end
      object TXT_Allysuche: TEdit
        Left = 68
        Top = 80
        Width = 425
        Height = 21
        TabOrder = 1
      end
    end
    object ts_Flotten: TTabSheet
      Caption = 'Flotten'
      ImageIndex = 9
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label9: TLabel
        Left = 24
        Top = 28
        Width = 145
        Height = 13
        Caption = 'Anzahl Sekunden vor Ankunft:'
      end
      object cb_fleet_popup_enabled: TCheckBox
        Left = 4
        Top = 8
        Width = 233
        Height = 17
        Caption = 'Hinweisfenster bei Flottenankunft anzeigen:'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object txts_fleet_popup_time_s: TSpinEdit
        Left = 300
        Top = 24
        Width = 93
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 240
      end
      object cb_fleet_alert_sound: TCheckBox
        Left = 20
        Top = 48
        Width = 117
        Height = 17
        Caption = 'Sound abspielen:'
        TabOrder = 2
      end
      object txt_fleet_alert_sound: TEdit
        Left = 148
        Top = 48
        Width = 189
        Height = 21
        TabOrder = 3
        Text = 'beep'
      end
      object Button6: TButton
        Left = 372
        Top = 48
        Width = 21
        Height = 21
        Caption = '...'
        TabOrder = 4
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 340
        Top = 48
        Width = 29
        Height = 21
        Caption = 'play'
        TabOrder = 5
        OnClick = Button7Click
      end
      object GroupBox13: TGroupBox
        Left = 3
        Top = 105
        Width = 390
        Height = 46
        Caption = ' Serverzeit '
        TabOrder = 6
        object cb_auto_serverzeit: TCheckBox
          Left = 16
          Top = 16
          Width = 361
          Height = 17
          Caption = 'Automatisch beim Start mit Server synchronisieren'
          TabOrder = 0
        end
      end
      object cb_fleet_msg_auto_close: TCheckBox
        Left = 20
        Top = 72
        Width = 377
        Height = 17
        Hint = 'das blinkt nach Ankunft und man kann es per Klick schlie'#223'en-'
        Caption = 'Nach Ankunft schlie'#223'en'
        TabOrder = 7
      end
    end
  end
  object Button1: TButton
    Left = 450
    Top = 203
    Width = 77
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 374
    Top = 203
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 1
  end
  object od_sound: TOpenDialog
    Filter = 'Sounds|*.wav;*.mp3;*.mid;|Alle|*.*'
    Left = 352
    Top = 86
  end
  object ColorDialog1: TColorDialog
    Left = 384
    Top = 86
  end
end
