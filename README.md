PB
# PC Shop -- por INFORMATOLI.org

Aplicación de escritorio para Windows desarrollada con **Delphi 12.1 Community Edition** y tecnología **VCL**.

El proyecto se desarrolla como aplicación práctica y demostrativa, con el objetivo de construir una gestión sencilla de productos utilizando una estructura progresivamente más organizada y mantenible.

## Objetivo

PC Shop no se plantea inicialmente como un ERP completo.

El proyecto se utiliza para desarrollar y documentar paso a paso una aplicación funcional que permita practicar y mostrar:

- Desarrollo con Delphi y Object Pascal.
- Interfaces de escritorio mediante VCL.
- Programación orientada a objetos.
- Separación entre interfaz y modelo de datos.
- Uso de colecciones genéricas.
- Gestión de memoria.
- Validaciones.
- Persistencia de datos.
- Evolución progresiva de una aplicación real.

## Estado actual

🚧 **Proyecto en desarrollo**

Actualmente se encuentra implementado el módulo inicial de gestión de productos.

### Funcionalidades disponibles

- Alta de productos.
- Selección de productos desde un `TStringGrid`.
- Modificación de productos existentes.
- Eliminación de productos.
- Validación de campos obligatorios.
- Validación de precio y stock.
- Control de códigos de producto duplicados.
- Modos diferenciados de Alta y Edición.
- Gestión de productos mediante `TObjectList<TProducto>`.
- Reconstrucción automática del `TStringGrid` desde la colección.

La colección `FProductos` constituye la fuente principal de información y el `TStringGrid` actúa únicamente como representación visual de los datos.

## Arquitectura actual

```text
Formulario
    ↓
TProducto
    ↓
TObjectList<TProducto>
    ↓
ActualizarTablaDesdeColeccion
    ↓
TStringGrid
