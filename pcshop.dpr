program pcshop;

uses
  Vcl.Forms,
  principal in 'principal.pas' {frmprincipal},
  productos in 'productos.pas' {frmproductos},
  uproducto in 'uproducto.pas',
  Datos in 'Datos.pas' {dmDatos: TDataModule},
  Ventas in 'Ventas.pas' {frmVentas};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmDatos, dmDatos);
  Application.CreateForm(Tfrmprincipal, frmprincipal);
  Application.CreateForm(Tfrmproductos, frmproductos);
  Application.CreateForm(TfrmVentas, frmVentas);
  Application.Run;
end.
