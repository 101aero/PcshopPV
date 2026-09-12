object frmHistorialVentas: TfrmHistorialVentas
  Left = 0
  Top = 0
  Caption = 'Historial de ventas'
  ClientHeight = 511
  ClientWidth = 834
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    834
    511)
  TextHeight = 17
  object lblTitulo: TLabel
    Left = 16
    Top = 14
    Width = 164
    Height = 25
    Caption = 'Historial de ventas'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grpBusqueda: TGroupBox
    Left = 16
    Top = 49
    Width = 800
    Height = 110
    Anchors = [akLeft, akTop, akRight]
    Caption = 'B'#250'squeda'
    TabOrder = 0
    ExplicitWidth = 798
    DesignSize = (
      800
      110)
    object lblBuscar: TLabel
      Left = 16
      Top = 32
      Width = 41
      Height = 17
      Caption = 'Buscar:'
    end
    object edtBuscarVenta: TEdit
      Left = 72
      Top = 27
      Width = 388
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      ExplicitWidth = 386
    end
    object btnBuscarVenta: TButton
      Left = 472
      Top = 26
      Width = 110
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btnBuscarVentaClick
      ExplicitLeft = 470
    end
    object btnMostrarVentas: TButton
      Left = 592
      Top = 26
      Width = 180
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Mostrar todas'
      TabOrder = 2
      ExplicitLeft = 590
    end
    object lblClienteFiltro: TLabel
      Left = 16
      Top = 72
      Width = 45
      Height = 17
      Caption = 'Cliente:'
    end
    object cboClienteFiltro: TComboBox
      Left = 72
      Top = 67
      Width = 300
      Height = 25
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = 'Todos los clientes'
      OnChange = cboClienteFiltroChange
      Items.Strings = (
        'Todos los clientes')
    end
  end
  object grdVentas: TStringGrid
    Left = 16
    Top = 173
    Width = 800
    Height = 249
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 7
    DefaultColWidth = 120
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 1
    ExplicitWidth = 798
    ExplicitHeight = 241
  end
  object grpResumen: TGroupBox
    Left = 16
    Top = 435
    Width = 800
    Height = 60
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Resumen comercial'
    TabOrder = 2
    ExplicitTop = 427
    ExplicitWidth = 798
    object lblTotalVentas: TLabel
      Left = 18
      Top = 28
      Width = 56
      Height = 17
      Caption = 'Ventas: 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblUnidadesVendidas: TLabel
      Left = 205
      Top = 28
      Width = 72
      Height = 17
      Caption = 'Unidades: 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblImporteVentas: TLabel
      Left = 420
      Top = 28
      Width = 126
      Height = 17
      Caption = 'Importe total: 0,00 '#8364
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
