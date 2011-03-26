object FRM_Stats_Einlesen: TFRM_Stats_Einlesen
  Left = 495
  Top = 165
  BorderStyle = bsDialog
  Caption = 'Stats Einlesen'
  ClientHeight = 631
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
  OnHide = FormHide
  OnShow = FormShow
  DesignSize = (
    442
    631)
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 60
    Top = 20
    Width = 125
    Height = 533
    Anchors = [akLeft, akTop, akBottom]
    OnPaint = PaintBox1Paint
  end
  object PaintBox2: TPaintBox
    Tag = 1
    Left = 188
    Top = 20
    Width = 125
    Height = 533
    Anchors = [akLeft, akTop, akBottom]
    OnPaint = PaintBox1Paint
  end
  object PaintBox3: TPaintBox
    Left = 4
    Top = 20
    Width = 49
    Height = 533
    Anchors = [akLeft, akTop, akBottom]
    OnPaint = PaintBox3Paint
  end
  object PaintBox4: TPaintBox
    Tag = 2
    Left = 316
    Top = 20
    Width = 125
    Height = 533
    Anchors = [akLeft, akTop, akBottom]
    OnPaint = PaintBox1Paint
  end
  object Label5: TLabel
    Left = 188
    Top = 4
    Width = 29
    Height = 13
    Caption = 'Flotte:'
  end
  object Label4: TLabel
    Left = 60
    Top = 4
    Width = 40
    Height = 13
    Caption = 'Punkte: '
  end
  object Label2: TLabel
    Left = 320
    Top = 4
    Width = 85
    Height = 13
    Caption = 'Allianzen-Statistik:'
  end
  object Label3: TLabel
    Left = 8
    Top = 556
    Width = 69
    Height = 13
    Caption = 'eigene Punkte'
  end
  object TXT_punkte: TEdit
    Left = 64
    Top = 572
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object TXT_Ally: TEdit
    Left = 320
    Top = 572
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '0'
    Visible = False
  end
  object TXT_fleet: TEdit
    Left = 192
    Top = 572
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '0'
    Visible = False
  end
  object Button1: TButton
    Left = 360
    Top = 600
    Width = 73
    Height = 25
    Caption = 'Fertig'
    ModalResult = 1
    TabOrder = 3
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 136
    Top = 80
  end
end
