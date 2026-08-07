program pcshop;

uses
  Vcl.Forms,
  principal in 'principal.pas' {frmprincipal},
  productos in 'productos.pas' {frmproductos},
  uproducto in 'uproducto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrmprincipal, frmprincipal);
  Application.CreateForm(Tfrmproductos, frmproductos);
  Application.Run;
end.
