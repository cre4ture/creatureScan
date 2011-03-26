object FRM_POST_TEST: TFRM_POST_TEST
  Left = 275
  Top = 0
  Width = 610
  Height = 772
  Caption = 'FRM_POST'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 20
    Top = 44
    Width = 74
    Height = 13
    Caption = 'Gesammtdauer:'
  end
  object Label3: TLabel
    Left = 128
    Top = 44
    Width = 51
    Height = 13
    Caption = 'Postdauer:'
  end
  object Label1: TLabel
    Left = 20
    Top = 4
    Width = 41
    Height = 13
    Caption = 'Adresse:'
  end
  object Label5: TLabel
    Left = 20
    Top = 88
    Width = 44
    Height = 13
    Caption = 'Protokoll:'
  end
  object Label6: TLabel
    Left = 304
    Top = 56
    Width = 124
    Height = 13
    Caption = 'Maximales Alter (in Tagen)'
  end
  object txt_url: TEdit
    Left = 20
    Top = 16
    Width = 537
    Height = 21
    TabOrder = 0
  end
  object Button4: TButton
    Left = 113
    Top = 216
    Width = 104
    Height = 25
    Caption = 'StartSync_systems'
    TabOrder = 1
    OnClick = Button4Click
  end
  object TXT_ges: TEdit
    Left = 20
    Top = 60
    Width = 101
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
    Text = 'TXT_ges'
  end
  object TXT_post: TEdit
    Left = 128
    Top = 60
    Width = 97
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 3
    Text = 'TXT_post'
  end
  object Button9: TButton
    Left = 223
    Top = 216
    Width = 105
    Height = 25
    Caption = 'StartSync_reports'
    TabOrder = 4
    OnClick = Button9Click
  end
  object mem_log_all: TMemo
    Left = 21
    Top = 247
    Width = 537
    Height = 51
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object pb_pos: TProgressBar
    Left = 19
    Top = 192
    Width = 537
    Height = 17
    TabOrder = 6
  end
  object pb_main: TProgressBar
    Left = 19
    Top = 172
    Width = 537
    Height = 17
    TabOrder = 7
  end
  object Button1: TButton
    Left = 483
    Top = 216
    Width = 75
    Height = 25
    Caption = 'STOP'
    TabOrder = 8
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 347
    Top = 216
    Width = 75
    Height = 25
    Caption = 'more...'
    TabOrder = 9
    OnClick = Button2Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 304
    Width = 577
    Height = 437
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 10
    object LBL_sys: TLabel
      Left = 20
      Top = 116
      Width = 40
      Height = 13
      Caption = 'LBL_sys'
    end
    object Label4: TLabel
      Left = 20
      Top = 16
      Width = 91
      Height = 13
      Caption = 'aktionen pro POST'
    end
    object LBL_scan: TLabel
      Left = 100
      Top = 116
      Width = 48
      Height = 13
      Caption = 'LBL_scan'
    end
    object Memo1: TMemo
      Left = 20
      Top = 132
      Width = 533
      Height = 109
      Lines.Strings = (
        'Memo1')
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object BTN_genSys: TButton
      Left = 20
      Top = 92
      Width = 75
      Height = 21
      Caption = 'generate solsys'
      TabOrder = 1
      OnClick = BTN_genSysClick
    end
    object BTN_POST_: TButton
      Left = 480
      Top = 108
      Width = 75
      Height = 21
      Caption = 'POST'
      TabOrder = 2
      OnClick = BTN_POST_Click
    end
    object Memo2: TMemo
      Left = 20
      Top = 288
      Width = 533
      Height = 141
      Lines.Strings = (
        'Memo2')
      ScrollBars = ssVertical
      TabOrder = 3
    end
    object Button3: TButton
      Left = 20
      Top = 252
      Width = 93
      Height = 25
      Caption = 'browser'
      TabOrder = 4
      OnClick = Button3Click
    end
    object CH_Auto: TCheckBox
      Left = 200
      Top = 96
      Width = 97
      Height = 17
      Caption = 'auto gen+post'
      TabOrder = 5
    end
    object CH_Pause: TCheckBox
      Left = 20
      Top = 64
      Width = 97
      Height = 17
      Caption = 'Pause'
      TabOrder = 6
    end
    object SpinEdit1: TSpinEdit
      Left = 20
      Top = 36
      Width = 189
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 7
      Value = 15
    end
    object Button5: TButton
      Left = 432
      Top = 44
      Width = 125
      Height = 25
      Caption = 'mysql_scan tables'
      TabOrder = 8
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 120
      Top = 252
      Width = 75
      Height = 25
      Caption = 'ParseAnswer'
      TabOrder = 9
      OnClick = Button6Click
    end
    object BTN_genScan: TButton
      Left = 100
      Top = 92
      Width = 85
      Height = 21
      Caption = 'generate report'
      TabOrder = 10
      OnClick = BTN_genScanClick
    end
    object Button8: TButton
      Left = 200
      Top = 252
      Width = 109
      Height = 25
      Caption = 'ParseAll Unknown!'
      TabOrder = 11
      OnClick = Button8Click
    end
    object CheckBox1: TCheckBox
      Left = 120
      Top = 64
      Width = 97
      Height = 17
      Caption = 'jedesmal pause'
      TabOrder = 12
    end
    object Button7: TButton
      Left = 300
      Top = 92
      Width = 75
      Height = 21
      Caption = 'generate stats'
      TabOrder = 13
      OnClick = Button7Click
    end
  end
  object mem_log: TMemo
    Left = 19
    Top = 107
    Width = 538
    Height = 57
    TabOrder = 11
  end
  object Button10: TButton
    Left = 19
    Top = 216
    Width = 88
    Height = 25
    Caption = 'Login'
    TabOrder = 12
    OnClick = Button10Click
  end
  object se_max_days_age: TSpinEdit
    Left = 432
    Top = 56
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 13
    Value = 90
  end
  object cb_filter_no_planet: TCheckBox
    Left = 304
    Top = 80
    Width = 161
    Height = 17
    Caption = 'cb_filter_no_planet'
    TabOrder = 14
  end
  object IdHTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
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
    HTTPOptions = []
    OnAuthorization = IdHTTP1Authorization
    Left = 264
    Top = 164
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 84
    Top = 400
  end
end
