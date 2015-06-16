object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'COM Graph v2.0'
  ClientHeight = 661
  ClientWidth = 931
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 161
    Top = 29
    Height = 613
    ExplicitLeft = 664
    ExplicitTop = 496
    ExplicitHeight = 100
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 931
    Height = 29
    ButtonHeight = 27
    ButtonWidth = 27
    Caption = 'tbMain'
    Images = ilToolBar
    TabOrder = 0
    object bnSquareDiscrete: TToolButton
      Left = 0
      Top = 0
      Hint = 'Square discrete'
      Caption = 'bnSquareDiscrete'
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
      OnClick = menuSquareDiscreteClick
    end
    object bnGraphAutoScroll: TToolButton
      Left = 27
      Top = 0
      Hint = 'Graph auto scroll'
      Caption = 'bnGraphAutoScroll'
      Down = True
      ImageIndex = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = menuGraphAutoScrollClick
    end
    object ToolButton4: TToolButton
      Left = 54
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object ToolButton1: TToolButton
      Left = 62
      Top = 0
      Caption = 'Exit'
      ImageIndex = 0
      MenuItem = menuExit
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 642
    Width = 931
    Height = 19
    Panels = <
      item
        Text = 'Status:'
        Width = 50
      end
      item
        Text = 'Ready'
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 29
    Width = 161
    Height = 613
    Align = alLeft
    TabOrder = 2
    DesignSize = (
      161
      613)
    object Label1: TLabel
      Left = 8
      Top = 6
      Width = 79
      Height = 13
      Caption = 'COM port name:'
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 108
      Height = 13
      Caption = 'Send BEFORE recieve:'
    end
    object Label3: TLabel
      Left = 8
      Top = 103
      Width = 150
      Height = 13
      Caption = 'How many channels to recieve:'
    end
    object Label4: TLabel
      Left = 8
      Top = 244
      Width = 33
      Height = 13
      Caption = 'Visible:'
    end
    object Label5: TLabel
      Left = 8
      Top = 149
      Width = 65
      Height = 13
      Caption = 'Values count:'
    end
    object Label6: TLabel
      Left = 8
      Top = 331
      Width = 93
      Height = 13
      Caption = 'Last recieved data:'
    end
    object Label7: TLabel
      Left = 8
      Top = 475
      Width = 81
      Height = 13
      Caption = 'MIN / MAX scale:'
    end
    object lbMaxData: TLabel
      Left = 8
      Top = 584
      Width = 109
      Height = 13
      Anchors = [akLeft, akBottom]
      BiDiMode = bdLeftToRight
      Caption = 'Max visible data = 256'
      ParentBiDiMode = False
    end
    object Label8: TLabel
      Left = 8
      Top = 196
      Width = 79
      Height = 13
      Caption = 'Bits per number:'
    end
    object cbCOM: TComboBox
      Left = 8
      Top = 25
      Width = 83
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object bnComRefresh: TBitBtn
      Left = 97
      Top = 20
      Width = 32
      Height = 30
      Hint = 'Refresh COM list'
      DoubleBuffered = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
        33333333333F8888883F33330000324334222222443333388F3833333388F333
        000032244222222222433338F8833FFFFF338F3300003222222AAAAA22243338
        F333F88888F338F30000322222A33333A2224338F33F8333338F338F00003222
        223333333A224338F33833333338F38F00003222222333333A444338FFFF8F33
        3338888300003AAAAAAA33333333333888888833333333330000333333333333
        333333333333333333FFFFFF000033333333333344444433FFFF333333888888
        00003A444333333A22222438888F333338F3333800003A2243333333A2222438
        F38F333333833338000033A224333334422224338338FFFFF8833338000033A2
        22444442222224338F3388888333FF380000333A2222222222AA243338FF3333
        33FF88F800003333AA222222AA33A3333388FFFFFF8833830000333333AAAAAA
        3333333333338888883333330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      ParentDoubleBuffered = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = bnComRefreshClick
    end
    object seSendBefore: TSpinEdit
      Left = 8
      Top = 75
      Width = 121
      Height = 22
      MaxValue = 255
      MinValue = 1
      TabOrder = 2
      Value = 2
    end
    object cbChannelsCount: TComboBox
      Left = 8
      Top = 122
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = '1'
      Items.Strings = (
        '1'
        '2'
        '3'
        '4')
    end
    object cbChannel1: TCheckBox
      Left = 8
      Top = 263
      Width = 97
      Height = 17
      Caption = 'Channel 1 (Red)'
      Checked = True
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      State = cbChecked
      TabOrder = 4
    end
    object cbChannel2: TCheckBox
      Left = 8
      Top = 278
      Width = 97
      Height = 17
      Caption = 'Channel 2 (Blue)'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 5
    end
    object cbChannel3: TCheckBox
      Left = 8
      Top = 293
      Width = 108
      Height = 17
      Caption = 'Channel 3 (Green)'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 6
    end
    object cbChannel4: TCheckBox
      Left = 8
      Top = 308
      Width = 108
      Height = 17
      Caption = 'Channel 4 (Yellow)'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 7
    end
    object seMaxData: TSpinEdit
      Left = 8
      Top = 168
      Width = 121
      Height = 22
      MaxValue = 65536
      MinValue = 1
      TabOrder = 8
      Value = 1
    end
    object edChannel1: TEdit
      Left = 8
      Top = 350
      Width = 121
      Height = 24
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      Text = '0'
    end
    object edChannel2: TEdit
      Left = 8
      Top = 374
      Width = 121
      Height = 24
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      Text = '0'
    end
    object edChannel3: TEdit
      Left = 8
      Top = 398
      Width = 121
      Height = 24
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
      Text = '0'
    end
    object edChannel4: TEdit
      Left = 8
      Top = 422
      Width = 121
      Height = 24
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clOlive
      Font.Height = -11
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
      Text = '0'
    end
    object cbAutoScale: TCheckBox
      Left = 8
      Top = 452
      Width = 97
      Height = 17
      Caption = 'Auto scale'
      Checked = True
      State = cbChecked
      TabOrder = 13
      OnClick = cbAutoScaleClick
    end
    object seMinScale: TSpinEdit
      Left = 8
      Top = 494
      Width = 61
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 14
      Value = -32768
    end
    object seMaxScale: TSpinEdit
      Left = 71
      Top = 494
      Width = 58
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 15
      Value = 32767
    end
    object bnStartStop: TBitBtn
      Left = 8
      Top = 522
      Width = 121
      Height = 25
      Caption = 'Start'
      DoubleBuffered = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00344446333334
        44433333FFFF333333FFFF33000033AAA43333332A4333338833F33333883F33
        00003332A46333332A4333333383F33333383F3300003332A2433336A6633333
        33833F333383F33300003333AA463362A433333333383F333833F33300003333
        6AA4462A46333333333833FF833F33330000333332AA22246333333333338333
        33F3333300003333336AAA22646333333333383333F8FF33000033444466AA43
        6A43333338FFF8833F383F330000336AA246A2436A43333338833F833F383F33
        000033336A24AA442A433333333833F33FF83F330000333333A2AA2AA4333333
        333383333333F3330000333333322AAA4333333333333833333F333300003333
        333322A4333333333333338333F333330000333333344A433333333333333338
        3F333333000033333336A24333333333333333833F333333000033333336AA43
        33333333333333833F3333330000333333336663333333333333333888333333
        0000}
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 16
      OnClick = bnStartStopClick
    end
    object bnSingleReq: TBitBtn
      Left = 8
      Top = 553
      Width = 121
      Height = 25
      Caption = 'Single request'
      Default = True
      DoubleBuffered = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFF2FFFFFFFFFFFFFFFA2FFFFFFFFFFFFFFAA2FFFFFFFFFFFFFAAA2FFF
        FFFFFFFFFAAAA2FFFFFFFFFFFAAAAA2FFFFFFFFFFAAAAAA2FFFFFFFFFAAAAAAA
        2FFFFFFFFAAAAAAAFFFFFFFFFAAAAAAFFFFFFFFFFAAAAAFFFFFFFFFFFAAAAFFF
        FFFFFFFFFAAAFFFFFFFFFFFFFAAFFFFFFFFFFFFFFAFFFFFFFFFF}
      ParentDoubleBuffered = False
      TabOrder = 17
      OnClick = bnSingleReqClick
    end
    object cbBitsPerNumber: TComboBox
      Left = 8
      Top = 217
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemIndex = 6
      TabOrder = 18
      Text = '32'
      Items.Strings = (
        '1'
        '2'
        '4'
        '8'
        '16'
        '24'
        '32'
        '64')
    end
  end
  object Panel2: TPanel
    Left = 164
    Top = 29
    Width = 767
    Height = 613
    Align = alClient
    TabOrder = 3
    object Chart: TChart
      Left = 1
      Top = 1
      Width = 765
      Height = 583
      Legend.Visible = False
      Title.Text.Strings = (
        'TChart')
      Title.Visible = False
      View3D = False
      View3DOptions.Orthogonal = False
      View3DWalls = False
      Align = alClient
      TabOrder = 0
      PrintMargins = (
        15
        8
        15
        8)
      object Series1: TFastLineSeries
        Marks.Arrow.Visible = True
        Marks.Callout.Brush.Color = clBlack
        Marks.Callout.Arrow.Visible = True
        Marks.Visible = False
        LinePen.Color = clRed
        LinePen.Width = 2
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object Series2: TFastLineSeries
        Marks.Arrow.Visible = True
        Marks.Callout.Brush.Color = clBlack
        Marks.Callout.Arrow.Visible = True
        Marks.Visible = False
        SeriesColor = clBlue
        LinePen.Color = clBlue
        LinePen.Width = 2
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object Series3: TFastLineSeries
        Marks.Arrow.Visible = True
        Marks.Callout.Brush.Color = clBlack
        Marks.Callout.Arrow.Visible = True
        Marks.Visible = False
        LinePen.Color = clGreen
        LinePen.Width = 2
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object Series4: TFastLineSeries
        Marks.Arrow.Visible = True
        Marks.Callout.Brush.Color = clBlack
        Marks.Callout.Arrow.Visible = True
        Marks.Visible = False
        SeriesColor = clOlive
        LinePen.Color = clOlive
        LinePen.Width = 2
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
    object tbMaxVisibleData: TTrackBar
      Left = 1
      Top = 584
      Width = 765
      Height = 28
      Align = alBottom
      Ctl3D = True
      Max = 8192
      Min = 3
      ParentCtl3D = False
      Position = 256
      ShowSelRange = False
      TabOrder = 1
      OnChange = tbMaxVisibleDataChange
    end
  end
  object MainMenu1: TMainMenu
    Images = ilToolBar
    Left = 472
    Top = 320
    object File1: TMenuItem
      Caption = 'File'
      object menuExit: TMenuItem
        Caption = 'Exit'
        ImageIndex = 0
        ShortCut = 32883
        OnClick = menuExitClick
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object menuSquareDiscrete: TMenuItem
        Caption = 'Square discrete'
        OnClick = menuSquareDiscreteClick
      end
      object menuGraphAutoScroll: TMenuItem
        Caption = 'Graph auto scroll'
        Checked = True
        OnClick = menuGraphAutoScrollClick
      end
    end
  end
  object ilToolBar: TImageList
    Left = 512
    Top = 320
    Bitmap = {
      494C0101050008007C0010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000000000000000000000000000000000000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      00000080000000000000000000000000000000FF000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000800000000000000000000000FF000000FF0000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF0000008000000000000000FF000000FF000000FF00000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF00000080000000FF000000FF000000FF000000FF
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF00000000000000FF000000FF000000FF000000FF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF0000000000000000000000FF000000FF000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000000000000000000000000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      00000000000000000000000000000000000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F000000
      000000000000000000007F7F7F000000000000000000000000007F7F7F000000
      000000000000000000007F7F7F000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      80008080800000000000000000000000000000000000000000007F7F7F000000
      00007F7F7F00000000007F7F7F00000000007F7F7F00000000007F7F7F000000
      00007F7F7F00000000007F7F7F000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000800000008000000080
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080000000000000000000000000007F7F7F007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000800000FFFFFF00FFFFFF00FFFF
      FF0000800000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FF000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000800000FFFFFF00FFFFFF00FFFF
      FF0000800000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FF000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000808080008080
      800080808000000000000000000000000000000000007F7F7F00000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000800000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000800000FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FF000000FF000000FF00000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000C0C0
      C000808080000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000FF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000800000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000800000FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080000000000000000000000000007F7F7F007F7F7F00000000007F7F
      7F007F7F7F007F7F7F000000FF007F7F7F00FF000000FF000000FF0000007F7F
      7F000000FF007F7F7F007F7F7F007F7F7F0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000800000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000800000FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF0000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00FF000000000000000000000000000000FF00
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF000000FF00000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      800080808000000000000000000000000000000000007F7F7F00000000000000
      00000000000000000000FF0000000000FF000000000000000000000000000000
      FF00FF0000000000000000000000000000000000000000800000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000800000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      0000008000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000FF000000FF000000FF000000
      0000FF0000000000000000000000000000000000000000800000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000800000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FF000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000008080
      8000808080000000000000000000000000007F7F7F007F7F7F00000000007F7F
      7F007F7F7F007F7F7F00FF0000007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F00FF0000007F7F7F007F7F7F007F7F7F000000000000800000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000800000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FF000000FF000000FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000000000000000000000000000FF00
      00000000000000000000000000000000000000000000FFFFFF0000800000FFFF
      FF00FFFFFF00FFFFFF0000800000FFFFFF00FFFFFF00FF000000FF000000FF00
      0000FF000000FF000000FF000000FFFFFF000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000007F7F7F00000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      00000000000000000000000000000000000000000000FFFFFF0000800000FFFF
      FF00FFFFFF00FFFFFF0000800000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FF000000FF000000FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000080
      00000080000000800000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FF000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FF000000FF000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000000000000000000008000
      0000000000000000000000000000000000007F7F7F007F7F7F00000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FF000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000FF000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000EF7F000000000000
      E73F000000000000E31F000000000000E10F000000000000E007000000000000
      E003000000000000E001000000000000E000000000000000E001000000000000
      E003000000000000E007000000000000E10F000000000000E31F000000000000
      E73F000000000000EF7F000000000000FFFFDDDD8000FFFFFE03D5558000FBFF
      FE0300008000F9FF4003DFFF8000F8FFC00387FC8000F87FE103DBFB8000F83F
      24C300008000F81FF003DCE7FEFFF80FFC839CE78000F807F803DD178000F80F
      FC0300008000F81FFE03DEEF8000F83FFE039F1F8000F87FFF0FDFFF8000F8FF
      FF6F00008000F9FFFF03FFFF8000FBFF00000000000000000000000000000000
      000000000000}
  end
  object timerMain: TTimer
    Enabled = False
    Interval = 1
    OnTimer = timerMainTimer
    Left = 552
    Top = 320
  end
end
