unit principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Ventas, HistorialVentas, Clientes, MovimientoStock;

type
  Tfrmprincipal = class(TForm)
    MainMenu1: TMainMenu;
    Archivo1: TMenuItem;
    Salir1: TMenuItem;
    Gestin1: TMenuItem;
    Gestin2: TMenuItem;
    Clientes1: TMenuItem;
    Clientes2: TMenuItem;
    Informes1: TMenuItem;
    Informes2: TMenuItem;
    Acercade1: TMenuItem;
    mnuHistorialVentas: TMenuItem;
    mnuMovimientoStock: TMenuItem;
    mnuCrearBackup: TMenuItem;
    procedure Gestin2Click(Sender: TObject);
    procedure Clientes1Click(Sender: TObject);
    procedure Clientes2Click(Sender: TObject);
    procedure mnuHistorialVentasClick(Sender: TObject);
    procedure mnuMovimientoStockClick(Sender: TObject);
    procedure mnuCrearBackupClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmprincipal: Tfrmprincipal;

implementation

{$R *.dfm}

uses productos, Datos;

procedure Tfrmprincipal.mnuCrearBackupClick(Sender: TObject);
var
  RutaBackup: string;
begin
  if dmDatos.CrearBackupManual(RutaBackup) then
  begin
    ShowMessage(
      'Copia de seguridad creada correctamente.' +
      sLineBreak + sLineBreak +
      RutaBackup
    );
  end
  else
  begin
    ShowMessage(
      'No se ha podido crear la copia de seguridad.' +
      sLineBreak + sLineBreak +
      dmDatos.UltimoError
    );
  end;
end;


procedure Tfrmprincipal.Clientes1Click(Sender: TObject);
var
  FormClientes: TfrmClientes;
begin
  // Clientes se crea al abrirlo y se libera al cerrar.
  // As� no a�adimos otro formulario al arranque de PC Shop.
  FormClientes := TfrmClientes.Create(Self);
  try
    FormClientes.ShowModal;
  finally
    FormClientes.Free;
  end;
end;

procedure Tfrmprincipal.Clientes2Click(Sender: TObject);
begin
frmventas.ShowModal;
end;

procedure Tfrmprincipal.Gestin2Click(Sender: TObject);
begin
frmproductos.show;
end;





procedure Tfrmprincipal.mnuHistorialVentasClick(Sender: TObject);
begin

frmHistorialVentas.ShowModal;

end;

procedure Tfrmprincipal.mnuMovimientoStockClick(Sender: TObject);
var
  FormMovimientoStock: TfrmMovimientoStock;
begin
  // El formulario se crea solo cuando el usuario lo necesita
  // y se libera al cerrarlo.
  FormMovimientoStock := TfrmMovimientoStock.Create(Self);
  try
    FormMovimientoStock.ShowModal;
  finally
    FormMovimientoStock.Free;
  end;
end;

end.
