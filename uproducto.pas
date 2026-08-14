unit uProducto;

interface
(*
Definimos el modelo de datos de un producto.

Cada objeto TProducto tendrá cinco atributos:

Codigo
Descripcion
Categoria
Precio
Stock

Todavía no crea productos ni los guarda. Simplemente hemos definido cómo es un
producto dentro del programa.

dejaremos de trabajar con datos sueltos en los controles del formulario y
empezaremos a trabajar con objetos, como se hace en aplicaciones profesionales.
*)

type
  TProducto = class
  private
    FCodigo: string;

    // Campo definitivo para el nombre del producto.
    FNombre: string;


    FPrecio: Double;
    FStock: Integer;

  public
    constructor Create;

    property Codigo: string read FCodigo write FCodigo;

    // Propiedad definitiva, alineada con PRODUCTOS.Nombre en SQLite.
    property Nombre: string read FNombre write FNombre;

    property Precio: Double read FPrecio write FPrecio;
    property Stock: Integer read FStock write FStock;
  end;

implementation
(*
  Cada vez que escribamos:

Producto := TProducto.Create;

obtendremos un objeto con estos valores iniciales:

Código vacío.
Descripción vacía.
Categoría vacía.
Precio = 0.
Stock = 0.
*)
constructor TProducto.Create;
begin
  inherited Create;

  FCodigo := '';
// Inicializamos el campo definitivo Nombre.
FNombre := '';

  FPrecio := 0;
  FStock := 0;
end;



end.
