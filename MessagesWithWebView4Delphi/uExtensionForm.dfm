object Form2: TForm2
  Left = 239
  Top = 132
  Width = 1254
  Height = 554
  Caption = 'Edge browser extensions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 48
    Width = 569
    Height = 13
    Caption = 
      'Extensions to  load  (//=comment   enter full path to unpacked s' +
      'ource folder or packed extension definition: *.crx or *.zip):'
  end
  object Label2: TLabel
    Left = 24
    Top = 384
    Width = 73
    Height = 13
    Caption = 'Extension path:'
  end
  object Label3: TLabel
    Left = 736
    Top = 48
    Width = 330
    Height = 13
    Caption = 
      'Select an extension source folder or a packed selection (*.crx o' +
      'r *.zip):'
  end
  object Label4: TLabel
    Left = 144
    Top = 8
    Width = 848
    Height = 25
    Caption = 
      'Caution: the current WebView4Delphi does NOT support packed exte' +
      'nsions (CRASH)  !'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ListBox1: TListBox
    Left = 24
    Top = 72
    Width = 689
    Height = 297
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object Edit1: TEdit
    Left = 24
    Top = 400
    Width = 657
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 24
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Update'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 200
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 24
    Top = 472
    Width = 257
    Height = 25
    Caption = 'Validate'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 640
    Top = 472
    Width = 75
    Height = 25
    Caption = 'Abandon'
    TabOrder = 6
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 683
    Top = 400
    Width = 102
    Height = 21
    Caption = 'Search extension'
    TabOrder = 7
    OnClick = Button6Click
  end
  object ListBox2: TListBox
    Left = 736
    Top = 72
    Width = 433
    Height = 297
    ItemHeight = 13
    TabOrder = 8
    Visible = False
    OnDblClick = ListBox2DblClick
    OnMouseDown = ListBox2MouseDown
  end
  object OpenDialog1: TOpenDialog
    Left = 680
    Top = 40
  end
end
