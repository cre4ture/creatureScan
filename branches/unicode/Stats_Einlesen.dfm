object FRM_Stats_Einlesen: TFRM_Stats_Einlesen
  Left = 351
  Top = 115
  Width = 527
  Height = 386
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Statistiken'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnHide = FormHide
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 519
    Height = 361
    Align = alClient
    TabOrder = 0
    Tabs.Strings = (
      'Player'
      'Alliance')
    TabIndex = 0
    OnChange = TabControl1Change
    object ScrollBox1: TScrollBox
      Left = 4
      Top = 24
      Width = 511
      Height = 278
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 0
      object pb_points: TPaintBox
        Left = 108
        Top = 24
        Width = 125
        Height = 425
        OnPaint = pb_pointsPaint
      end
      object pb_fleet: TPaintBox
        Tag = 1
        Left = 236
        Top = 24
        Width = 125
        Height = 425
        OnPaint = pb_pointsPaint
      end
      object pb_place_range: TPaintBox
        Left = 4
        Top = 24
        Width = 93
        Height = 425
        OnPaint = pb_place_rangePaint
      end
      object pb_research: TPaintBox
        Tag = 2
        Left = 364
        Top = 24
        Width = 125
        Height = 425
        OnPaint = pb_pointsPaint
      end
      object Label5: TLabel
        Left = 236
        Top = 4
        Width = 29
        Height = 13
        Caption = 'Flotte:'
      end
      object Label4: TLabel
        Left = 108
        Top = 4
        Width = 40
        Height = 13
        Caption = 'Punkte: '
      end
      object Label2: TLabel
        Left = 368
        Top = 4
        Width = 53
        Height = 13
        Caption = 'Forschung:'
      end
    end
    object Panel1: TPanel
      Left = 4
      Top = 302
      Width = 511
      Height = 55
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Label3: TLabel
        Left = 16
        Top = 4
        Width = 69
        Height = 13
        Caption = 'eigene Punkte'
      end
      object TXT_punkte: TEdit
        Left = 112
        Top = 4
        Width = 121
        Height = 21
        TabOrder = 0
        Text = '0'
      end
      object TXT_Ally: TEdit
        Left = 368
        Top = 4
        Width = 121
        Height = 21
        TabOrder = 1
        Text = '0'
        Visible = False
      end
      object TXT_fleet: TEdit
        Left = 240
        Top = 4
        Width = 121
        Height = 21
        TabOrder = 2
        Text = '0'
        Visible = False
      end
      object Button1: TButton
        Left = 8
        Top = 24
        Width = 83
        Height = 25
        Caption = #220'bernehmen'
        TabOrder = 3
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 424
        Top = 24
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Schlie'#223'en'
        TabOrder = 4
        OnClick = Button2Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 240
    Top = 120
  end
  object XPManifest1: TXPManifest
    Left = 308
    Top = 112
  end
end
