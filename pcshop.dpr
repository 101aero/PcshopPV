program pcshop;

uses
  Vcl.Forms,
  principal in 'principal.pas' {frmprincipal},
  productos in 'productos.pas' {frmproductos},
  uproducto in 'uproducto.pas',
  Datos in 'Datos.pas' {dmDatos: TDataModule},
  Ventas in 'Ventas.pas' {frmVentas},
  HistorialVentas in 'HistorialVentas.pas' {frmHistorialVentas},
  uVenta in 'uVenta.pas',
  uCliente in 'uCliente.pas',
  Clientes in 'Clientes.pas' {frmClientes};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmDatos, dmDatos);
  Application.CreateForm(Tfrmprincipal, frmprincipal);
  Application.CreateForm(Tfrmproductos, frmproductos);
  Application.CreateForm(TfrmVentas, frmVentas);
  Application.CreateForm(TfrmHistorialVentas, frmHistorialVentas);
  Application.Run;
end.
