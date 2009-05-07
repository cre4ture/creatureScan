object FRM_ImportProgress: TFRM_ImportProgress
  Left = 590
  Top = 826
  BorderStyle = bsDialog
  Caption = 'Importiere...'
  ClientHeight = 75
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 4
    Top = 4
    Width = 341
    Height = 69
    Caption = ' Importiere '
    TabOrder = 0
    object Gauge1: TGauge
      Left = 8
      Top = 16
      Width = 325
      Height = 17
      Progress = 0
    end
    object Label1: TLabel
      Left = 8
      Top = 36
      Width = 3
      Height = 13
    end
  end
  object Button1: TButton
    Left = 260
    Top = 40
    Width = 77
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    TabOrder = 1
    OnClick = Button1Click
  end
end
