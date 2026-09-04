unit principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Ventas;

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
    procedure Gestin2Click(Sender: TObject);
    procedure Clientes2Click(Sender: TObject);
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

procedure Tfrmprincipal.Clientes2Click(Sender: TObject);
begin
frmventas.ShowModal;
end;

procedure Tfrmprincipal.Gestin2Click(Sender: TObject);
begin
frmproductos.show;
end;

end.
