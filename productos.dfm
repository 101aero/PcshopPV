object frmproductos: Tfrmproductos
  Left = 0
  Top = 0
  Caption = 'Productos'
  ClientHeight = 551
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
  TextHeight = 15
  object lblModo: TLabel
    Left = 304
    Top = 32
    Width = 53
    Height = 37
    Caption = 'Alta'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtBusqueda: TEdit
    Left = 24
    Top = 8
    Width = 260
    Height = 23
    TabOrder = 0
    TextHint = 'Buscar por c'#243'digo o nombre'
  end
  object btnBuscarFiltro: TButton
    Left = 290
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Buscar'
    TabOrder = 1
    OnClick = btnBuscarFiltroClick
  end
  object btnMostrarTodos: TButton
    Left = 392
    Top = 8
    Width = 75
    Height = 25
    Caption = 'mostrar todos'
    TabOrder = 2
    OnClick = btnMostrarTodosClick
  end
end
