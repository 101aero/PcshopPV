object frmClientes: TfrmClientes
  Left = 0
  Top = 0
  Caption = 'Clientes'
  ClientHeight = 546
  ClientWidth = 824
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
  TextHeight = 17
  object lblTitulo: TLabel
    Left = 16
    Top = 14
    Width = 165
    Height = 25
    Caption = 'Gestión de clientes'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblModoCliente: TLabel
    Left = 640
    Top = 18
    Width = 72
    Height = 17
    Caption = 'Modo: Alta'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grpBusqueda: TGroupBox
    Left = 16
    Top = 49
    Width = 792
    Height = 72
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Búsqueda'
    TabOrder = 0
    object lblBuscar: TLabel
      Left = 16
      Top = 31
      Width = 43
      Height = 17
      Caption = 'Buscar:'
    end
    object edtBuscarCliente: TEdit
      Left = 72
      Top = 26
      Width = 402
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      TextHint = 'Nombre, email o teléfono'
    end
    object btnBuscarCliente: TButton
      Left = 486
      Top = 25
      Width = 110
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btnBuscarClienteClick
    end
    object btnMostrarClientes: TButton
      Left = 606
      Top = 25
      Width = 160
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Mostrar todos'
      TabOrder = 2
      OnClick = btnMostrarClientesClick
    end
  end
  object grpDatosCliente: TGroupBox
    Left = 16
    Top = 132
    Width = 792
    Height = 126
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Datos del cliente'
    TabOrder = 1
    object lblNombreCliente: TLabel
      Left = 16
      Top = 31
      Width = 52
      Height = 17
      Caption = 'Nombre:'
    end
    object lblEmailCliente: TLabel
      Left = 16
      Top = 66
      Width = 36
      Height = 17
      Caption = 'Email:'
    end
    object lblTelefonoCliente: TLabel
      Left = 414
      Top = 66
      Width = 55
      Height = 17
      Caption = 'Teléfono:'
    end
    object edtNombreCliente: TEdit
      Left = 88
      Top = 26
      Width = 678
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object edtEmailCliente: TEdit
      Left = 88
      Top = 61
      Width = 300
      Height = 25
      TabOrder = 1
    end
    object edtTelefonoCliente: TEdit
      Left = 486
      Top = 61
      Width = 280
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
  end
  object btnNuevoCliente: TButton
    Left = 16
    Top = 273
    Width = 110
    Height = 30
    Caption = 'Nuevo'
    TabOrder = 2
    OnClick = btnNuevoClienteClick
  end
  object btnGuardarCliente: TButton
    Left = 136
    Top = 273
    Width = 125
    Height = 30
    Caption = 'Guardar'
    TabOrder = 3
    OnClick = btnGuardarClienteClick
  end
  object btnEliminarCliente: TButton
    Left = 271
    Top = 273
    Width = 125
    Height = 30
    Caption = 'Eliminar'
    TabOrder = 4
    OnClick = btnEliminarClienteClick
  end
  object btnCerrarCliente: TButton
    Left = 698
    Top = 273
    Width = 110
    Height = 30
    Anchors = [akTop, akRight]
    Caption = 'Cerrar'
    TabOrder = 5
    OnClick = btnCerrarClienteClick
  end
  object grdClientes: TStringGrid
    Left = 16
    Top = 316
    Width = 792
    Height = 214
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 4
    DefaultColWidth = 120
    DefaultRowHeight = 24
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 6
    OnSelectCell = grdClientesSelectCell
  end
end
