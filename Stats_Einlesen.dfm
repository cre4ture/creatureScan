object FRM_Stats_Einlesen: TFRM_Stats_Einlesen
  Left = 359
  Top = 32
  BorderStyle = bsDialog
  Caption = 'Stats Einlesen'
  ClientHeight = 679
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    442
    679)
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 60
    Top = 76
    Width = 125
    Height = 531
    Anchors = [akLeft, akTop, akBottom]
    OnPaint = PaintBox1Paint
  end
  object PaintBox2: TPaintBox
    Tag = 1
    Left = 188
    Top = 76
    Width = 125
    Height = 531
    Anchors = [akLeft, akTop, akBottom]
    OnPaint = PaintBox1Paint
  end
  object PaintBox3: TPaintBox
    Left = 4
    Top = 76
    Width = 49
    Height = 532
    Anchors = [akLeft, akTop, akBottom]
    OnPaint = PaintBox3Paint
  end
  object PaintBox4: TPaintBox
    Tag = 2
    Left = 316
    Top = 76
    Width = 125
    Height = 531
    Anchors = [akLeft, akTop, akBottom]
    OnPaint = PaintBox1Paint
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 442
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 4
      Top = 4
      Width = 437
      Height = 45
      AutoSize = False
      Caption = 
        'Solange dieses Fenster ge'#246'ffnet ist, wird die Zwischenablage auf' +
        ' Statistiken '#252'berwacht und dann eingelesen:'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 320
      Top = 60
      Width = 85
      Height = 13
      Caption = 'Allianzen-Statistik:'
    end
    object Label4: TLabel
      Left = 60
      Top = 60
      Width = 40
      Height = 13
      Caption = 'Punkte: '
    end
    object Label5: TLabel
      Left = 188
      Top = 60
      Width = 29
      Height = 13
      Caption = 'Flotte:'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 612
    Width = 442
    Height = 67
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object Label3: TLabel
      Left = 24
      Top = 4
      Width = 69
      Height = 13
      Caption = 'eigene Punkte'
    end
    object Button1: TButton
      Left = 368
      Top = 40
      Width = 73
      Height = 25
      Caption = 'Fertig'
      ModalResult = 1
      TabOrder = 0
    end
    object CH_Beep: TCheckBox
      Left = 8
      Top = 24
      Width = 49
      Height = 17
      Hint = 'Beep als Best'#228'tigung dass Stats erkannt wurden'
      Caption = 'Beep'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object TXT_punkte: TEdit
      Left = 64
      Top = 20
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object TXT_fleet: TEdit
      Left = 192
      Top = 20
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '0'
      Visible = False
    end
    object TXT_Ally: TEdit
      Left = 320
      Top = 20
      Width = 121
      Height = 21
      TabOrder = 4
      Text = '0'
      Visible = False
    end
  end
  object Timer1: TTimer
    Interval = 800
    OnTimer = Timer1Timer
    Left = 8
    Top = 40
  end
end
