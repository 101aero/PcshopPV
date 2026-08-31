unit Productos;

interface

uses
  System.Diagnostics,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.ExtCtrls,
  uproducto,Datos;

type
  TfrmProductos = class(TForm)
    grpfiltros: TGroupBox;
    edtBusqueda: TEdit;
    btnBuscarFiltro: TButton;
    edtFiltroStock: TEdit;
    btnStockBajo: TButton;
    btnMostrarTodos: TButton;
    lblEstadoBusqueda: TLabel;
    lblModo: TLabel;
    lblFiltroStock: TLabel;
    btnValorInventario: TButton;
    lblValorInventario: TLabel;
    procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
    procedure btnMostrarTodosClick(Sender: TObject);
    procedure btnBuscarFiltroClick(Sender: TObject);
    procedure edtBusquedaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnStockBajoClick(Sender: TObject);
    procedure btnValorInventarioClick(Sender: TObject);

  private
  FProducto: TProducto;

    // Colección que almacena varios objetos TProducto.
  // La lista será propietaria de los objetos y se encargará
  // de liberarlos automáticamente cuando corresponda.
  FProductos: TObjectList<TProducto>;

  //
//        se usa FIndiceProductoSeleccionado
// El valor -1 indica que no existe ningún producto seleccionado
// y que el formulario se utiliza para crear un producto nuevo.
//
// Los índices válidos de la colección comienzan en 0.
FIndiceProductoSeleccionado: Integer;

    lblTitulo: TLabel;

    lblCodigo: TLabel;
    lblNombre: TLabel;

    lblPrecio: TLabel;
    lblStock: TLabel;

    edtCodigo: TEdit;
    edtNombre: TEdit;

    edtPrecio: TEdit;
    edtStock: TEdit;

    btnNuevo: TButton;
    btnGuardar: TButton;
    btnEliminar: TButton;
    btnBuscar: TButton;
    btnCerrar: TButton;

    grdProductos: TStringGrid;

    procedure ActualizarValorInventario;

    procedure RefrescarVistaProductos;

    procedure ComprobarConsistenciaProductos;
    procedure CrearInterfaz;
    procedure PrepararTabla;
    procedure LimpiarCampos;




procedure grdProductosSelectCell(
  Sender: TObject;
  ACol, ARow: LongInt;
  var CanSelect: Boolean
);


    // Reconstruye el TStringGrid utilizando los productos
// almacenados en la colección FProductos.
procedure ActualizarTablaDesdeColeccion;

    procedure btnNuevoClick(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnCerrarClick(Sender: TObject);




  public
  end;

var
  frmProductos: TfrmProductos;

  // ***********************************************************

implementation

{$R *.dfm}
(*
FORM-CREATE****

  --private
  FProducto: TProducto;
  --formcreate
  fproducto:=TProducto.create;
  ¿Qué hemos conseguido?

Cuando se abra la ventana Productos, el programa creará automáticamente un objeto TProducto
en memoria.

Todavía no lo utilizamos para guardar datos, pero ya existe.
 Es el primer paso para dejar de depender de los controles del formulario y
  empezar a trabajar con objetos.
*)

procedure TfrmProductos.FormCreate(Sender: TObject);
begin
fproducto:=TProducto.Create;
  // CREA COLECCIÓN que almacenará los productos.
  // El valor True indica que la lista será propietaria
  // de los objetos y los liberará automáticamente.
  FProductos := TObjectList<TProducto>.Create(True);

      // Al abrir el formulario no existe ningún producto
  // seleccionado para modificar.
  FIndiceProductoSeleccionado := -1;


  Caption := 'Productos';
  Position := poScreenCenter;
  Width := 900;
  Height := 680;
  Constraints.MinWidth := 800;
  Constraints.MinHeight := 650;



  CrearInterfaz;
  PrepararTabla;

  // Carga desde SQLite los productos persistidos
  // y crea un TProducto por cada registro recuperado.
  dmDatos.CargarProductos(FProductos);

  // Muestra en el TStringGrid los objetos cargados
  // desde la base de datos.
  ActualizarTablaDesdeColeccion;

  // COMPROBAMOS
  // En este punto FProductos contiene todos los registros
// recuperados de SQLite, por lo que ambos totales deben coincidir.
ComprobarConsistenciaProductos;
end;




procedure TfrmProductos.ActualizarValorInventario;
var
  ValorTotal: Double;
begin
  // SQLite realiza el cálculo agregado del inventario.
  ValorTotal := dmDatos.ObtenerValorInventario;

  // El formulario únicamente presenta el resultado.
  lblValorInventario.Caption :=
    'Valor total: ' +
    FormatFloat('0.00', ValorTotal) +
    ' €';
end;






procedure TfrmProductos.RefrescarVistaProductos;
begin
  // Si existe un criterio de búsqueda, mantenemos
  // la vista filtrada consultando nuevamente SQLite.
  if Trim(edtBusqueda.Text) <> '' then
    dmDatos.BuscarProductos(
      FProductos,
      edtBusqueda.Text
    )
  else
    // Sin filtro cargamos la colección completa.
    dmDatos.CargarProductos(FProductos);

  // El TStringGrid siempre se reconstruye a partir
  // de los datos que acaba de devolver SQLite.
  ActualizarTablaDesdeColeccion;
end;






procedure TfrmProductos.ComprobarConsistenciaProductos;
var
  TotalSQLite: Integer;
begin
  TotalSQLite := dmDatos.ObtenerTotalProductos;

  if TotalSQLite <> FProductos.Count then
  begin
    // Dejamos constancia técnica para poder investigar
    // posteriormente una posible desincronización.
    dmDatos.RegistrarDiagnostico(
      'CONSISTENCIA PRODUCTOS',
      'SQLite=' + IntToStr(TotalSQLite) +
      ' | Memoria=' + IntToStr(FProductos.Count)
    );

    ShowMessage(
      'Se ha detectado una diferencia entre SQLite y la memoria.' +
      sLineBreak +
      'SQLite: ' + IntToStr(TotalSQLite) +
      sLineBreak +
      'Memoria: ' + IntToStr(FProductos.Count)
    );
  end;
end;

{
 SELECCIÓN DE LA FILA ***

  Guarda el índice del producto seleccionado.

  La fila 0 contiene las cabeceras.
  La fila 1 corresponde a FProductos[0].
}
{
  Identifica el producto seleccionado y muestra sus datos
  en los campos del formulario.

  La fila 0 contiene las cabeceras del TStringGrid.
  La fila 1 corresponde al producto situado en el índice 0
  de la colección FProductos.
}
procedure TfrmProductos.grdProductosSelectCell(
  Sender: TObject;
  ACol, ARow: LongInt;
  var CanSelect: Boolean
);
var
  Producto: TProducto;
begin
  // Se permite seleccionar la celda o fila pulsada.
  CanSelect := True;

  // Se comprueba que la fila seleccionada corresponda
  // realmente a un producto de la colección.
  if (ARow < 1) or (ARow > FProductos.Count) then
  begin
    FIndiceProductoSeleccionado := -1;
    Exit;
  end;

  // La fila 1 corresponde al índice 0 de FProductos.
  FIndiceProductoSeleccionado := ARow - 1;

  // Se obtiene el objeto seleccionado desde la colección.
  Producto := FProductos[FIndiceProductoSeleccionado];

  // Al seleccionar un producto existente, el formulario
// pasa del modo Alta al modo Edición.
lblModo.Caption := 'Modo: Edición';
// codigoidentifica de forma unica
edtCodigo.ReadOnly:=true;


  // Se copian sus propiedades en los campos del formulario.
  // En este momento únicamente se muestran los datos;
  // todavía no se modifica el objeto.
  edtCodigo.Text := Producto.Codigo;
  edtNombre.Text := Producto.Nombre;

  edtPrecio.Text := FloatToStr(Producto.Precio);
  edtStock.Text := IntToStr(Producto.Stock);
end;

{       ACTUALIZAR TABLA ****
  Actualiza completamente el contenido del TStringGrid
  utilizando la colección FProductos como fuente de datos.

  En los siguientes pasos se incorpora el recorrido de la
  colección y la escritura de cada producto en la tabla.
}
procedure TfrmProductos.ActualizarTablaDesdeColeccion;
var
i: integer;
Producto: Tproducto;
begin
  // La fila 0 se reserva para los títulos de las columnas.
  // Si no existen productos, se mantiene una fila vacía.
  if FProductos.Count = 0 then
  begin
    grdProductos.RowCount := 2;
    grdProductos.Rows[1].Clear;
    Exit;
  end;

  // Se añade una fila por cada producto, además de la
  // cabecera situada en la fila 0.
  grdProductos.RowCount := FProductos.Count + 1;

    // Se recorre la colección desde el índice 0.
  for I := 0 to FProductos.Count - 1 do
  begin
    Producto := FProductos[I];

// 0 = Código
// 1 = Nombre
// 2 = Precio
// 3 = Stock
grdProductos.Cells[0, I + 1] := Producto.Codigo;
grdProductos.Cells[1, I + 1] := Producto.Nombre;

grdProductos.Cells[2, I + 1] :=
  FormatFloat('0.00', Producto.Precio);

grdProductos.Cells[3, I + 1] :=
  IntToStr(Producto.Stock);
  end;
end;



{
  Se liberan los objetos creados por el formulario.

  Free comprueba internamente si el objeto existe antes
  de destruirlo, por lo que resulta más seguro que llamar
  directamente al método Destroy.
}
procedure TfrmProductos.FormDestroy(Sender: TObject);
begin
  FProducto.Free;
  FProductos.Free;
end;


// CREAR INTERFAZ ***
//
//

procedure TfrmProductos.CrearInterfaz;
begin
  lblTitulo := TLabel.Create(Self);
  lblTitulo.Parent := Self;
  lblTitulo.Left := 4;
  lblTitulo.Top := 136;
  lblTitulo.Caption := 'Gestión de productos';
  lblTitulo.Font.Size := 12;
  lblTitulo.Font.Style := [fsBold];

  lblCodigo := TLabel.Create(Self);
  lblCodigo.Parent := Self;
  lblCodigo.Left := 24;
  lblCodigo.Top := 178;
  lblCodigo.Caption := 'Código:';

  edtCodigo := TEdit.Create(Self);
  edtCodigo.Parent := Self;
  edtCodigo.Left := 125;
  edtCodigo.Top := 173;
  edtCodigo.Width := 180;
  edtCodigo.MaxLength := 20;

// Etiqueta del nombre del producto.
lblNombre := TLabel.Create(Self);
lblNombre.Parent := Self;
lblNombre.Left := 24;
lblNombre.Top := 213;
lblNombre.Caption := 'Nombre:';

// Campo donde el usuario introduce el nombre.
edtNombre := TEdit.Create(Self);
edtNombre.Parent := Self;
edtNombre.Left := 125;
edtNombre.Top := 208;
edtNombre.Width := 400;
edtNombre.MaxLength := 100;





  lblPrecio := TLabel.Create(Self);
  lblPrecio.Parent := Self;
  lblPrecio.Left := 420;
  lblPrecio.Top := 178;
  lblPrecio.Caption := 'Precio:';

  edtPrecio := TEdit.Create(Self);
  edtPrecio.Parent := Self;
  edtPrecio.Left := 480;
  edtPrecio.Top := 173;
  edtPrecio.Width := 120;
  edtPrecio.TextHint := '0,00';

  lblStock := TLabel.Create(Self);
  lblStock.Parent := Self;
  lblStock.Left := 630;
  lblStock.Top := 178;
  lblStock.Caption := 'Stock:';

  edtStock := TEdit.Create(Self);
  edtStock.Parent := Self;
  edtStock.Left := 680;
  edtStock.Top := 173;
  edtStock.Width := 100;
  edtStock.TextHint := '0';

  btnNuevo := TButton.Create(Self);
  btnNuevo.Parent := Self;
  btnNuevo.Left := 24;
  btnNuevo.Top := 250;
  btnNuevo.Width := 100;
  btnNuevo.Caption := 'Nuevo';
  btnNuevo.OnClick := btnNuevoClick;

  btnGuardar := TButton.Create(Self);
  btnGuardar.Parent := Self;
  btnGuardar.Left := 135;
  btnGuardar.Top := 250;
  btnGuardar.Width := 100;
  btnGuardar.Caption := 'Guardar';
  btnGuardar.OnClick := btnGuardarClick;

  btnEliminar := TButton.Create(Self);
  btnEliminar.Parent := Self;
  btnEliminar.Left := 246;
  btnEliminar.Top := 250;
  btnEliminar.Width := 100;
  btnEliminar.Caption := 'Eliminar';
  btnEliminar.OnClick := btnEliminarClick;

  btnBuscar := TButton.Create(Self);
  btnBuscar.Parent := Self;
  btnBuscar.Left := 357;
  btnBuscar.Top := 250;
  btnBuscar.Width := 100;
  btnBuscar.Caption := 'Buscar';
  btnBuscar.OnClick := btnBuscarClick;

  btnCerrar := TButton.Create(Self);
  btnCerrar.Parent := Self;
  btnCerrar.Left := 680;
  btnCerrar.Top := 250;
  btnCerrar.Width := 100;
  btnCerrar.Caption := 'Cerrar';
  btnCerrar.OnClick := btnCerrarClick;

   // CREA grid de productos

  grdProductos := TStringGrid.Create(Self);
  grdProductos.Parent := Self;
  grdProductos.Left := 24;
  grdProductos.Top := 300;
  grdProductos.Width := 800;
  grdProductos.Height := 310;
  grdProductos.Anchors := [akLeft, akTop, akRight, akBottom];
  // Como el TStringGrid se crea mediante código,
// su evento también se asigna manualmente.
grdProductos.OnSelectCell := grdProductosSelectCell;

end;

procedure TfrmProductos.edtBusquedaKeyDown(
  Sender: TObject;
  var Key: Word;
  Shift: TShiftState
);
begin
  // Permite iniciar la búsqueda directamente con Enter.
  // Reutilizamos el mismo código del botón para no
  // duplicar la lógica de búsqueda.
  if Key = VK_RETURN then
  begin
    btnBuscarFiltroClick(btnBuscarFiltro);

    // Evita que Enter siga procesándose después.
    Key := 0;
  end;
end;

procedure TfrmProductos.PrepararTabla;
begin
// El grid muestra exactamente los mismos cuatro campos
// que utiliza actualmente TProducto y la tabla PRODUCTOS.
grdProductos.ColCount := 4;
  grdProductos.RowCount := 2;
  grdProductos.FixedRows := 1;
  grdProductos.FixedCols := 0;
  grdProductos.DefaultRowHeight := 24;
  grdProductos.Options :=
    grdProductos.Options + [goRowSelect] - [goEditing];

    grdProductos.Cells[0, 0] := 'Código';
grdProductos.Cells[1, 0] := 'Nombre';
grdProductos.Cells[2, 0] := 'Precio';
grdProductos.Cells[3, 0] := 'Stock';


grdProductos.ColWidths[0] := 120;
grdProductos.ColWidths[1] := 300;
grdProductos.ColWidths[2] := 100;
grdProductos.ColWidths[3] := 80;

  grdProductos.Rows[1].Clear;
end;

procedure TfrmProductos.LimpiarCampos;
begin
  edtCodigo.Clear;
  edtNombre.Clear;

  edtPrecio.Clear;
  edtStock.Clear;
  edtCodigo.SetFocus;
end;

// BOTÓN NUEVO ***
procedure TfrmProductos.btnNuevoClick(Sender: TObject);
begin
  // Se abandona el modo de edición.
  FIndiceProductoSeleccionado := -1;
 (*  El valor -1 indica que no existe ningún producto seleccionado
  para modificar. De esta forma, el botón Guardar interpreta
  posteriormente que debe añadir un nuevo objeto a la colección. *)

    // Se informa al usuario del estado actual del formulario.
  lblModo.Caption := 'Modo: Alta';
  // aqui si se puede modificar el codigo
  edtCodigo.ReadOnly:=false;

  LimpiarCampos;
end;




procedure TfrmProductos.btnStockBajoClick(Sender: TObject);
var
  StockMaximo: Integer;
begin
  // Comprobamos que el usuario haya introducido
  // un número entero válido.
  if not TryStrToInt(
    Trim(edtFiltroStock.Text),
    StockMaximo
  ) then
  begin
    ShowMessage(
      'Introduce un valor de stock válido.'
    );

    edtFiltroStock.SetFocus;
    Exit;
  end;

  // Un stock máximo negativo no tendría sentido
  // para este filtro.
  if StockMaximo < 0 then
  begin
    ShowMessage(
      'El stock máximo no puede ser negativo.'
    );

    edtFiltroStock.SetFocus;
    Exit;
  end;

  // El formulario solo entrega el criterio.
  // El filtrado real se realiza en SQLite
  // desde el Data Module.
  dmDatos.FiltrarProductosStockBajo(
    FProductos,
    StockMaximo
  );

  ActualizarTablaDesdeColeccion;

  lblEstadoBusqueda.Caption :=
    IntToStr(FProductos.Count) +
    ' productos con stock <= ' +
    IntToStr(StockMaximo);



end;











procedure TfrmProductos.btnValorInventarioClick(Sender: TObject);
var
  ValorTotal: Double;
begin
  ActualizarValorInventario;

end;







(* BOTÓN GUARDAR DATOS:
Usuario
   │
   ▼
Formulario
   │
   ▼
Objeto TProducto
   │
   ▼
StringGrid
*)



// BOTÓN GUARDAR ****
procedure TfrmProductos.btnGuardarClick(Sender: TObject);
var
  Precio: Double;
  Stock: Integer;
    Producto: TProducto;
    i: integer;

begin
  if Trim(edtCodigo.Text) = '' then
  begin
    ShowMessage('Introduce el código del producto.');
    edtCodigo.SetFocus;
    Exit;
  end;

  if Trim(edtNombre.Text) = '' then
  begin
    ShowMessage('Introduce el nombre del producto.');
    edtNombre.SetFocus;
    Exit;
  end;


// Primero se comprueba que el PRECIO se haya introducido.
// Después se comprobará que realmente sea un número válido.
if Trim(edtPrecio.Text) = '' then
begin
  ShowMessage('Introduce el precio del producto.');
  edtPrecio.SetFocus;
  Exit;
end;

// Se comprueba que el contenido del campo pueda convertirse
// correctamente a un número DECIMAL ****
//
// TryStrToFloat evita que la aplicación genere una excepción
// si el usuario introduce letras u otro valor no numérico.
if not TryStrToFloat(Trim(edtPrecio.Text), Precio) then
begin
  ShowMessage('El precio introducido no es válido.');
  edtPrecio.SetFocus;
  Exit;
end;

// No se admiten precios NEGATIVOS.
// Se permite el valor 0 por si posteriormente se utilizan
// productos gratuitos, promociones u otros casos especiales.
if Precio < 0 then
begin
  ShowMessage('El precio no puede ser negativo.');
  edtPrecio.SetFocus;
  Exit;
end;


  // El stock es obligatorio.
// En el siguiente control se comprobará además
// que el valor introducido sea un número entero.
if Trim(edtStock.Text) = '' then
begin
  ShowMessage('Introduce el stock del producto.');
  edtStock.SetFocus;
  Exit;
end;


  if not TryStrToInt(Trim(edtStock.Text), Stock) then
  begin
    ShowMessage('El stock introducido no es válido.');
    edtStock.SetFocus;
    Exit;
  end;

  if Stock < 0 then
  begin
    ShowMessage('El stock no puede ser negativo.');
    edtStock.SetFocus;
    Exit;
  end;

  // Solo comprobamos duplicados durante un ALTA.
// En edición el código permanece bloqueado y corresponde
// al producto que ya existe en SQLite.
if FIndiceProductoSeleccionado < 0 then
begin
  // Consultamos directamente SQLite en lugar de recorrer
  // FProductos, porque la colección puede estar filtrada
  // y no contener todos los productos existentes.
  if dmDatos.ExisteCodigoProducto(Trim(edtCodigo.Text)) then
  begin
    ShowMessage('Ya existe un producto con ese código.');
    edtCodigo.SetFocus;
    Exit;
  end;
end;


    (* ----------------------------------------------------------
//ANTIGUO>>>> EVITA DUPLICADOS (Se comprueba que el código del producto sea único)
//
// Se recorren todos los objetos almacenados en FProductos.
// Si se encuentra el mismo código en otro producto,
// se cancela la operación.

for I := 0 to FProductos.Count - 1 do
begin
  if SameText(
       Trim(FProductos[I].Codigo),
       Trim(edtCodigo.Text)
     ) and
     (I <> FIndiceProductoSeleccionado) then
  begin
    ShowMessage('Ya existe un producto con ese código.');
  <<<<<                       *)


    // ------VALOR -1 = NUEVO PRODUCTO
  // Se comprueba si se modifica un producto existente
  // o se registra un producto nuevo.
  //
  // El valor -1 indica que no existe ningún producto
  // seleccionado y, por tanto, se realiza un alta.
  // ----------------------------------------------------------

  if FIndiceProductoSeleccionado >= 0 then    // PRODUCTO EXISTENTE
  begin


    // Se obtiene directamente el objeto seleccionado
    // dentro de la colección.
    Producto := FProductos[FIndiceProductoSeleccionado];

    // Se actualizan sus propiedades con los valores
    // introducidos en el formulario.
    Producto.Nombre:= Trim(edtNombre.Text);

    Producto.Precio := Precio;
    Producto.Stock := Stock;


    if dmDatos.ActualizarProducto(Producto)
    then begin

// SQLite ya ha confirmado el UPDATE.
// Recargamos la vista actual para mantener el filtro
// si el usuario estaba realizando una búsqueda.
RefrescarVistaProductos;

    // Se abandona el modo de edición.
    FIndiceProductoSeleccionado := -1;
    edtCodigo.ReadOnly:=false;
    lblModo.Caption:='Modo alta';

    LimpiarCampos;
    ShowMessage('Producto modificado correctamente.');
          end else begin

          dmDatos.CargarProductos(FProductos);
          ActualizarTablaDesdeColeccion;
          Showmessage('no se ha podido actualizar el producto en sqlite');
                   end;

    //**
  end
  else
  begin       // AÑADIMOS NUEVO
    // No existe ningún producto seleccionado.
    // Se rellenan las propiedades del objeto temporal.
    FProducto.Codigo := Trim(edtCodigo.Text);
    FProducto.Nombre := Trim(edtNombre.Text);

    FProducto.Precio := Precio;
    FProducto.Stock := Stock;

    // ----------------------------------------------------------
// Persistencia en SQLite.
//
// El formulario no conoce el SQL.
// Entrega el objeto TProducto al Data Module,
// que es responsable del acceso a la base de datos.
// ----------------------------------------------------------
// Intentamos guardar primero el producto en SQLite.
// Si la persistencia falla, no añadimos el objeto
// a la colección en memoria.
if not dmDatos.InsertarProducto(FProducto) then
begin
  ShowMessage(
    'No se ha podido guardar el producto.' +
    sLineBreak +
    dmDatos.UltimoError
  );

  Exit;
end;

// Solo llegamos aquí si SQLite ha confirmado el alta.
// La colección pasa entonces a ser propietaria del objeto.
FProductos.Add(FProducto);

    // Se muestra el contenido actualizado de la colección.
    ActualizarTablaDesdeColeccion;

    // Se crea un objeto vacío para la siguiente alta.
    FProducto := TProducto.Create;

    lblModo.Caption := 'Modo: Alta';

    LimpiarCampos;
    ShowMessage('Producto añadido correctamente.');
  end;

end;


procedure TfrmProductos.btnMostrarTodosClick(Sender: TObject);
begin
  // Eliminamos el criterio de búsqueda.
  // RefrescarVistaProductos detectará que ya no existe filtro
  // y volverá a cargar todos los productos desde SQLite.
  edtBusqueda.Clear;

  RefrescarVistaProductos;

  // Ya no estamos mostrando el resultado de una búsqueda.
  lblEstadoBusqueda.Caption := '';
end;




// ELIMINAR ****

procedure TfrmProductos.btnEliminarClick(Sender: TObject);
var
  Fila: Integer;
  Producto: TProducto;

begin
  Fila := grdProductos.Row;

  if (Fila < 1) or (Trim(grdProductos.Cells[0, Fila]) = '') then
  begin
    ShowMessage('Selecciona un producto de la tabla.');
    Exit;
  end;

  if MessageDlg(
    '¿Deseas eliminar el producto seleccionado?',
    mtConfirmation,
    [mbYes, mbNo],
    0
  ) <> mrYes then
    Exit;


    // Obtenemos el producto seleccionado.
// La fila 1 del grid corresponde al índice 0 de FProductos.
Producto := FProductos[Fila - 1];

// Primero intentamos eliminar el registro persistido en SQLite.
// Si SQLite no elimina ninguna fila, no modificamos la colección
// en memoria para evitar que ambos estados queden desincronizados.
if not dmDatos.EliminarProducto(Producto.Codigo) then
begin
  ShowMessage(
    'No se ha podido eliminar el producto de la base de datos.'
  );
  Exit;
end;

// SQLite ya ha confirmado el DELETE.
// Recargamos la vista desde la base de datos para mantener
// correctamente la vista completa o el filtro activo.
RefrescarVistaProductos;


// Ya no existe ningún producto seleccionado.
FIndiceProductoSeleccionado := -1;

// El formulario vuelve visualmente al modo de alta.
lblModo.Caption := 'Modo: Alta';

// Se limpian los datos del producto eliminado.
LimpiarCampos;

end;
// *****




procedure TfrmProductos.btnBuscarClick(Sender: TObject);
var
  TextoBuscar: string;
  I: Integer;
begin
  TextoBuscar := InputBox(
    'Buscar producto',
    'Introduce un código o un nombre:',
    ''
  );

  TextoBuscar := LowerCase(Trim(TextoBuscar));

  if TextoBuscar = '' then
    Exit;

  for I := 1 to grdProductos.RowCount - 1 do
  begin
    if (Pos(TextoBuscar, LowerCase(grdProductos.Cells[0, I])) > 0) or
       (Pos(TextoBuscar, LowerCase(grdProductos.Cells[1, I])) > 0) then
    begin
      grdProductos.Row := I;
      grdProductos.SetFocus;
      Exit;
    end;
  end;

  ShowMessage('No se encuentra ningún producto.');
end;




procedure TfrmProductos.btnBuscarFiltroClick(Sender: TObject);
var
  Cronometro: TStopwatch;
begin
  // Evitamos ejecutar una búsqueda vacía.
  // Para recuperar todos los productos utilizaremos
  // específicamente el botón "Mostrar todos".
  if Trim(edtBusqueda.Text) = '' then
  begin
    ShowMessage('Introduce un código o nombre para buscar.');
    edtBusqueda.SetFocus;
    Exit;
  end;

  // Comenzamos a medir justo antes de solicitar los datos.
  Cronometro := TStopwatch.StartNew;

  // El formulario únicamente solicita la operación.
  // El SQL y FireDAC permanecen dentro del Data Module.
  dmDatos.BuscarProductos(
    FProductos,
    edtBusqueda.Text
  );

  // FProductos contiene ahora únicamente
  // los productos encontrados en SQLite.
  ActualizarTablaDesdeColeccion;

  // Detenemos la medición cuando también está actualizado el grid.
  Cronometro.Stop;

  // Mostramos cantidad de resultados y tiempo empleado.
  lblEstadoBusqueda.Caption :=
    IntToStr(FProductos.Count) +
    ' resultados — ' +
    IntToStr(Cronometro.ElapsedMilliseconds) +
    ' ms';

  // Si alcanzamos el límite configurado en SQL,
  // advertimos de que puede haber más coincidencias.
  if FProductos.Count = 100 then
  begin
    ShowMessage(
      'Se muestran los primeros 100 resultados.' +
      sLineBreak +
      'Refina la búsqueda para obtener una lista más precisa.'
    );
  end;

//
end;

//+

procedure TfrmProductos.btnCerrarClick(Sender: TObject);
begin
  Close;
end;

end.
