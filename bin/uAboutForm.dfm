object AboutForm: TAboutForm
  Left = 381
  Top = 259
  BorderStyle = bsDialog
  Caption = 'Sobre o Calx'
  ClientHeight = 208
  ClientWidth = 250
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
    Width = 183
    Height = 20
    Caption = 'Calculadora RPN - Pr'#225'tica'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 82
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
  object Label4: TLabel
    Left = 8
    Top = 64
    Width = 75
    Height = 13
    Caption = 'Desenvolvedor:'
  end
  object Label5: TLabel
    Left = 8
    Top = 113
    Width = 63
    Height = 13
    Caption = 'Beta Testers:'
  end
  object Label6: TLabel
    Left = 8
    Top = 130
    Width = 136
    Height = 20
    Caption = 'Fernando Nomellini'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 8
    Top = 148
    Width = 176
    Height = 20
    Caption = 'Renato Barboza Ferreira'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object BitBtn1: TBitBtn
    Left = 166
    Top = 174
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
end
