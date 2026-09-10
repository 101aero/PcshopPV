object frmVentas: TfrmVentas
  Left = 0
  Top = 0
  Caption = 'Ventas'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object grpVenta: TGroupBox
    Left = 16
    Top = 16
    Width = 470
    Height = 240
    Caption = 'grpVenta'
    TabOrder = 0
    object lblProducto: TLabel
      Left = 32
      Top = 40
      Width = 62
      Height = 15
      Caption = 'lblProducto'
    end
    object lblCantidad: TLabel
      Left = 280
      Top = 43
      Width = 61
      Height = 15
      Caption = 'lblCantidad'
    end
    object lblStockventa: TLabel
      Left = 20
      Top = 160
      Width = 71
      Height = 15
      Caption = 'lblStockventa'
    end
    object lblPrecioVenta: TLabel
      Left = 128
      Top = 160
      Width = 75
      Height = 15
      Caption = 'lblPrecioVenta'
    end
    object lblTotalVenta: TLabel
      Left = 307
      Top = 160
      Width = 67
      Height = 15
      Caption = 'lblTotalVenta'
    end
    object lblCliente: TLabel
      Left = 32
      Top = 100
      Width = 40
      Height = 15
      Caption = 'Cliente:'
    end
    object cboProducto: TComboBox
      Left = 32
      Top = 61
      Width = 145
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = cboProductoChange
    end
    object cboCliente: TComboBox
      Left = 32
      Top = 121
      Width = 361
      Height = 23
      Style = csDropDownList
      TabOrder = 2
    end
    object edtCantidad: TEdit
      Left = 272
      Top = 64
      Width = 121
      Height = 23
      TabOrder = 1
      Text = '1'
      OnChange = edtCantidadChange
    end
    object btnRegistrarVenta: TButton
      Left = 20
      Top = 195
      Width = 131
      Height = 25
      Caption = 'btnRegistrarVenta'
      TabOrder = 3
      OnClick = btnRegistrarVentaClick
    end
  end
end
