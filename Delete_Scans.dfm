object FRM_Delete_Scans: TFRM_Delete_Scans
  Left = 532
  Top = 400
  BorderStyle = bsDialog
  Caption = 'L'#246'schen von alten Scanberichten'
  ClientHeight = 231
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    333
    231)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 4
    Top = 0
    Width = 325
    Height = 199
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' L'#246'sche Scanberichte '
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 36
      Width = 198
      Height = 13
      Caption = 'maximale Anzahl Scanberichte pro Planet:'
    end
    object Label2: TLabel
      Left = 48
      Top = 120
      Width = 162
      Height = 13
      Caption = 'minimale Anzahl Scans pro Planet:'
    end
    object Label4: TLabel
      Left = 160
      Top = 172
      Width = 47
      Height = 13
      Caption = 'enthalten!'
    end
    object TXT_maxAnzahl: TEdit
      Left = 256
      Top = 36
      Width = 57
      Height = 21
      TabOrder = 1
      Text = '10'
    end
    object DTP_minAlter: TDateTimePicker
      Left = 28
      Top = 76
      Width = 289
      Height = 21
      Date = 38649.938968495400000000
      Time = 38649.938968495400000000
      TabOrder = 3
    end
    object CH_minAnzahl: TCheckBox
      Left = 28
      Top = 100
      Width = 293
      Height = 17
      Caption = 'nicht wenn minimale Anzahl pro Planet unterschritten wird:'
      TabOrder = 4
    end
    object TXT_minAnzahl: TEdit
      Left = 256
      Top = 116
      Width = 57
      Height = 21
      TabOrder = 5
      Text = '4'
    end
    object RB_minAlter: TRadioButton
      Left = 8
      Top = 56
      Width = 245
      Height = 17
      Caption = 'die '#228'lter sind als:'
      TabOrder = 2
      OnClick = RB_minAlterClick
    end
    object RB_maxAnzahl: TRadioButton
      Left = 8
      Top = 16
      Width = 309
      Height = 17
      Caption = 'von Planeten bei den die maximale Anzahl '#252'berschritten:'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RB_minAlterClick
    end
    object CB_ScanBereiche: TComboBox
      Left = 8
      Top = 168
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 6
    end
    object CH_ScanBereiche: TCheckBox
      Left = 8
      Top = 148
      Width = 309
      Height = 17
      Caption = 'L'#246'sche keine Scans die den Bereich'
      TabOrder = 7
    end
  end
  object Button1: TButton
    Left = 4
    Top = 203
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'L'#246'sche!'
    TabOrder = 1
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 84
    Top = 207
    Width = 246
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
  end
end
