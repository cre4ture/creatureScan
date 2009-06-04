object FRM_Connect: TFRM_Connect
  Left = 456
  Top = 187
  BorderStyle = bsDialog
  Caption = 'Verbinden...'
  ClientHeight = 213
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 87
    Height = 13
    Caption = 'Host/IP-Addresse:'
  end
  object Label2: TLabel
    Left = 8
    Top = 52
    Width = 22
    Height = 13
    Caption = 'Port:'
  end
  object Label3: TLabel
    Left = 180
    Top = 8
    Width = 35
    Height = 13
    Caption = 'History:'
  end
  object Label4: TLabel
    Left = 8
    Top = 80
    Width = 55
    Height = 13
    Caption = 'Loginname:'
  end
  object Label5: TLabel
    Left = 8
    Top = 120
    Width = 46
    Height = 13
    Caption = 'Passwort:'
  end
  object txt_adress: TEdit
    Left = 8
    Top = 24
    Width = 157
    Height = 21
    TabOrder = 0
  end
  object txt_port: TEdit
    Left = 52
    Top = 48
    Width = 113
    Height = 21
    TabOrder = 1
  end
  object ListBox1: TListBox
    Left = 180
    Top = 24
    Width = 141
    Height = 181
    ItemHeight = 13
    PopupMenu = PopupMenu1
    TabOrder = 7
    OnClick = ListBox1Click
    OnDblClick = ListBox1DblClick
  end
  object btn_ok: TButton
    Left = 92
    Top = 180
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 5
    OnClick = btn_okClick
  end
  object btn_cancel: TButton
    Left = 8
    Top = 180
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 6
  end
  object txt_loginname: TEdit
    Left = 8
    Top = 96
    Width = 157
    Height = 21
    TabOrder = 2
  end
  object txt_pw: TEdit
    Left = 8
    Top = 136
    Width = 157
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object cb_save_pw: TCheckBox
    Left = 8
    Top = 160
    Width = 157
    Height = 17
    Caption = 'Passwort merken'
    TabOrder = 4
  end
  object PopupMenu1: TPopupMenu
    Left = 212
    Top = 64
    object Verbinden1: TMenuItem
      Caption = 'Verbinden'
      Default = True
      OnClick = Verbinden1Click
    end
    object Entf1: TMenuItem
      Caption = 'L'#246'schen'
      ShortCut = 46
      OnClick = Entf1Click
    end
  end
end
