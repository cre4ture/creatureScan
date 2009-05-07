object FRM_Mond: TFRM_Mond
  Left = 641
  Top = 520
  BorderStyle = bsDialog
  Caption = 'creatureScan - Mond?'
  ClientHeight = 67
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 4
    Width = 200
    Height = 13
    Caption = 'Ist dieser Scan ein Scan von einem Mond:'
  end
  object Label2: TLabel
    Left = 8
    Top = 20
    Width = 38
    Height = 13
    Caption = '[0:0:0]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  inline Frame_Bericht1: TFrame_Bericht
    Left = 8
    Top = 69
    Width = 381
    Height = 404
    HorzScrollBar.Style = ssHotTrack
    VertScrollBar.Style = ssHotTrack
    Color = clBlack
    ParentBackground = False
    ParentColor = False
    PopupMenu = Frame_Bericht1.PopupMenu1
    TabOrder = 0
    Visible = False
    inherited PB_B: TPaintBox
      Width = 381
    end
    inherited Panel1: TPanel
      Width = 381
    end
  end
  object Button1: TButton
    Left = 140
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Ja'
    Default = True
    ModalResult = 6
    TabOrder = 1
  end
  object Button2: TButton
    Left = 220
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Nein'
    ModalResult = 7
    TabOrder = 2
  end
  object Button3: TButton
    Left = 4
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Mehr...'
    TabOrder = 3
    OnClick = Button3Click
  end
end
