# Diagrama Entidad-Relación del Motor de Monitoreo PLD

Este diagrama muestra la estructura de las tablas y sus relaciones.

```mermaid
erDiagram
    Empresa ||--o{ EmpresaActividadVulnerable : "tiene"
    Empresa ||--o{ Cliente : "tiene"
    Empresa ||--o{ AlertaMonitoreo : "genera"
    Empresa ||--o{ AvisoUIF : "presenta"
    Empresa ||--o{ AcumuladoMensualCliente : "registra"
    
    ActividadVulnerable ||--o{ EmpresaActividadVulnerable : "asignada a"
    ActividadVulnerable ||--o{ UmbralIdentificacionCliente : "tiene"
    ActividadVulnerable ||--o{ UmbralPresentacionAviso : "tiene"
    ActividadVulnerable ||--o{ AlertaMonitoreo : "relacionada"
    ActividadVulnerable ||--o{ AvisoUIF : "relacionada"
    ActividadVulnerable ||--o{ AcumuladoMensualCliente : "acumula"
    
    EmpresaActividadVulnerable ||--o{ Operacion : "registra"
    
    Cliente ||--o{ Operacion : "realiza"
    Cliente ||--o{ AlertaMonitoreo : "genera"
    Cliente ||--o{ AvisoUIF : "requiere"
    Cliente ||--o{ AcumuladoMensualCliente : "acumula"
    
    Operacion }o--|| TipoOperacion : "tipo"
    Operacion }o--|| Divisa : "moneda"
    Operacion }o--|| ProductoServicio : "producto"
    Operacion ||--o{ AvisoUIFOperacion : "incluida en"
    Operacion ||--o{ AlertaMonitoreo : "dispara"
    
    TipoAlerta ||--o{ AlertaMonitoreo : "clasifica"
    EstatusAlerta ||--o{ AlertaMonitoreo : "estado"
    
    EstatusAviso ||--o{ AvisoUIF : "estado"
    AvisoUIF ||--o{ AvisoUIFOperacion : "contiene"
    
    ValorUMA ||--|| ValorUMA : "vigencia"

    Empresa {
        int EmpresaId PK
        nvarchar Nombre
        nvarchar RFC
        int ActividadVulnerableId FK
        bit EstaActivo
    }
    
    ActividadVulnerable {
        int ActividadVulnerableId PK
        nvarchar Codigo
        nvarchar Descripcion
        bit EstaActivo
    }
    
    EmpresaActividadVulnerable {
        int EmpresaActividadVulnerableId PK
        int EmpresaId FK
        int ActividadVulnerableId FK
        bit EstaActivo
    }
    
    Cliente {
        int ClienteId PK
        int EmpresaId FK
        int TipoClienteId
        int PersonaId FK
        bit EstaActivo
    }
    
    Operacion {
        bigint Id PK
        int EmpresaActividadVulnerableId FK
        int ClienteId FK
        int TipoOperacionId FK
        int TipoSubOperacionId FK
        int ProductoServicioId FK
        int DivisaId FK
        money Monto
        date FechaOperacion
        nvarchar FolioOperacion
        bit EstaActivo
    }
    
    ValorUMA {
        int ValorUMAId PK
        decimal ValorDiario
        decimal ValorMensual
        decimal ValorAnual
        date InicioVigencia
        date FinVigencia
    }
    
    UmbralIdentificacionCliente {
        int UmbralIdentificacionClienteId PK
        int ActividadVulnerableId FK
        int UmbralEnUMAs
    }
    
    UmbralPresentacionAviso {
        int UmbralPresentacionAvisoId PK
        int ActividadVulnerableId FK
        int UmbralEnUMAs
    }
    
    TipoAlerta {
        int TipoAlertaId PK
        nvarchar Codigo
        nvarchar Descripcion
    }
    
    EstatusAlerta {
        int EstatusAlertaId PK
        nvarchar Nombre
        nvarchar Descripcion
    }
    
    AlertaMonitoreo {
        bigint AlertaMonitoreoId PK
        int EmpresaId FK
        int ClienteId FK
        int ActividadVulnerableId FK
        int TipoAlertaId FK
        int EstatusAlertaId FK
        date FechaPeriodoInicio
        date FechaPeriodoFin
        money MontoEvaluado
        decimal MontoEnUMAs
        decimal UmbralAplicado
        bigint OperacionId FK
        datetime2 FechaGeneracion
    }
    
    EstatusAviso {
        int EstatusAvisoId PK
        nvarchar Nombre
        nvarchar Descripcion
    }
    
    AvisoUIF {
        bigint AvisoUIFId PK
        int EmpresaId FK
        int ClienteId FK
        int ActividadVulnerableId FK
        int EstatusAvisoId FK
        int PeriodoMes
        int PeriodoAnio
        date FechaLimitePresentacion
        money MontoTotalOperaciones
        decimal MontoTotalEnUMAs
        int NumeroOperaciones
        nvarchar FolioAvisoPortal
    }
    
    AvisoUIFOperacion {
        bigint AvisoUIFOperacionId PK
        bigint AvisoUIFId FK
        bigint OperacionId FK
    }
    
    AcumuladoMensualCliente {
        bigint AcumuladoMensualClienteId PK
        int EmpresaId FK
        int ClienteId FK
        int ActividadVulnerableId FK
        int PeriodoMes
        int PeriodoAnio
        money MontoAcumulado
        decimal MontoAcumuladoUMAs
        int NumeroOperaciones
        bit SuperaUmbralIdentificacion
        bit SuperaUmbralAviso
        bit RequiereAviso
        bit AvisoGenerado
    }
    
    LogMonitoreo {
        bigint LogMonitoreoId PK
        nvarchar TipoProceso
        datetime2 FechaInicio
        datetime2 FechaFin
        int EmpresaId
        int PeriodoMes
        int PeriodoAnio
        int OperacionesProcesadas
        int AlertasGeneradas
        int AvisosGenerados
        nvarchar EstatusEjecucion
    }
```

## Descripción de Entidades Principales

### Tablas de Catálogo
| Tabla | Descripción |
|-------|-------------|
| `ActividadVulnerable` | 17 actividades según Art. 17 LFPIORPI |
| `ValorUMA` | Valores históricos del UMA |
| `UmbralIdentificacionCliente` | Umbrales para identificación |
| `UmbralPresentacionAviso` | Umbrales para aviso |
| `TipoAlerta` | Tipos de alerta (IDEN_IND, AVISO_ACU, etc.) |
| `EstatusAlerta` | Estados de alerta |
| `EstatusAviso` | Estados de aviso |

### Tablas Transaccionales
| Tabla | Descripción |
|-------|-------------|
| `Operacion` | Operaciones realizadas por clientes |
| `AlertaMonitoreo` | Alertas generadas por el motor |
| `AvisoUIF` | Avisos a presentar ante la UIF |
| `AvisoUIFOperacion` | Operaciones incluidas en cada aviso |
| `AcumuladoMensualCliente` | Acumulados mensuales por cliente |
| `LogMonitoreo` | Bitácora de ejecuciones |
