# Motor de Reglas de Monitoreo PLD

## Descripción General

Este motor implementa las reglas de monitoreo de operaciones para el cumplimiento de la **Ley Federal para la Prevención e Identificación de Operaciones con Recursos de Procedencia Ilícita (LFPIORPI)** y su normatividad relacionada.

## Arquitectura

```
┌─────────────────────────────────────────────────────────────────────┐
│                    MOTOR DE MONITOREO PLD                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────────┐ │
│  │ Operaciones │───►│ Evaluación  │───►│ Alertas / Avisos        │ │
│  │ (Entrada)   │    │ Individual  │    │ (Salida)                │ │
│  └─────────────┘    └──────┬──────┘    └─────────────────────────┘ │
│                            │                                       │
│                     ┌──────▼──────┐                                │
│                     │ Acumulación │                                │
│                     │  Mensual    │                                │
│                     └─────────────┘                                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## Orden de Instalación

Ejecutar los scripts en el siguiente orden:

1. `Tablas_relacionadas_con_Operaciones.sql` - Tablas base (si no existen)
2. `Tablas_Monitoreo.sql` - Tablas de soporte para monitoreo
3. `Funciones_Monitoreo.sql` - Funciones de cálculo
4. `EvaluacionOperacion.sql` - Evaluación de operaciones individuales
5. `AcumulacionMensual.sql` - Cálculo de acumulados
6. `AlertasYAvisos.sql` - Gestión de alertas y avisos
7. `MotorMonitoreoPLD.sql` - Motor principal
8. `DatosIniciales_Monitoreo.sql` - Catálogos y configuración

## Componentes

### Tablas

| Tabla | Descripción |
|-------|-------------|
| `TipoAlerta` | Catálogo de tipos de alerta |
| `EstatusAlerta` | Estados de las alertas |
| `AlertaMonitoreo` | Registro de alertas generadas |
| `EstatusAviso` | Estados de los avisos |
| `AvisoUIF` | Avisos a presentar ante la UIF |
| `AvisoUIFOperacion` | Relación aviso-operaciones |
| `AcumuladoMensualCliente` | Acumulados mensuales por cliente |
| `LogMonitoreo` | Bitácora de ejecuciones |

### Funciones

| Función | Descripción |
|---------|-------------|
| `ObtenerValorUMAVigente` | Obtiene el valor del UMA para una fecha |
| `ConvertirMontoAUMAs` | Convierte pesos a UMAs |
| `ConvertirUMAsAPesos` | Convierte UMAs a pesos |
| `ObtenerUmbralIdentificacion` | Obtiene umbral de identificación |
| `ObtenerUmbralAviso` | Obtiene umbral de aviso |
| `CalcularFechaLimitePresentacion` | Calcula fecha límite (día 17) |
| `EvaluarSuperaUmbralIdentificacion` | Evalúa si supera umbral |
| `EvaluarSuperaUmbralAviso` | Evalúa si supera umbral de aviso |
| `ObtenerOperacionesMesCliente` | Lista operaciones del mes |
| `ObtenerResumenAcumuladoMensual` | Resumen de acumulados |

### Procedimientos Almacenados

#### Evaluación
| Procedimiento | Descripción |
|---------------|-------------|
| `EvaluarOperacionIndividual` | Evalúa una operación contra umbrales |
| `EvaluarOperacionAlInsertar` | Evalúa al insertar (para triggers) |

#### Acumulación
| Procedimiento | Descripción |
|---------------|-------------|
| `ActualizarAcumuladoMensual` | Actualiza acumulado de un cliente |
| `RecalcularAcumuladosMensuales` | Recalcula todo un período |
| `ObtenerAcumuladoCliente` | Consulta acumulado de cliente |
| `ObtenerHistorialAcumuladosCliente` | Historial de acumulados |

#### Alertas y Avisos
| Procedimiento | Descripción |
|---------------|-------------|
| `GenerarAvisoUIF` | Genera un aviso para la UIF |
| `GenerarAvisosAutomaticos` | Genera avisos masivamente |
| `ObtenerAlertasPendientes` | Lista alertas pendientes |
| `ObtenerAvisosPendientes` | Lista avisos pendientes |
| `ActualizarEstatusAlerta` | Actualiza estatus de alerta |
| `ActualizarEstatusAviso` | Actualiza estatus de aviso |

#### Motor Principal
| Procedimiento | Descripción |
|---------------|-------------|
| `EjecutarMonitoreoPLD` | Proceso completo de monitoreo |
| `ResumenMonitoreoPLD` | Resumen ejecutivo |
| `ObtenerDetalleOperacionesCliente` | Detalle de operaciones |

## Uso

### Ejecutar Monitoreo Completo

```sql
-- Monitoreo del mes actual para todas las empresas
EXEC dbo.EjecutarMonitoreoPLD;

-- Monitoreo de un mes específico
EXEC dbo.EjecutarMonitoreoPLD 
    @EmpresaId = NULL,      -- Todas las empresas
    @Mes = 3,               -- Marzo
    @Anio = 2026,
    @GenerarAvisos = 1,     -- Generar avisos automáticos
    @UsuarioId = 1;
```

### Evaluar Operación Individual

```sql
DECLARE @SuperaIden BIT, @SuperaAviso BIT, @MontoUMAs DECIMAL(18,4);
DECLARE @UmbralIden INT, @UmbralAviso INT;

EXEC dbo.EvaluarOperacionIndividual 
    @OperacionId = 12345,
    @GenerarAlerta = 1,
    @SuperaUmbralIdentificacion = @SuperaIden OUTPUT,
    @SuperaUmbralAviso = @SuperaAviso OUTPUT,
    @MontoUMAs = @MontoUMAs OUTPUT,
    @UmbralIdentificacionUMAs = @UmbralIden OUTPUT,
    @UmbralAvisoUMAs = @UmbralAviso OUTPUT;
```

### Consultar Acumulado de Cliente

```sql
EXEC dbo.ObtenerAcumuladoCliente 
    @EmpresaId = 1,
    @ClienteId = 100,
    @ActividadVulnerableId = NULL,  -- Todas las actividades
    @Mes = 3,
    @Anio = 2026;
```

### Obtener Alertas Pendientes

```sql
EXEC dbo.ObtenerAlertasPendientes 
    @EmpresaId = 1,
    @ClienteId = NULL,
    @TipoAlertaId = NULL;
```

### Generar Aviso Manual

```sql
DECLARE @AvisoId BIGINT;

EXEC dbo.GenerarAvisoUIF 
    @EmpresaId = 1,
    @ClienteId = 100,
    @ActividadVulnerableId = 7,  -- Metales preciosos
    @Mes = 3,
    @Anio = 2026,
    @UsuarioId = 1,
    @AvisoUIFId = @AvisoId OUTPUT;
```

## Reglas de Negocio Implementadas

### R1: Evaluación Individual
- Cada operación se evalúa individualmente contra el umbral de identificación y aviso
- Si supera umbral, se genera alerta correspondiente

### R2: Acumulación Mensual
- Las operaciones se acumulan por cliente, por mes calendario
- El período de acumulación inicia el día 1 y termina el último día del mes

### R3: Fecha Límite de Presentación
- Los avisos deben presentarse a más tardar el día 17 del mes siguiente
- El sistema calcula automáticamente esta fecha

### R4: Tipos de Alerta
- **IDEN_IND**: Identificación por operación individual
- **IDEN_ACU**: Identificación por acumulado mensual
- **AVISO_IND**: Aviso por operación individual
- **AVISO_ACU**: Aviso por acumulado mensual

## Umbrales por Actividad Vulnerable

Los umbrales están configurados según el Artículo 17 de la LFPIORPI:

| Actividad | Identificación (UMAs) | Aviso (UMAs) |
|-----------|----------------------|--------------|
| Juegos con apuesta | 325 | 645 |
| Tarjetas de crédito | 805 | 1,285 |
| Tarjetas prepagadas | 645 | 645 |
| Cheques de viajero | 645 | 645 |
| Mutuos/préstamos | 1,605 | 3,210 |
| Inmobiliaria | 8,025 | 16,050 |
| Metales preciosos | 805 | 1,605 |
| Obras de arte | 2,410 | 4,815 |
| Vehículos | 3,210 | 6,420 |
| Blindaje | 2,410 | 4,815 |
| Custodia valores | 3,210 | 6,420 |
| Servicios profesionales | 805 | 1,605 |
| Comercio exterior | 645 | 645 |
| Donativos | 1,605 | 3,210 |
| Arrendamiento | 1,605 | 3,210 |
| Activos virtuales | 645 | 645 |

## Valor del UMA

El valor del UMA para 2025 es: **$113.14 MXN diarios**

Los valores están almacenados en la tabla `ValorUMA` y se actualizan anualmente.

## Mantenimiento

### Actualizar Valor UMA (Anualmente)

```sql
INSERT INTO dbo.ValorUMA (ValorDiario, ValorMensual, ValorAnual, InicioVigencia, FinVigencia)
VALUES (XXX.XX, XXXX.XX, XXXXX.XX, '2027-01-01', '2027-12-31');
```

### Recalcular Acumulados

```sql
-- Recalcular un mes específico
EXEC dbo.RecalcularAcumuladosMensuales 
    @EmpresaId = NULL,
    @Mes = 3,
    @Anio = 2026;
```

## Consideraciones de Rendimiento

- Los acumulados se almacenan en tabla para evitar recálculos constantes
- Se recomienda ejecutar el monitoreo completo en horarios de baja actividad
- Índices optimizados para las consultas más frecuentes

## Diagramas

La documentación visual del motor se encuentra en la carpeta [Diagramas/](Diagramas/README.md):

| Diagrama | Descripción |
|----------|-------------|
| [Flujo del Proceso](Diagramas/01_Flujo_Proceso_Monitoreo.md) | Flujo completo desde operación hasta aviso |
| [Entidad-Relación](Diagramas/02_Diagrama_Entidad_Relacion.md) | Estructura de tablas y relaciones |
| [Secuencia](Diagramas/03_Diagrama_Secuencia.md) | Interacción entre procedimientos |
| [Estados](Diagramas/04_Diagrama_Estados.md) | Ciclos de vida de alertas y avisos |
| [Arquitectura](Diagramas/05_Diagrama_Arquitectura.md) | Componentes y capas del sistema |
| [Decisión](Diagramas/06_Diagrama_Decision_Umbrales.md) | Evaluación de umbrales |

## Fundamento Legal

- **Art. 17 LFPIORPI**: Definición de Actividades Vulnerables y umbrales
- **Art. 18 fr. VI LFPIORPI**: Fecha límite de presentación de avisos
- **Art. 22 Reglamento LFPIORPI**: Acumulación de operaciones
- **Reglas de Carácter General**: Procedimientos de cumplimiento
