object Form1: TForm1
  Left = 204
  Top = 117
  Width = 1056
  Height = 740
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MessagesPnl: TPanel
    Left = 680
    Top = 80
    Width = 329
    Height = 105
    TabOrder = 0
    object Edit1: TEdit
      Left = 32
      Top = 24
      Width = 257
      Height = 21
      TabOrder = 0
    end
    object SendMsgBtn: TButton
      Left = 48
      Top = 56
      Width = 105
      Height = 25
      Caption = 'Send message'
      TabOrder = 1
      OnClick = SendMsgBtnClick
    end
    object Button1: TButton
      Left = 156
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Inject'
      TabOrder = 2
      Visible = False
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 236
      Top = 56
      Width = 75
      Height = 25
      Caption = 'JavaScript'
      TabOrder = 3
      Visible = False
      OnClick = Button3Click
    end
  end
  object Panel1: TPanel
    Left = 680
    Top = 200
    Width = 329
    Height = 225
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 99
      Height = 13
      Caption = 'Received messages:'
    end
    object MessagesList: TListBox
      Left = 16
      Top = 32
      Width = 297
      Height = 177
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 680
    Top = 440
    Width = 329
    Height = 105
    TabOrder = 2
    object Label2: TLabel
      Left = 16
      Top = 8
      Width = 67
      Height = 13
      Caption = 'Shared buffer:'
    end
    object SharedBufferEdt: TEdit
      Left = 16
      Top = 24
      Width = 289
      Height = 21
      TabOrder = 0
    end
    object PostSharedBufferBtn: TButton
      Left = 96
      Top = 56
      Width = 139
      Height = 25
      Caption = 'Post shared buffer'
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    Left = 680
    Top = 0
    Width = 329
    Height = 65
    TabOrder = 3
    object Button2: TButton
      Left = 88
      Top = 24
      Width = 89
      Height = 25
      Caption = 'Load local file'
      TabOrder = 0
      OnClick = Button2Click
    end
  end
  object ScrollBar1: TScrollBar
    Left = 0
    Top = 664
    Width = 625
    Height = 17
    PageSize = 0
    TabOrder = 4
    OnChange = ScrollBar1Change
  end
  object ScrollBar2: TScrollBar
    Left = 624
    Top = 54
    Width = 17
    Height = 611
    Kind = sbVertical
    PageSize = 0
    TabOrder = 5
    OnChange = ScrollBar2Change
  end
  object Panel4: TPanel
    Left = 680
    Top = 560
    Width = 329
    Height = 121
    TabOrder = 6
    object Label3: TLabel
      Left = 128
      Top = 8
      Width = 69
      Height = 13
      Caption = 'Zoom 1000 (1)'
    end
    object Label4: TLabel
      Left = 16
      Top = 40
      Width = 50
      Height = 13
      Caption = 'Horizontal:'
    end
    object Label5: TLabel
      Left = 16
      Top = 80
      Width = 38
      Height = 13
      Caption = 'Vertical:'
    end
    object ScrollBar3: TScrollBar
      Left = 80
      Top = 40
      Width = 217
      Height = 17
      Max = 4000
      PageSize = 0
      TabOrder = 0
      OnChange = ScrollBar3Change
    end
    object ScrollBar4: TScrollBar
      Left = 80
      Top = 80
      Width = 217
      Height = 17
      Max = 600
      PageSize = 0
      TabOrder = 1
      OnChange = ScrollBar4Change
    end
  end
  object Button4: TButton
    Left = 8
    Top = 0
    Width = 41
    Height = 25
    Caption = '<<<'
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 48
    Top = 0
    Width = 41
    Height = 25
    Caption = 'Home'
    TabOrder = 8
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 88
    Top = 0
    Width = 89
    Height = 25
    Caption = 'Set Home Page'
    TabOrder = 9
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 176
    Top = 0
    Width = 49
    Height = 25
    Caption = 'Refresh'
    TabOrder = 10
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 360
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Extensions'
    TabOrder = 11
    OnClick = Button8Click
  end
  object OpenDialog1: TOpenDialog
    Left = 304
    Top = 120
  end
end
