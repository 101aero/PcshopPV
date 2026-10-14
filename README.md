Sí. Ese README ya está **muy por detrás del estado real de `pcshopPV`**. Yo no lo iría parcheando: ahora que `pcshopPV` es el repositorio público principal, lo sustituiría por uno que presente PC Shop como aplicación real y no como el CRUD de agosto.

Te propongo este README completo, listo para sustituir el actual:

```markdown
# PC Shop

Aplicación de escritorio para **TPV y gestión sencilla de pequeños comercios**, desarrollada con **Delphi 12.1 Community Edition**, **Object Pascal**, **VCL**, **FireDAC** y **SQLite**.

PC Shop forma parte del portfolio técnico de **InformatOLI** y evoluciona como una aplicación real: persistencia, ventas, clientes, inventario, trazabilidad, mantenimiento de datos, copias de seguridad y recuperación.

> El objetivo no es construir una colección de ejercicios Delphi, sino evolucionar una aplicación Windows funcional y mantenible.

---

## 🚀 Estado actual

PC Shop dispone actualmente de:

- gestión persistente de productos;
- gestión de clientes;
- ventas;
- control de stock;
- movimientos de inventario;
- trazabilidad entre ventas y movimientos;
- auditoría de inconsistencias;
- migraciones de esquema SQLite;
- logging técnico;
- copias de seguridad;
- restauración controlada;
- historial y resumen de ventas;
- filtros y búsquedas;
- primera versión funcional de ticket de venta.

El proyecto continúa en desarrollo.

---

## 🛠️ Tecnologías

- Delphi 12.1 Community Edition
- Object Pascal
- VCL
- FireDAC
- SQLite
- SQL
- Programación orientada a objetos
- `TObjectList<T>`
- Transacciones
- Migraciones de esquema
- Logging
- Git / GitHub

---

# 🧱 Arquitectura

PC Shop mantiene separadas la interfaz, el modelo de dominio y la persistencia:

```text
Usuario
   ↓
VCL
   ↓
Objetos de dominio
   ↓
Data Module
   ↓
FireDAC
   ↓
SQLite
```

El formulario no ejecuta directamente las sentencias SQL principales.

La lógica de persistencia se centraliza en el Data Module.

Entre los objetos utilizados se encuentran:

```text
TProducto
TCliente
TVenta
TMovimientoStock
```

---

# 📦 Productos

La gestión de productos utiliza:

```text
Codigo
Nombre
Precio
Stock
```

`Codigo` actúa como identificador del producto.

Está implementado el CRUD persistente completo:

```text
CREATE  ✅
READ    ✅
UPDATE  ✅
DELETE  ✅
```

Las operaciones utilizan SQL parametrizado mediante FireDAC.

Ejemplo de búsqueda:

```sql
SELECT Codigo, Nombre, Precio, Stock
FROM PRODUCTOS
WHERE Codigo LIKE :Busqueda
   OR Nombre LIKE :Busqueda
ORDER BY Codigo;
```

También están implementados:

- búsqueda por código;
- búsqueda por nombre;
- búsqueda parcial mediante `LIKE`;
- control de códigos duplicados;
- filtro de stock bajo;
- cálculo del valor total del inventario;
- validaciones;
- recuperación automática de datos al iniciar.

---

# 👤 Clientes

PC Shop incorpora una entidad independiente para clientes.

Datos principales:

```text
IdCliente
Nombre
Email
Telefono
```

`IdCliente` utiliza:

```sql
INTEGER PRIMARY KEY AUTOINCREMENT
```

Está implementado:

- alta;
- consulta;
- modificación;
- eliminación;
- búsqueda por nombre;
- búsqueda por email;
- búsqueda por teléfono.

Los clientes se relacionan con las ventas mediante `IdCliente`.

Las ventas pueden continuar siendo anónimas.

---

# 🛒 Ventas

Las ventas se almacenan persistentemente en SQLite.

Una venta incluye información como:

```text
Id
Fecha
CodigoProducto
Cantidad
PrecioUnitario
Total
IdCliente
```

La aplicación dispone de:

- registro de ventas;
- actualización automática del stock;
- comprobación de stock disponible;
- historial de ventas;
- búsqueda;
- filtro por cliente;
- soporte para ventas anónimas;
- resumen de ventas;
- número de operaciones;
- unidades vendidas;
- importe total.

La relación con clientes se mantiene mediante identificadores, evitando duplicar nombres dentro de `VENTAS`.

---

# 🔄 Transacciones

Una venta no se trata como una sucesión de operaciones independientes.

Actualmente el flujo incluye:

```text
BEGIN TRANSACTION
        ↓
INSERT VENTA
        ↓
obtener IdVenta
        ↓
UPDATE PRODUCTOS.Stock
        ↓
INSERT MOVIMIENTOS_STOCK
        ↓
COMMIT
```

Si una operación falla:

```text
ROLLBACK
```

De esta forma se evita terminar con situaciones como:

```text
Venta registrada        ✅
Stock actualizado       ❌
```

o:

```text
Stock actualizado       ✅
Movimiento registrado   ❌
```

---

# 📊 Movimientos de stock

PC Shop dispone de una entidad `MOVIMIENTOS_STOCK` para explicar cómo cambia el inventario.

Tipos:

```text
ENTRADA
SALIDA
AJUSTE
```

La cantidad representa siempre la variación:

```text
ENTRADA +5
SALIDA  -2
AJUSTE  +3
AJUSTE  -1
```

Regla:

```text
StockNuevo = StockActual + Cantidad
```

Los movimientos pueden ser:

### Manuales

```text
IdVenta = NULL
```

### Generados por una venta

```text
Tipo     = SALIDA
Cantidad = -CantidadVendida
Motivo   = Venta
IdVenta  = identificador real
```

El identificador de la venta se recupera desde SQLite mediante:

```sql
SELECT last_insert_rowid();
```

utilizando la misma conexión FireDAC.

---

# 🔍 Auditoría de trazabilidad

Además de registrar movimientos, PC Shop puede comprobar la coherencia entre ventas e inventario.

La auditoría permite detectar:

- ventas sin movimiento;
- más de un movimiento asociado a una venta;
- movimientos asociados a ventas inexistentes;
- diferencias entre cantidad vendida y salida de stock.

Ejemplo:

```text
VENTAS.Cantidad = 3

debe corresponder con:

MOVIMIENTOS_STOCK.Cantidad = -3
```

Las incidencias detectadas utilizan el sistema de logging ya existente.

---

# 🕰️ Compatibilidad con datos históricos

Durante la incorporación de la trazabilidad apareció un problema real de mantenimiento:

las ventas creadas antes de existir `MOVIMIENTOS_STOCK` no disponían de movimiento asociado.

Eso no significaba que fueran datos incorrectos.

Para distinguir datos históricos de ventas sometidas a las nuevas reglas se incorporó:

```sql
Trazable INTEGER NOT NULL DEFAULT 0
```

Interpretación:

```text
Trazable = 0
→ venta histórica

Trazable = 1
→ venta creada con el sistema moderno
→ debe cumplir trazabilidad
```

Así se evita modificar artificialmente el histórico.

---

# 🔧 Migraciones de esquema

PC Shop debe poder evolucionar sin eliminar las bases existentes.

Para comprobar la estructura real se utiliza:

```sql
PRAGMA table_info(VENTAS);
```

y cuando es necesario se aplican migraciones mediante `ALTER TABLE`.

Ejemplo:

```sql
ALTER TABLE VENTAS
ADD COLUMN Trazable INTEGER NOT NULL DEFAULT 0;
```

Esto permite evolucionar instalaciones existentes conservando los datos.

Una conclusión importante del proyecto ha sido:

> `CREATE TABLE IF NOT EXISTS` crea tablas nuevas, pero no actualiza automáticamente la estructura de tablas que ya existen.

Por eso PC Shop incorpora migraciones explícitas.

---

# 🛡️ Integridad desde SQLite

Parte de las reglas también se protege desde la propia base de datos.

Para impedir que una venta termine accidentalmente asociada a más de un movimiento se utiliza un índice `UNIQUE` parcial:

```sql
CREATE UNIQUE INDEX IF NOT EXISTS UX_MOVIMIENTOS_STOCK_IdVenta
ON MOVIMIENTOS_STOCK(IdVenta)
WHERE IdVenta IS NOT NULL;
```

Esto permite:

```text
Movimientos manuales
IdVenta = NULL
→ múltiples movimientos

Movimientos de venta
IdVenta = valor real
→ uno por venta
```

La integridad se plantea mediante varias capas:

```text
Lógica Delphi
      +
Transacciones
      +
Auditoría
      +
Restricciones SQLite
      ↓
Mayor consistencia de los datos
```

---

# 💾 Copias de seguridad

PC Shop incorpora copia de seguridad manual de SQLite mediante:

```text
TFDSQLiteBackup
```

No se realiza una simple copia directa de `pcshop.db` mientras la base permanece abierta.

Flujo:

```text
PC Shop
   ↓
Crear copia de seguridad
   ↓
Data Module
   ↓
TFDSQLiteBackup
   ↓
backups\
   ↓
pcshop_AAAA-MM-DD_HHMM.db
```

La aplicación:

- crea la carpeta `backups` si es necesario;
- utiliza fecha y hora en el nombre;
- evita sobrescrituras silenciosas;
- comprueba que el fichero ha sido generado;
- comprueba que su tamaño sea mayor que cero;
- informa al usuario;
- registra éxito o error en el log.

---

# ♻️ Restauración de copias

También está implementada la restauración manual y controlada de bases SQLite.

El flujo incluye:

```text
Seleccionar backup
       ↓
Validar
       ↓
Backup preventivo de la base actual
       ↓
Confirmación
       ↓
Cerrar conexión FireDAC
       ↓
Restaurar
       ↓
Validar base restaurada
       ↓
Reabrir conexión
       ↓
Aplicar migraciones
```

Se utilizan componentes específicos de FireDAC como:

```text
TFDSQLiteBackup
TFDSQLiteValidate
```

El objetivo es que la restauración sea:

- recuperable;
- verificable;
- compatible con versiones anteriores del esquema.

---

# 🧾 Ticket de venta

PC Shop dispone también de una primera versión funcional del ticket.

Flujo:

```text
Historial de ventas
        ↓
seleccionar venta
        ↓
Ver ticket
```

El ticket utiliza el objeto `TVenta` asociado a la venta seleccionada y muestra:

- Id de venta;
- fecha;
- producto;
- cantidad;
- precio unitario;
- total;
- cliente;
- venta anónima cuando no existe cliente asociado.

Actualmente es una primera versión funcional.

Todavía no incluye:

- PDF;
- impresión;
- diseño fiscal completo;
- configuración avanzada del negocio.

Estas áreas forman parte de la evolución prevista.

---

# 🔎 Logging y diagnóstico

PC Shop mantiene un registro técnico:

```text
logs\pcshop.log
```

Se utiliza para registrar distintas operaciones e incidencias de la aplicación.

También se reutiliza desde funcionalidades como:

- auditoría de inventario;
- copias de seguridad;
- restauración;
- diagnóstico de errores.

El objetivo es evitar crear sistemas de logging distintos para cada módulo.

---

# 📁 Base de datos portable

La ruta de `pcshop.db` se calcula a partir de la ubicación de la aplicación en lugar de depender de una ruta absoluta de un equipo concreto.

Esto permite mover el proyecto entre diferentes instalaciones sin mantener rutas específicas del equipo de desarrollo.

Conceptualmente:

```text
PC Shop
│
├── pcshop.exe
└── pcshop.db
```

---

# 🧠 Problemas reales resueltos

Durante el desarrollo se han diagnosticado y corregido incidencias como:

- parámetros FireDAC incorrectos;
- duplicación accidental de objetos;
- diferencias entre memoria y persistencia;
- SQLite bloqueado;
- Access Violation por ciclo de vida del Data Module;
- orden incorrecto de creación de formularios;
- eliminación duplicada de objetos;
- rutas SQLite absolutas;
- ejecutable bloqueado durante compilación;
- desincronización entre DFM y PAS;
- eventos VCL sin implementación asociada;
- consultas activadas desde Designer antes de configurar la conexión real;
- evolución de migraciones existentes al incorporar nuevas columnas.

Estas incidencias forman parte del objetivo del proyecto: practicar no solo desarrollo nuevo, sino también diagnóstico y mantenimiento de aplicaciones existentes.

---

# 🎯 Competencias trabajadas

PC Shop sirve como proyecto de portfolio para trabajar y demostrar:

- Delphi / Object Pascal
- VCL
- Aplicaciones Windows
- FireDAC
- SQLite
- SQL relacional
- SQL parametrizado
- CRUD
- Programación orientada a objetos
- Data Modules
- Transacciones
- COMMIT / ROLLBACK
- Integridad de datos
- Migraciones de esquema
- Compatibilidad con datos históricos
- Índices
- Auditoría
- Logging
- Copias de seguridad
- Recuperación de datos
- Gestión de errores
- Mantenimiento de aplicaciones existentes
- Depuración
- Git / GitHub

---

# 🗺️ Próximas líneas de evolución

Entre las siguientes áreas previstas se encuentran:

- configuración persistente del negocio;
- evolución visual del ticket;
- generación de tickets en PDF;
- impresión;
- exportación CSV / Excel;
- estadísticas;
- mejora de interfaz;
- pruebas automatizadas;
- instalador;
- nuevas mejoras de rendimiento y mantenibilidad.

El roadmap puede adaptarse según el estado real del proyecto y las competencias profesionales que resulte útil incorporar.

---

# 📚 Filosofía del proyecto

PC Shop comenzó trabajando conceptos básicos de gestión de productos, pero el objetivo actual es evolucionarlo como una aplicación mantenible.

La progresión puede resumirse así:

```text
CRUD
  ↓
Persistencia
  ↓
Clientes
  ↓
Ventas
  ↓
Stock
  ↓
Trazabilidad
  ↓
Auditoría
  ↓
Migraciones
  ↓
Backup / restauración
  ↓
Ticket
  ↓
TPV más completo
```

Un CRUD permite demostrar que se pueden insertar, modificar, consultar y eliminar datos.

PC Shop intenta avanzar un paso más:

> evolucionar una aplicación que ya contiene información, mantener compatibilidad con datos existentes y añadir nuevas funcionalidades sin romper lo anterior.

---

# 🌐 InformatOLI

Proyecto desarrollado como parte del portfolio de **InformatOLI**.

https://informatoli.org

---

# 📄 License

This project is licensed under the **MIT License**.

See the [LICENSE](LICENSE) file for details.
```

### Dos cambios importantes respecto al README antiguo

Yo **eliminaría completamente el diario detallado de agosto** del README. Ese historial ya tiene un sitio mejor: **DelphiHeaven**. El README de GitHub debe responder rápidamente a un reclutador o desarrollador:

**qué es → qué hace → cómo está diseñado → qué tecnologías demuestra → hacia dónde va.**

Y eliminaría también frases antiguas como:

> “Próximo hito: eliminar la dependencia de rutas absolutas”

porque eso **ya está resuelto** y ahora transmite incorrectamente que el repositorio está mucho más atrasado de lo que realmente está.

Con este cambio, `pcshopPV` deja de presentarse como *“mi ejercicio CRUD de Delphi”* y empieza a presentarse como lo que ya es: **un TPV en evolución utilizado como proyecto real de desarrollo y mantenimiento Delphi**.
