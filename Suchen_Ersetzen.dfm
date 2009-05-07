object FRM_Suchen_Ersetzen: TFRM_Suchen_Ersetzen
  Left = 505
  Top = 303
  BorderStyle = bsDialog
  Caption = 'Spielername Suchen & ersetzen'
  ClientHeight = 115
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 40
    Height = 13
    Caption = 'Suchen:'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 77
    Height = 13
    Caption = 'Ersetzten durch:'
  end
  object Gauge1: TGauge
    Left = 92
    Top = 92
    Width = 237
    Height = 17
    Progress = 0
  end
  object Label3: TLabel
    Left = 4
    Top = 4
    Width = 325
    Height = 29
    AutoSize = False
    Caption = 
      'Hier kannst du einen Spieler umtaufen. Dabei wird in allen Scan-' +
      ' berichten, Sonnensystemen und Notizen der gesuchte Name ersetzt' +
      '.'
    WordWrap = True
  end
  object Edit1: TEdit
    Left = 92
    Top = 36
    Width = 237
    Height = 21
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 92
    Top = 60
    Width = 237
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 4
    Top = 88
    Width = 85
    Height = 25
    Caption = 'Start'
    TabOrder = 2
    OnClick = Button1Click
  end
end
