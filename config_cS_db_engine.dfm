object frm_config_cS_engine: Tfrm_config_cS_engine
  Left = 113
  Top = 129
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'cS_db_engine einrichten'
  ClientHeight = 212
  ClientWidth = 286
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    286
    212)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 36
    Width = 75
    Height = 13
    Caption = 'URL zum Script:'
  end
  object Label2: TLabel
    Left = 8
    Top = 79
    Width = 55
    Height = 13
    Caption = 'Loginname:'
  end
  object Label3: TLabel
    Left = 8
    Top = 106
    Width = 48
    Height = 13
    Caption = 'Passwort:'
  end
  object Label4: TLabel
    Left = 8
    Top = 156
    Width = 69
    Height = 13
    Caption = 'Interval (min):'
  end
  object Label5: TLabel
    Left = 8
    Top = 8
    Width = 68
    Height = 13
    Caption = 'Anzeigename:'
  end
  object txt_url: TEdit
    Left = 8
    Top = 52
    Width = 270
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'http://www.bla.de/cS_auto.php'
  end
  object txt_username: TEdit
    Left = 104
    Top = 79
    Width = 174
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object txt_password: TEdit
    Left = 104
    Top = 106
    Width = 174
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    PasswordChar = '*'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 203
    Top = 181
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object Button2: TButton
    Left = 122
    Top = 181
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 7
  end
  object cb_auto: TCheckBox
    Left = 8
    Top = 133
    Width = 153
    Height = 17
    Caption = 'automatisch synchronisieren:'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object se_min: TSpinEdit
    Left = 104
    Top = 153
    Width = 174
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 15
  end
  object txt_name: TEdit
    Left = 104
    Top = 8
    Width = 174
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'Mein Server...'
  end
end
