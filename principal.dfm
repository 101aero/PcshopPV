object frmprincipal: Tfrmprincipal
  Left = 0
  Top = 0
  Caption = 'pc shop'
  ClientHeight = 661
  ClientWidth = 984
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  TextHeight = 15
  object MainMenu1: TMainMenu
    Left = 136
    Top = 128
    object Archivo1: TMenuItem
      Caption = 'Archivo'
      object Salir1: TMenuItem
        Caption = 'Salir'
      end
    end
    object Gestin1: TMenuItem
      Caption = 'Gesti'#243'n'
      object Gestin2: TMenuItem
        Caption = 'Productos'
        OnClick = Gestin2Click
      end
      object mnuMovimientoStock: TMenuItem
        Caption = 'Movimientos de stock'
        OnClick = mnuMovimientoStockClick
      end
      object Clientes1: TMenuItem
        Caption = 'Clientes'
        OnClick = Clientes1Click
      end
      object Clientes2: TMenuItem
        Caption = 'Ventas'
        OnClick = Clientes2Click
      end
      object mnuHistorialVentas: TMenuItem
        Caption = 'HistorialVentas'
        OnClick = mnuHistorialVentasClick
      end
      object mnuCrearBackup: TMenuItem
        Caption = 'Crear copia de seguridad'
        OnClick = mnuCrearBackupClick
      end
    end
    object Informes1: TMenuItem
      Caption = 'Informes'
    end
    object Informes2: TMenuItem
      Caption = 'Ayuda'
      object Acercade1: TMenuItem
        Caption = 'Acerca de...'
      end
    end
  end
end
