unit uCliente;

interface

type
  TCliente = class
  private
    FIdCliente: Integer;
    FNombre: string;
    FEmail: string;
    FTelefono: string;

  public
    // Identificador interno y estable del cliente.
    // Será la clave primaria en SQLite y permitirá
    // relacionar posteriormente VENTAS con CLIENTES.
    property IdCliente: Integer
      read FIdCliente write FIdCliente;

    // El nombre es un dato descriptivo.
    // No se utiliza como clave porque puede repetirse
    // y además puede modificarse con el tiempo.
    property Nombre: string
      read FNombre write FNombre;

    property Email: string
      read FEmail write FEmail;

    property Telefono: string
      read FTelefono write FTelefono;
  end;

implementation

end.
