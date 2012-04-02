object frm_stat_explorer: Tfrm_stat_explorer
  Left = 0
  Top = 0
  Caption = 'frm_stat_explorer'
  ClientHeight = 226
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    475
    226)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 303
    Top = 13
    Width = 33
    Height = 13
    Caption = 'Suche:'
  end
  object vst_stats: TVirtualStringTree
    Left = 8
    Top = 63
    Width = 459
    Height = 155
    Anchors = [akLeft, akTop, akRight, akBottom]
    Header.AutoSizeIndex = 1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    TabOrder = 0
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnGetText = vst_statsGetText
    ExplicitWidth = 417
    Columns = <
      item
        Alignment = taRightJustify
        Position = 0
        Width = 60
        WideText = 'Platz'
      end
      item
        Position = 1
        Width = 95
        WideText = 'Name'
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 100
        WideText = 'Punkte'
      end
      item
        Alignment = taRightJustify
        Position = 3
        Width = 100
        WideText = 'Schiffe/Mitglieder'
      end
      item
        Position = 4
        Width = 100
        WideText = 'Allianz'
      end>
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 89
    Height = 49
    TabOrder = 1
    object rb_player: TRadioButton
      Left = 6
      Top = 6
      Width = 80
      Height = 17
      Caption = 'Spieler'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rb_playerClick
    end
    object rb_ally: TRadioButton
      Left = 6
      Top = 26
      Width = 80
      Height = 17
      Caption = 'Allianz'
      TabOrder = 1
      OnClick = rb_playerClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 103
    Top = 8
    Width = 186
    Height = 49
    TabOrder = 2
    object rb_points: TRadioButton
      Left = 16
      Top = 6
      Width = 57
      Height = 17
      Caption = 'Punkte'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rb_playerClick
    end
    object rb_fleet: TRadioButton
      Left = 16
      Top = 26
      Width = 57
      Height = 17
      Caption = 'Flotte'
      TabOrder = 1
      OnClick = rb_playerClick
    end
    object rb_research: TRadioButton
      Left = 87
      Top = 6
      Width = 82
      Height = 17
      Caption = 'Forschung'
      TabOrder = 2
      OnClick = rb_playerClick
    end
  end
  object Edit1: TEdit
    Left = 303
    Top = 32
    Width = 164
    Height = 21
    TabOrder = 3
    OnChange = Edit1Change
    OnKeyPress = Edit1KeyPress
  end
end
