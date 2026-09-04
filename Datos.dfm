object dmDatos: TdmDatos
  OnCreate = DataModuleCreate
  Height = 837
  Width = 1116
  PixelsPerInch = 120
  object FDConnection1: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'DriverID=SQLite')
    Left = 72
    Top = 43
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
    Left = 72
    Top = 122
  end
  object qryInsertarProducto: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO PRODUCTOS'
      '  (Codigo, Nombre, Precio, Stock)'
      'VALUES'
      '  (:Codigo, :Nombre, :Precio, :Stock);')
    Left = 236
    Top = 150
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
    Left = 387
    Top = 150
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
    Left = 501
    Top = 150
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
    Left = 330
    Top = 301
    ParamData = <
      item
        Name = 'CODIGO'
        ParamType = ptInput
      end>
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 258
    Top = 79
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
    Left = 201
    Top = 244
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
    Left = 444
    Top = 64
  end
  object qryExisteCodigo: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT COUNT(*) AS Total'
      'FROM PRODUCTOS'
      'WHERE Codigo = :Codigo;')
    Left = 530
    Top = 294
    ParamData = <
      item
        Name = 'CODIGO'
        ParamType = ptInput
      end>
  end
  object qryStockBajo: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT Codigo, Nombre, Precio, Stock'
      'FROM PRODUCTOS'
      'WHERE Stock <= :StockMaximo'
      'ORDER BY Stock ASC, Nombre ASC;')
    Left = 666
    Top = 308
    ParamData = <
      item
        Name = 'STOCKMAXIMO'
        ParamType = ptInput
      end>
  end
  object qryValorInventario: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT COALESCE(SUM(Precio * Stock), 0) AS ValorTotal'
      'FROM PRODUCTOS;')
    Left = 767
    Top = 308
  end
  object qryOrdenarProductos: TFDQuery
    Connection = FDConnection1
    Left = 880
    Top = 312
  end
  object qryCrearTablaVentas: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS VENTAS ('
      '    Id INTEGER PRIMARY KEY AUTOINCREMENT,'
      '    Fecha TEXT NOT NULL,'
      '    CodigoProducto TEXT NOT NULL,'
      '    Cantidad INTEGER NOT NULL,'
      '    PrecioUnitario REAL NOT NULL,'
      '    Total REAL NOT NULL'
      ');')
    Left = 288
    Top = 432
  end
  object qryInsertarVenta: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO VENTAS'
      '  (Fecha, CodigoProducto, Cantidad, PrecioUnitario, Total)'
      'VALUES'
      '  (:Fecha, :CodigoProducto, :Cantidad, :PrecioUnitario, :Total);')
    Left = 440
    Top = 440
    ParamData = <
      item
        Name = 'FECHA'
        ParamType = ptInput
      end
      item
        Name = 'CODIGOPRODUCTO'
        ParamType = ptInput
      end
      item
        Name = 'CANTIDAD'
        ParamType = ptInput
      end
      item
        Name = 'PRECIOUNITARIO'
        ParamType = ptInput
      end
      item
        Name = 'TOTAL'
        ParamType = ptInput
      end>
  end
  object qryDescontarStock: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'UPDATE PRODUCTOS'
      'SET Stock = Stock - :Cantidad'
      'WHERE Codigo = :CodigoProducto'
      '  AND Stock >= :Cantidad;')
    Left = 568
    Top = 440
    ParamData = <
      item
        Name = 'CANTIDAD'
        ParamType = ptInput
      end
      item
        Name = 'CODIGOPRODUCTO'
        ParamType = ptInput
      end>
  end
  object qryListarVentas: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'SELECT Id, Fecha, CodigoProducto, Cantidad, PrecioUnitario, Tota' +
        'l'
      'FROM VENTAS'
      'ORDER BY Id DESC;')
    Left = 848
    Top = 616
  end
end
