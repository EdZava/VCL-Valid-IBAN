object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Main'
  ClientHeight = 336
  ClientWidth = 523
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 523
    Height = 336
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Generar IBAN'
      object Label1: TLabel
        Left = 18
        Top = 16
        Width = 19
        Height = 13
        Caption = 'Pais'
      end
      object Label2: TLabel
        Left = 18
        Top = 113
        Width = 25
        Height = 13
        Caption = 'CCC:'
      end
      object Label3: TLabel
        Left = 18
        Top = 201
        Width = 62
        Height = 13
        Caption = 'Nuevo IBAN:'
      end
      object Label5: TLabel
        Left = 18
        Top = 65
        Width = 40
        Height = 13
        Caption = 'Entidad:'
      end
      object Label6: TLabel
        Left = 90
        Top = 65
        Width = 37
        Height = 13
        Caption = 'Oficina:'
      end
      object Label7: TLabel
        Left = 162
        Top = 65
        Width = 18
        Height = 13
        Caption = 'DC:'
      end
      object Label8: TLabel
        Left = 210
        Top = 65
        Width = 39
        Height = 13
        Caption = 'Cuenta:'
      end
      object Label9: TLabel
        Left = 130
        Top = 201
        Width = 131
        Height = 13
        Caption = 'IBAN Completo Electronico:'
      end
      object Label10: TLabel
        Left = 130
        Top = 249
        Width = 105
        Height = 13
        Caption = 'IBAN Completo Papel:'
      end
      object edtPais: TEdit
        Left = 18
        Top = 32
        Width = 199
        Height = 21
        TabOrder = 0
        Text = 'DE'
      end
      object edtCCC: TEdit
        Left = 18
        Top = 129
        Width = 231
        Height = 21
        TabOrder = 1
        Text = '370400440532013000'
      end
      object btnGenerarIBAN: TButton
        Left = 18
        Top = 161
        Width = 86
        Height = 25
        Caption = 'Generar IBAN'
        TabOrder = 2
        OnClick = btnGenerarIBANClick
      end
      object edtNewIBAN: TEdit
        Left = 18
        Top = 217
        Width = 86
        Height = 21
        TabOrder = 3
      end
      object edtEntidad: TEdit
        Left = 18
        Top = 81
        Width = 62
        Height = 21
        TabOrder = 4
        Text = '3704'
      end
      object edtOficina: TEdit
        Left = 90
        Top = 81
        Width = 62
        Height = 21
        TabOrder = 5
        Text = '0044'
      end
      object edtDC: TEdit
        Left = 162
        Top = 81
        Width = 31
        Height = 21
        TabOrder = 6
        Text = '05'
      end
      object edtCuenta: TEdit
        Left = 210
        Top = 81
        Width = 62
        Height = 21
        TabOrder = 7
        Text = '32013000'
      end
      object btnToCCC: TButton
        Left = 288
        Top = 79
        Width = 75
        Height = 25
        Caption = 'Generar CCC'
        TabOrder = 8
        OnClick = btnToCCCClick
      end
      object edtIBANFullElect: TEdit
        Left = 130
        Top = 217
        Width = 295
        Height = 21
        TabOrder = 9
      end
      object edtIBANFullPapel: TEdit
        Left = 130
        Top = 265
        Width = 295
        Height = 21
        TabOrder = 10
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Validar IBAN'
      ImageIndex = 1
      object Label4: TLabel
        Left = 27
        Top = 32
        Width = 28
        Height = 13
        Caption = 'IBAN:'
      end
      object btnValid_IBAN: TButton
        Left = 27
        Top = 87
        Width = 86
        Height = 25
        Caption = 'Validar IBAN'
        TabOrder = 0
        OnClick = btnValid_IBANClick
      end
      object edtIBAN_valid: TEdit
        Left = 27
        Top = 53
        Width = 295
        Height = 21
        TabOrder = 1
        Text = 'IBAN ES1720852066623456789011'
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Validar N'#186' Cuenta (ESP)'
      ImageIndex = 2
    end
  end
end
