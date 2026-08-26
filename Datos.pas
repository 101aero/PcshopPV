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
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

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
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  FUltimoError: string;

  procedure RegistrarError(
  const AOperacion: string;
  const AMensaje: string
);



public

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
end;
// END-CREATE //



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
      Producto := TProducto.Create;

      try
        // Convertimos cada registro SQL en un TProducto.
        Producto.Codigo :=
          qryBuscarProductos.FieldByName('Codigo').AsString;

        Producto.Nombre :=
          qryBuscarProductos.FieldByName('Nombre').AsString;

        Producto.Precio :=
          qryBuscarProductos.FieldByName('Precio').AsFloat;

        Producto.Stock :=
          qryBuscarProductos.FieldByName('Stock').AsInteger;

        // La colección pasa a ser propietaria del objeto.
        ALista.Add(Producto);
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


procedure TdmDatos.CargarProductos(ALista: TObjectList<TProducto>);
var
  Producto: TProducto;
begin
  // Eliminamos cualquier contenido anterior para evitar
  // cargar dos veces los mismos productos en memoria.
  ALista.Clear;

  // Cerramos la consulta por seguridad antes de abrirla de nuevo.
  qryListarProductos.Close;

  // Open ejecuta el SELECT configurado en qryListarProductos
  // y deja disponibles los registros devueltos.
  qryListarProductos.Open;

  // Eof significa "End Of File".
  // Mientras no lleguemos al final, procesamos cada registro.
  while not qryListarProductos.Eof do
  begin
    Producto := TProducto.Create;

    try
      // Convertimos las columnas de SQLite
      // en propiedades de un objeto TProducto.
      Producto.Codigo :=
        qryListarProductos.FieldByName('Codigo').AsString;

      Producto.Nombre :=
        qryListarProductos.FieldByName('Nombre').AsString;

      Producto.Precio :=
        qryListarProductos.FieldByName('Precio').AsFloat;

      Producto.Stock :=
        qryListarProductos.FieldByName('Stock').AsInteger;

      // La colección pasa a ser propietaria del objeto.
      ALista.Add(Producto);

      // Evitamos que el bloque finally libere un objeto
      // que ya pertenece a la colección.
      Producto := nil;

    finally
      Producto.Free;
    end;

    // Avanzamos al siguiente registro devuelto por el SELECT.
    qryListarProductos.Next;
  end;

  // Cerramos la consulta una vez terminada la lectura.
  qryListarProductos.Close;
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
