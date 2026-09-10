unit uVenta;

interface

type
  TVenta = class
  private
    FIdVenta: Integer;
    FIdCliente: Integer;
    FFecha: string;
    FCodigoProducto: string;
    FProducto: string;
    FCliente: string;
    FCantidad: Integer;
    FPrecioUnitario: Double;
    FTotal: Double;
  public
    property IdVenta: Integer
      read FIdVenta write FIdVenta;

    // En SQLite una venta sin cliente se guarda como NULL.
    // En el modelo Delphi representaremos ese caso con 0;
    // los IdCliente reales empiezan en 1 por ser autoincrementales.
    property IdCliente: Integer
      read FIdCliente write FIdCliente;

    property Fecha: string
      read FFecha write FFecha;

    property CodigoProducto: string
      read FCodigoProducto write FCodigoProducto;

    property Producto: string
      read FProducto write FProducto;

    // Nombre descriptivo del cliente para presentación en el historial.
    // No se persiste en VENTAS: se obtendrá de CLIENTES mediante IdCliente.
    // Para una venta sin cliente se cargará un texto como '(venta anónima)'.
    property Cliente: string
      read FCliente write FCliente;

    property Cantidad: Integer
      read FCantidad write FCantidad;

    property PrecioUnitario: Double
      read FPrecioUnitario write FPrecioUnitario;

    property Total: Double
      read FTotal write FTotal;
  end;

implementation

end.
