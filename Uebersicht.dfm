object FRM_Uebersicht: TFRM_Uebersicht
  Left = 351
  Top = 596
  Width = 800
  Height = 295
  HorzScrollBar.Size = 8
  VertScrollBar.Size = 8
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Universums'#252'bersicht'
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
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PB_Lupe: TPaintBox
    Left = 567
    Top = 81
    Width = 225
    Height = 189
    Align = alRight
  end
  object Splitter1: TSplitter
    Left = 564
    Top = 81
    Height = 189
    Align = alRight
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object Label2: TLabel
      Left = 12
      Top = 8
      Width = 497
      Height = 26
      AutoSize = False
      Caption = 
        'Diese Grafik zeigt eine '#220'bersicht '#252'ber die Sonnensysteme des gan' +
        'zen Universums an. Die Farben zeigen die Aktualit'#228't der Informat' +
        'ionen an. [Doppelklick -> Galaxie-Explorer]'
      WordWrap = True
    end
    object Label4: TLabel
      Left = 520
      Top = 60
      Width = 60
      Height = 13
      Caption = 'Koordinaten:'
    end
    object LBL_Koords: TLabel
      Left = 584
      Top = 60
      Width = 3
      Height = 13
    end
    object Button2: TButton
      Left = 520
      Top = 8
      Width = 149
      Height = 25
      Caption = 'Planeten hervorheben...'
      TabOrder = 0
      OnClick = Button2Click
    end
    object CH_Planeten: TCheckBox
      Left = 156
      Top = 40
      Width = 113
      Height = 17
      Caption = 'Planeten anzeigen'
      TabOrder = 1
      OnClick = CH_PlanetenClick
    end
    object CH_Systeme: TCheckBox
      Left = 12
      Top = 40
      Width = 141
      Height = 17
      Caption = 'Sonnensysteme anzeigen'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = CH_PlanetenClick
    end
    object CH_Scans: TCheckBox
      Left = 272
      Top = 40
      Width = 149
      Height = 17
      Caption = 'Spionageberichte anzeigen'
      TabOrder = 3
      OnClick = CH_PlanetenClick
    end
    object cb_filter: TCheckBox
      Left = 12
      Top = 56
      Width = 185
      Height = 17
      Caption = 'aktuellen Filter anzeigen/editieren'
      TabOrder = 4
      OnClick = CH_PlanetenClick
    end
    object cb_point_stats: TCheckBox
      Left = 272
      Top = 56
      Width = 149
      Height = 17
      Caption = 'Punkte Stats'
      TabOrder = 5
      OnClick = CH_PlanetenClick
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 81
    Width = 443
    Height = 189
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 1
    object PB_Uni: TPaintBox
      Left = 0
      Top = 0
      Width = 499
      Height = 180
      Color = clBlack
      ParentColor = False
      PopupMenu = PopupMenu1
      OnDblClick = PB_UniDblClick
      OnMouseDown = PB_UniMouseDown
      OnMouseMove = PB_UniMouseMove
      OnMouseUp = PB_UniMouseUp
      OnPaint = PB_UniPaint
    end
  end
  object lb_ranges: TListBox
    Left = 443
    Top = 81
    Width = 121
    Height = 189
    Align = alRight
    ItemHeight = 13
    PopupMenu = PopupMenu2
    TabOrder = 2
    Visible = False
    OnClick = lb_rangesClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 4000
    OnTimer = Timer1Timer
    Left = 36
    Top = 148
  end
  object PopupMenu1: TPopupMenu
    Left = 224
    Top = 144
    object Zeitfaktor1: TMenuItem
      Caption = 'Zeitfaktor'
      object N11: TMenuItem
        Tag = 1
        Caption = '1'
        Checked = True
        RadioItem = True
        OnClick = N11Click
      end
      object N121: TMenuItem
        Tag = 2
        Caption = '1/2'
        RadioItem = True
        OnClick = N11Click
      end
      object N12: TMenuItem
        Tag = 3
        Caption = '1/3'
        RadioItem = True
        OnClick = N11Click
      end
      object N141: TMenuItem
        Tag = 4
        Caption = '1/4'
        RadioItem = True
        OnClick = N11Click
      end
      object N151: TMenuItem
        Tag = 5
        Caption = '1/5'
        RadioItem = True
        OnClick = N11Click
      end
      object N161: TMenuItem
        Tag = 6
        Caption = '1/6'
        RadioItem = True
        OnClick = N11Click
      end
      object N171: TMenuItem
        Tag = 7
        Caption = '1/7'
        RadioItem = True
        OnClick = N11Click
      end
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 564
    Top = 136
    object delete1: TMenuItem
      Caption = 'delete'
      ShortCut = 46
      OnClick = delete1Click
    end
    object editr1: TMenuItem
      Caption = 'edit'
      OnClick = editr1Click
    end
    object new1: TMenuItem
      Caption = 'new'
      OnClick = new1Click
    end
  end
end
