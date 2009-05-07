object FRM_Connections: TFRM_Connections
  Left = 270
  Top = 174
  Width = 643
  Height = 272
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Verbindungen'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  DesignSize = (
    635
    245)
  PixelsPerInch = 96
  TextHeight = 13
  object LV_Connections: TListView
    Left = 8
    Top = 48
    Width = 508
    Height = 97
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'IP'
        Width = 150
      end
      item
        AutoSize = True
        Caption = 'Username'
      end
      item
        AutoSize = True
        Caption = 'Fortschritt'
      end
      item
        Caption = 'Sendbuffer'
        Width = 75
      end>
    HideSelection = False
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnData = LV_ConnectionsData
    OnSelectItem = LV_ConnectionsSelectItem
  end
  object Button3: TButton
    Left = 8
    Top = 213
    Width = 125
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Verbindung trennen'
    TabOrder = 1
    OnClick = Button3Click
  end
  object GroupBox1: TGroupBox
    Left = 396
    Top = 0
    Width = 235
    Height = 45
    Anchors = [akLeft, akTop, akRight]
    Caption = ' '
    TabOrder = 2
    DesignSize = (
      235
      45)
    object Button2: TButton
      Left = 129
      Top = 15
      Width = 97
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Chat'
      TabOrder = 0
      OnClick = SpeedButton1Click
    end
  end
  object BTN_Close: TButton
    Left = 524
    Top = 213
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Schlie'#223'en'
    TabOrder = 3
    OnClick = BTN_CloseClick
  end
  object GroupBox2: TGroupBox
    Left = 120
    Top = 0
    Width = 273
    Height = 45
    Caption = ' Server '
    TabOrder = 4
    object Label2: TLabel
      Left = 68
      Top = 20
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object Label9: TLabel
      Left = 168
      Top = 20
      Width = 93
      Height = 13
      Cursor = crHandPoint
      Caption = 'IP nachschauen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 20
      Width = 53
      Height = 17
      Caption = 'aktiv'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object SpinEdit1: TSpinEdit
      Left = 100
      Top = 16
      Width = 61
      Height = 22
      MaxLength = 5
      MaxValue = 65535
      MinValue = 1
      TabOrder = 1
      Value = 44456
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 0
    Width = 109
    Height = 45
    Caption = 'Clientverbindungen'
    TabOrder = 5
    object BTN_Verbinden: TButton
      Left = 8
      Top = 16
      Width = 93
      Height = 21
      Caption = 'Verbinden...'
      TabOrder = 0
      OnClick = BTN_VerbindenClick
    end
  end
  object GroupBox5: TGroupBox
    Left = 7
    Top = 147
    Width = 509
    Height = 64
    Anchors = [akLeft, akRight, akBottom]
    Caption = ' Verb. Statistik '
    TabOrder = 6
    object Label1: TLabel
      Left = 56
      Top = 16
      Width = 66
      Height = 13
      Alignment = taRightJustify
      BiDiMode = bdLeftToRight
      Caption = 'Scanberichte:'
      ParentBiDiMode = False
    end
    object Label4: TLabel
      Left = 8
      Top = 32
      Width = 47
      Height = 13
      Caption = 'gesendet:'
      Transparent = True
    end
    object Label5: TLabel
      Left = 8
      Top = 44
      Width = 56
      Height = 13
      Caption = 'empfangen:'
      Transparent = True
    end
    object LBL_SendScans: TLabel
      Left = 111
      Top = 32
      Width = 6
      Height = 13
      Alignment = taRightJustify
      BiDiMode = bdLeftToRight
      Caption = '0'
      ParentBiDiMode = False
      Transparent = True
    end
    object LBL_RecvScans: TLabel
      Left = 111
      Top = 44
      Width = 6
      Height = 13
      Alignment = taRightJustify
      BiDiMode = bdLeftToRight
      Caption = '0'
      ParentBiDiMode = False
      Transparent = True
    end
    object Label6: TLabel
      Left = 132
      Top = 16
      Width = 78
      Height = 13
      Alignment = taRightJustify
      Caption = 'Sonnensysteme:'
    end
    object LBL_SendSys: TLabel
      Left = 199
      Top = 32
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
      Transparent = True
    end
    object LBL_RecvSys: TLabel
      Left = 199
      Top = 44
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
      Transparent = True
    end
    object Label3: TLabel
      Left = 242
      Top = 16
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = 'Statistiken:'
      Visible = False
    end
    object Label7: TLabel
      Left = 283
      Top = 32
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
      Transparent = True
      Visible = False
    end
    object Label8: TLabel
      Left = 283
      Top = 44
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
      Transparent = True
      Visible = False
    end
  end
  object GroupBox6: TGroupBox
    Left = 522
    Top = 48
    Width = 109
    Height = 163
    Anchors = [akTop, akRight, akBottom]
    Caption = ' Rechte '
    TabOrder = 7
    DesignSize = (
      109
      163)
    object LBL_Rights: TMemo
      Left = 8
      Top = 16
      Width = 93
      Height = 141
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 24
    Top = 88
  end
end
