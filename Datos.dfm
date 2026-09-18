object dmDatos: TdmDatos
  OnCreate = DataModuleCreate
  Height = 940
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
      '    Total REAL NOT NULL,'
      '    IdCliente INTEGER'
      ');')
    Left = 288
    Top = 432
  end
  object qryInsertarVenta: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO VENTAS'
      '  (Fecha, IdCliente, CodigoProducto, Cantidad, PrecioUnitario, Total)'
      'VALUES'
      '  (:Fecha, :IdCliente, :CodigoProducto, :Cantidad, :PrecioUnitario, :Total);')
    Left = 440
    Top = 440
    ParamData = <
      item
        Name = 'FECHA'
        ParamType = ptInput
      end
      item
        Name = 'IDCLIENTE'
        DataType = ftInteger
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
      'SELECT'
      '    v.Id AS IdVenta,'
      '    v.IdCliente,'
      '    v.Fecha,'
      '    v.CodigoProducto,'
      '    COALESCE(p.Nombre, '#39'(producto no disponible)'#39') AS Producto,'
      '    COALESCE(c.Nombre, '#39'(venta anónima)'#39') AS Cliente,'
      '    v.Cantidad,'
      '    v.PrecioUnitario,'
      '    v.Total'
      'FROM VENTAS v'
      'LEFT JOIN PRODUCTOS p'
      '    ON p.Codigo = v.CodigoProducto'
      'LEFT JOIN CLIENTES c'
      '    ON c.IdCliente = v.IdCliente'
      'WHERE (:IdClienteFiltro = 0 OR v.IdCliente = :IdClienteFiltro)'
      'ORDER BY v.Id DESC;')
    Left = 848
    Top = 616
    ParamData = <
      item
        Name = 'IDCLIENTEFILTRO'
        ParamType = ptInput
      end>
  end
  object qryResumenVentas: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT'
      '    COUNT(*) AS TotalVentas,'
      '    COALESCE(SUM(Cantidad), 0) AS UnidadesVendidas,'
      '    COALESCE(SUM(Total), 0) AS ImporteTotal'
      'FROM VENTAS;')
    Left = 696
    Top = 584
  end
  object qryBuscarVentas: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT'
      '    v.Id AS IdVenta,'
      '    v.IdCliente,'
      '    v.Fecha,'
      '    v.CodigoProducto,'
      '    COALESCE(p.Nombre, '#39'(producto no disponible)'#39') AS Producto,'
      '    COALESCE(c.Nombre, '#39'(venta anónima)'#39') AS Cliente,'
      '    v.Cantidad,'
      '    v.PrecioUnitario,'
      '    v.Total'
      'FROM VENTAS v'
      'LEFT JOIN PRODUCTOS p'
      '    ON p.Codigo = v.CodigoProducto'
      'LEFT JOIN CLIENTES c'
      '    ON c.IdCliente = v.IdCliente'
      'WHERE v.CodigoProducto = :Codigo'
      '   OR p.Nombre LIKE :Nombre'
      'ORDER BY v.Id DESC;')
    Left = 520
    Top = 616
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

  object qryCrearTablaClientes: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS CLIENTES ('
      '  IdCliente INTEGER PRIMARY KEY AUTOINCREMENT,'
      '  Nombre TEXT NOT NULL,'
      '  Email TEXT,'
      '  Telefono TEXT'
      ');')
    Left = 72
    Top = 744
  end
  object qryInsertarCliente: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO CLIENTES'
      '  (Nombre, Email, Telefono)'
      'VALUES'
      '  (:Nombre, :Email, :Telefono);')
    Left = 240
    Top = 744
    ParamData = <
      item
        Name = 'NOMBRE'
        ParamType = ptInput
      end
      item
        Name = 'EMAIL'
        ParamType = ptInput
      end
      item
        Name = 'TELEFONO'
        ParamType = ptInput
      end>
  end
  object qryListarClientes: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT IdCliente, Nombre, Email, Telefono'
      'FROM CLIENTES'
      'ORDER BY Nombre, IdCliente;')
    Left = 408
    Top = 744
  end
  object qryActualizarCliente: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'UPDATE CLIENTES'
      'SET Nombre = :Nombre,'
      '    Email = :Email,'
      '    Telefono = :Telefono'
      'WHERE IdCliente = :IdCliente;')
    Left = 560
    Top = 744
    ParamData = <
      item
        Name = 'NOMBRE'
        ParamType = ptInput
      end
      item
        Name = 'EMAIL'
        ParamType = ptInput
      end
      item
        Name = 'TELEFONO'
        ParamType = ptInput
      end
      item
        Name = 'IDCLIENTE'
        ParamType = ptInput
      end>
  end
  object qryEliminarCliente: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'DELETE FROM CLIENTES'
      'WHERE IdCliente = :IdCliente;')
    Left = 736
    Top = 744
    ParamData = <
      item
        Name = 'IDCLIENTE'
        ParamType = ptInput
      end>
  end
  object qryBuscarClientes: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT IdCliente, Nombre, Email, Telefono'
      'FROM CLIENTES'
      'WHERE Nombre LIKE :Nombre'
      '   OR Email LIKE :Email'
      '   OR Telefono LIKE :Telefono'
      'ORDER BY Nombre, IdCliente;')
    Left = 888
    Top = 744
    ParamData = <
      item
        Name = 'NOMBRE'
        ParamType = ptInput
      end
      item
        Name = 'EMAIL'
        ParamType = ptInput
      end
      item
        Name = 'TELEFONO'
        ParamType = ptInput
      end>
  end
  object qryEstructuraVentas: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'PRAGMA table_info(VENTAS);')
    Left = 1056
    Top = 744
  end
  object qryAgregarIdClienteVentas: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'ALTER TABLE VENTAS ADD COLUMN IdCliente INTEGER;')
    Left = 1056
    Top = 816
  end
  object qryCrearTablaMovimientosStock: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS MOVIMIENTOS_STOCK ('
      '  IdMovimiento INTEGER PRIMARY KEY AUTOINCREMENT,'
      '  Fecha TEXT NOT NULL,'
      '  CodigoProducto TEXT NOT NULL,'
      '  Tipo TEXT NOT NULL,'
      '  Cantidad INTEGER NOT NULL,'
      '  Motivo TEXT NOT NULL,'
      '  IdVenta INTEGER,'
      '  CHECK (Tipo IN ('#39'ENTRADA'#39', '#39'SALIDA'#39', '#39'AJUSTE'#39')),'
      '  CHECK ('
      '    (Tipo = '#39'ENTRADA'#39' AND Cantidad > 0) OR'
      '    (Tipo = '#39'SALIDA'#39' AND Cantidad < 0) OR'
      '    (Tipo = '#39'AJUSTE'#39' AND Cantidad <> 0)'
      '  )'
      ');')
    Left = 968
    Top = 744
  end

  object qryInsertarMovimientoStock: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO MOVIMIENTOS_STOCK'
      '  (Fecha, CodigoProducto, Tipo, Cantidad, Motivo, IdVenta)'
      'VALUES'
      '  (:Fecha, :CodigoProducto, :Tipo, :Cantidad, :Motivo, :IdVenta);')
    Left = 856
    Top = 816
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
        Name = 'TIPO'
        ParamType = ptInput
      end
      item
        Name = 'CANTIDAD'
        ParamType = ptInput
      end
      item
        Name = 'MOTIVO'
        ParamType = ptInput
      end
      item
        Name = 'IDVENTA'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end

  object qryActualizarStockMovimiento: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'UPDATE PRODUCTOS'
      'SET Stock = Stock + :Cantidad'
      'WHERE Codigo = :CodigoProducto'
      '  AND Stock + :Cantidad >= 0;')
    Left = 744
    Top = 816
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

  object qryListarMovimientosStock: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT'
      '  IdMovimiento,'
      '  Fecha,'
      '  CodigoProducto,'
      '  Tipo,'
      '  Cantidad,'
      '  Motivo,'
      '  IdVenta'
      'FROM MOVIMIENTOS_STOCK'
      'ORDER BY IdMovimiento DESC;')
    Left = 632
    Top = 816
  end

  object qryEstructuraMovimientosStock: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'PRAGMA table_info(MOVIMIENTOS_STOCK);')
    Left = 472
    Top = 888
  end

  object qryAgregarIdVentaMovimientos: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'ALTER TABLE MOVIMIENTOS_STOCK ADD COLUMN IdVenta INTEGER;')
    Left = 680
    Top = 888
  end

  object qryUltimoIdVenta: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT last_insert_rowid() AS IdVenta;')
    Left = 888
    Top = 440
  end



  object qryAuditoriaTrazabilidadResumen: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT'
      '  (SELECT COUNT(*) FROM VENTAS) AS VentasRevisadas,'
      '  ('
      '    SELECT COUNT(*)'
      '    FROM VENTAS v'
      '    WHERE NOT EXISTS ('
      '      SELECT 1'
      '      FROM MOVIMIENTOS_STOCK m'
      '      WHERE m.IdVenta = v.Id'
      '        AND m.Tipo = ''SALIDA'''
      '        AND m.Motivo = ''Venta'''
      '    )'
      '  ) AS SinMovimiento,'
      '  ('
      '    SELECT COUNT(*)'
      '    FROM ('
      '      SELECT m.IdVenta'
      '      FROM MOVIMIENTOS_STOCK m'
      '      WHERE m.IdVenta IS NOT NULL'
      '        AND m.Tipo = ''SALIDA'''
      '        AND m.Motivo = ''Venta'''
      '      GROUP BY m.IdVenta'
      '      HAVING COUNT(*) > 1'
      '    ) duplicadas'
      '  ) AS Duplicados,'
      '  ('
      '    SELECT COUNT(*)'
      '    FROM MOVIMIENTOS_STOCK m'
      '    LEFT JOIN VENTAS v ON v.Id = m.IdVenta'
      '    WHERE m.IdVenta IS NOT NULL'
      '      AND v.Id IS NULL'
      '  ) AS Huerfanos,'
      '  ('
      '    SELECT COUNT(*)'
      '    FROM MOVIMIENTOS_STOCK m'
      '    INNER JOIN VENTAS v ON v.Id = m.IdVenta'
      '    WHERE m.Tipo = ''SALIDA'''
      '      AND m.Motivo = ''Venta'''
      '      AND m.Cantidad <> -v.Cantidad'
      '  ) AS CantidadesIncoherentes;')
    Left = 1048
    Top = 440
  end

  object qryAuditoriaTrazabilidadDetalle: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT 1 AS Orden,'
      '       ''SIN_MOVIMIENTO | Venta Id='' || v.Id ||'
      '       '' | Producto='' || v.CodigoProducto ||'
      '       '' | Cantidad='' || v.Cantidad AS Detalle'
      'FROM VENTAS v'
      'WHERE NOT EXISTS ('
      '  SELECT 1'
      '  FROM MOVIMIENTOS_STOCK m'
      '  WHERE m.IdVenta = v.Id'
      '    AND m.Tipo = ''SALIDA'''
      '    AND m.Motivo = ''Venta'''
      ')'
      ''
      'UNION ALL'
      ''
      'SELECT 2 AS Orden,'
      '       ''DUPLICADO | Venta Id='' || v.Id ||'
      '       '' | Movimientos automaticos='' || COUNT(m.IdMovimiento)'
      '       AS Detalle'
      'FROM VENTAS v'
      'INNER JOIN MOVIMIENTOS_STOCK m ON m.IdVenta = v.Id'
      'WHERE m.Tipo = ''SALIDA'''
      '  AND m.Motivo = ''Venta'''
      'GROUP BY v.Id'
      'HAVING COUNT(m.IdMovimiento) > 1'
      ''
      'UNION ALL'
      ''
      'SELECT 3 AS Orden,'
      '       ''HUERFANO | Movimiento Id='' || m.IdMovimiento ||'
      '       '' | IdVenta='' || m.IdVenta ||'
      '       '' | Producto='' || m.CodigoProducto AS Detalle'
      'FROM MOVIMIENTOS_STOCK m'
      'LEFT JOIN VENTAS v ON v.Id = m.IdVenta'
      'WHERE m.IdVenta IS NOT NULL'
      '  AND v.Id IS NULL'
      ''
      'UNION ALL'
      ''
      'SELECT 4 AS Orden,'
      '       ''CANTIDAD_INCOHERENTE | Venta Id='' || v.Id ||'
      '       '' | Cantidad venta='' || v.Cantidad ||'
      '       '' | Movimiento Id='' || m.IdMovimiento ||'
      '       '' | Cantidad movimiento='' || m.Cantidad AS Detalle'
      'FROM MOVIMIENTOS_STOCK m'
      'INNER JOIN VENTAS v ON v.Id = m.IdVenta'
      'WHERE m.Tipo = ''SALIDA'''
      '  AND m.Motivo = ''Venta'''
      '  AND m.Cantidad <> -v.Cantidad'
      ''
      'ORDER BY Orden, Detalle;')
    Left = 1048
    Top = 512
  end

end
