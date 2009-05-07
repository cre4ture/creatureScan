object FRM_Galaxy_Rights: TFRM_Galaxy_Rights
  Left = 480
  Top = 196
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Galaxien-Rechte'
  ClientHeight = 73
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    370
    73)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 369
    Height = 41
    Caption = ' System/Scan/Raid - Rechte f'#252'r folgende Galaxien: '
    TabOrder = 0
  end
  object Button1: TButton
    Left = 291
    Top = 44
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 211
    Top = 44
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 2
  end
  object ch_allnone: TCheckBox
    Left = 8
    Top = 48
    Width = 197
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'w'#228'hle alle/keine'
    TabOrder = 3
    OnClick = ch_allnoneClick
  end
end
