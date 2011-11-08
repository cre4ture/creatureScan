object FRM_Notizen_Images_einstellungen: TFRM_Notizen_Images_einstellungen
  Left = 507
  Top = 282
  BorderStyle = bsDialog
  Caption = 'Bearbeiten der Notiztypen'
  ClientHeight = 199
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 208
    Top = 8
    Width = 24
    Height = 13
    Caption = 'Text:'
  end
  object ListView1: TListView
    Left = 4
    Top = 4
    Width = 197
    Height = 193
    Color = clBlack
    Columns = <
      item
        Caption = 'Bild'
        Width = 30
      end
      item
        AutoSize = True
        Caption = 'Text'
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    HideSelection = False
    LargeImages = ImageList1
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    SmallImages = ImageList1
    TabOrder = 0
    ViewStyle = vsReport
    OnAdvancedCustomDrawItem = ListView1AdvancedCustomDrawItem
    OnSelectItem = ListView1SelectItem
  end
  object Button1: TButton
    Left = 208
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Hinzuf'#252'gen'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 208
    Top = 108
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 208
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 3
    OnChange = Edit1Change
  end
  object Button3: TButton
    Left = 208
    Top = 172
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object Button4: TButton
    Left = 208
    Top = 144
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 5
  end
  object Button5: TButton
    Left = 208
    Top = 48
    Width = 73
    Height = 17
    Caption = 'BG Farbe..'
    TabOrder = 6
    OnClick = Button5Click
  end
  object PopupMenu1: TPopupMenu
    Left = 84
    Top = 48
    object Lschen1: TMenuItem
      Caption = 'L'#246'schen'
      ShortCut = 46
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmap (*.bmp)|*.bmp'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 116
    Top = 48
  end
  object ImageList1: TImageList
    Left = 148
    Top = 48
  end
  object ColorDialog1: TColorDialog
    Left = 52
    Top = 48
  end
end
