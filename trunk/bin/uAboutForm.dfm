object AboutForm: TAboutForm
  Left = 381
  Top = 259
  BorderStyle = bsDialog
  Caption = 'Sobre o Calx'
  ClientHeight = 118
  ClientWidth = 236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 32
    Height = 32
  end
  object Label1: TLabel
    Left = 58
    Top = 6
    Width = 35
    Height = 20
    Caption = 'Calx'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 59
    Top = 26
    Width = 121
    Height = 20
    Caption = 'Calculadora RPN'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 7
    Top = 58
    Width = 223
    Height = 20
    Caption = 'Alex Sandre Dundes Rodrigues'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object BitBtn1: TBitBtn
    Left = 156
    Top = 88
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
end
