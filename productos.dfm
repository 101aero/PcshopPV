object frmproductos: Tfrmproductos
  Left = 0
  Top = 0
  Caption = 'Productos'
  ClientHeight = 651
  ClientWidth = 845
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    845
    651)
  TextHeight = 15
  object lblModo: TLabel
    Left = 680
    Top = 134
    Width = 95
    Height = 25
    Caption = 'Modo: Alta'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grpfiltros: TGroupBox
    Left = 8
    Top = 8
    Width = 825
    Height = 129
    Anchors = [akLeft, akTop, akRight]
    Caption = 'B'#250'squeda y filtros'
    TabOrder = 0
    object lblFiltroStock: TLabel
      Left = 16
      Top = 68
      Width = 78
      Height = 15
      Caption = 'Stock m'#225'ximo:'
    end
    object lblEstadoBusqueda: TLabel
      Left = 285
      Top = 68
      Width = 3
      Height = 15
    end
    object lblValorInventario: TLabel
      Left = 449
      Top = 68
      Width = 10
      Height = 25
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object edtBusqueda: TEdit
      Left = 16
      Top = 24
      Width = 290
      Height = 23
      TabOrder = 0
      TextHint = 'Buscar por c'#243'digo o nombre'
      OnKeyDown = edtBusquedaKeyDown
    end
    object btnBuscarFiltro: TButton
      Left = 314
      Top = 23
      Width = 80
      Height = 25
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btnBuscarFiltroClick
    end
    object btnMostrarTodos: TButton
      Left = 402
      Top = 23
      Width = 110
      Height = 25
      Caption = 'Mostrar todos'
      TabOrder = 2
      OnClick = btnMostrarTodosClick
    end
    object edtFiltroStock: TEdit
      Left = 105
      Top = 64
      Width = 60
      Height = 23
      TabOrder = 3
      Text = '5'
    end
    object btnStockBajo: TButton
      Left = 173
      Top = 63
      Width = 90
      Height = 25
      Caption = 'Stock bajo'
      TabOrder = 4
      OnClick = btnStockBajoClick
    end
    object btnValorInventario: TButton
      Left = 328
      Top = 72
      Width = 115
      Height = 25
      Caption = 'btnValorInventario'
      TabOrder = 5
      OnClick = btnValorInventarioClick
    end
    object btnExportarCSV: TButton
      Left = 704
      Top = 72
      Width = 105
      Height = 25
      Caption = 'Exportar CSV'
      TabOrder = 6
      OnClick = btnExportarCSVClick
    end
  end
  object dlgExportarCSV: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'Archivos CSV (*.csv)|*.csv'
    Options = [ofOverwritePrompt, ofPathMustExist, ofEnableSizing]
    Title = 'Exportar inventario a CSV'
    Left = 784
    Top = 160
  end
end
