unit uMovimientoStock;

interface

uses
  System.SysUtils;

type
  // En Delphi usamos un tipo enumerado para evitar cadenas arbitrarias
  // como 'SALDA', 'ENTRADAA', etc. SQLite seguirá almacenando texto legible.
  TTipoMovimientoStock = (
    tmsEntrada,
    tmsSalida,
    tmsAjuste
  );

  TMovimientoStock = class
  private
    FIdMovimiento: Integer;
    FFecha: string;
    FCodigoProducto: string;
    FTipo: TTipoMovimientoStock;
    FCantidad: Integer;
    FMotivo: string;
  public
    property IdMovimiento: Integer
      read FIdMovimiento write FIdMovimiento;

    property Fecha: string
      read FFecha write FFecha;

    property CodigoProducto: string
      read FCodigoProducto write FCodigoProducto;

    property Tipo: TTipoMovimientoStock
      read FTipo write FTipo;

    // Cantidad representa siempre la variación del stock:
    // ENTRADA  -> positiva
    // SALIDA   -> negativa
    // AJUSTE   -> positiva o negativa, pero nunca cero.
    property Cantidad: Integer
      read FCantidad write FCantidad;

    property Motivo: string
      read FMotivo write FMotivo;
  end;

// Convierte el tipo Delphi al texto que se almacenará en SQLite.
function TipoMovimientoStockToString(
  ATipo: TTipoMovimientoStock
): string;

// Convierte el texto recuperado de SQLite al tipo Delphi.
function StringToTipoMovimientoStock(
  const AValor: string
): TTipoMovimientoStock;

implementation



//************************************************



function TipoMovimientoStockToString(
  ATipo: TTipoMovimientoStock
): string;
begin
  case ATipo of
    tmsEntrada:
      Result := 'ENTRADA';

    tmsSalida:
      Result := 'SALIDA';

    tmsAjuste:
      Result := 'AJUSTE';
  else
    raise EArgumentException.Create(
      'Tipo de movimiento de stock no válido.'
    );
  end;
end;

function StringToTipoMovimientoStock(
  const AValor: string
): TTipoMovimientoStock;
begin
  if SameText(AValor, 'ENTRADA') then
    Result := tmsEntrada
  else if SameText(AValor, 'SALIDA') then
    Result := tmsSalida
  else if SameText(AValor, 'AJUSTE') then
    Result := tmsAjuste
  else
    raise EConvertError.CreateFmt(
      'Tipo de movimiento de stock desconocido: %s',
      [AValor]
    );
end;

end.
