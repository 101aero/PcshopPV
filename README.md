# PC Shop

Aplicación de gestión de productos desarrollada con **Delphi 12.1 Community Edition**, **VCL**, **FireDAC** y **SQLite**.

El proyecto forma parte de **InformatOLI** y tiene como objetivo desarrollar una aplicación de escritorio sencilla pero estructurada, aplicando técnicas utilizadas en proyectos Delphi reales.

---

## Tecnologías

- Delphi 12.1 Community Edition
- Object Pascal
- VCL
- FireDAC
- SQLite
- SQL
- Programación orientada a objetos
- `TObjectList<TProducto>`
- Git / GitHub

---

## Estado actual

PC Shop permite gestionar productos utilizando los campos:

- Código
- Nombre
- Precio
- Stock

La aplicación utiliza una base de datos SQLite local (`pcshop.db`) y dispone de **CRUD persistente completo** y **búsqueda por Código o Nombre**.

---

## CRUD de PRODUCTOS

Actualmente están implementadas las cuatro operaciones principales:

- **CREATE** → alta mediante `INSERT` parametrizado.
- **READ** → recuperación mediante `SELECT`.
- **UPDATE** → edición mediante `UPDATE` parametrizado.
- **DELETE** → eliminación mediante `DELETE` parametrizado.

```text
CREATE  ✅
READ    ✅
UPDATE  ✅
DELETE  ✅
```

Los cambios permanecen almacenados después de cerrar y volver a ejecutar PC Shop.

---

## Búsqueda de productos

La aplicación permite filtrar productos por:

- Código.
- Nombre completo.
- Parte del nombre.

La búsqueda se realiza mediante un `TFDQuery` específico en el Data Module y una consulta SQL parametrizada:

```sql
SELECT Codigo, Nombre, Precio, Stock
FROM PRODUCTOS
WHERE Codigo LIKE :Busqueda
   OR Nombre LIKE :Busqueda
ORDER BY Codigo;
```

El criterio introducido por el usuario se convierte en un patrón:

```text
tecl
 ↓
%tecl%
```

y se asigna mediante FireDAC:

```pascal
qryBuscarProductos.ParamByName('Busqueda').AsString :=
  '%' + Trim(ABusqueda) + '%';
```

De esta forma, el contenido del `TEdit` no se concatena directamente dentro del SQL.

Los resultados de la consulta se transforman nuevamente en objetos `TProducto`, se incorporan a `FProductos` y el `TStringGrid` se reconstruye desde la colección.

---

## Funcionalidades implementadas

- Alta de productos.
- Edición de productos existentes.
- Eliminación persistente.
- Validación de datos.
- Control de códigos duplicados.
- Selección mediante `TStringGrid`.
- Modelo `TProducto`.
- Gestión mediante `TObjectList<TProducto>`.
- Base de datos SQLite.
- Conexión mediante FireDAC.
- `INSERT` parametrizado.
- `SELECT` de productos.
- `UPDATE` parametrizado.
- `DELETE` parametrizado.
- Uso de `RowsAffected`.
- Recuperación automática de productos al iniciar la aplicación.
- Búsqueda por Código o Nombre.
- Búsqueda parcial mediante `LIKE`.
- Botón para recuperar de nuevo todos los productos.
- Separación del acceso a datos mediante Data Module.
- Persistencia entre ejecuciones.
- Reutilización de la lógica de carga de productos.

---

## Arquitectura

La aplicación mantiene separadas la interfaz, el modelo y la persistencia.

```text
Usuario
   ↓
VCL
   ↓
Productos.pas
   ↓
TProducto / FProductos
   ↓
Data Module
   ↓
FireDAC
   ↓
SQLite
```

El formulario no ejecuta directamente sentencias SQL.

Las operaciones de persistencia y búsqueda se delegan al Data Module.

---

## Base de datos

Tabla principal:

```text
PRODUCTOS
```

Campos:

```text
Codigo
Nombre
Precio
Stock
```

`Codigo` se mantiene como clave primaria e identificador del producto.

Las operaciones SQL utilizan parámetros FireDAC en lugar de concatenar directamente valores introducidos por el usuario.

---

## Flujo de persistencia

### Alta

```text
Formulario
   ↓
TProducto
   ↓
INSERT
   ↓
SQLite
```

### Lectura

```text
SQLite
   ↓
SELECT
   ↓
TProducto
   ↓
FProductos
   ↓
TStringGrid
```

### Edición

```text
Producto seleccionado
   ↓
TProducto
   ↓
UPDATE
   ↓
RowsAffected
   ↓
SQLite
```

### Eliminación

```text
Producto seleccionado
   ↓
DELETE parametrizado
   ↓
SQLite
   ↓
RowsAffected
   ↓
FProductos
   ↓
TStringGrid
```

### Búsqueda

```text
Usuario
   ↓
edtBusqueda
   ↓
Productos.pas
   ↓
dmDatos.BuscarProductos
   ↓
TFDQuery
   ↓
SQL parametrizado + LIKE
   ↓
SQLite
   ↓
TProducto
   ↓
FProductos
   ↓
TStringGrid
```

---

## Problemas resueltos durante el desarrollo

Durante el desarrollo se han diagnosticado y corregido diferentes incidencias reales:

- Duplicación accidental de productos en `FProductos`.
- Error de visualización entre Precio y Stock.
- Bloqueos de SQLite.
- Error `F2039` al permanecer `pcshop.exe` abierto.
- Access Violation por utilizar el Data Module antes de su creación.
- Corrección del orden de Auto-create forms.
- Diferenciación entre modificar un objeto en memoria y persistir realmente el cambio.
- Uso de `RowsAffected` para comprobar operaciones SQL.
- Error `Parameter 'Codigo' not found` debido a un parámetro SQL incorrecto.
- Error `List index out of bounds` provocado por eliminar dos veces el mismo elemento de `FProductos`.
- Error `unable to open database file` provocado por una ruta absoluta de `pcshop.db` procedente de otro equipo.
- Comprobación del CRUD completo después de incorporar nuevas funcionalidades.

---

## Diario de desarrollo

### AGOSTO — Semana 1

Se desarrolla la gestión inicial de productos en memoria.

Se incorporan:

- `TProducto`.
- `TObjectList<TProducto>`.
- Alta.
- Edición.
- Eliminación.
- Selección mediante grid.
- Validaciones.
- Control de duplicados.
- Separación entre colección y representación visual.

**Semana completada: 4/4 jornadas.**

---

### AGOSTO — Semana 2

Se incorpora la persistencia mediante SQLite y FireDAC.

Se implementan:

- Conexión SQLite.
- Tabla `PRODUCTOS`.
- `INSERT` parametrizado.
- `SELECT`.
- Reconstrucción de objetos desde la base de datos.
- `UPDATE` parametrizado.
- Data Module para separar persistencia e interfaz.
- Depuración de errores relacionados con FireDAC, SQLite y ciclo de vida de formularios.

**Semana completada: 4/4 jornadas.**

---

### AGOSTO — Semana 3

La semana se orienta a consolidar el CRUD y comenzar a construir funcionalidades sobre una arquitectura más mantenible.

#### Jornada 1 — DELETE persistente

- `DELETE` parametrizado.
- Comprobación mediante `RowsAffected`.
- Sincronización entre SQLite, `FProductos` y `TStringGrid`.
- Depuración de errores en parámetros SQL y gestión de la colección.

#### Jornada 2 — Validación completa del CRUD

- Consolidación de `INSERT`, `SELECT`, `UPDATE` y `DELETE`.
- `Codigo` se mantiene como clave primaria inmutable.
- SQL centralizado en el Data Module.
- Validación completa mediante cierre y reapertura de la aplicación.

#### Jornada 3 — Refactorización de la capa de datos

- Revisión de responsabilidades.
- Mejora de la organización del Data Module.
- Uso de `try/finally`.
- Comprobación mediante `RowsAffected`.
- Métodos con resultados `Boolean`.
- Mayor separación entre formulario y persistencia.

#### Jornada 4 — Búsqueda parametrizada

- `edtBusqueda`.
- `btnBuscarFiltro`.
- `btnMostrarTodos`.
- `qryBuscarProductos`.
- `SELECT` con `LIKE`.
- Parámetro `:Busqueda`.
- Búsqueda por Código o Nombre.
- Búsqueda parcial.
- Conversión de cada fila SQL en `TProducto`.
- Reutilización de `CargarProductos`.
- Prueba completa del CRUD después de incorporar el filtro.

**Semana completada: 4/4 jornadas. ✅**

---

## Competencias trabajadas

PC Shop sirve como proyecto de portfolio para practicar y demostrar competencias relacionadas con:

- Delphi.
- Object Pascal.
- VCL.
- Aplicaciones Windows.
- FireDAC.
- SQLite.
- SQL.
- SQL parametrizado.
- Bases de datos relacionales.
- CRUD.
- Persistencia.
- Programación orientada a objetos.
- Gestión de colecciones.
- Separación de responsabilidades.
- Data Modules.
- Mantenimiento de código existente.
- Refactorización.
- Depuración.
- Resolución de errores.
- Organización de aplicaciones.
- Git y GitHub.

---

## Próximos objetivos

El siguiente objetivo es mejorar la portabilidad de la aplicación.

Actualmente se ha detectado que una ruta absoluta hacia `pcshop.db` puede impedir que PC Shop funcione correctamente al copiar el proyecto a otro ordenador.

La evolución prevista es utilizar una ubicación relativa a la aplicación:

```text
PC Shop
│
├── pcshop.exe
└── pcshop.db
```

Esto facilitará ejecutar el proyecto en:

- PC de desarrollo.
- Portátil.
- Otro equipo Windows.
- Repositorio clonado.

Después se continuará con nuevas mejoras funcionales y de arquitectura.

---

## Estado del proyecto

**CRUD persistente de PRODUCTOS completado. ✅**

**Búsqueda parametrizada por Código o Nombre completada. ✅**

**AGOSTO — Semana 3 completada: 4/4 jornadas. ✅**

Próximo hito:

**Eliminar la dependencia de rutas absolutas para `pcshop.db` y mejorar la portabilidad de PC Shop.**

---

## InformatOLI

https://informatoli.org
