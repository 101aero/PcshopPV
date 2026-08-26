object dmDatos: TdmDatos
  OnCreate = DataModuleCreate
  Height = 935
  Width = 1246
  PixelsPerInch = 134
  object FDConnection1: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'DriverID=SQLite')
    Left = 80
    Top = 48
  end
  object qryProductos: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS PRODUCTOS ('
      '  Codigo TEXT PRIMARY KEY NOT NULL,'
      '  Nombre TEXT NOT NULL,'
      '  Precio REAL NOT NULL CHECK (Precio >= 0),'
      '  Stock INTEGER NOT NULL CHECK (Stock >= 0)'
      ');')
    Left = 80
    Top = 136
  end
  object qryInsertarProducto: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO PRODUCTOS'
      '  (Codigo, Nombre, Precio, Stock)'
      'VALUES'
      '  (:Codigo, :Nombre, :Precio, :Stock);')
    Left = 264
    Top = 168
    ParamData = <
      item
        Name = 'CODIGO'
        ParamType = ptInput
      end
      item
        Name = 'NOMBRE'
        ParamType = ptInput
      end
      item
        Name = 'PRECIO'
        ParamType = ptInput
      end
      item
        Name = 'STOCK'
        ParamType = ptInput
      end>
  end
  object qryListarProductos: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT Codigo, Nombre, Precio, Stock'
      'FROM PRODUCTOS'
      'ORDER BY Codigo;')
    Left = 432
    Top = 168
  end
  object qryActualizarProducto: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      '                       UPDATE PRODUCTOS'
      'SET'
      '  Nombre = :Nombre,'
      '  Precio = :Precio,'
      '  Stock = :Stock'
      'WHERE Codigo = :Codigo;')
    Left = 560
    Top = 168
    ParamData = <
      item
        Name = 'NOMBRE'
        ParamType = ptInput
      end
      item
        Name = 'PRECIO'
        ParamType = ptInput
      end
      item
        Name = 'STOCK'
        ParamType = ptInput
      end
      item
        Name = 'CODIGO'
        ParamType = ptInput
      end>
  end
  object qryEliminarProducto: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'DELETE FROM PRODUCTOS WHERE Codigo = :Codigo')
    Left = 368
    Top = 336
    ParamData = <
      item
        Name = 'CODIGO'
        ParamType = ptInput
      end>
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 288
    Top = 88
  end
  object qryBuscarProductos: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT Codigo, Nombre, Precio, Stock'
      'FROM PRODUCTOS'
      'WHERE Codigo = :Codigo'
      '  OR Nombre LIKE :Nombre'
      'ORDER BY Codigo'
      'LIMIT 100;')
    Left = 224
    Top = 272
    ParamData = <
      item
        Name = 'CODIGO'
        ParamType = ptInput
      end
      item
        Name = 'NOMBRE'
        ParamType = ptInput
      end>
  end
  object qryContarProductos: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT COUNT(*) AS Total'
      'FROM PRODUCTOS;')
    Left = 496
    Top = 72
  end
end
