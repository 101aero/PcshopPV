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
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, uVenta, uCliente,
  uMovimientoStock, FireDAC.Phys.MSAccDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSAcc;

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
    qryCrearTablaMovimientosStock: TFDQuery;
    qryInsertarMovimientoStock: TFDQuery;
    qryActualizarStockMovimiento: TFDQuery;
    qryListarMovimientosStock: TFDQuery;
    qryEstructuraMovimientosStock: TFDQuery;
    qryAgregarIdVentaMovimientos: TFDQuery;
    qryUltimoIdVenta: TFDQuery;
    qryAuditoriaTrazabilidadResumen: TFDQuery;
    qryAuditoriaTrazabilidadDetalle: TFDQuery;
    qryAgregarTrazableVentas: TFDQuery;
    qryCrearIndiceUnicoMovimientoVenta: TFDQuery;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDSQLiteBackup1: TFDSQLiteBackup;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  FUltimoError: string;

  // Comprueba la estructura real de VENTAS y aplica únicamente
  // la evolución necesaria para conservar los datos existentes.
  procedure MigrarEsquemaVentas;

  // Evoluciona MOVIMIENTOS_STOCK sin borrar ni recrear la tabla.
  // Los movimientos antiguos conservarán sus datos y tendrán IdVenta = NULL.
  procedure MigrarEsquemaMovimientosStock;

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

  // Devuelve el identificador generado por SQLite para la última venta
  // insertada mediante esta misma conexión. Debe consultarse inmediatamente
  // después del INSERT de VENTAS y antes de cualquier otro INSERT.
  function ObtenerUltimoIdVentaInsertada: Integer;


public

function CrearBackupManual(out ARutaBackup: string): Boolean;

// MOVIMIENTOS DE STOCK ----------------------------------------------------
// Registra únicamente la trazabilidad del movimiento.
// En este paso todavía NO modifica PRODUCTOS.Stock.
function RegistrarMovimientoStock(
  const AMovimiento: TMovimientoStock
): Boolean;

// Aplica la variación al stock y registra su trazabilidad como una sola
// operación. Si cualquiera de las dos acciones falla, se hace ROLLBACK.
function AplicarMovimientoStock(
  const AMovimiento: TMovimientoStock
): Boolean;

// Recupera la trazabilidad ya persistida. La lista recibida es propiedad
// del formulario/capa llamadora; el Data Module solo la rellena.
procedure CargarMovimientosStock(
  ALista: TObjectList<TMovimientoStock>
);

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
  ALista: TObjectList<TVenta>;
  AIdCliente: Integer = 0
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

// AUDITORIA DE TRAZABILIDAD -----------------------------------------------
// Comprueba la coherencia entre VENTAS y los movimientos de stock
// generados automaticamente por una venta. No modifica ningun dato.
function ComprobarTrazabilidadInventario(
  out AVentasRevisadas: Integer;
  out ASinMovimiento: Integer;
  out ADuplicados: Integer;
  out AHuerfanos: Integer;
  out ACantidadesIncoherentes: Integer
): Boolean;

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

  // MOVIMIENTOS_STOCK registra la trazabilidad del inventario.
  // Es una tabla nueva, por lo que CREATE TABLE IF NOT EXISTS es suficiente:
  // no necesitamos migrar una estructura previa como ocurrió con VENTAS.
  qryCrearTablaMovimientosStock.ExecSQL;

  // Una base creada antes de incorporar la relación con VENTAS no tendrá
  // todavía IdVenta. La migración añade únicamente esa columna si falta.
  MigrarEsquemaMovimientosStock;

  qryCrearIndiceUnicoMovimientoVenta.ExecSQL;

end;
// END-CREATE //





// BACKUP
// *****

function TdmDatos.CrearBackupManual(
  out ARutaBackup: string
): Boolean;
var
  RutaBD: string;
  CarpetaBackup: string;
begin
  Result := False;
  ARutaBackup := '';
  FUltimoError := '';

  RutaBD := FDConnection1.Params.Values['Database'];
  CarpetaBackup :=
    IncludeTrailingPathDelimiter(ExtractFilePath(RutaBD)) +
    'backups';

  try
    // Creamos la carpeta solo si todavía no existe.
    if not DirectoryExists(CarpetaBackup) then
      ForceDirectories(CarpetaBackup);

    ARutaBackup :=
      IncludeTrailingPathDelimiter(CarpetaBackup) +
      'pcshop_' +
      FormatDateTime('yyyy-mm-dd_hhnn', Now) +
      '.db';

    // Evitamos sobrescribir silenciosamente un backup
    // creado durante el mismo minuto.
    if FileExists(ARutaBackup) then
    begin
      FUltimoError :=
        'Ya existe una copia de seguridad con esa fecha y hora.';
      Exit;
    end;

    // FireDAC utiliza la API de backup de SQLite.
    // No hacemos una copia directa del fichero abierto.
    FDSQLiteBackup1.Database := RutaBD;
    FDSQLiteBackup1.DestDatabase := ARutaBackup;

    FDSQLiteBackup1.Backup;

    // El backup solo se considera correcto si el fichero
    // realmente ha sido creado y contiene datos.
    if not FileExists(ARutaBackup) then
    begin
      FUltimoError :=
        'La copia de seguridad no se ha creado.';
      Exit;
    end;

    if TFile.GetSize(ARutaBackup) <= 0 then
    begin
      FUltimoError :=
        'La copia de seguridad creada no es válida.';
      Exit;
    end;

RegistrarDiagnostico(
  'BACKUP SQLITE',
  'OK | ' + ARutaBackup
);

    Result := True;

  except
    on E: Exception do
    begin
      FUltimoError :=
        'No se ha podido crear la copia de seguridad.';

RegistrarDiagnostico(
  'BACKUP SQLITE',
  'ERROR | ' + E.Message
);

      Result := False;
    end;
  end;
end;






procedure TdmDatos.MigrarEsquemaVentas;
var
  TieneIdCliente: Boolean;
  TieneTrazable: Boolean;
  NombreCampo: string;
begin
  TieneIdCliente := False;
  TieneTrazable := False;

  qryEstructuraVentas.Close;
  qryEstructuraVentas.Open;

  try
    while not qryEstructuraVentas.Eof do
    begin
      NombreCampo :=
        qryEstructuraVentas.FieldByName('name').AsString;

      if SameText(NombreCampo, 'IdCliente') then
        TieneIdCliente := True;

      if SameText(NombreCampo, 'Trazable') then
        TieneTrazable := True;

      // No hacemos Break:
      // necesitamos revisar toda la estructura de VENTAS.
      qryEstructuraVentas.Next;
    end;
  finally
    qryEstructuraVentas.Close;
  end;

  if not TieneIdCliente then
    qryAgregarIdClienteVentas.ExecSQL;

  if not TieneTrazable then
    qryAgregarTrazableVentas.ExecSQL;
end;

// ========================================================================
// MIGRACIÓN DE ESQUEMA: MOVIMIENTOS_STOCK
// ========================================================================

procedure TdmDatos.MigrarEsquemaMovimientosStock;
var
  TieneIdVenta: Boolean;
begin
  TieneIdVenta := False;

  // Consultamos la estructura real porque cambiar el CREATE TABLE no
  // modifica una tabla que ya existe y contiene movimientos.
  qryEstructuraMovimientosStock.Close;
  qryEstructuraMovimientosStock.Open;

  try
    while not qryEstructuraMovimientosStock.Eof do
    begin
      if SameText(
        qryEstructuraMovimientosStock.FieldByName('name').AsString,
        'IdVenta'
      ) then
      begin
        TieneIdVenta := True;
        Break;
      end;

      qryEstructuraMovimientosStock.Next;
    end;
  finally
    qryEstructuraMovimientosStock.Close;
  end;

  if not TieneIdVenta then
  begin
    // La nueva columna admite NULL. Por tanto, todos los movimientos
    // ya existentes siguen siendo válidos y quedan sin venta asociada.
    qryAgregarIdVentaMovimientos.ExecSQL;
  end;
end;


// ========================================================================
// MOVIMIENTOS DE STOCK
// ========================================================================

function TdmDatos.RegistrarMovimientoStock(
  const AMovimiento: TMovimientoStock
): Boolean;
var
  FechaMovimiento: string;
begin
  FUltimoError := '';
  Result := False;

  // La fecha pertenece a la trazabilidad de la operación.
  // Si el llamador no proporciona una, la capa de datos toma el momento
  // real en que se registra el movimiento.
  FechaMovimiento := Trim(AMovimiento.Fecha);
  if FechaMovimiento = '' then
    FechaMovimiento := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);

  try
    qryInsertarMovimientoStock.ParamByName('Fecha').AsString :=
      FechaMovimiento;

    qryInsertarMovimientoStock.ParamByName('CodigoProducto').AsString :=
      AMovimiento.CodigoProducto;

    // Delphi trabaja con un enumerado; SQLite guarda texto legible.
    qryInsertarMovimientoStock.ParamByName('Tipo').AsString :=
      TipoMovimientoStockToString(AMovimiento.Tipo);

    qryInsertarMovimientoStock.ParamByName('Cantidad').AsInteger :=
      AMovimiento.Cantidad;

    qryInsertarMovimientoStock.ParamByName('Motivo').AsString :=
      AMovimiento.Motivo;

    // IdVenta es opcional. Los movimientos manuales utilizan 0 en Delphi,
    // pero se persisten como NULL. Los movimientos generados por una venta
    // almacenarán el identificador real de VENTAS.Id.
    qryInsertarMovimientoStock.ParamByName('IdVenta').DataType := ftInteger;

    if AMovimiento.IdVenta > 0 then
      qryInsertarMovimientoStock.ParamByName('IdVenta').AsInteger :=
        AMovimiento.IdVenta
    else
      qryInsertarMovimientoStock.ParamByName('IdVenta').Clear;

    qryInsertarMovimientoStock.ExecSQL;

    Result := qryInsertarMovimientoStock.RowsAffected > 0;

    if not Result then
      FUltimoError :=
        'No se ha podido registrar el movimiento de stock.';

  except
    on E: Exception do
    begin
      RegistrarError(
        'INSERT MOVIMIENTO STOCK',
        'Codigo=' + AMovimiento.CodigoProducto +
        ' | Tipo=' + TipoMovimientoStockToString(AMovimiento.Tipo) +
        ' | Cantidad=' + IntToStr(AMovimiento.Cantidad) +
        ' | ' + E.Message
      );

      FUltimoError :=
        'No se ha podido registrar el movimiento de stock.';

      Result := False;
    end;
  end;
end;


function TdmDatos.AplicarMovimientoStock(
  const AMovimiento: TMovimientoStock
): Boolean;
begin
  FUltimoError := '';
  Result := False;

  // Validamos antes de abrir la transacción. Cantidad representa siempre
  // la variación: positiva en ENTRADA, negativa en SALIDA y con cualquier
  // signo (excepto cero) en AJUSTE.
  if Trim(AMovimiento.CodigoProducto) = '' then
  begin
    FUltimoError := 'El movimiento debe indicar un producto.';
    Exit;
  end;

  if Trim(AMovimiento.Motivo) = '' then
  begin
    FUltimoError := 'El movimiento debe indicar un motivo.';
    Exit;
  end;

  case AMovimiento.Tipo of
    tmsEntrada:
      if AMovimiento.Cantidad <= 0 then
      begin
        FUltimoError := 'Una entrada debe tener una cantidad positiva.';
        Exit;
      end;

    tmsSalida:
      if AMovimiento.Cantidad >= 0 then
      begin
        FUltimoError := 'Una salida debe tener una cantidad negativa.';
        Exit;
      end;

    tmsAjuste:
      if AMovimiento.Cantidad = 0 then
      begin
        FUltimoError := 'Un ajuste debe modificar el stock.';
        Exit;
      end;
  end;

  try
    // El stock actual y su explicación histórica deben cambiar juntos.
    FDConnection1.StartTransaction;

    // 1. Aplicamos la variación al stock. La condición adicional impide
    // que una SALIDA o AJUSTE negativo deje existencias por debajo de cero.
    qryActualizarStockMovimiento.ParamByName('Cantidad').AsInteger :=
      AMovimiento.Cantidad;

    qryActualizarStockMovimiento.ParamByName('CodigoProducto').AsString :=
      AMovimiento.CodigoProducto;

    qryActualizarStockMovimiento.ExecSQL;

    if qryActualizarStockMovimiento.RowsAffected <= 0 then
    begin
      FDConnection1.Rollback;
      FUltimoError :=
        'No se ha podido modificar el stock. Comprueba el producto y las existencias.';
      Exit;
    end;

    // 2. Registramos por qué cambió. RegistrarMovimientoStock usa la
    // misma conexión, por lo que su INSERT forma parte de esta transacción.
    if not RegistrarMovimientoStock(AMovimiento) then
    begin
      if FDConnection1.InTransaction then
        FDConnection1.Rollback;
      Exit;
    end;

    // Solo confirmamos cuando las dos operaciones han terminado bien.
    FDConnection1.Commit;
    Result := True;

  except
    on E: Exception do
    begin
      if FDConnection1.InTransaction then
        FDConnection1.Rollback;

      RegistrarError(
        'APLICAR MOVIMIENTO STOCK',
        'Codigo=' + AMovimiento.CodigoProducto +
        ' | Tipo=' + TipoMovimientoStockToString(AMovimiento.Tipo) +
        ' | Cantidad=' + IntToStr(AMovimiento.Cantidad) +
        ' | ' + E.Message
      );

      FUltimoError :=
        'No se ha podido aplicar el movimiento de stock.';
      Result := False;
    end;
  end;
end;


// ========================================================================
// ========================================================================
// CARGA DE MOVIMIENTOS DE STOCK
// ========================================================================

procedure TdmDatos.CargarMovimientosStock(
  ALista: TObjectList<TMovimientoStock>
);
var
  Movimiento: TMovimientoStock;
begin
  ALista.Clear;

  qryListarMovimientosStock.Close;
  qryListarMovimientosStock.Open;

  try
    while not qryListarMovimientosStock.Eof do
    begin
      Movimiento := TMovimientoStock.Create;

      try
        Movimiento.IdMovimiento :=
          qryListarMovimientosStock.FieldByName('IdMovimiento').AsInteger;

        Movimiento.Fecha :=
          qryListarMovimientosStock.FieldByName('Fecha').AsString;

        Movimiento.CodigoProducto :=
          qryListarMovimientosStock.FieldByName('CodigoProducto').AsString;

        Movimiento.Tipo := StringToTipoMovimientoStock(
          qryListarMovimientosStock.FieldByName('Tipo').AsString
        );

        Movimiento.Cantidad :=
          qryListarMovimientosStock.FieldByName('Cantidad').AsInteger;

        Movimiento.Motivo :=
          qryListarMovimientosStock.FieldByName('Motivo').AsString;

        // En SQLite, NULL significa que el movimiento no procede de una venta.
        // En el modelo Delphi representamos esa ausencia mediante IdVenta = 0.
        if qryListarMovimientosStock.FieldByName('IdVenta').IsNull then
          Movimiento.IdVenta := 0
        else
          Movimiento.IdVenta :=
            qryListarMovimientosStock.FieldByName('IdVenta').AsInteger;

        ALista.Add(Movimiento);
        Movimiento := nil;
      finally
        Movimiento.Free;
      end;

      qryListarMovimientosStock.Next;
    end;
  finally
    qryListarMovimientosStock.Close;
  end;
end;


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
  ALista: TObjectList<TVenta>;
  AIdCliente: Integer
);
var
  Venta: TVenta;
begin
  // La colección representará exactamente
  // el historial devuelto actualmente por SQLite.
  ALista.Clear;

  qryListarVentas.Close;

  // AIdCliente = 0 significa "Todos los clientes".
  // Un identificador real limita el historial a ese cliente.
  qryListarVentas.ParamByName('IdClienteFiltro').AsInteger := AIdCliente;
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
  // El resumen de la ultima venta siempre consulta el historial general.
  qryListarVentas.ParamByName('IdClienteFiltro').AsInteger := 0;
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









function TdmDatos.ObtenerUltimoIdVentaInsertada: Integer;
begin
  Result := 0;

  qryUltimoIdVenta.Close;
  qryUltimoIdVenta.Open;
  try
    Result := qryUltimoIdVenta.FieldByName('IdVenta').AsInteger;
  finally
    qryUltimoIdVenta.Close;
  end;
end;



function TdmDatos.RegistrarVenta(
  const AProducto: TProducto;
  ACantidad: Integer;
  AIdCliente: Integer
): Boolean;
var
  Total: Double;
  IdVenta: Integer;
  FechaVenta: string;
  Movimiento: TMovimientoStock;
begin
  FUltimoError := '';
  Result := False;

  Total := AProducto.Precio * ACantidad;
  FechaVenta := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);

  try
    // Venta, descuento de stock y trazabilidad forman una sola operación.
    // RegistrarVenta sigue siendo el único propietario de la transacción.
    FDConnection1.StartTransaction;

    // --------------------------------------------------
    // 1. Registramos la venta.
    // --------------------------------------------------
    qryInsertarVenta.ParamByName('Fecha').AsString :=
      FechaVenta;

    // En Delphi usamos 0 para representar "sin cliente",
    // pero en SQLite guardamos un NULL real.
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

      // Las ventas creadas por la versión actual ya forman parte
// del sistema de trazabilidad de inventario.
qryInsertarVenta.ParamByName('Trazable').AsInteger := 1;

    qryInsertarVenta.ExecSQL;

    if qryInsertarVenta.RowsAffected <= 0 then
    begin
      FDConnection1.Rollback;
      FUltimoError := 'No se ha podido registrar la venta.';
      Exit;
    end;

    // El identificador debe recuperarse inmediatamente después del INSERT
    // de VENTAS, antes de que otro INSERT cambie last_insert_rowid().
    IdVenta := ObtenerUltimoIdVentaInsertada;

    if IdVenta <= 0 then
    begin
      FDConnection1.Rollback;
      FUltimoError :=
        'No se ha podido obtener el identificador de la venta.';
      Exit;
    end;

    // --------------------------------------------------
    // 2. Descontamos el stock.
    // --------------------------------------------------
    qryDescontarStock.ParamByName('Cantidad').AsInteger :=
      ACantidad;

    qryDescontarStock.ParamByName('CodigoProducto').AsString :=
      AProducto.Codigo;

    qryDescontarStock.ExecSQL;

    if qryDescontarStock.RowsAffected <= 0 then
    begin
      // La venta ya se había insertado, pero al estar dentro de la misma
      // transacción también se deshace.
      FDConnection1.Rollback;
      FUltimoError :=
        'No hay stock suficiente para realizar la venta.';
      Exit;
    end;

    // --------------------------------------------------
    // 3. Registramos la salida automática de inventario.
    // --------------------------------------------------
    Movimiento := TMovimientoStock.Create;
    try
      Movimiento.Fecha := FechaVenta;
      Movimiento.CodigoProducto := AProducto.Codigo;
      Movimiento.Tipo := tmsSalida;
      Movimiento.Cantidad := -ACantidad;
      Movimiento.Motivo := 'Venta';
      Movimiento.IdVenta := IdVenta;

      // RegistrarMovimientoStock NO inicia otra transacción. Al utilizar la
      // misma FDConnection1, este INSERT forma parte de la venta actual.
      if not RegistrarMovimientoStock(Movimiento) then
      begin
        if FDConnection1.InTransaction then
          FDConnection1.Rollback;
        Exit;
      end;
    finally
      Movimiento.Free;
    end;

    // Solo confirmamos cuando venta, stock y movimiento han terminado bien.
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




// ========================================================================
// AUDITORIA DE TRAZABILIDAD DE INVENTARIO
// ========================================================================

function TdmDatos.ComprobarTrazabilidadInventario(
  out AVentasRevisadas: Integer;
  out ASinMovimiento: Integer;
  out ADuplicados: Integer;
  out AHuerfanos: Integer;
  out ACantidadesIncoherentes: Integer
): Boolean;
var
  TotalIncidencias: Integer;
begin
  Result := False;
  FUltimoError := '';

  AVentasRevisadas := 0;
  ASinMovimiento := 0;
  ADuplicados := 0;
  AHuerfanos := 0;
  ACantidadesIncoherentes := 0;

  qryAuditoriaTrazabilidadResumen.Close;
  qryAuditoriaTrazabilidadDetalle.Close;

  try
    // Esta comprobacion es de solo lectura: no repara ni modifica datos.
    qryAuditoriaTrazabilidadResumen.Open;
    try
      AVentasRevisadas :=
        qryAuditoriaTrazabilidadResumen.FieldByName('VentasRevisadas').AsInteger;

      ASinMovimiento :=
        qryAuditoriaTrazabilidadResumen.FieldByName('SinMovimiento').AsInteger;

      ADuplicados :=
        qryAuditoriaTrazabilidadResumen.FieldByName('Duplicados').AsInteger;

      AHuerfanos :=
        qryAuditoriaTrazabilidadResumen.FieldByName('Huerfanos').AsInteger;

      ACantidadesIncoherentes :=
        qryAuditoriaTrazabilidadResumen
          .FieldByName('CantidadesIncoherentes').AsInteger;
    finally
      qryAuditoriaTrazabilidadResumen.Close;
    end;

    TotalIncidencias :=
      ASinMovimiento +
      ADuplicados +
      AHuerfanos +
      ACantidadesIncoherentes;

    // Reutilizamos el log tecnico existente unicamente si hay incidencias.
    if TotalIncidencias > 0 then
    begin
      RegistrarDiagnostico(
        'AUDITORIA INVENTARIO',
        Format(
          'Resumen | Ventas=%d | SinMovimiento=%d | Duplicados=%d | ' +
          'Huerfanos=%d | CantidadesIncoherentes=%d',
          [
            AVentasRevisadas,
            ASinMovimiento,
            ADuplicados,
            AHuerfanos,
            ACantidadesIncoherentes
          ]
        )
      );

      qryAuditoriaTrazabilidadDetalle.Open;
      try
        while not qryAuditoriaTrazabilidadDetalle.Eof do
        begin
          RegistrarDiagnostico(
            'AUDITORIA INVENTARIO',
            qryAuditoriaTrazabilidadDetalle.FieldByName('Detalle').AsString
          );

          qryAuditoriaTrazabilidadDetalle.Next;
        end;
      finally
        qryAuditoriaTrazabilidadDetalle.Close;
      end;
    end;

    Result := True;

  except
    on E: Exception do
    begin
      qryAuditoriaTrazabilidadResumen.Close;
      qryAuditoriaTrazabilidadDetalle.Close;

      FUltimoError :=
        'No se ha podido completar la auditoria de trazabilidad.';

      RegistrarError(
        'AUDITORIA INVENTARIO',
        E.Message
      );

      Result := False;
    end;
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
