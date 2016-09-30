object FRM_Sources: TFRM_Sources
  Left = 212
  Top = 222
  Caption = 'Sources'
  ClientHeight = 378
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  DesignSize = (
    684
    378)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 21
    Height = 13
    Caption = 'Text'
  end
  object Label2: TLabel
    Left = 8
    Top = 112
    Width = 30
    Height = 13
    Caption = 'HTML'
  end
  object Label3: TLabel
    Left = 144
    Top = 288
    Width = 37
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'FileInfo:'
  end
  object m_Text: TMemo
    Left = 8
    Top = 24
    Width = 661
    Height = 85
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'm_Text')
    ScrollBars = ssVertical
    TabOrder = 0
    OnChange = m_TextChange
  end
  object m_Html: TMemo
    Left = 8
    Top = 128
    Width = 661
    Height = 85
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Memo2'
      '')
    ScrollBars = ssVertical
    TabOrder = 1
    OnChange = m_HtmlChange
  end
  object CB_Clipboard: TCheckBox
    Left = 8
    Top = 288
    Width = 97
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Use Clipboard'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = CB_ClipboardClick
  end
  object Button1: TButton
    Left = 96
    Top = 312
    Width = 85
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Load From File'
    TabOrder = 3
    OnClick = Button1Click
  end
  object m_fileinfo: TMemo
    Left = 188
    Top = 220
    Width = 481
    Height = 137
    Anchors = [akLeft, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object Button2: TButton
    Left = 8
    Top = 312
    Width = 85
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Save To File'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 96
    Top = 340
    Width = 85
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Write Clipboard'
    TabOrder = 6
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 52
    Top = 112
    Width = 73
    Height = 13
    Caption = 'copy up'
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 131
    Top = 112
    Width = 73
    Height = 13
    Caption = 'copy down'
    TabOrder = 8
    OnClick = Button5Click
  end
  object btn_to_clipboard: TButton
    Left = 408
    Top = 106
    Width = 113
    Height = 25
    Caption = 'To Clipboard'
    TabOrder = 9
  end
  object OpenDialog1: TOpenDialog
    Left = 124
    Top = 248
  end
  object SaveDialog1: TSaveDialog
    Left = 36
    Top = 248
  end
end
