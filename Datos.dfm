object dmDatos: TdmDatos
  OnCreate = DataModuleCreate
  Height = 940
  Width = 1116
  PixelsPerInch = 120
  object FDConnection1: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'DriverID=SQLite')
    Connected = True
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
      
        '  (Fecha, IdCliente, CodigoProducto, Cantidad, PrecioUnitario, T' +
        'otal, Trazable)'
      'VALUES'
      
        '  (:Fecha, :IdCliente, :CodigoProducto, :Cantidad, :PrecioUnitar' +
        'io, :Total, :Trazable);')
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
      end
      item
        Name = 'TRAZABLE'
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
      '    COALESCE(c.Nombre, '#39'(venta an'#243'nima)'#39') AS Cliente,'
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
      '    COALESCE(c.Nombre, '#39'(venta an'#243'nima)'#39') AS Cliente,'
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
      
        '  (:Fecha, :CodigoProducto, :Tipo, :Cantidad, :Motivo, :IdVenta)' +
        ';')
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
      '  ('
      '    SELECT COUNT(*)'
      '    FROM VENTAS'
      '    WHERE Trazable = 1'
      '  ) AS VentasRevisadas,'
      ''
      '  ('
      '    SELECT COUNT(*)'
      '    FROM VENTAS v'
      '    WHERE v.Trazable = 1'
      '      AND NOT EXISTS ('
      '        SELECT 1'
      '        FROM MOVIMIENTOS_STOCK m'
      '        WHERE m.IdVenta = v.Id'
      '          AND m.Tipo = '#39'SALIDA'#39
      '          AND m.Motivo = '#39'Venta'#39
      '      )'
      '  ) AS SinMovimiento,'
      ''
      '  ('
      '    SELECT COUNT(*)'
      '    FROM ('
      '      SELECT m.IdVenta'
      '      FROM MOVIMIENTOS_STOCK m'
      '      INNER JOIN VENTAS v'
      '        ON v.Id = m.IdVenta'
      '      WHERE v.Trazable = 1'
      '        AND m.Tipo = '#39'SALIDA'#39
      '        AND m.Motivo = '#39'Venta'#39
      '      GROUP BY m.IdVenta'
      '      HAVING COUNT(*) > 1'
      '    ) duplicadas'
      '  ) AS Duplicados,'
      ''
      '  ('
      '    SELECT COUNT(*)'
      '    FROM MOVIMIENTOS_STOCK m'
      '    LEFT JOIN VENTAS v'
      '      ON v.Id = m.IdVenta'
      '    WHERE m.IdVenta IS NOT NULL'
      '      AND v.Id IS NULL'
      '  ) AS Huerfanos,'
      ''
      '  ('
      '    SELECT COUNT(*)'
      '    FROM MOVIMIENTOS_STOCK m'
      '    INNER JOIN VENTAS v'
      '      ON v.Id = m.IdVenta'
      '    WHERE v.Trazable = 1'
      '      AND m.Tipo = '#39'SALIDA'#39
      '      AND m.Motivo = '#39'Venta'#39
      '      AND m.Cantidad <> -v.Cantidad'
      '  ) AS CantidadesIncoherentes;')
    Left = 968
    Top = 392
  end
  object qryAuditoriaTrazabilidadDetalle: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT 1 AS Orden,'
      '       '#39'SIN_MOVIMIENTO | Venta Id='#39' || v.Id ||'
      '       '#39' | Producto='#39' || v.CodigoProducto ||'
      '       '#39' | Cantidad='#39' || v.Cantidad AS Detalle'
      'FROM VENTAS v'
      'WHERE v.Trazable = 1'
      '  AND NOT EXISTS ('
      '    SELECT 1'
      '    FROM MOVIMIENTOS_STOCK m'
      '    WHERE m.IdVenta = v.Id'
      '      AND m.Tipo = '#39'SALIDA'#39
      '      AND m.Motivo = '#39'Venta'#39
      '  )'
      ''
      'UNION ALL'
      ''
      'SELECT 2 AS Orden,'
      '       '#39'DUPLICADO | Venta Id='#39' || v.Id ||'
      '       '#39' | Movimientos automaticos='#39' || COUNT(m.IdMovimiento)'
      '       AS Detalle'
      'FROM VENTAS v'
      'INNER JOIN MOVIMIENTOS_STOCK m'
      '  ON m.IdVenta = v.Id'
      'WHERE v.Trazable = 1'
      '  AND m.Tipo = '#39'SALIDA'#39
      '  AND m.Motivo = '#39'Venta'#39
      'GROUP BY v.Id'
      'HAVING COUNT(m.IdMovimiento) > 1'
      ''
      'UNION ALL'
      ''
      'SELECT 3 AS Orden,'
      '       '#39'HUERFANO | Movimiento Id='#39' || m.IdMovimiento ||'
      '       '#39' | IdVenta='#39' || m.IdVenta ||'
      '       '#39' | Producto='#39' || m.CodigoProducto AS Detalle'
      'FROM MOVIMIENTOS_STOCK m'
      'LEFT JOIN VENTAS v'
      '  ON v.Id = m.IdVenta'
      'WHERE m.IdVenta IS NOT NULL'
      '  AND v.Id IS NULL'
      ''
      'UNION ALL'
      ''
      'SELECT 4 AS Orden,'
      '       '#39'CANTIDAD_INCOHERENTE | Venta Id='#39' || v.Id ||'
      '       '#39' | Cantidad venta='#39' || v.Cantidad ||'
      '       '#39' | Movimiento Id='#39' || m.IdMovimiento ||'
      '       '#39' | Cantidad movimiento='#39' || m.Cantidad AS Detalle'
      'FROM MOVIMIENTOS_STOCK m'
      'INNER JOIN VENTAS v'
      '  ON v.Id = m.IdVenta'
      'WHERE v.Trazable = 1'
      '  AND m.Tipo = '#39'SALIDA'#39
      '  AND m.Motivo = '#39'Venta'#39
      '  AND m.Cantidad <> -v.Cantidad'
      ''
      'ORDER BY Orden, Detalle;')
    Left = 912
    Top = 512
  end
  object qryAgregarTrazableVentas: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'ALTER TABLE VENTAS'
      'ADD COLUMN Trazable INTEGER NOT NULL DEFAULT 0;')
    Left = 784
    Top = 96
  end
  object qryCrearIndiceUnicoMovimientoVenta: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        '         CREATE UNIQUE INDEX IF NOT EXISTS UX_MOVIMIENTOS_STOCK_' +
        'IdVenta'
      'ON MOVIMIENTOS_STOCK(IdVenta)'
      'WHERE IdVenta IS NOT NULL;')
    Left = 736
    Top = 232
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 120
    Top = 440
  end
  object FDSQLiteBackup1: TFDSQLiteBackup
    DriverLink = FDPhysSQLiteDriverLink1
    Catalog = 'MAIN'
    DestCatalog = 'MAIN'
    Left = 616
    Top = 56
  end
  object FDSQLiteValidate1: TFDSQLiteValidate
    DriverLink = FDPhysSQLiteDriverLink1
    OnProgress = FDSQLiteValidate1Progress
    Left = 248
    Top = 600
  end
  object qryCrearTablaLineasVenta: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS LINEAS_VENTA ('
      '    IdLinea INTEGER PRIMARY KEY AUTOINCREMENT,'
      '    IdVenta INTEGER NOT NULL,'
      '    CodigoProducto TEXT NOT NULL,'
      '    Cantidad INTEGER NOT NULL CHECK (Cantidad > 0),'
      '    PrecioUnitario REAL NOT NULL CHECK (PrecioUnitario >= 0),'
      '    TotalLinea REAL NOT NULL CHECK (TotalLinea >= 0),'
      '    FOREIGN KEY (IdVenta) REFERENCES VENTAS(Id)'
      ');')
    Left = 912
    Top = 56
  end
  object qryMigrarLineasVenta: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO LINEAS_VENTA'
      '  (IdVenta, CodigoProducto, Cantidad, PrecioUnitario, TotalLinea)'
      'SELECT'
      '  v.Id, v.CodigoProducto, v.Cantidad, v.PrecioUnitario, v.Total'
      'FROM VENTAS v'
      'WHERE NOT EXISTS ('
      '  SELECT 1 FROM LINEAS_VENTA lv WHERE lv.IdVenta = v.Id'
      ');')
    Left = 1040
    Top = 56
  end
  object qryInsertarLineaVenta: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO LINEAS_VENTA'
      '  (IdVenta, CodigoProducto, Cantidad, PrecioUnitario, TotalLinea)'
      'VALUES'
      '  (:IdVenta, :CodigoProducto, :Cantidad, :PrecioUnitario, :TotalLinea);')
    Left = 1168
    Top = 56
    ParamData = <
      item
        Name = 'IDVENTA'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'CODIGOPRODUCTO'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'CANTIDAD'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'PRECIOUNITARIO'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'TOTALLINEA'
        DataType = ftFloat
        ParamType = ptInput
      end>
  end
end
