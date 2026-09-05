unit uVenta;

interface

type
  TVenta = class
  private
    FIdVenta: Integer;
    FFecha: string;
    FCodigoProducto: string;
    FProducto: string;
    FCantidad: Integer;
    FPrecioUnitario: Double;
    FTotal: Double;
  public
    property IdVenta: Integer
      read FIdVenta write FIdVenta;

    property Fecha: string
      read FFecha write FFecha;

    property CodigoProducto: string
      read FCodigoProducto write FCodigoProducto;

    property Producto: string
      read FProducto write FProducto;

    property Cantidad: Integer
      read FCantidad write FCantidad;

    property PrecioUnitario: Double
      read FPrecioUnitario write FPrecioUnitario;

    property Total: Double
      read FTotal write FTotal;
  end;

implementation

end.
