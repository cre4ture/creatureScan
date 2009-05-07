object FRM_Add_Raid: TFRM_Add_Raid
  Left = 541
  Top = 468
  BorderStyle = bsDialog
  Caption = 'Raid hinzuf'#252'gen'
  ClientHeight = 118
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BTN_OK: TButton
    Left = 340
    Top = 92
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = BTN_OKClick
  end
  object BTN_Cancel: TButton
    Left = 260
    Top = 92
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 236
    Top = 4
    Width = 181
    Height = 85
    Caption = ' geplante Beute: '
    TabOrder = 2
    object Label8: TLabel
      Left = 12
      Top = 20
      Width = 28
      Height = 13
      Caption = 'Metall'
    end
    object Label9: TLabel
      Left = 12
      Top = 40
      Width = 30
      Height = 13
      Caption = 'Kristall'
    end
    object Label10: TLabel
      Left = 12
      Top = 60
      Width = 48
      Height = 13
      Caption = 'Deuterium'
    end
    object TXT_Metall: TEdit
      Left = 64
      Top = 16
      Width = 105
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object TXT_Kristall: TEdit
      Left = 64
      Top = 36
      Width = 105
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object TXT_Deuterium: TEdit
      Left = 64
      Top = 56
      Width = 105
      Height = 21
      TabOrder = 2
      Text = '0'
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 4
    Width = 229
    Height = 109
    Caption = ' Raid '
    TabOrder = 3
    object Label3: TLabel
      Left = 32
      Top = 40
      Width = 20
      Height = 13
      Caption = 'Ziel:'
    end
    object Label2: TLabel
      Left = 28
      Top = 20
      Width = 25
      Height = 13
      Caption = 'Start:'
    end
    object Label1: TLabel
      Left = 4
      Top = 60
      Width = 51
      Height = 13
      Caption = 'Ankunft in:'
    end
    object Label4: TLabel
      Left = 92
      Top = 60
      Width = 6
      Height = 13
      Caption = 'h'
    end
    object Label5: TLabel
      Left = 132
      Top = 60
      Width = 16
      Height = 13
      Caption = 'min'
    end
    object Label6: TLabel
      Left = 180
      Top = 60
      Width = 17
      Height = 13
      Caption = 'sec'
    end
    object TXT_Start: TEdit
      Left = 60
      Top = 16
      Width = 61
      Height = 21
      TabOrder = 0
      Text = '1:1:1'
    end
    object TXT_Ziel: TEdit
      Left = 60
      Top = 36
      Width = 61
      Height = 21
      TabOrder = 1
      Text = '1:1:1'
    end
    object cb_ankunftum: TCheckBox
      Left = 4
      Top = 84
      Width = 105
      Height = 17
      Caption = 'oder Ankunft um:'
      TabOrder = 2
      OnClick = cb_ankunftumClick
    end
    object TXT_AnkunfUm: TMaskEdit
      Left = 116
      Top = 80
      Width = 105
      Height = 21
      EditMask = '!90/90/00 !90:00:00;1;_'
      MaxLength = 17
      TabOrder = 3
      Text = '00.00.00 00:00:00'
    end
    object TXT_h: TEdit
      Left = 60
      Top = 56
      Width = 29
      Height = 21
      TabOrder = 4
      Text = '0'
      OnChange = TXT_hChange
    end
    object TXT_min: TEdit
      Left = 104
      Top = 56
      Width = 29
      Height = 21
      TabOrder = 5
      Text = '50'
      OnChange = TXT_hChange
    end
    object TXT_Sec: TEdit
      Left = 152
      Top = 56
      Width = 29
      Height = 21
      TabOrder = 6
      Text = '0'
      OnChange = TXT_hChange
    end
    object BTN_Paste: TButton
      Left = 144
      Top = 16
      Width = 75
      Height = 25
      Hint = 
        'kopiere die Ansicht die kurz nach dem Abschicken der Flotte ersc' +
        'heint'
      Caption = 'Paste'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = BTN_PasteClick
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 196
    Top = 52
  end
end
