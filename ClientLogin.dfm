object FRM_ClientLogin: TFRM_ClientLogin
  Left = 534
  Top = 259
  BorderStyle = bsDialog
  Caption = 'Login'
  ClientHeight = 157
  ClientWidth = 207
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = 'Servername:'
  end
  object Label2: TLabel
    Left = 8
    Top = 24
    Width = 35
    Height = 13
    Caption = 'IP:Port:'
  end
  object Label3: TLabel
    Left = 8
    Top = 44
    Width = 110
    Height = 13
    Caption = 'Spieler-/Gruppenname:'
  end
  object Label4: TLabel
    Left = 8
    Top = 84
    Width = 46
    Height = 13
    Caption = 'Passwort:'
  end
  object LBL_Servername: TLabel
    Left = 76
    Top = 8
    Width = 128
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    BiDiMode = bdLeftToRight
    Caption = 'LBL_Servername'
    ParentBiDiMode = False
  end
  object LBL_IP_Port: TLabel
    Left = 56
    Top = 24
    Width = 148
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'LBL_IP_Port'
  end
  object TXT_Username: TEdit
    Left = 8
    Top = 60
    Width = 193
    Height = 21
    MaxLength = 25
    TabOrder = 0
  end
  object TXT_Pass: TEdit
    Left = 8
    Top = 100
    Width = 193
    Height = 21
    MaxLength = 15
    PasswordChar = '*'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 60
    Top = 128
    Width = 93
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
end
