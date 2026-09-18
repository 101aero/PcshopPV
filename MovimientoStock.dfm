object frmMovimientoStock: TfrmMovimientoStock
  Left = 0
  Top = 0
  Caption = 'Movimiento de stock'
  ClientHeight = 620
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object grpMovimiento: TGroupBox
    Left = 16
    Top = 16
    Width = 688
    Height = 321
    Caption = 'Operaci'#243'n manual de stock'
    TabOrder = 0
    object lblProducto: TLabel
      Left = 24
      Top = 34
      Width = 53
      Height = 15
      Caption = 'Producto:'
    end
    object lblStockActual: TLabel
      Left = 24
      Top = 88
      Width = 79
      Height = 15
      Caption = 'Stock actual: -'
    end
    object lblTipo: TLabel
      Left = 24
      Top = 121
      Width = 27
      Height = 15
      Caption = 'Tipo:'
    end
    object lblCantidad: TLabel
      Left = 232
      Top = 121
      Width = 51
      Height = 15
      Caption = 'Cantidad:'
    end
    object lblAyudaCantidad: TLabel
      Left = 24
      Top = 174
      Width = 541
      Height = 15
      AutoSize = False
      Caption = 'Ayuda de cantidad'
    end
    object lblMotivo: TLabel
      Left = 24
      Top = 205
      Width = 40
      Height = 15
      Caption = 'Motivo:'
    end
    object cboProducto: TComboBox
      Left = 24
      Top = 55
      Width = 360
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = cboProductoChange
    end
    object cboTipo: TComboBox
      Left = 24
      Top = 142
      Width = 177
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      OnChange = cboTipoChange
    end
    object edtCantidad: TEdit
      Left = 232
      Top = 142
      Width = 152
      Height = 23
      TabOrder = 2
    end
    object edtMotivo: TEdit
      Left = 24
      Top = 226
      Width = 541
      Height = 23
      TabOrder = 3
    end
    object btnAplicar: TButton
      Left = 24
      Top = 271
      Width = 145
      Height = 30
      Caption = 'Aplicar movimiento'
      TabOrder = 4
      OnClick = btnAplicarClick
    end
    object btnCerrar: TButton
      Left = 520
      Top = 271
      Width = 125
      Height = 30
      Caption = 'Cerrar'
      TabOrder = 5
      OnClick = btnCerrarClick
    end
  end
  object grpHistorial: TGroupBox
    Left = 16
    Top = 352
    Width = 688
    Height = 249
    Caption = 'Historial de movimientos de stock'
    TabOrder = 1
    object lblAuditoria: TLabel
      Left = 190
      Top = 23
      Width = 478
      Height = 34
      AutoSize = False
      Caption = 'Auditoria: sin comprobar'
      WordWrap = True
    end
    object btnComprobarTrazabilidad: TButton
      Left = 16
      Top = 22
      Width = 160
      Height = 30
      Caption = 'Comprobar trazabilidad'
      TabOrder = 0
      OnClick = btnComprobarTrazabilidadClick
    end
    object grdMovimientos: TStringGrid
      Left = 16
      Top = 64
      Width = 656
      Height = 168
      ColCount = 7
      DefaultColWidth = 90
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 1
      ColWidths = (
        48
        122
        88
        78
        70
        150
        70)
    end
  end
end
