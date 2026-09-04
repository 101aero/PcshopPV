unit Ventas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,System.Generics.Collections,
uProducto, Datos;

type
  TfrmVentas = class(TForm)
    grpVenta: TGroupBox;
    lblProducto: TLabel;
    lblCantidad: TLabel;
    cboProducto: TComboBox;
    edtCantidad: TEdit;
    lblStockventa: TLabel;
    lblPrecioVenta: TLabel;
    lblTotalVenta: TLabel;
    btnRegistrarVenta: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cboProductoChange(Sender: TObject);
    procedure edtCantidadChange(Sender: TObject);
    procedure btnRegistrarVentaClick(Sender: TObject);
  private
    { Private declarations }

  // Mantiene los productos cargados desde SQLite.
  // El índice coincidirá después con el ItemIndex del ComboBox.
  FProductosVenta: TObjectList<TProducto>;



  public
    { Public declarations }
  end;

var
  frmVentas: TfrmVentas;

implementation

{$R *.dfm}

procedure TfrmVentas.btnRegistrarVentaClick(Sender: TObject);
var
  Cantidad: Integer;
  Producto: TProducto;
begin
  // Debe existir un producto seleccionado.
  if cboProducto.ItemIndex < 0 then
  begin
    ShowMessage('Selecciona un producto.');
    cboProducto.SetFocus;
    Exit;
  end;

  // La cantidad debe ser un entero válido.
  if not TryStrToInt(Trim(edtCantidad.Text), Cantidad) then
  begin
    ShowMessage('Introduce una cantidad válida.');
    edtCantidad.SetFocus;
    Exit;
  end;

  if Cantidad <= 0 then
  begin
    ShowMessage('La cantidad debe ser mayor que cero.');
    edtCantidad.SetFocus;
    Exit;
  end;

  Producto :=
    FProductosVenta[cboProducto.ItemIndex];

  // Esta comprobación permite dar al usuario un mensaje
  // inmediato antes de intentar registrar la operación.
  //
  // Aun así, SQLite vuelve a comprobar el stock dentro
  // de la transacción para garantizar la consistencia real.
  if Cantidad > Producto.Stock then
  begin
    ShowMessage(
      'No hay stock suficiente.' +
      sLineBreak +
      'Stock disponible: ' +
      IntToStr(Producto.Stock)
    );

    edtCantidad.SetFocus;
    Exit;
  end;

  // El formulario no ejecuta SQL.
  // La venta completa se delega al Data Module.
  if not dmDatos.RegistrarVenta(
    Producto,
    Cantidad
  ) then
  begin
    ShowMessage(dmDatos.UltimoError);
    Exit;
  end;

  // SQLite ya ha confirmado mediante COMMIT
// tanto la venta como la reducción del stock.
// Ahora sí actualizamos la copia en memoria.
Producto.Stock := Producto.Stock - Cantidad;

// Reflejamos inmediatamente el nuevo stock.
lblStockVenta.Caption :=
  'Stock disponible: ' +
  IntToStr(Producto.Stock);

// Dejamos preparada la siguiente venta.
edtCantidad.Text := '1';

lblTotalVenta.Caption :=
  'Total: ' +
  FormatFloat('0.00', Producto.Precio) +
  ' €';

ShowMessage(
  'Venta registrada correctamente.' +
  sLineBreak +
  sLineBreak +
  dmDatos.ObtenerUltimaVentaResumen
);

end;
// BTN VENTA








procedure TfrmVentas.cboProductoChange(Sender: TObject);
var
Producto: TProducto;
begin
  // Comprobamos que exista una selección válida.
  if cboProducto.ItemIndex < 0 then
    Exit;

  // El índice del ComboBox coincide con el índice
  // de la colección cargada desde SQLite.
  Producto := FProductosVenta[cboProducto.ItemIndex];

  // Mostramos los datos principales del producto seleccionado.
  lblStockVenta.Caption :=
    'Stock disponible: ' +
    IntToStr(Producto.Stock);

  lblPrecioVenta.Caption :=
    'Precio unitario: ' +
    FormatFloat('0.00', Producto.Precio) +
    ' €';

  // El total se calculará después según la cantidad.
  lblTotalVenta.Caption := 'Total: -';
end;





procedure TfrmVentas.edtCantidadChange(Sender: TObject);
var
  Cantidad: Integer;
  Producto: TProducto;
  Total: Double;
begin
  // Necesitamos un producto seleccionado.
  if cboProducto.ItemIndex < 0 then
  begin
    lblTotalVenta.Caption := 'Total: -';
    Exit;
  end;

  // La cantidad debe ser un entero válido y mayor que cero.
  if not TryStrToInt(Trim(edtCantidad.Text), Cantidad) then
  begin
    lblTotalVenta.Caption := 'Total: -';
    Exit;
  end;

  if Cantidad <= 0 then
  begin
    lblTotalVenta.Caption := 'Total: -';
    Exit;
  end;

  Producto := FProductosVenta[cboProducto.ItemIndex];

  Total := Producto.Precio * Cantidad;

  lblTotalVenta.Caption :=
    'Total: ' +
    FormatFloat('0.00', Total) +
    ' €';
end;






procedure TfrmVentas.FormCreate(Sender: TObject);
begin
    // La lista FProductosVenta será propietaria de los objetos TProducto
  // que carguemos desde SQLite.
  FProductosVenta := TObjectList<TProducto>.Create(True);

end;

procedure TfrmVentas.FormDestroy(Sender: TObject);
begin
 FProductosVenta.Free;
end;

procedure TfrmVentas.FormShow(Sender: TObject);
var
I: integer;
begin
  // Recargamos los productos desde SQLite cada vez
  // que se abre el formulario de ventas.
  dmDatos.CargarProductos(FProductosVenta);

  cboProducto.Items.BeginUpdate;
  try
    cboProducto.Items.Clear;

    for I := 0 to FProductosVenta.Count - 1 do
    begin
      // Mostramos código y nombre para identificar
      // claramente el producto que se va a vender.
      cboProducto.Items.Add(
        FProductosVenta[I].Codigo + ' - ' +
        FProductosVenta[I].Nombre
      );
    end;

    // Obligamos al usuario a elegir un producto.
    cboProducto.ItemIndex := -1;

  finally
    cboProducto.Items.EndUpdate;
  end;
end;

end.
