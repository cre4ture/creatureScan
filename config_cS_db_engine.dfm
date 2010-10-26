object frm_config_cS_engine: Tfrm_config_cS_engine
  Left = 114
  Top = 166
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'cS_db_engine einrichten'
  ClientHeight = 319
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    313
    319)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 230
    Top = 288
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 149
    Top = 288
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 3
  end
  object gb_config: TGroupBox
    Left = 8
    Top = 160
    Width = 297
    Height = 121
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Sync-Optionen'
    TabOrder = 1
    DesignSize = (
      297
      121)
    object Label6: TLabel
      Left = 8
      Top = 16
      Width = 234
      Height = 13
      Caption = 'Maximales Alter der zu syncronisierenden Daten:'
    end
    object Label7: TLabel
      Left = 8
      Top = 32
      Width = 45
      Height = 13
      Caption = 'in Tagen:'
    end
    object Label8: TLabel
      Left = 8
      Top = 64
      Width = 281
      Height = 33
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        'Es werden zuerst die Sonnensystem-Daten, dannach die Scanbericht' +
        '-Daten Syncronisiert.'
      WordWrap = True
    end
    object se_max_days_age: TSpinEdit
      Left = 104
      Top = 32
      Width = 185
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 90
    end
    object cb_dont_sync_deletet_planets: TCheckBox
      Left = 8
      Top = 96
      Width = 281
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Scans gel'#246'schter Planeten nicht synchronisieren'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
  object gb_login: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 145
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Server- und Logineinstellungen'
    TabOrder = 0
    DesignSize = (
      297
      145)
    object Label1: TLabel
      Left = 8
      Top = 44
      Width = 75
      Height = 13
      Caption = 'URL zum Script:'
    end
    object Label2: TLabel
      Left = 8
      Top = 87
      Width = 55
      Height = 13
      Caption = 'Loginname:'
    end
    object Label3: TLabel
      Left = 8
      Top = 114
      Width = 48
      Height = 13
      Caption = 'Passwort:'
    end
    object Label5: TLabel
      Left = 8
      Top = 16
      Width = 68
      Height = 13
      Caption = 'Anzeigename:'
    end
    object txt_url: TEdit
      Left = 8
      Top = 60
      Width = 281
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = 'http://www.bla.de/cS_auto.php'
    end
    object txt_username: TEdit
      Left = 104
      Top = 87
      Width = 185
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object txt_password: TEdit
      Left = 104
      Top = 114
      Width = 185
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      PasswordChar = '*'
      TabOrder = 2
    end
    object txt_name: TEdit
      Left = 104
      Top = 16
      Width = 185
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      Text = 'Mein Server...'
    end
  end
end
