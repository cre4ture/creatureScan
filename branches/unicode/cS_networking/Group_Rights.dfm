object FRM_Group_Rights: TFRM_Group_Rights
  Left = 400
  Top = 159
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Gruppenverwaltung'
  ClientHeight = 193
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    404
    193)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 152
    Top = 4
    Width = 248
    Height = 157
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' Gruppe: '
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 46
      Height = 13
      Caption = 'Passwort:'
    end
    object Label3: TLabel
      Left = 8
      Top = 64
      Width = 38
      Height = 13
      Caption = 'Rechte:'
    end
    object BTN_ScanGalaxien: TButton
      Left = 124
      Top = 92
      Width = 117
      Height = 33
      Caption = 'Galaxien'
      TabOrder = 6
      OnClick = BTN_SystemGalaxienClick
    end
    object TXT_Name: TEdit
      Left = 84
      Top = 12
      Width = 149
      Height = 21
      MaxLength = 25
      TabOrder = 0
      OnKeyUp = CH_SystemeKeyUp
    end
    object TXT_pass: TEdit
      Left = 84
      Top = 36
      Width = 149
      Height = 21
      MaxLength = 15
      TabOrder = 1
      OnKeyUp = CH_SystemeKeyUp
    end
    object CH_Systeme: TCheckBox
      Left = 8
      Top = 128
      Width = 97
      Height = 17
      Caption = 'Sonnensysteme'
      TabOrder = 7
      OnKeyUp = CH_SystemeKeyUp
      OnMouseUp = CH_SystemeMouseUp
    end
    object CH_Scans: TCheckBox
      Left = 8
      Top = 92
      Width = 97
      Height = 17
      Caption = 'Scanberichte'
      TabOrder = 4
      OnKeyUp = CH_SystemeKeyUp
      OnMouseUp = CH_SystemeMouseUp
    end
    object CH_Chat: TCheckBox
      Left = 168
      Top = 60
      Width = 73
      Height = 17
      Caption = 'Chat'
      TabOrder = 3
      OnKeyUp = CH_SystemeKeyUp
      OnMouseUp = CH_SystemeMouseUp
    end
    object BTN_SystemGalaxien: TButton
      Left = 124
      Top = 128
      Width = 117
      Height = 21
      Caption = 'Galaxien'
      TabOrder = 8
      OnClick = BTN_SystemGalaxienClick
    end
    object CH_Raids: TCheckBox
      Left = 8
      Top = 108
      Width = 57
      Height = 17
      Caption = 'Raids'
      TabOrder = 5
      OnKeyUp = CH_SystemeKeyUp
      OnMouseUp = CH_SystemeMouseUp
    end
    object CH_Stats: TCheckBox
      Left = 84
      Top = 60
      Width = 73
      Height = 17
      Caption = 'Statistiken'
      TabOrder = 2
      OnKeyUp = CH_SystemeKeyUp
      OnMouseUp = CH_SystemeMouseUp
    end
  end
  object BTN_Add: TButton
    Left = 4
    Top = 165
    Width = 65
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = 'New'
    TabOrder = 1
    OnClick = BTN_AddClick
  end
  object BTN_Entf: TButton
    Left = 80
    Top = 165
    Width = 69
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = 'Delete'
    TabOrder = 2
    OnClick = BTN_EntfClick
  end
  object BTN_OK: TButton
    Left = 323
    Top = 164
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object BTN_Abbrechen: TButton
    Left = 243
    Top = 164
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 4
  end
  object ListView1: TListView
    Left = 4
    Top = 8
    Width = 145
    Height = 153
    Anchors = [akLeft, akTop, akBottom]
    Columns = <
      item
        AutoSize = True
        Caption = 'Benutzer'
      end>
    ColumnClick = False
    HideSelection = False
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 5
    ViewStyle = vsReport
    OnData = ListView1Data
    OnSelectItem = ListView1SelectItem
  end
end
