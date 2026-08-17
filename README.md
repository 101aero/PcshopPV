# PC Shop

Aplicación de gestión de productos desarrollada con **Delphi 12.1 Community Edition**, **VCL**, **FireDAC** y **SQLite**.

El proyecto forma parte de **InformatOLI** y tiene como objetivo desarrollar una aplicación de escritorio sencilla pero estructurada, aplicando técnicas utilizadas en proyectos Delphi reales.

---

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

---

## 📦 Estado actual

PC Shop permite gestionar productos utilizando:

- Código
- Nombre
- Precio
- Stock

La aplicación utiliza una base de datos SQLite local (`pcshop.db`) y dispone ya de **CRUD persistente completo**.

---

## ✅ CRUD de PRODUCTOS

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

## ✅ Funcionalidades implementadas

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
- Separación del acceso a datos mediante Data Module.
- Persistencia entre ejecuciones.

---

## 🏗 Arquitectura

La aplicación mantiene separadas la interfaz, el modelo y la persistencia.

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

El formulario no ejecuta directamente sentencias SQL.

Las operaciones sobre la base de datos se delegan al Data Module.

---

## 🗄 Base de datos

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

Las operaciones utilizan parámetros FireDAC en lugar de concatenar directamente valores introducidos por el usuario.

Ejemplo:

```sql
UPDATE PRODUCTOS
SET Nombre = :Nombre,
    Precio = :Precio,
    Stock = :Stock
WHERE Codigo = :Codigo;
```

El mismo criterio se utiliza para las operaciones `INSERT` y `DELETE`.

---

## 🔄 Persistencia

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

---

## 🔧 Problemas resueltos durante el desarrollo

Durante el desarrollo se han diagnosticado y corregido diferentes incidencias reales:

- Duplicación accidental de productos en `FProductos`.
- Error de visualización entre Precio y Stock.
- Bloqueos de SQLite.
- Error `F2039` al permanecer `pcshop.exe` abierto.
- Access Violation por utilizar el Data Module antes de su creación.
- Corrección del orden de Auto-create forms.
- Diferenciación entre modificar un objeto en memoria y persistir el cambio.
- Uso de `RowsAffected` para comprobar operaciones SQL.
- Error `Parameter 'Codigo' not found` debido a un parámetro SQL incorrecto.
- Error `List index out of bounds` provocado por eliminar dos veces el mismo elemento de `FProductos`.

---

## 📚 Diario de desarrollo

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

### AGOSTO — Semana 3

#### Jornada 1 — CRUD persistente completo

Se implementa:

- `DELETE` parametrizado.
- Comprobación mediante `RowsAffected`.
- Sincronización entre SQLite, `FProductos` y `TStringGrid`.
- Eliminación persistente comprobada después de reiniciar PC Shop.

Con esta jornada queda completado el CRUD básico de `PRODUCTOS`.

**Progreso semanal: 1/4 jornadas.**

---

## 🎯 Próximos objetivos

- Consolidar y revisar el CRUD completo.
- Revisar definitivamente la persistencia del `UPDATE`.
- Mejorar la capa de acceso a datos.
- Reducir responsabilidades del formulario.
- Mejorar búsquedas y filtrado.
- Continuar incorporando funcionalidades progresivamente.
- Seguir trabajando mantenimiento, depuración y calidad de código.

---

## 💻 Objetivo del proyecto

PC Shop no pretende ser un ERP complejo.

Su objetivo es servir como una aplicación de escritorio funcional y como proyecto de portfolio para practicar y demostrar competencias relacionadas con:

- Delphi.
- Object Pascal.
- VCL.
- Aplicaciones Windows.
- FireDAC.
- SQL.
- Bases de datos relacionales.
- SQLite.
- CRUD.
- Persistencia.
- Programación orientada a objetos.
- Gestión de colecciones.
- Separación de responsabilidades.
- Mantenimiento.
- Depuración.
- Organización de aplicaciones.
- Git y GitHub.

---

## 🚀 Estado del proyecto

**CRUD persistente de PRODUCTOS completado. ✅**

Próximo hito:

**Consolidar la capa de persistencia y continuar mejorando la arquitectura de PC Shop.**

---

**InformatOLI**

https://informatoli.org