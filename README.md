# PC Shop

Aplicación de gestión de productos desarrollada con **Delphi 12.1 Community Edition**, VCL, FireDAC y SQLite.

El proyecto forma parte de **InformatOLI** y tiene como objetivo desarrollar una aplicación de escritorio sencilla pero estructurada, aplicando técnicas utilizadas en proyectos Delphi reales.

## 🛠 Tecnologías

- Delphi 12.1 Community Edition
- Object Pascal
- VCL
- FireDAC
- SQLite
- SQL
- Programación orientada a objetos
- `TObjectList<TProducto>`
- Git / GitHub

## 📦 Estado actual

PC Shop permite actualmente gestionar productos utilizando los siguientes campos:

- Código
- Nombre
- Precio
- Stock

La aplicación utiliza una base de datos SQLite local (`pcshop.db`) para almacenar los productos.

## ✅ Funcionalidades implementadas

- Alta de productos.
- Edición de productos existentes.
- Eliminación en memoria.
- Validación de datos.
- Control de códigos duplicados.
- Selección de productos mediante `TStringGrid`.
- Gestión de productos mediante objetos `TProducto`.
- Colección de productos mediante `TObjectList<TProducto>`.
- Base de datos SQLite.
- Conexión mediante FireDAC.
- INSERT parametrizado.
- SELECT de productos almacenados.
- UPDATE parametrizado.
- Recuperación automática de productos al iniciar la aplicación.
- Separación del acceso a datos mediante un Data Module.
- Persistencia de los cambios entre ejecuciones.

## 🏗 Arquitectura actual

El proyecto intenta mantener separadas la interfaz, el modelo y la persistencia.

```text
Formulario VCL
     ↓
TProducto
     ↓
TObjectList<TProducto>
     ↓
Data Module
     ↓
FireDAC
     ↓
SQLite
```

La interfaz no contiene directamente las sentencias SQL.

Las operaciones de persistencia se delegan al Data Module.

## 🗄 Base de datos

La tabla principal utilizada actualmente es:

```sql
PRODUCTOS
```

Sus datos principales son:

```text
Codigo
Nombre
Precio
Stock
```

Las operaciones SQL se realizan utilizando parámetros FireDAC en lugar de concatenar directamente los valores introducidos por el usuario.

Ejemplo conceptual:

```sql
UPDATE PRODUCTOS
SET Nombre = :Nombre,
    Precio = :Precio,
    Stock = :Stock
WHERE Codigo = :Codigo;
```

## 🔄 Persistencia

Actualmente se encuentra implementado el siguiente ciclo:

```text
Alta
 ↓
INSERT
 ↓
SQLite

Inicio aplicación
 ↓
SELECT
 ↓
TProducto
 ↓
FProductos
 ↓
TStringGrid

Edición
 ↓
UPDATE
 ↓
SQLite
```

Esto permite cerrar PC Shop y volver a ejecutarlo conservando los productos y sus modificaciones.

## 🔧 Problemas resueltos durante el desarrollo

Durante el desarrollo se han solucionado, entre otros:

- Duplicación accidental de productos en `FProductos`.
- Error de visualización entre Precio y Stock.
- Bloqueos de SQLite.
- Error `F2039` al permanecer `pcshop.exe` abierto.
- Access Violation por utilizar el Data Module antes de su creación.
- Corrección del orden de creación de formularios y Data Modules.
- Diferenciación entre modificar un objeto en memoria y persistir realmente el cambio.
- Uso de `RowsAffected` para comprobar operaciones SQL.

## 🎯 Próximos objetivos

- Implementar DELETE parametrizado.
- Completar el CRUD persistente de PRODUCTOS.
- Mejorar búsquedas y filtrado.
- Continuar mejorando la organización del código.
- Añadir nuevas funcionalidades progresivamente.
- Seguir incorporando prácticas relacionadas con desarrollo profesional en Delphi, SQL y bases de datos relacionales.

## 📚 Diario de desarrollo

### AGOSTO — Semana 1

Se desarrolla la gestión inicial de productos en memoria.

Se incorporan:

- `TProducto`
- `TObjectList<TProducto>`
- Alta
- Edición
- Eliminación
- Selección mediante grid
- Validaciones
- Control de duplicados
- Separación entre colección y representación visual

### AGOSTO — Semana 2

Se incorpora persistencia mediante SQLite y FireDAC.

Se implementan:

- Conexión SQLite.
- Tabla PRODUCTOS.
- INSERT parametrizado.
- SELECT y reconstrucción de objetos.
- UPDATE parametrizado.
- Data Module para separar persistencia e interfaz.
- Depuración de errores relacionados con FireDAC, SQLite y ciclo de vida de los formularios.

**Semana completada: 4/4 jornadas.**

## 💻 Objetivo del proyecto

PC Shop no pretende ser un ERP complejo.

Su objetivo es servir como una aplicación de escritorio funcional y como proyecto de portfolio para practicar y demostrar competencias relacionadas con:

- Delphi.
- Object Pascal.
- VCL.
- Aplicaciones Windows.
- SQL.
- Bases de datos relacionales.
- FireDAC.
- Persistencia.
- Programación orientada a objetos.
- Mantenimiento y depuración.
- Organización de aplicaciones.
- Git y GitHub.

## 🚀 Proyecto en desarrollo

El proyecto continúa evolucionando de forma progresiva.

Próximo hito:

**DELETE parametrizado y CRUD persistente completo de PRODUCTOS.**

---

**InformatOLI**

https://informatoli.org
