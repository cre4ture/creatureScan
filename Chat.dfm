object FRM_Chat: TFRM_Chat
  Left = 482
  Top = 312
  Width = 440
  Height = 286
  Caption = 'FRM_Chat'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 300
    Top = 4
    Height = 198
    Align = alRight
  end
  object Panel1: TPanel
    Left = 0
    Top = 202
    Width = 432
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      432
      30)
    object Edit1: TEdit
      Left = 4
      Top = 4
      Width = 422
      Height = 21
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
    end
  end
  object Memo1: TMemo
    Left = 4
    Top = 4
    Width = 296
    Height = 198
    Align = alClient
    ReadOnly = True
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 303
    Top = 4
    Width = 129
    Height = 198
    Align = alRight
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 2
    object VST_Member: TVirtualStringTree
      Left = 0
      Top = 0
      Width = 129
      Height = 173
      Align = alClient
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoColumnResize, hoDrag]
      TabOrder = 0
      TreeOptions.PaintOptions = [toShowDropmark, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnGetText = VST_MemberGetText
      OnPaintText = VST_MemberPaintText
      OnGetNodeDataSize = VST_MemberGetNodeDataSize
      Columns = <>
    end
    object Panel3: TPanel
      Left = 0
      Top = 173
      Width = 129
      Height = 25
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        129
        25)
      object Button1: TButton
        Left = 4
        Top = 4
        Width = 121
        Height = 21
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Refresh'
        TabOrder = 0
        OnClick = Button1Click
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 4
    Width = 4
    Height = 198
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 432
    Height = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
  end
  object Panel6: TPanel
    Left = 40
    Top = 84
    Width = 217
    Height = 97
    Caption = 'Panel6'
    TabOrder = 5
    Visible = False
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 201
      Height = 81
      AutoSize = False
      Caption = 
        'Damit ein schneller Chat gew'#228'hrleistet ist, muss ->jeder<- im ch' +
        'atroom ne schnelle Packetverarbeitung haben! Deswegen: Timer1.In' +
        'tervall := 200!!! (msec)'
      Visible = False
      WordWrap = True
    end
  end
  object MainMenu1: TMainMenu
    Left = 60
    Top = 24
    object Fenster1: TMenuItem
      Caption = 'Fenster'
      object immerimVordergrund1: TMenuItem
        Caption = 'immer im Vordergrund'
        OnClick = immerimVordergrund1Click
      end
    end
  end
  object ChatMerge: TMergeSocketComponent
    Left = 168
    Top = 24
  end
  object Timer1: TTimer
    Interval = 200
    OnTimer = Timer1Timer
    Left = 116
    Top = 24
  end
end
