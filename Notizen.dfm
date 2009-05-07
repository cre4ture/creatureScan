object FRM_Notizen: TFRM_Notizen
  Left = 424
  Top = 248
  Caption = 'Notizen'
  ClientHeight = 262
  ClientWidth = 515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 209
    Width = 515
    Height = 53
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      515
      53)
    object Label1: TLabel
      Left = 282
      Top = 32
      Width = 48
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Kategorie:'
    end
    object LBL_bezeichner: TLabel
      Left = 4
      Top = 32
      Width = 35
      Height = 13
      Caption = 'Spieler:'
    end
    object CB_Image: TComboBox
      Left = 334
      Top = 28
      Width = 177
      Height = 22
      Style = csOwnerDrawFixed
      Anchors = [akTop, akRight]
      ItemHeight = 16
      TabOrder = 2
      OnChange = CB_ImageChange
      OnDrawItem = CB_ImageDrawItem
    end
    object TXT_Notiz: TEdit
      Left = 4
      Top = 4
      Width = 507
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = 'Notiz'
      OnKeyPress = TXT_NotizKeyPress
    end
    object TXT_Spezifikation: TEdit
      Left = 48
      Top = 28
      Width = 227
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnKeyPress = TXT_NotizKeyPress
    end
  end
  object VST_Notizen: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 515
    Height = 209
    Align = alClient
    Header.AutoSizeIndex = 2
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
    Images = ImageList1
    PopupMenu = PopupMenu1
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnCompareNodes = VST_NotizenCompareNodes
    OnFocusChanged = VST_NotizenFocusChanged
    OnGetText = VST_NotizenGetText
    OnGetImageIndex = VST_NotizenGetImageIndex
    OnGetNodeDataSize = VST_NotizenGetNodeDataSize
    OnHeaderClick = VST_NotizenHeaderClick
    Columns = <
      item
        Position = 0
        Width = 20
      end
      item
        Position = 1
        Width = 130
        WideText = 'Position/Name'
      end
      item
        Position = 2
        Width = 211
        WideText = 'Notiz'
      end
      item
        Position = 3
        Width = 150
        WideText = 'Datum'
      end>
  end
  object ImageList1: TImageList
    Left = 164
    Top = 56
  end
  object PopupMenu1: TPopupMenu
    Left = 128
    Top = 56
    object Entfernen1: TMenuItem
      Caption = 'L'#246'schen'
      ShortCut = 46
      OnClick = Entfernen1Click
    end
  end
end
