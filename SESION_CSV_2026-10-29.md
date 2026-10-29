# PC Shop — sesión 2026-10-29 — Exportación CSV

## Cambios integrados
- `productos.pas`: nuevo manejador `btnExportarCSVClick`, usa `TFDQuery` conectado al Data Module existente.
- `productos.dfm`: se añaden `btnExportarCSV` y `dlgExportarCSV` en el diseñador VCL.
- Se consulta `PRODUCTOS` directamente; se exportan TODOS los registros, sin aplicar los filtros temporales de pantalla.
- CSV UTF-8 con cabeceras `Codigo;Nombre;Precio;Stock`; se escapan las comillas dobles en textos, el precio usa punto decimal con dos cifras y el separador es punto y coma.
- Se escribe primero un archivo temporal y se reemplaza el destino mediante `MoveFileEx` si se completa la exportación.
- Se muestran errores y número de productos exportados.

## Cómo probar en Delphi 12.1 CE
1. Guardar una copia del proyecto y de `pcshop.db` antes de sustituir archivos.
2. Abrir `pcshop.dproj` y compilar para Windows.
3. Abrir Gestión de productos y comprobar que aparece «Exportar CSV».
4. Pulsar el botón, elegir destino y abrir el CSV en un editor de texto o Calc/Excel (separador `;`, UTF-8).
5. Probar comillas, acentos, precio decimal, stock 0, inventario vacío y cancelación del diálogo.
6. Probar la exportación tras aplicar una búsqueda: el fichero debe contener TODOS los productos.
7. Probar la sobrescritura, aceptando el aviso del diálogo; y un destino no escribible para comprobar el mensaje de error.

## Alcance y precauciones
- La base SQLite se incluye sin cambios respecto al ZIP de entrada.
- No se modifican SQL de escritura, estructura de BD, ventas, stock ni copias de seguridad.
- No es posible compilar VCL/Delphi 12.1 en este entorno; la compilación y prueba funcional están pendientes en la IDE del usuario.
- El CSV contiene información comercial del inventario: compartirlo con cuidado.
- Para importar en Excel puede ser necesario indicar explícitamente el delimitador `;` y la codificación UTF-8.
