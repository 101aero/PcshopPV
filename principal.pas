unit principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Ventas, HistorialVentas, Clientes;

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
    procedure Gestin2Click(Sender: TObject);
    procedure Clientes1Click(Sender: TObject);
    procedure Clientes2Click(Sender: TObject);
    procedure mnuHistorialVentasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmprincipal: Tfrmprincipal;

implementation

{$R *.dfm}

uses productos;

procedure Tfrmprincipal.Clientes1Click(Sender: TObject);
var
  FormClientes: TfrmClientes;
begin
  // Clientes se crea al abrirlo y se libera al cerrar.
  // Así no añadimos otro formulario al arranque de PC Shop.
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

end.
