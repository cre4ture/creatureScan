object frm_quickupdate: Tfrm_quickupdate
  Left = 383
  Top = 222
  Caption = 'Quick Update'
  ClientHeight = 327
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 512
    Height = 327
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    DesignSize = (
      512
      327)
    object lbl_update: TLabel
      Left = 8
      Top = 8
      Width = 488
      Height = 33
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        'Das QuickUpdate aktualisiert die Config-Dateien der io-Plugins. ' +
        'So kann schnell auf '#196'nderungen seitens OGame reagiert werden.'
      WordWrap = True
    end
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 179
      Height = 13
      Caption = 'F'#252'r folgende Dateien gibt es Updates:'
    end
    object vst_files: TVirtualStringTree
      Left = 8
      Top = 56
      Width = 497
      Height = 232
      Anchors = [akLeft, akTop, akRight, akBottom]
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
      OnBeforeCellPaint = vst_filesBeforeCellPaint
      OnCompareNodes = vst_filesCompareNodes
      OnGetText = vst_filesGetText
      OnGetNodeDataSize = vst_filesGetNodeDataSize
      Columns = <
        item
          CheckState = csCheckedNormal
          CheckBox = True
          Position = 0
          Width = 200
          WideText = 'Dateiname'
        end
        item
          Position = 1
          Width = 100
          WideText = 'Version'
        end
        item
          Position = 2
          Width = 100
          WideText = 'Serverversion'
        end
        item
          Position = 3
          Width = 70
          WideText = 'Status'
        end>
    end
    object btn_update: TButton
      Left = 423
      Top = 294
      Width = 81
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Update!'
      Default = True
      TabOrder = 1
      OnClick = btn_updateClick
    end
    object Button2: TButton
      Left = 343
      Top = 294
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Abbrechen'
      ModalResult = 2
      TabOrder = 2
    end
    object Button3: TButton
      Left = 8
      Top = 294
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'neu laden'
      TabOrder = 3
      OnClick = Button3Click
    end
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 208
    Top = 136
  end
end
