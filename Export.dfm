object FRM_Export: TFRM_Export
  Left = 547
  Top = 272
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Export in Datei'
  ClientHeight = 275
  ClientWidth = 295
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
  object Button1: TButton
    Left = 216
    Top = 248
    Width = 77
    Height = 25
    Caption = 'Export'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 60
    Width = 289
    Height = 141
    Caption = ' Bereich: '
    TabOrder = 1
    object Label2: TLabel
      Left = 112
      Top = 36
      Width = 3
      Height = 13
      Caption = ':'
    end
    object Label3: TLabel
      Left = 156
      Top = 36
      Width = 3
      Height = 13
      Caption = ':'
    end
    object RB_alles: TRadioButton
      Left = 8
      Top = 16
      Width = 41
      Height = 17
      Caption = 'Alles'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RB_RangesClick
    end
    object RB_Ranges: TRadioButton
      Left = 8
      Top = 32
      Width = 69
      Height = 17
      Caption = 'Bereiche:'
      TabOrder = 1
      OnClick = RB_RangesClick
    end
    object LV_export: TListView
      Left = 8
      Top = 56
      Width = 273
      Height = 77
      Columns = <
        item
          Caption = '#'
          Width = 91
        end
        item
          AutoSize = True
          Caption = 'Galaxie'
        end
        item
          AutoSize = True
          Caption = 'Sonnensystem'
        end
        item
          AutoSize = True
          Caption = 'Planet'
        end>
      Enabled = False
      TabOrder = 2
      ViewStyle = vsReport
    end
    object TXT_Gala: TEdit
      Left = 80
      Top = 32
      Width = 29
      Height = 21
      Enabled = False
      TabOrder = 3
      Text = '1'
    end
    object TXT_System: TEdit
      Left = 116
      Top = 32
      Width = 37
      Height = 21
      Enabled = False
      TabOrder = 4
      Text = 'X'
    end
    object TXT_Planet: TEdit
      Left = 160
      Top = 32
      Width = 29
      Height = 21
      Enabled = False
      TabOrder = 5
      Text = 'X'
      Visible = False
    end
    object Button2: TButton
      Left = 260
      Top = 32
      Width = 21
      Height = 21
      Caption = '?'
      TabOrder = 6
      OnClick = Button2Click
    end
    object BTN_Add: TButton
      Left = 192
      Top = 32
      Width = 37
      Height = 21
      Hint = 'F'#252'gt den eingegebenen Bereich zur Exportliste hinzu.'
      Caption = '+'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = BTN_AddClick
    end
    object BTN_Del: TButton
      Left = 232
      Top = 32
      Width = 25
      Height = 21
      Hint = 'l'#246'scht den ausgew'#228'hlten Bereich uas der Liste'
      Caption = '-'
      TabOrder = 8
      OnClick = BTN_DelClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 4
    Top = 4
    Width = 289
    Height = 53
    Caption = ' Export von: '
    TabOrder = 2
    object RB_Scans: TRadioButton
      Left = 112
      Top = 16
      Width = 85
      Height = 17
      Caption = 'Scanberichte'
      TabOrder = 0
      OnClick = RB_ScansClick
    end
    object RB_Systems: TRadioButton
      Left = 12
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Sonnensysteme'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = RB_ScansClick
    end
    object CH_OnlyNew: TCheckBox
      Left = 112
      Top = 32
      Width = 173
      Height = 17
      Caption = 'nur die neusten jedes Planeten'
      Enabled = False
      TabOrder = 2
      OnClick = CH_OnlyNewClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 4
    Top = 204
    Width = 289
    Height = 41
    Caption = ' Datei '
    TabOrder = 3
    object Edit1: TEdit
      Left = 8
      Top = 12
      Width = 249
      Height = 21
      TabOrder = 0
      Text = 'C:\creatureScanexport.csef'
    end
    object Button3: TButton
      Left = 260
      Top = 12
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 1
      OnClick = Button3Click
    end
  end
  object Button4: TButton
    Left = 136
    Top = 248
    Width = 77
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Panel1: TPanel
    Left = 56
    Top = 84
    Width = 185
    Height = 101
    Caption = 'Bitte Warten....'
    Color = 7103176
    TabOrder = 5
    Visible = False
  end
  object ComboBox1: TComboBox
    Left = 4
    Top = 248
    Width = 125
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 6
    Text = '"normal"'
    Items.Strings = (
      '"normal"'
      'XML'
      'cSe_1_0 (kleiner!)')
  end
  object SaveDialog1: TSaveDialog
    Filter = 'creatureScan Export-Files|*.csef'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 152
    Top = 212
  end
end
