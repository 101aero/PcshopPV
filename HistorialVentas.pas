unit HistorialVentas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Grids, Vcl.StdCtrls, System.Generics.Collections, uVenta, uCliente, Datos;

type
  TfrmHistorialVentas = class(TForm)
    lblTitulo: TLabel;
    grpBusqueda: TGroupBox;
    lblBuscar: TLabel;
    edtBuscarVenta: TEdit;
    btnBuscarVenta: TButton;
    btnMostrarVentas: TButton;
    lblClienteFiltro: TLabel;
    cboClienteFiltro: TComboBox;
    grdVentas: TStringGrid;
    grpResumen: TGroupBox;
    lblTotalVentas: TLabel;
    lblUnidadesVendidas: TLabel;
    lblImporteVentas: TLabel;
    btnVerTicket: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnBuscarVentaClick(Sender: TObject);
    procedure btnMostrarVentasClick(Sender: TObject);
    procedure cboClienteFiltroChange(Sender: TObject);
    procedure btnVerTicketClick(Sender: TObject);


  private
    { Private declarations }

  // Mantiene en memoria las ventas recuperadas desde SQLite.
  // El formulario utilizará esta colección para rellenar el grid.
  FVentas: TObjectList<TVenta>;

  // Colección de clientes utilizada por el filtro del historial.
  // Los datos se cargan mediante el Data Module; el formulario no ejecuta SQL.
  FClientesFiltro: TObjectList<TCliente>;

  procedure CargarClientesFiltro;
  function ObtenerIdClienteFiltro: Integer;
  procedure AplicarFiltroCliente;
  procedure ActualizarTablaVentas;


  procedure ActualizarResumenVentas;


  public
    { Public declarations }
  end;

var
  frmHistorialVentas: TfrmHistorialVentas;




  // *******************************
  // IMPLEMENTATION
  //
  //

implementation




{$R *.dfm}

procedure TfrmHistorialVentas.FormCreate(Sender: TObject);
begin
  FVentas := TObjectList<TVenta>.Create(True);
  FClientesFiltro := TObjectList<TCliente>.Create(True);

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





procedure TfrmHistorialVentas.btnVerTicketClick(Sender: TObject);
var
  Venta: TVenta;
  TextoCliente: string;
begin
  // La fila 0 contiene los encabezados.
  // Cada fila de datos corresponde al mismo índice de FVentas - 1.
  if (FVentas.Count = 0) or
     (grdVentas.Row < 1) or
     (grdVentas.Row > FVentas.Count) then
  begin
    ShowMessage('Selecciona una venta para ver su ticket.');
    Exit;
  end;

  Venta := FVentas[grdVentas.Row - 1];

  // En el modelo, IdCliente = 0 representa una venta anónima.
  if Venta.IdCliente = 0 then
    TextoCliente := 'Venta anónima'
  else
    TextoCliente := Venta.Cliente;

  ShowMessage(
    'PC SHOP' + sLineBreak +
    'Ticket de venta' + sLineBreak +
    '--------------------------------' + sLineBreak +
    'Venta: #' + IntToStr(Venta.IdVenta) + sLineBreak +
    'Fecha: ' + Venta.Fecha + sLineBreak +
    sLineBreak +
    'Producto: ' + Venta.Producto + sLineBreak +
    'Cantidad: ' + IntToStr(Venta.Cantidad) + sLineBreak +
    'Precio: ' + FormatFloat('0.00', Venta.PrecioUnitario) + ' €' + sLineBreak +
    'Total: ' + FormatFloat('0.00', Venta.Total) + ' €' + sLineBreak +
    sLineBreak +
    'Cliente: ' + TextoCliente
  );
end;



procedure TfrmHistorialVentas.CargarClientesFiltro;
var
  I: Integer;
begin
  // Dejamos siempre disponible la opción general, incluso antes de
  // recuperar los clientes desde SQLite.
  cboClienteFiltro.Items.BeginUpdate;
  try
    cboClienteFiltro.Items.Clear;
    cboClienteFiltro.Items.Add('Todos los clientes');
    cboClienteFiltro.ItemIndex := 0;

    // Reutilizamos la carga de CLIENTES ya existente en el Data Module.
    dmDatos.CargarClientes(FClientesFiltro);

    for I := 0 to FClientesFiltro.Count - 1 do
      cboClienteFiltro.Items.Add(
        IntToStr(FClientesFiltro[I].IdCliente) + ' - ' +
        FClientesFiltro[I].Nombre
      );
  finally
    cboClienteFiltro.Items.EndUpdate;
  end;
end;


function TfrmHistorialVentas.ObtenerIdClienteFiltro: Integer;
begin
  // El primer elemento representa el historial general.
  if cboClienteFiltro.ItemIndex <= 0 then
    Exit(0);

  // Los clientes se añaden al ComboBox en el mismo orden
  // que mantienen dentro de FClientesFiltro.
  Result := FClientesFiltro[cboClienteFiltro.ItemIndex - 1].IdCliente;
end;


procedure TfrmHistorialVentas.AplicarFiltroCliente;
begin
  // El Data Module decide si devuelve todas las ventas
  // o solamente las del cliente seleccionado.
  dmDatos.CargarVentas(
    FVentas,
    ObtenerIdClienteFiltro
  );

  ActualizarTablaVentas;
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
  // Recargamos el selector desde CLIENTES sin duplicar SQL en el formulario.
  CargarClientesFiltro;

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




procedure TfrmHistorialVentas.FormDestroy(Sender: TObject);
begin
  FClientesFiltro.Free;
  FVentas.Free;
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

procedure TfrmHistorialVentas.cboClienteFiltroChange(Sender: TObject);
begin
  // Al cambiar de cliente dejamos atrás cualquier texto de búsqueda
  // para que la vista refleje claramente el filtro seleccionado.
  edtBuscarVenta.Clear;

  AplicarFiltroCliente;
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
