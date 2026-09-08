unit Clientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, System.Generics.Collections,
  uCliente, Datos;

type
  TfrmClientes = class(TForm)
    lblTitulo: TLabel;
    grpBusqueda: TGroupBox;
    lblBuscar: TLabel;
    edtBuscarCliente: TEdit;
    btnBuscarCliente: TButton;
    btnMostrarClientes: TButton;
    grpDatosCliente: TGroupBox;
    lblNombreCliente: TLabel;
    lblEmailCliente: TLabel;
    lblTelefonoCliente: TLabel;
    edtNombreCliente: TEdit;
    edtEmailCliente: TEdit;
    edtTelefonoCliente: TEdit;
    btnNuevoCliente: TButton;
    btnGuardarCliente: TButton;
    btnEliminarCliente: TButton;
    btnCerrarCliente: TButton;
    lblModoCliente: TLabel;
    grdClientes: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnNuevoClienteClick(Sender: TObject);
    procedure btnGuardarClienteClick(Sender: TObject);
    procedure btnEliminarClienteClick(Sender: TObject);
    procedure btnBuscarClienteClick(Sender: TObject);
    procedure btnMostrarClientesClick(Sender: TObject);
    procedure btnCerrarClienteClick(Sender: TObject);
    procedure grdClientesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    FClientes: TObjectList<TCliente>;
    FIndiceClienteSeleccionado: Integer;

    procedure ActualizarTablaClientes;
    procedure LimpiarCamposCliente;
    procedure RefrescarVistaClientes;
    procedure PrepararModoAlta;
  public
    { Public declarations }
  end;

var
  frmClientes: TfrmClientes;

implementation

{$R *.dfm}

procedure TfrmClientes.FormCreate(Sender: TObject);
begin
  FClientes := TObjectList<TCliente>.Create(True);
  FIndiceClienteSeleccionado := -1;

  grdClientes.ColCount := 4;
  grdClientes.RowCount := 2;
  grdClientes.FixedRows := 1;
  grdClientes.FixedCols := 0;
  grdClientes.Options :=
    grdClientes.Options + [goRowSelect] - [goEditing];

  grdClientes.Cells[0, 0] := 'Id';
  grdClientes.Cells[1, 0] := 'Nombre';
  grdClientes.Cells[2, 0] := 'Email';
  grdClientes.Cells[3, 0] := 'Teléfono';

  grdClientes.ColWidths[0] := 70;
  grdClientes.ColWidths[1] := 220;
  grdClientes.ColWidths[2] := 280;
  grdClientes.ColWidths[3] := 160;

  PrepararModoAlta;
end;

procedure TfrmClientes.FormDestroy(Sender: TObject);
begin
  FClientes.Free;
end;

procedure TfrmClientes.FormShow(Sender: TObject);
begin
  // Siempre partimos del estado persistido real de SQLite.
  edtBuscarCliente.Clear;
  PrepararModoAlta;
  RefrescarVistaClientes;
end;

procedure TfrmClientes.PrepararModoAlta;
begin
  FIndiceClienteSeleccionado := -1;
  lblModoCliente.Caption := 'Modo: Alta';
  LimpiarCamposCliente;
end;

procedure TfrmClientes.LimpiarCamposCliente;
begin
  edtNombreCliente.Clear;
  edtEmailCliente.Clear;
  edtTelefonoCliente.Clear;
end;

procedure TfrmClientes.ActualizarTablaClientes;
var
  I: Integer;
  Cliente: TCliente;
begin
  grdClientes.RowCount := FClientes.Count + 1;

  if grdClientes.RowCount < 2 then
    grdClientes.RowCount := 2;

  for I := 1 to grdClientes.RowCount - 1 do
    grdClientes.Rows[I].Clear;

  for I := 0 to FClientes.Count - 1 do
  begin
    Cliente := FClientes[I];

    grdClientes.Cells[0, I + 1] := IntToStr(Cliente.IdCliente);
    grdClientes.Cells[1, I + 1] := Cliente.Nombre;
    grdClientes.Cells[2, I + 1] := Cliente.Email;
    grdClientes.Cells[3, I + 1] := Cliente.Telefono;
  end;
end;

procedure TfrmClientes.RefrescarVistaClientes;
begin
  // Si existe búsqueda activa, mantenemos el filtro.
  // En caso contrario cargamos todos los clientes.
  if Trim(edtBuscarCliente.Text) <> '' then
    dmDatos.BuscarClientes(FClientes, edtBuscarCliente.Text)
  else
    dmDatos.CargarClientes(FClientes);

  ActualizarTablaClientes;
end;

procedure TfrmClientes.btnNuevoClienteClick(Sender: TObject);
begin
  PrepararModoAlta;
  edtNombreCliente.SetFocus;
end;

procedure TfrmClientes.btnGuardarClienteClick(Sender: TObject);
var
  Cliente: TCliente;
  EsAlta: Boolean;
begin
  if Trim(edtNombreCliente.Text) = '' then
  begin
    ShowMessage('Introduce el nombre del cliente.');
    edtNombreCliente.SetFocus;
    Exit;
  end;

  EsAlta := FIndiceClienteSeleccionado < 0;

  Cliente := TCliente.Create;
  try
    if not EsAlta then
      Cliente.IdCliente :=
        FClientes[FIndiceClienteSeleccionado].IdCliente;

    Cliente.Nombre := Trim(edtNombreCliente.Text);
    Cliente.Email := Trim(edtEmailCliente.Text);
    Cliente.Telefono := Trim(edtTelefonoCliente.Text);

    // Primero SQLite. Solo si confirma la operación
    // reconstruimos después memoria e interfaz.
    if EsAlta then
    begin
      if not dmDatos.InsertarCliente(Cliente) then
      begin
        ShowMessage(dmDatos.UltimoError);
        Exit;
      end;
    end
    else
    begin
      if not dmDatos.ActualizarCliente(Cliente) then
      begin
        ShowMessage(dmDatos.UltimoError);
        Exit;
      end;
    end;
  finally
    Cliente.Free;
  end;

  // En un alta mostramos la lista completa para que el nuevo
  // cliente sea visible aunque antes hubiese un filtro activo.
  if EsAlta then
    edtBuscarCliente.Clear;

  RefrescarVistaClientes;
  PrepararModoAlta;

  if EsAlta then
    ShowMessage('Cliente registrado correctamente.')
  else
    ShowMessage('Cliente actualizado correctamente.');
end;

procedure TfrmClientes.btnEliminarClienteClick(Sender: TObject);
var
  Cliente: TCliente;
begin
  if (FIndiceClienteSeleccionado < 0) or
     (FIndiceClienteSeleccionado >= FClientes.Count) then
  begin
    ShowMessage('Selecciona un cliente de la tabla.');
    Exit;
  end;

  Cliente := FClientes[FIndiceClienteSeleccionado];

  if MessageDlg(
    '¿Deseas eliminar el cliente "' + Cliente.Nombre + '"?',
    mtConfirmation,
    [mbYes, mbNo],
    0
  ) <> mrYes then
    Exit;

  // SQLite elimina primero; la colección se recarga
  // únicamente después de recibir confirmación.
  if not dmDatos.EliminarCliente(Cliente.IdCliente) then
  begin
    ShowMessage(dmDatos.UltimoError);
    Exit;
  end;

  RefrescarVistaClientes;
  PrepararModoAlta;

  ShowMessage('Cliente eliminado correctamente.');
end;

procedure TfrmClientes.btnBuscarClienteClick(Sender: TObject);
begin
  if Trim(edtBuscarCliente.Text) = '' then
  begin
    ShowMessage('Introduce un nombre, email o teléfono para buscar.');
    edtBuscarCliente.SetFocus;
    Exit;
  end;

  dmDatos.BuscarClientes(FClientes, edtBuscarCliente.Text);
  ActualizarTablaClientes;

  FIndiceClienteSeleccionado := -1;
  lblModoCliente.Caption := 'Modo: Alta';
  LimpiarCamposCliente;
end;

procedure TfrmClientes.btnMostrarClientesClick(Sender: TObject);
begin
  edtBuscarCliente.Clear;
  dmDatos.CargarClientes(FClientes);
  ActualizarTablaClientes;

  FIndiceClienteSeleccionado := -1;
  lblModoCliente.Caption := 'Modo: Alta';
  LimpiarCamposCliente;
end;

procedure TfrmClientes.btnCerrarClienteClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmClientes.grdClientesSelectCell(
  Sender: TObject;
  ACol, ARow: Integer;
  var CanSelect: Boolean
);
var
  Indice: Integer;
  Cliente: TCliente;
begin
  if ARow < 1 then
    Exit;

  Indice := ARow - 1;

  if (Indice < 0) or (Indice >= FClientes.Count) then
    Exit;

  FIndiceClienteSeleccionado := Indice;
  Cliente := FClientes[Indice];

  edtNombreCliente.Text := Cliente.Nombre;
  edtEmailCliente.Text := Cliente.Email;
  edtTelefonoCliente.Text := Cliente.Telefono;

  lblModoCliente.Caption :=
    'Modo: Edición - Id ' + IntToStr(Cliente.IdCliente);
end;

end.
