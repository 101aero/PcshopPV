unit Datos;

interface

uses
  Winapi.Windows,System.Diagnostics,System.IOUtils,Vcl.Dialogs,uProducto, System.Generics.Collections,
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Phys.PGDef, FireDAC.Phys.PG, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, uVenta, uCliente;

type
  TdmDatos = class(TDataModule)
    FDConnection1: TFDConnection;
    qryProductos: TFDQuery;
    qryInsertarProducto: TFDQuery;
    qryListarProductos: TFDQuery;
    qryActualizarProducto: TFDQuery;
    qryEliminarProducto: TFDQuery;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    qryBuscarProductos: TFDQuery;
    qryContarProductos: TFDQuery;
    qryExisteCodigo: TFDQuery;
    qryStockBajo: TFDQuery;
    qryValorInventario: TFDQuery;
    qryOrdenarProductos: TFDQuery;
    qryCrearTablaVentas: TFDQuery;
    qryInsertarVenta: TFDQuery;
    qryDescontarStock: TFDQuery;
    qryListarVentas: TFDQuery;
    qryResumenVentas: TFDQuery;
    qryBuscarVentas: TFDQuery;
    qryCrearTablaClientes: TFDQuery;
    qryInsertarCliente: TFDQuery;
    qryListarClientes: TFDQuery;
    qryActualizarCliente: TFDQuery;
    qryEliminarCliente: TFDQuery;
    qryBuscarClientes: TFDQuery;
    qryEstructuraVentas: TFDQuery;
    qryAgregarIdClienteVentas: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  FUltimoError: string;

  // Comprueba la estructura real de VENTAS y aplica únicamente
  // la evolución necesaria para conservar los datos existentes.
  procedure MigrarEsquemaVentas;

  procedure RegistrarError(
  const AOperacion: string;
  const AMensaje: string
                          );
      function CrearProductoDesdeQuery(
  AQuery: TFDQuery
): TProducto;

  // Convierte una fila devuelta por FireDAC en el modelo TCliente.
  // Se reutiliza tanto en la carga completa como en las búsquedas.
  function CrearClienteDesdeQuery(
    AQuery: TFDQuery
  ): TCliente;


public

// CLIENTES ---------------------------------------------------------------
// El formulario trabaja con TCliente y delega todo el SQL en el Data Module.
function InsertarCliente(const ACliente: TCliente): Boolean;
function ActualizarCliente(const ACliente: TCliente): Boolean;
function EliminarCliente(AIdCliente: Integer): Boolean;

procedure CargarClientes(
  ALista: TObjectList<TCliente>
);

procedure BuscarClientes(
  ALista: TObjectList<TCliente>;
  const ABusqueda: string
);


procedure BuscarVentas(
  ALista: TObjectList<TVenta>;
  const ABusqueda: string
);



procedure ObtenerResumenVentas(
  out ATotalVentas: Integer;
  out AUnidadesVendidas: Integer;
  out AImporteTotal: Double
);



procedure CargarVentas(
  ALista: TObjectList<TVenta>
);

function ObtenerUltimaVentaResumen: string;

function RegistrarVenta(
  const AProducto: TProducto;
  ACantidad: Integer;
  AIdCliente: Integer = 0
): Boolean;


procedure OrdenarProductosPorNombre(Alista: TObjectList<Tproducto>; AAscendente: Boolean);

function ObtenerValorInventario: Double;


procedure FiltrarProductosStockBajo(
  ALista: TObjectList<TProducto>;
  AStockMaximo: Integer
);

function ExisteCodigoProducto(const ACodigo: string): Boolean;

procedure RegistrarDiagnostico(
  const AOperacion: string;
  const AMensaje: string
);

property UltimoError: string read FUltimoError;
function ObtenerTotalProductos: Integer;

procedure BuscarProductos(
  ALista: TObjectList<TProducto>;
  const ABusqueda: string
);

// Elimina de SQLite el producto identificado por su código.
// Devuelve True si realmente se ha eliminado una fila.
function EliminarProducto(const ACodigo: string): Boolean;

// Actualiza en SQLite los datos de un producto existente.
function ActualizarProducto(const AProducto: TProducto): Boolean;
  // Lee los productos almacenados en SQLite y
  // los convierte nuevamente en objetos TProducto.
  //
  // ALista es la colección proporcionada por el formulario.
  procedure CargarProductos(ALista: TObjectList<TProducto>);
  // Guarda un producto en SQLite utilizando una consulta parametrizada.
  function InsertarProducto(const AProducto: TProducto): Boolean;
  end;

var
  dmDatos: TdmDatos;

// IMPL //
// **********************************************



implementation




{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
procedure TdmDatos.DataModuleCreate(Sender: TObject);
var
  RutaBD: string;
begin
  // El ejecutable se genera normalmente en Win32\Debug
  // o Win32\Release. Subimos dos niveles hasta la carpeta
  // del proyecto, donde se encuentra pcshop.db.
  RutaBD := ExpandFileName(
    ExtractFilePath(ParamStr(0)) + '..\..\pcshop.db'
  );

  // La ruta se establece antes de abrir la conexión.
  // Así evitamos depender de una ruta absoluta de un PC concreto.
  FDConnection1.Params.Values['Database'] := RutaBD;

  if not FDConnection1.Connected then
    FDConnection1.Connected := True;

  qryProductos.ExecSQL;
  qryCrearTablaVentas.ExecSQL;

  // CREATE TABLE IF NOT EXISTS no modifica una tabla ya creada.
  // Por eso comprobamos y migramos el esquema de VENTAS aparte.
  MigrarEsquemaVentas;

  // CLIENTES se crea automáticamente si todavía no existe.
  // IdCliente será la clave estable para futuras relaciones con VENTAS.
  qryCrearTablaClientes.ExecSQL;
end;
// END-CREATE //








// ========================================================================
// MIGRACIÓN DE ESQUEMA: VENTAS
// ========================================================================

procedure TdmDatos.MigrarEsquemaVentas;
var
  TieneIdCliente: Boolean;
begin
  TieneIdCliente := False;

  // PRAGMA table_info devuelve la estructura real de la tabla existente.
  // Esto permite distinguir una base antigua de una ya migrada.
  qryEstructuraVentas.Close;
  qryEstructuraVentas.Open;

  try
    while not qryEstructuraVentas.Eof do
    begin
      if SameText(
        qryEstructuraVentas.FieldByName('name').AsString,
        'IdCliente'
      ) then
      begin
        TieneIdCliente := True;
        Break;
      end;

      qryEstructuraVentas.Next;
    end;
  finally
    qryEstructuraVentas.Close;
  end;

  if not TieneIdCliente then
  begin
    // En SQLite una columna sin NOT NULL admite NULL por defecto.
    // Las ventas anteriores conservarán todos sus datos y recibirán
    // NULL en IdCliente automáticamente.
    qryAgregarIdClienteVentas.ExecSQL;
  end;
end;


// ========================================================================
// CLIENTES
// ========================================================================

function TdmDatos.CrearClienteDesdeQuery(
  AQuery: TFDQuery
): TCliente;
begin
  Result := TCliente.Create;
  try
    // Un único punto conoce cómo se transforma una fila SQL en TCliente.
    Result.IdCliente :=
      AQuery.FieldByName('IdCliente').AsInteger;

    Result.Nombre :=
      AQuery.FieldByName('Nombre').AsString;

    Result.Email :=
      AQuery.FieldByName('Email').AsString;

    Result.Telefono :=
      AQuery.FieldByName('Telefono').AsString;
  except
    Result.Free;
    raise;
  end;
end;


function TdmDatos.InsertarCliente(
  const ACliente: TCliente
): Boolean;
begin
  FUltimoError := '';
  Result := False;

  try
    qryInsertarCliente.ParamByName('Nombre').AsString :=
      ACliente.Nombre;

    qryInsertarCliente.ParamByName('Email').AsString :=
      ACliente.Email;

    qryInsertarCliente.ParamByName('Telefono').AsString :=
      ACliente.Telefono;

    qryInsertarCliente.ExecSQL;

    // No consideramos éxito solo porque ExecSQL no lance excepción.
    Result := qryInsertarCliente.RowsAffected > 0;

    if not Result then
      FUltimoError := 'No se ha podido registrar el cliente.';

  except
    on E: Exception do
    begin
      RegistrarError(
        'INSERT CLIENTE',
        'Nombre=' + ACliente.Nombre + ' | ' + E.Message
      );

      FUltimoError := 'No se ha podido registrar el cliente.';
      Result := False;
    end;
  end;
end;


function TdmDatos.ActualizarCliente(
  const ACliente: TCliente
): Boolean;
begin
  FUltimoError := '';
  Result := False;

  try
    qryActualizarCliente.ParamByName('Nombre').AsString :=
      ACliente.Nombre;

    qryActualizarCliente.ParamByName('Email').AsString :=
      ACliente.Email;

    qryActualizarCliente.ParamByName('Telefono').AsString :=
      ACliente.Telefono;

    qryActualizarCliente.ParamByName('IdCliente').AsInteger :=
      ACliente.IdCliente;

    qryActualizarCliente.ExecSQL;

    Result := qryActualizarCliente.RowsAffected > 0;

    if not Result then
      FUltimoError :=
        'No se ha encontrado el cliente que se quería actualizar.';

  except
    on E: Exception do
    begin
      RegistrarError(
        'UPDATE CLIENTE',
        'IdCliente=' + IntToStr(ACliente.IdCliente) +
        ' | ' + E.Message
      );

      FUltimoError := 'No se ha podido actualizar el cliente.';
      Result := False;
    end;
  end;
end;


function TdmDatos.EliminarCliente(
  AIdCliente: Integer
): Boolean;
begin
  FUltimoError := '';
  Result := False;

  try
    qryEliminarCliente.ParamByName('IdCliente').AsInteger :=
      AIdCliente;

    qryEliminarCliente.ExecSQL;

    Result := qryEliminarCliente.RowsAffected > 0;

    if not Result then
      FUltimoError :=
        'No se ha encontrado el cliente que se quería eliminar.';

  except
    on E: Exception do
    begin
      RegistrarError(
        'DELETE CLIENTE',
        'IdCliente=' + IntToStr(AIdCliente) +
        ' | ' + E.Message
      );

      FUltimoError := 'No se ha podido eliminar el cliente.';
      Result := False;
    end;
  end;
end;


procedure TdmDatos.CargarClientes(
  ALista: TObjectList<TCliente>
);
var
  Cliente: TCliente;
begin
  ALista.Clear;

  qryListarClientes.Close;
  qryListarClientes.Open;

  try
    while not qryListarClientes.Eof do
    begin
      Cliente := CrearClienteDesdeQuery(qryListarClientes);

      try
        ALista.Add(Cliente);
        Cliente := nil;
      finally
        Cliente.Free;
      end;

      qryListarClientes.Next;
    end;
  finally
    qryListarClientes.Close;
  end;
end;


procedure TdmDatos.BuscarClientes(
  ALista: TObjectList<TCliente>;
  const ABusqueda: string
);
var
  Cliente: TCliente;
  Patron: string;
begin
  ALista.Clear;

  qryBuscarClientes.Close;

  // La misma entrada se aplica a Nombre, Email y Teléfono
  // mediante parámetros FireDAC; el formulario no contiene SQL.
  Patron := '%' + Trim(ABusqueda) + '%';

  qryBuscarClientes.ParamByName('Nombre').AsString := Patron;
  qryBuscarClientes.ParamByName('Email').AsString := Patron;
  qryBuscarClientes.ParamByName('Telefono').AsString := Patron;

  qryBuscarClientes.Open;

  try
    while not qryBuscarClientes.Eof do
    begin
      Cliente := CrearClienteDesdeQuery(qryBuscarClientes);

      try
        ALista.Add(Cliente);
        Cliente := nil;
      finally
        Cliente.Free;
      end;

      qryBuscarClientes.Next;
    end;
  finally
    qryBuscarClientes.Close;
  end;
end;


procedure TdmDatos.BuscarVentas(
  ALista: TObjectList<TVenta>;
  const ABusqueda: string
);
var
  Venta: TVenta;
begin
  // La colección mostrará únicamente las ventas
  // devueltas por esta búsqueda.
  ALista.Clear;

  qryBuscarVentas.Close;

  // Código exacto.
  qryBuscarVentas.ParamByName('Codigo').AsString :=
    Trim(ABusqueda);

  // Nombre parcial.
  qryBuscarVentas.ParamByName('Nombre').AsString :=
    '%' + Trim(ABusqueda) + '%';

  qryBuscarVentas.Open;

  try
    while not qryBuscarVentas.Eof do
    begin
      Venta := TVenta.Create;

      try
        Venta.IdVenta :=
          qryBuscarVentas.FieldByName('IdVenta').AsInteger;

        // En SQLite una venta antigua o anónima guarda NULL.
        // En el modelo Delphi representamos ese caso con IdCliente = 0.
        if qryBuscarVentas.FieldByName('IdCliente').IsNull then
          Venta.IdCliente := 0
        else
          Venta.IdCliente :=
            qryBuscarVentas.FieldByName('IdCliente').AsInteger;

        Venta.Fecha :=
          qryBuscarVentas.FieldByName('Fecha').AsString;

        Venta.CodigoProducto :=
          qryBuscarVentas.FieldByName('CodigoProducto').AsString;

        Venta.Producto :=
          qryBuscarVentas.FieldByName('Producto').AsString;

        // Cliente es un dato descriptivo obtenido mediante LEFT JOIN.
        // Si IdCliente es NULL, SQL devuelve '(venta anónima)'.
        Venta.Cliente :=
          qryBuscarVentas.FieldByName('Cliente').AsString;

        Venta.Cantidad :=
          qryBuscarVentas.FieldByName('Cantidad').AsInteger;

        Venta.PrecioUnitario :=
          qryBuscarVentas.FieldByName('PrecioUnitario').AsFloat;

        Venta.Total :=
          qryBuscarVentas.FieldByName('Total').AsFloat;

        ALista.Add(Venta);
        Venta := nil;

      finally
        Venta.Free;
      end;

      qryBuscarVentas.Next;
    end;

  finally
    qryBuscarVentas.Close;
  end;
end;





procedure TdmDatos.ObtenerResumenVentas(
  out ATotalVentas: Integer;
  out AUnidadesVendidas: Integer;
  out AImporteTotal: Double
);
begin
  qryResumenVentas.Close;
  qryResumenVentas.Open;

  try
    // Recuperamos en una sola consulta SQL
    // las tres métricas principales del historial.
    ATotalVentas :=
      qryResumenVentas.FieldByName('TotalVentas').AsInteger;

    AUnidadesVendidas :=
      qryResumenVentas.FieldByName('UnidadesVendidas').AsInteger;

    AImporteTotal :=
      qryResumenVentas.FieldByName('ImporteTotal').AsFloat;

  finally
    // La consulta queda siempre cerrada,
    // incluso si ocurre un error durante la lectura.
    qryResumenVentas.Close;
  end;
end;





procedure TdmDatos.CargarVentas(
  ALista: TObjectList<TVenta>
);
var
  Venta: TVenta;
begin
  // La colección representará exactamente
  // el historial devuelto actualmente por SQLite.
  ALista.Clear;

  qryListarVentas.Close;
  qryListarVentas.Open;

  try
    while not qryListarVentas.Eof do
    begin
      Venta := TVenta.Create;

      try
        // Convertimos cada fila SQL en un objeto TVenta.
        Venta.IdVenta :=
          qryListarVentas.FieldByName('IdVenta').AsInteger;

        // NULL conserva la compatibilidad con ventas antiguas
        // y con ventas realizadas sin cliente asociado.
        if qryListarVentas.FieldByName('IdCliente').IsNull then
          Venta.IdCliente := 0
        else
          Venta.IdCliente :=
            qryListarVentas.FieldByName('IdCliente').AsInteger;

        Venta.Fecha :=
          qryListarVentas.FieldByName('Fecha').AsString;

        Venta.CodigoProducto :=
          qryListarVentas.FieldByName('CodigoProducto').AsString;

        Venta.Producto :=
          qryListarVentas.FieldByName('Producto').AsString;

        // Cliente es un dato descriptivo obtenido mediante LEFT JOIN.
        // Las ventas antiguas o anónimas reciben el texto de SQL.
        Venta.Cliente :=
          qryListarVentas.FieldByName('Cliente').AsString;

        Venta.Cantidad :=
          qryListarVentas.FieldByName('Cantidad').AsInteger;

        Venta.PrecioUnitario :=
          qryListarVentas.FieldByName('PrecioUnitario').AsFloat;

        Venta.Total :=
          qryListarVentas.FieldByName('Total').AsFloat;

        // La colección pasa a ser propietaria del objeto.
        ALista.Add(Venta);
        Venta := nil;

      finally
        Venta.Free;
      end;

      qryListarVentas.Next;
    end;

  finally
    // La consulta siempre queda cerrada,
    // incluso si ocurre algún error durante la carga.
    qryListarVentas.Close;
  end;
end;










function TdmDatos.ObtenerUltimaVentaResumen: string;
begin
  qryListarVentas.Close;
  qryListarVentas.Open;

  try
    if qryListarVentas.Eof then
    begin
      Result := 'No hay ventas registradas.';
      Exit;
    end;

    // qryListarVentas está ordenada por Id DESC,
    // por lo que la primera fila corresponde
    // a la venta más reciente.
    Result :=
      'Id: ' +
      qryListarVentas.FieldByName('IdVenta').AsString +
      ' | Producto: ' +
      qryListarVentas.FieldByName('CodigoProducto').AsString +
      ' | Cantidad: ' +
      qryListarVentas.FieldByName('Cantidad').AsString +
      ' | Total: ' +
      FormatFloat(
        '0.00',
        qryListarVentas.FieldByName('Total').AsFloat
      ) +
      ' €';

  finally
    qryListarVentas.Close;
  end;
end;









function TdmDatos.RegistrarVenta(
  const AProducto: TProducto;
  ACantidad: Integer;
  AIdCliente: Integer
): Boolean;
var
  Total: Double;
begin
  FUltimoError := '';
  Result := False;

  Total := AProducto.Precio * ACantidad;

  try
    // La venta y la reducción de stock forman
    // una única operación lógica.
    FDConnection1.StartTransaction;

    // --------------------------------------------------
    // 1. Registramos la venta.
    // --------------------------------------------------
    qryInsertarVenta.ParamByName('Fecha').AsString :=
      FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);

    // En Delphi usamos 0 para representar "sin cliente",
    // pero en SQLite guardamos un NULL real. De este modo
    // las ventas anónimas y las ventas antiguas siguen siendo válidas.
    qryInsertarVenta.ParamByName('IdCliente').DataType := ftInteger;

    if AIdCliente > 0 then
      qryInsertarVenta.ParamByName('IdCliente').AsInteger :=
        AIdCliente
    else
      qryInsertarVenta.ParamByName('IdCliente').Clear;

    qryInsertarVenta.ParamByName('CodigoProducto').AsString :=
      AProducto.Codigo;

    qryInsertarVenta.ParamByName('Cantidad').AsInteger :=
      ACantidad;

    qryInsertarVenta.ParamByName('PrecioUnitario').AsFloat :=
      AProducto.Precio;

    qryInsertarVenta.ParamByName('Total').AsFloat :=
      Total;

    qryInsertarVenta.ExecSQL;

    if qryInsertarVenta.RowsAffected <= 0 then
    begin
      FDConnection1.Rollback;

      FUltimoError :=
        'No se ha podido registrar la venta.';

      Exit;
    end;

    // --------------------------------------------------
    // 2. Descontamos el stock.
    //
    // SQLite vuelve a comprobar que exista suficiente
    // stock en el momento exacto de realizar la operación.
    // --------------------------------------------------
    qryDescontarStock.ParamByName('Cantidad').AsInteger :=
      ACantidad;

    qryDescontarStock.ParamByName('CodigoProducto').AsString :=
      AProducto.Codigo;

    qryDescontarStock.ExecSQL;

    if qryDescontarStock.RowsAffected <= 0 then
    begin
      // La venta ya se había insertado, pero al formar
      // parte de la misma transacción también se deshace.
      FDConnection1.Rollback;

      FUltimoError :=
        'No hay stock suficiente para realizar la venta.';

      Exit;
    end;

    // Ambas operaciones han terminado correctamente.
    FDConnection1.Commit;
    Result := True;

  except
    on E: Exception do
    begin
      if FDConnection1.InTransaction then
        FDConnection1.Rollback;

      RegistrarError(
        'REGISTRAR VENTA',
        'Codigo=' + AProducto.Codigo +
        ' | Cantidad=' + IntToStr(ACantidad) +
        ' | ' + E.Message
      );

      FUltimoError :=
        'No se ha podido completar la venta.';

      Result := False;
    end;
  end;
end;






procedure TdmDatos.OrdenarProductosPorNombre(
  ALista: TObjectList<TProducto>;
  AAscendente: Boolean
);
var
  Producto: TProducto;
begin
  ALista.Clear;
  qryOrdenarProductos.Close;

  // No concatenamos texto introducido por el usuario.
  // Elegimos entre dos sentencias SQL fijas y conocidas.
  if AAscendente then
    qryOrdenarProductos.SQL.Text :=
      'SELECT Codigo, Nombre, Precio, Stock ' +
      'FROM PRODUCTOS ' +
      'ORDER BY Nombre ASC'
  else
    qryOrdenarProductos.SQL.Text :=
      'SELECT Codigo, Nombre, Precio, Stock ' +
      'FROM PRODUCTOS ' +
      'ORDER BY Nombre DESC';

  qryOrdenarProductos.Open;

  try
    while not qryOrdenarProductos.Eof do
    begin
      // Reutilizamos el mapeo común SQL -> TProducto.
      Producto := CrearProductoDesdeQuery(qryOrdenarProductos);

      try
        ALista.Add(Producto);
        Producto := nil;
      finally
        Producto.Free;
      end;

      qryOrdenarProductos.Next;
    end;
  finally
    qryOrdenarProductos.Close;
  end;
end;



function TdmDatos.ObtenerValorInventario: Double;
begin
  qryValorInventario.Close;
  qryValorInventario.Open;

  try
    Result :=
      qryValorInventario.FieldByName('ValorTotal').AsFloat;
  finally
    qryValorInventario.Close;
  end;
end;




procedure TdmDatos.FiltrarProductosStockBajo(
  ALista: TObjectList<TProducto>;
  AStockMaximo: Integer
);
var
  Producto: TProducto;
begin
  // La lista va a representar únicamente
  // los productos devueltos por este filtro.
  ALista.Clear;

  qryStockBajo.Close;

  // El valor llega a SQLite mediante un parámetro FireDAC.
  // No concatenamos el contenido introducido por el usuario.
  qryStockBajo.ParamByName('StockMaximo').AsInteger :=
    AStockMaximo;

  qryStockBajo.Open;

  try
    while not qryStockBajo.Eof do
    begin
      // Reutilizamos el mapeo común SQL -> TProducto.
      Producto := CrearProductoDesdeQuery(qryStockBajo);

      try
        ALista.Add(Producto);

        // La colección pasa a ser propietaria del objeto.
        Producto := nil;
      finally
        Producto.Free;
      end;

      qryStockBajo.Next;
    end;

  finally
    // La consulta siempre queda cerrada,
    // incluso si ocurre una excepción.
    qryStockBajo.Close;
  end;
end;



function TdmDatos.ExisteCodigoProducto(
  const ACodigo: string
): Boolean;
begin
  // Nos aseguramos de que la consulta no quede abierta
  // de una ejecución anterior.
  qryExisteCodigo.Close;

  // Enviamos el código como parámetro FireDAC.
  // Así evitamos concatenar directamente el texto del usuario
  // dentro de la sentencia SQL.
  qryExisteCodigo.ParamByName('Codigo').AsString :=
    Trim(ACodigo);

  // Ejecutamos la consulta:
  //
  // SELECT COUNT(*) AS Total
  // FROM PRODUCTOS
  // WHERE Codigo = :Codigo;
  //
  // SQLite devolverá cuántos productos existen
  // con ese código.
  qryExisteCodigo.Open;

  try
    // Si el contador es mayor que 0,
    // significa que ya existe al menos un producto
    // con ese código en la base de datos.
    Result :=
      qryExisteCodigo.FieldByName('Total').AsInteger > 0;

  finally
    // Cerramos siempre la consulta,
    // incluso si ocurre algún error durante la lectura.
    qryExisteCodigo.Close;
  end;
end;







function TdmDatos.CrearProductoDesdeQuery(
  AQuery: TFDQuery
): TProducto;
begin
  Result := TProducto.Create;

  try
    // Centralizamos aquí la conversión de una fila SQL
    // al modelo utilizado por la aplicación.
    Result.Codigo :=
      AQuery.FieldByName('Codigo').AsString;

    Result.Nombre :=
      AQuery.FieldByName('Nombre').AsString;

    Result.Precio :=
      AQuery.FieldByName('Precio').AsFloat;

    Result.Stock :=
      AQuery.FieldByName('Stock').AsInteger;

  except
    // Si falla la lectura de algún campo,
    // evitamos dejar un objeto creado sin liberar.
    Result.Free;
    raise;
  end;
end;





// LOGERROR
procedure TdmDatos.RegistrarError(
  const AOperacion: string;
  const AMensaje: string
);
var
  CarpetaLog: string;
  ArchivoLog: string;
  Linea: string;
begin
  try
    CarpetaLog :=
      TPath.Combine(
        ExtractFilePath(ParamStr(0)),
        'logs'
      );

    ForceDirectories(CarpetaLog);

    ArchivoLog :=
      TPath.Combine(
        CarpetaLog,
        'pcshop.log'
      );

    Linea :=
      FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) +
      ' | ' +
      AOperacion +
      ' | ' +
      AMensaje;

    TFile.AppendAllText(
      ArchivoLog,
      Linea + sLineBreak,
      TEncoding.UTF8
    );

  except
    // El registro de diagnóstico nunca debe impedir
    // que la aplicación continúe gestionando el error original.
  end;
end;




procedure TdmDatos.RegistrarDiagnostico(
  const AOperacion: string;
  const AMensaje: string
);
begin
  RegistrarError(AOperacion, AMensaje);
end;



procedure TdmDatos.BuscarProductos(
  ALista: TObjectList<TProducto>;
  const ABusqueda: string
);
var
  Producto: TProducto;
begin
  // Eliminamos los resultados anteriores de la colección.
  // TObjectList es propietaria de sus TProducto.
  ALista.Clear;

  qryBuscarProductos.Close;

// Para el código buscamos coincidencia exacta.
qryBuscarProductos.ParamByName('Codigo').AsString :=
  Trim(ABusqueda);

// Para el nombre permitimos coincidencias parciales.
// Los símbolos % significan "cualquier texto antes o después".
qryBuscarProductos.ParamByName('Nombre').AsString :=
  '%' + Trim(ABusqueda) + '%';

  qryBuscarProductos.Open;

  try
 while not qryBuscarProductos.Eof do
begin
  // Reutilizamos el mismo mapeo SQL ? TProducto
  // que utiliza la carga completa de productos.
  Producto := CrearProductoDesdeQuery(qryBuscarProductos);

  try
    ALista.Add(Producto);

    // A partir de aquí la colección es propietaria
    // del objeto y será responsable de liberarlo.
    Producto := nil;
  finally
    Producto.Free;
  end;

  qryBuscarProductos.Next;
end;

  finally
    // La consulta se cierra incluso si ocurre algún error.
    qryBuscarProductos.Close;
  end;
end;



function TdmDatos.EliminarProducto(const ACodigo: string): Boolean;
begin
  // Asignamos el código al parámetro :Codigo del DELETE.
  // No concatenamos el valor dentro del SQL.
  qryEliminarProducto.ParamByName('Codigo').AsString := ACodigo;

  // ExecSQL ejecuta el DELETE.
  qryEliminarProducto.ExecSQL;

  // RowsAffected indica cuántas filas ha modificado
  // la última operación SQL.
  Result := qryEliminarProducto.RowsAffected > 0;
end;



function TdmDatos.ActualizarProducto(const AProducto: TProducto): Boolean;
begin
  // Asignamos los nuevos valores a los parámetros SQL.
  qryActualizarProducto.ParamByName('Nombre').AsString :=
    AProducto.Nombre;

  qryActualizarProducto.ParamByName('Precio').AsFloat :=
    AProducto.Precio;

  qryActualizarProducto.ParamByName('Stock').AsInteger :=
    AProducto.Stock;

  // Codigo identifica qué registro concreto se actualiza.
  qryActualizarProducto.ParamByName('Codigo').AsString :=
    AProducto.Codigo;

  // UPDATE modifica datos y no devuelve filas.
  qryActualizarProducto.ExecSQL;
// indica cuantas filas ha afectado
  Result:= qryActualizarProducto.RowsAffected>0;

end;

function TdmDatos.ObtenerTotalProductos: Integer;
begin
  qryContarProductos.Close;
  qryContarProductos.Open;

  try
    Result :=
      qryContarProductos.FieldByName('Total').AsInteger;
  finally
    qryContarProductos.Close;
  end;
end;





// CARGAR-PRODUCTOS
// *
procedure TdmDatos.CargarProductos(ALista: TObjectList<TProducto>);
var
  Producto: TProducto;
begin
  // Eliminamos el contenido anterior para evitar
  // duplicar los productos cargados en memoria.
  ALista.Clear;

  qryListarProductos.Close;
  qryListarProductos.Open;

  try
while not qryListarProductos.Eof do
begin
  Producto := CrearProductoDesdeQuery(qryListarProductos);

  try
    ALista.Add(Producto);
    Producto := nil;
  finally
    Producto.Free;
  end;

  qryListarProductos.Next;
end;

  finally
    // La consulta siempre queda cerrada,
    // incluso si ocurre una excepción durante la carga.
    qryListarProductos.Close;
  end;
end;


//** INSERTAR
// --

function TdmDatos.InsertarProducto(
  const AProducto: TProducto
): Boolean;
var
  Cronometro: TStopwatch;
begin
  FUltimoError := '';
  Result := False;

  try
  // Medimos la operación real de persistencia.
Cronometro := TStopwatch.StartNew;
    // La operación se confirma únicamente si SQLite
    // completa correctamente el INSERT.
    FDConnection1.StartTransaction;

    qryInsertarProducto.ParamByName('Codigo').AsString :=
      AProducto.Codigo;

    qryInsertarProducto.ParamByName('Nombre').AsString :=
      AProducto.Nombre;

    qryInsertarProducto.ParamByName('Precio').AsFloat :=
      AProducto.Precio;

    qryInsertarProducto.ParamByName('Stock').AsInteger :=
      AProducto.Stock;

    qryInsertarProducto.ExecSQL;

    if qryInsertarProducto.RowsAffected > 0 then
    begin
      FDConnection1.Commit;
      Result := True;
      // COMMIT CORRECTO
      Cronometro.Stop;

// >>MEDIMOS Durante el desarrollo podemos consultar este tiempo
// en la salida de depuración de Delphi.
OutputDebugString(
  PChar(
    Format(
      'INSERT PRODUCTO: %d ms',
      [Cronometro.ElapsedMilliseconds]
    )
  )
);  // <<FIN MEDIR


    end
    else
begin
  FDConnection1.Rollback;

  Cronometro.Stop;

  OutputDebugString(
    PChar(
      Format(
        'INSERT PRODUCTO FALLIDO: %d ms',
        [Cronometro.ElapsedMilliseconds]
      )
    )
  );

  FUltimoError :=
    'No se ha podido insertar el producto.';
end;

except
  on E: Exception do //FALLO
  begin
    // Si la operación FALLA con una transacción abierta,
    // deshacemos cualquier cambio pendiente.
    if FDConnection1.InTransaction then
      FDConnection1.Rollback;

      Cronometro.Stop;

OutputDebugString(
  PChar(
    Format(
      'INSERT PRODUCTO ERROR: %d ms',
      [Cronometro.ElapsedMilliseconds]
    )
  )
);


      //***

    // El log conserva el detalle técnico necesario
    // para poder investigar posteriormente el problema.
    RegistrarError(
      'INSERT PRODUCTO',
      'Codigo=' + AProducto.Codigo + ' | ' + E.Message
    );

    // La interfaz no necesita mostrar directamente
    // toda la información interna de FireDAC/SQLite.
    FUltimoError :=
      'No se ha podido insertar el producto.';

    Result := False;
  end;
end;
end;


end.
