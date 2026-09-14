unit MovimientoStock;

interface

uses
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
  uProducto,
  uMovimientoStock,
  Datos;

type
  TfrmMovimientoStock = class(TForm)
    grpMovimiento: TGroupBox;
    lblProducto: TLabel;
    cboProducto: TComboBox;
    lblStockActual: TLabel;
    lblTipo: TLabel;
    cboTipo: TComboBox;
    lblCantidad: TLabel;
    edtCantidad: TEdit;
    lblAyudaCantidad: TLabel;
    lblMotivo: TLabel;
    edtMotivo: TEdit;
    btnAplicar: TButton;
    btnCerrar: TButton;
    grpHistorial: TGroupBox;
    grdMovimientos: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cboProductoChange(Sender: TObject);
    procedure cboTipoChange(Sender: TObject);
    procedure btnAplicarClick(Sender: TObject);
    procedure btnCerrarClick(Sender: TObject);
  private
    FProductos: TObjectList<TProducto>;
    FMovimientos: TObjectList<TMovimientoStock>;
    procedure CargarProductos;
    procedure CargarMovimientos;
    procedure ActualizarTablaMovimientos;
    procedure ActualizarStockMostrado;
    procedure ActualizarAyudaCantidad;
  public
  end;

var
  frmMovimientoStock: TfrmMovimientoStock;

implementation

{$R *.dfm}

procedure TfrmMovimientoStock.FormCreate(Sender: TObject);
begin
  // La colecci√≥n es propietaria de los TProducto cargados desde SQLite.
  FProductos := TObjectList<TProducto>.Create(True);
  FMovimientos := TObjectList<TMovimientoStock>.Create(True);

  // Configuramos el historial desde el formulario, sin crear controles por cÛdigo.
  grdMovimientos.ColCount := 6;
  grdMovimientos.RowCount := 2;
  grdMovimientos.FixedRows := 1;
  grdMovimientos.Cells[0, 0] := 'Id';
  grdMovimientos.Cells[1, 0] := 'Fecha';
  grdMovimientos.Cells[2, 0] := 'CÛdigo';
  grdMovimientos.Cells[3, 0] := 'Tipo';
  grdMovimientos.Cells[4, 0] := 'Cantidad';
  grdMovimientos.Cells[5, 0] := 'Motivo';

  // El tipo se representa en la interfaz con opciones cerradas.
  // El formulario traducir√° despu√©s cada opci√≥n al enumerado Delphi.
  cboTipo.Items.Clear;
  cboTipo.Items.Add('ENTRADA');
  cboTipo.Items.Add('SALIDA');
  cboTipo.Items.Add('AJUSTE');
  cboTipo.ItemIndex := 0;

  ActualizarAyudaCantidad;
end;

procedure TfrmMovimientoStock.FormDestroy(Sender: TObject);
begin
  FMovimientos.Free;
  FProductos.Free;
end;

procedure TfrmMovimientoStock.FormShow(Sender: TObject);
begin
  // Cada apertura recupera el estado actual de PRODUCTOS desde SQLite.
  CargarProductos;

  edtCantidad.Clear;
  edtMotivo.Clear;
  cboTipo.ItemIndex := 0;
  ActualizarAyudaCantidad;

  // Recuperamos tambiÈn la trazabilidad ya registrada en SQLite.
  CargarMovimientos;
end;

procedure TfrmMovimientoStock.CargarProductos;
var
  I: Integer;
begin
  dmDatos.CargarProductos(FProductos);

  cboProducto.Items.BeginUpdate;
  try
    cboProducto.Items.Clear;

    for I := 0 to FProductos.Count - 1 do
      cboProducto.Items.Add(
        FProductos[I].Codigo + ' - ' +
        FProductos[I].Nombre
      );

    cboProducto.ItemIndex := -1;
  finally
    cboProducto.Items.EndUpdate;
  end;

  ActualizarStockMostrado;
end;


procedure TfrmMovimientoStock.CargarMovimientos;
begin
  // El formulario pide los datos, pero la consulta SQL permanece en el Data Module.
  dmDatos.CargarMovimientosStock(FMovimientos);
  ActualizarTablaMovimientos;
end;

procedure TfrmMovimientoStock.ActualizarTablaMovimientos;
var
  I: Integer;
  Movimiento: TMovimientoStock;
begin
  grdMovimientos.RowCount := FMovimientos.Count + 1;

  // TStringGrid necesita al menos una fila de datos adem·s de la cabecera
  // para mantener una presentaciÛn estable cuando no hay movimientos.
  if grdMovimientos.RowCount < 2 then
    grdMovimientos.RowCount := 2;

  for I := 1 to grdMovimientos.RowCount - 1 do
    grdMovimientos.Rows[I].Clear;

  for I := 0 to FMovimientos.Count - 1 do
  begin
    Movimiento := FMovimientos[I];

    grdMovimientos.Cells[0, I + 1] := IntToStr(Movimiento.IdMovimiento);
    grdMovimientos.Cells[1, I + 1] := Movimiento.Fecha;
    grdMovimientos.Cells[2, I + 1] := Movimiento.CodigoProducto;
    grdMovimientos.Cells[3, I + 1] := TipoMovimientoStockToString(Movimiento.Tipo);
    grdMovimientos.Cells[4, I + 1] := IntToStr(Movimiento.Cantidad);
    grdMovimientos.Cells[5, I + 1] := Movimiento.Motivo;
  end;
end;

procedure TfrmMovimientoStock.ActualizarStockMostrado;
begin
  if (cboProducto.ItemIndex < 0) or
     (cboProducto.ItemIndex >= FProductos.Count) then
  begin
    lblStockActual.Caption := 'Stock actual: -';
    Exit;
  end;

  lblStockActual.Caption :=
    'Stock actual: ' +
    IntToStr(FProductos[cboProducto.ItemIndex].Stock);
end;

procedure TfrmMovimientoStock.ActualizarAyudaCantidad;
begin
  case cboTipo.ItemIndex of
    0:
      lblAyudaCantidad.Caption :=
        'ENTRADA: escribe una cantidad positiva, por ejemplo 5.';

    1:
      lblAyudaCantidad.Caption :=
        'SALIDA: escribe una cantidad positiva; PC Shop la convertir√° en -cantidad.';

    2:
      lblAyudaCantidad.Caption :=
        'AJUSTE: usa signo, por ejemplo +3 o -2.';
  else
    lblAyudaCantidad.Caption := '';
  end;
end;

procedure TfrmMovimientoStock.cboProductoChange(Sender: TObject);
begin
  ActualizarStockMostrado;
end;

procedure TfrmMovimientoStock.cboTipoChange(Sender: TObject);
begin
  ActualizarAyudaCantidad;
end;

procedure TfrmMovimientoStock.btnAplicarClick(Sender: TObject);
var
  Producto: TProducto;
  Movimiento: TMovimientoStock;
  CantidadIntroducida: Integer;
  Variacion: Integer;
begin
  if (cboProducto.ItemIndex < 0) or
     (cboProducto.ItemIndex >= FProductos.Count) then
  begin
    ShowMessage('Selecciona un producto.');
    cboProducto.SetFocus;
    Exit;
  end;

  if cboTipo.ItemIndex < 0 then
  begin
    ShowMessage('Selecciona el tipo de movimiento.');
    cboTipo.SetFocus;
    Exit;
  end;

  if not TryStrToInt(Trim(edtCantidad.Text), CantidadIntroducida) then
  begin
    ShowMessage('Introduce una cantidad entera v√°lida.');
    edtCantidad.SetFocus;
    Exit;
  end;

  if Trim(edtMotivo.Text) = '' then
  begin
    ShowMessage('Introduce el motivo del movimiento.');
    edtMotivo.SetFocus;
    Exit;
  end;

  Movimiento := TMovimientoStock.Create;
  try
    Producto := FProductos[cboProducto.ItemIndex];

    Movimiento.CodigoProducto := Producto.Codigo;
    Movimiento.Motivo := Trim(edtMotivo.Text);

    case cboTipo.ItemIndex of
      0: // ENTRADA
        begin
          if CantidadIntroducida <= 0 then
          begin
            ShowMessage('En una entrada la cantidad debe ser mayor que cero.');
            edtCantidad.SetFocus;
            Exit;
          end;

          Movimiento.Tipo := tmsEntrada;
          Variacion := CantidadIntroducida;
        end;

      1: // SALIDA
        begin
          if CantidadIntroducida <= 0 then
          begin
            ShowMessage('En una salida introduce una cantidad mayor que cero.');
            edtCantidad.SetFocus;
            Exit;
          end;

          Movimiento.Tipo := tmsSalida;
          Variacion := -CantidadIntroducida;
        end;

      2: // AJUSTE
        begin
          if CantidadIntroducida = 0 then
          begin
            ShowMessage('Un ajuste debe ser distinto de cero.');
            edtCantidad.SetFocus;
            Exit;
          end;

          Movimiento.Tipo := tmsAjuste;
          Variacion := CantidadIntroducida;
        end;
    else
      Exit;
    end;

    Movimiento.Cantidad := Variacion;

    // El formulario no ejecuta SQL. El Data Module cambia PRODUCTOS.Stock
    // y registra MOVIMIENTOS_STOCK dentro de una √∫nica transacci√≥n.
    if not dmDatos.AplicarMovimientoStock(Movimiento) then
    begin
      ShowMessage(dmDatos.UltimoError);
      Exit;
    end;

    // SQLite ya confirm√≥ las dos operaciones con COMMIT.
    // Actualizamos ahora la copia del producto que mantiene este formulario.
    Producto.Stock := Producto.Stock + Variacion;
    ActualizarStockMostrado;

    // El movimiento ya est· confirmado en SQLite; refrescamos el historial.
    CargarMovimientos;

    edtCantidad.Clear;
    edtMotivo.Clear;
    edtCantidad.SetFocus;

    ShowMessage('Movimiento de stock registrado correctamente.');

  finally
    Movimiento.Free;
  end;
end;

procedure TfrmMovimientoStock.btnCerrarClick(Sender: TObject);
begin
  Close;
end;

end.
