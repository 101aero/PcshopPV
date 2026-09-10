unit HistorialVentas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Grids, Vcl.StdCtrls, System.Generics.Collections,uVenta,Datos;

type
  TfrmHistorialVentas = class(TForm)
    lblTitulo: TLabel;
    grpBusqueda: TGroupBox;
    lblBuscar: TLabel;
    edtBuscarVenta: TEdit;
    btnBuscarVenta: TButton;
    btnMostrarVentas: TButton;
    grdVentas: TStringGrid;
    grpResumen: TGroupBox;
    lblTotalVentas: TLabel;
    lblUnidadesVendidas: TLabel;
    lblImporteVentas: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnBuscarVentaClick(Sender: TObject);
    procedure btnMostrarVentasClick(Sender: TObject);


  private
    { Private declarations }

  // Mantiene en memoria las ventas recuperadas desde SQLite.
  // El formulario utilizará esta colección para rellenar el grid.
  FVentas: TObjectList<TVenta>;

  procedure ActualizarTablaVentas;


  procedure ActualizarResumenVentas;


  public
    { Public declarations }
  end;

var
  frmHistorialVentas: TfrmHistorialVentas;

implementation

{$R *.dfm}

procedure TfrmHistorialVentas.FormCreate(Sender: TObject);
begin
  FVentas := TObjectList<TVenta>.Create(True);

  // Preparamos las columnas visibles del historial.
  grdVentas.ColCount := 7;
  grdVentas.RowCount := 2;
  grdVentas.FixedRows := 1;

  grdVentas.Cells[0, 0] := 'Fecha';
  grdVentas.Cells[1, 0] := 'Código';
  grdVentas.Cells[2, 0] := 'Producto';
  grdVentas.Cells[3, 0] := 'Cliente';
  grdVentas.Cells[4, 0] := 'Cantidad';
  grdVentas.Cells[5, 0] := 'Precio';
  grdVentas.Cells[6, 0] := 'Total';
end;



procedure TfrmHistorialVentas.ActualizarResumenVentas;
var
  TotalVentas: Integer;
  UnidadesVendidas: Integer;
  ImporteTotal: Double;
begin
  // Pedimos al Data Module las métricas calculadas en SQLite.
  dmDatos.ObtenerResumenVentas(
    TotalVentas,
    UnidadesVendidas,
    ImporteTotal
  );

  // El formulario solo presenta los resultados.
  lblTotalVentas.Caption :=
    'Ventas: ' + IntToStr(TotalVentas);

  lblUnidadesVendidas.Caption :=
    'Unidades: ' + IntToStr(UnidadesVendidas);

  lblImporteVentas.Caption :=
    'Importe total: ' +
    FormatFloat('0.00', ImporteTotal) +
    ' €';
end;



procedure TfrmHistorialVentas.FormShow(Sender: TObject);
begin
  // Cada vez que se abre el historial,
  // recargamos las ventas directamente desde SQLite.
  dmDatos.CargarVentas(FVentas);

  // Actualizamos el grid con los datos recuperados.
  ActualizarTablaVentas;

  dmDatos.CargarVentas(FVentas);


  ActualizarTablaVentas;

  // Actualizamos también el resumen comercial.
  ActualizarResumenVentas;
end;




procedure TfrmHistorialVentas.ActualizarTablaVentas;
var
  I: Integer;
  Venta: TVenta;
begin
  // Dejamos una fila fija para los encabezados
  // y tantas filas como ventas existan.
  grdVentas.RowCount := FVentas.Count + 1;

  // Si no hay ventas, conservamos una fila vacía
  // debajo de los encabezados.
  if grdVentas.RowCount < 2 then
    grdVentas.RowCount := 2;

  // Limpiamos las filas de datos antes de reconstruir el historial.
  for I := 1 to grdVentas.RowCount - 1 do
    grdVentas.Rows[I].Clear;

  for I := 0 to FVentas.Count - 1 do
  begin
    Venta := FVentas[I];

    grdVentas.Cells[0, I + 1] := Venta.Fecha;
    grdVentas.Cells[1, I + 1] := Venta.CodigoProducto;
    grdVentas.Cells[2, I + 1] := Venta.Producto;
    grdVentas.Cells[3, I + 1] := Venta.Cliente;
    grdVentas.Cells[4, I + 1] := IntToStr(Venta.Cantidad);

    grdVentas.Cells[5, I + 1] :=
      FormatFloat('0.00', Venta.PrecioUnitario);

    grdVentas.Cells[6, I + 1] :=
      FormatFloat('0.00', Venta.Total);
  end;




end;

procedure TfrmHistorialVentas.btnBuscarVentaClick(Sender: TObject);
begin
  // Evitamos ejecutar una búsqueda sin criterio.
  if Trim(edtBuscarVenta.Text) = '' then
  begin
    ShowMessage(
      'Introduce un código o nombre de producto.'
    );

    edtBuscarVenta.SetFocus;
    Exit;
  end;

  // El formulario entrega únicamente el criterio.
  // La consulta SQL permanece en el Data Module.
  dmDatos.BuscarVentas(
    FVentas,
    edtBuscarVenta.Text
  );

  // Reconstruimos el grid con las ventas encontradas.
  ActualizarTablaVentas;
end;


procedure TfrmHistorialVentas.btnMostrarVentasClick(Sender: TObject);
begin
  // Quitamos el criterio de búsqueda.
  edtBuscarVenta.Clear;

  // Recargamos el historial completo desde SQLite.
  dmDatos.CargarVentas(FVentas);

  // Reconstruimos el grid con todas las ventas.
  ActualizarTablaVentas;
end;


end.
