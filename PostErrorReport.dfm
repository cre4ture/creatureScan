object frm_postErrorReport: Tfrm_postErrorReport
  Left = 298
  Top = 41
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Senden eines Error Reports'
  ClientHeight = 664
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 376
    Width = 291
    Height = 13
    Caption = 'Aktueller Inhalt der Zwischenablage (wird laufend aktualisiert):'
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 307
    Height = 39
    Caption = 
      'Du m'#246'chtest einen Fehlerbericht an den Entwickler dieses Tools s' +
      'chicken, weil bestimmte Daten nicht richtig eingelesen wurden? D' +
      'ann bist du hier genau richtig:'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 300
    Height = 39
    Caption = 
      'Bitte '#252'berpr'#252'fe unten in dem Textfeld ob der Inhalt der Zwischen' +
      'ablage auch der ist den du schicken m'#246'chtest! Damit dein Bericht' +
      ' auch wirklich ausgewertet werden kann!'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 8
    Top = 120
    Width = 231
    Height = 13
    Caption = 'Art des Inhalt der nicht eingelesen werden kann: '
  end
  object Label5: TLabel
    Left = 8
    Top = 216
    Width = 127
    Height = 13
    Caption = 'Deine Fehlerbeschreibung:'
  end
  object Label6: TLabel
    Left = 8
    Top = 168
    Width = 165
    Height = 13
    Caption = 'Name und Version deines Browser:'
  end
  object Label7: TLabel
    Left = 8
    Top = 320
    Width = 230
    Height = 13
    Caption = 'Deine E-Mail Addresse f'#252'r R'#252'ckfragen: (optional)'
  end
  object Memo1: TMemo
    Left = 8
    Top = 392
    Width = 305
    Height = 177
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 136
    Width = 305
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      'Scans'
      'Sonnensystem'
      'Statistiken'
      'Flotten'
      'Andere... (Angabe im Nachrichten Feld)')
  end
  object mem_desc: TMemo
    Left = 8
    Top = 232
    Width = 305
    Height = 73
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object txt_browser: TEdit
    Left = 8
    Top = 184
    Width = 305
    Height = 21
    TabOrder = 1
    Text = 'zb. Firefox 3.5 ...'
  end
  object Button1: TButton
    Left = 88
    Top = 576
    Width = 153
    Height = 25
    Caption = 'Senden'
    TabOrder = 5
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 608
    Width = 305
    Height = 17
    TabOrder = 6
  end
  object Button2: TButton
    Left = 232
    Top = 632
    Width = 81
    Height = 25
    Caption = 'Abbruch'
    ModalResult = 2
    TabOrder = 7
  end
  object txt_email: TEdit
    Left = 8
    Top = 336
    Width = 305
    Height = 21
    TabOrder = 3
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 56
    Top = 432
  end
  object HTTP: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    OnWork = HTTPWork
    OnWorkBegin = HTTPWorkBegin
    OnWorkEnd = HTTPWorkEnd
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 88
    Top = 432
  end
end
