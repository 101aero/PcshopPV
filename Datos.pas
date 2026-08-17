unit Datos;

interface

uses
  Vcl.Dialogs,uProducto, System.Generics.Collections,
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
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    qryProductos: TFDQuery;
    qryInsertarProducto: TFDQuery;
    qryListarProductos: TFDQuery;
    qryActualizarProducto: TFDQuery;
    qryEliminarProducto: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
public

// Elimina de SQLite el producto identificado por su código.
// Devuelve True si realmente se ha eliminado una fila.
function EliminarProducto(const ACodigo: string): Boolean;

// Actualiza en SQLite los datos de un producto existente.
procedure ActualizarProducto(const AProducto: TProducto);
  // Lee los productos almacenados en SQLite y
  // los convierte nuevamente en objetos TProducto.
  //
  // ALista es la colección proporcionada por el formulario.
  procedure CargarProductos(ALista: TObjectList<TProducto>);
  // Guarda un producto en SQLite utilizando una consulta parametrizada.
  procedure InsertarProducto(const AProducto: TProducto);
  end;

var
  dmDatos: TdmDatos;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmDatos.DataModuleCreate(Sender: TObject);
begin
  // Se comprueba que la conexión con SQLite esté abierta.
  // Si todavía no lo está, FireDAC realiza la conexión.
  if not FDConnection1.Connected then
    FDConnection1.Connected := True;

  // Ejecuta la sentencia CREATE TABLE almacenada
  // en qryProductos.SQL.
  //
  // Como utilizamos IF NOT EXISTS, la sentencia también
  // puede ejecutarse cuando PRODUCTOS ya existe.
  qryProductos.ExecSQL;

  // ----------------------------------------------------------
// Después de crear PRODUCTOS, comprobamos que la tabla
// aparece realmente en el esquema interno de SQLite.
// ----------------------------------------------------------

qryProductos.Close;

qryProductos.SQL.Text :=
  'SELECT name FROM sqlite_schema ' +
  'WHERE type = ''table'' AND name = ''PRODUCTOS'';';

// SELECT devuelve registros, por lo que se utiliza Open
// en lugar de ExecSQL.
qryProductos.Open;

if not qryProductos.IsEmpty then
  ShowMessage('Conexión SQLite correcta. Tabla PRODUCTOS creada.');
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

procedure TdmDatos.ActualizarProducto(const AProducto: TProducto);
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
//
  if qryActualizarProducto.RowsAffected=0 then showmessage('sqlite no') else showmessage('sql si');

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


procedure TdmDatos.InsertarProducto(const AProducto: TProducto);
begin
  // Cada parámetro SQL recibe el valor correspondiente
  // desde el objeto TProducto.
  //
  // No concatenamos texto para construir el INSERT.
  qryInsertarProducto.ParamByName('Codigo').AsString :=
    AProducto.Codigo;

  qryInsertarProducto.ParamByName('Nombre').AsString :=
    AProducto.Nombre;

  qryInsertarProducto.ParamByName('Precio').AsFloat :=
    AProducto.Precio;

  qryInsertarProducto.ParamByName('Stock').AsInteger :=
    AProducto.Stock;

  // ExecSQL ejecuta el INSERT porque esta sentencia
  // modifica datos y no devuelve un conjunto de registros.
  qryInsertarProducto.ExecSQL;
end;


end.
