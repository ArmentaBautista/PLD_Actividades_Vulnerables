# Diagrama de Arquitectura del Motor de Monitoreo PLD

Este diagrama muestra los componentes del sistema y cómo se integran.

## Arquitectura de Componentes

```mermaid
flowchart TB
    subgraph CAPA_PRESENTACION["🖥️ CAPA DE PRESENTACIÓN"]
        UI_Web["Portal Web<br/>Administración"]
        UI_Reports["Reportes y<br/>Dashboards"]
        Portal_SAT["Portal SAT<br/>(Externo)"]
    end
    
    subgraph CAPA_APLICACION["⚙️ CAPA DE APLICACIÓN"]
        API["API de<br/>Servicios"]
        Scheduler["Scheduler<br/>Tareas Programadas"]
    end
    
    subgraph MOTOR_MONITOREO["🔄 MOTOR DE MONITOREO PLD"]
        direction TB
        
        subgraph FUNCIONES["📐 FUNCIONES"]
            F1["ObtenerValorUMAVigente"]
            F2["ConvertirMontoAUMAs"]
            F3["ObtenerUmbralIdentificacion"]
            F4["ObtenerUmbralAviso"]
            F5["CalcularFechaLimitePresentacion"]
            F6["EvaluarSuperaUmbral"]
        end
        
        subgraph PROCEDIMIENTOS["📋 PROCEDIMIENTOS"]
            P1["EvaluarOperacionIndividual"]
            P2["ActualizarAcumuladoMensual"]
            P3["RecalcularAcumuladosMensuales"]
            P4["GenerarAvisoUIF"]
            P5["GenerarAvisosAutomaticos"]
            P6["EjecutarMonitoreoPLD"]
        end
        
        subgraph CONSULTAS["🔍 CONSULTAS"]
            Q1["ObtenerAlertasPendientes"]
            Q2["ObtenerAvisosPendientes"]
            Q3["ResumenMonitoreoPLD"]
            Q4["ObtenerDetalleOperacionesCliente"]
        end
    end
    
    subgraph CAPA_DATOS["💾 CAPA DE DATOS"]
        subgraph CATALOGOS["📚 Catálogos"]
            C1[("ActividadVulnerable")]
            C2[("ValorUMA")]
            C3[("UmbralIdentificacion")]
            C4[("UmbralAviso")]
            C5[("TipoAlerta")]
            C6[("EstatusAlerta")]
        end
        
        subgraph TRANSACCIONAL["📊 Transaccional"]
            T1[("Operacion")]
            T2[("AlertaMonitoreo")]
            T3[("AvisoUIF")]
            T4[("AcumuladoMensualCliente")]
            T5[("LogMonitoreo")]
        end
    end
    
    UI_Web --> API
    UI_Reports --> API
    Scheduler --> API
    
    API --> PROCEDIMIENTOS
    API --> CONSULTAS
    
    PROCEDIMIENTOS --> FUNCIONES
    PROCEDIMIENTOS --> TRANSACCIONAL
    FUNCIONES --> CATALOGOS
    
    CONSULTAS --> TRANSACCIONAL
    CONSULTAS --> CATALOGOS
    
    API -.->|"Envío de avisos"| Portal_SAT
    
    style MOTOR_MONITOREO fill:#e3f2fd
    style CAPA_DATOS fill:#e8f5e9
    style CAPA_APLICACION fill:#fff3e0
    style CAPA_PRESENTACION fill:#fce4ec
```

## Arquitectura de Datos

```mermaid
flowchart LR
    subgraph ENTRADA["📥 ENTRADA"]
        OP[("Operaciones<br/>Diarias")]
        UMA[("Valor UMA<br/>Anual")]
        CONFIG[("Configuración<br/>Umbrales")]
    end
    
    subgraph PROCESAMIENTO["⚙️ PROCESAMIENTO"]
        direction TB
        EVAL["Evaluación<br/>Individual"]
        ACUM["Acumulación<br/>Mensual"]
        ALERT["Generación<br/>Alertas"]
        AVISO["Generación<br/>Avisos"]
    end
    
    subgraph SALIDA["📤 SALIDA"]
        ALERTAS[("Alertas<br/>Generadas")]
        AVISOS[("Avisos<br/>UIF")]
        LOGS[("Logs de<br/>Ejecución")]
        REPORTES["Reportes<br/>Cumplimiento"]
    end
    
    OP --> EVAL
    UMA --> EVAL
    CONFIG --> EVAL
    
    EVAL --> ACUM
    EVAL --> ALERT
    ACUM --> ALERT
    ALERT --> AVISO
    
    ALERT --> ALERTAS
    AVISO --> AVISOS
    AVISO --> LOGS
    
    ALERTAS --> REPORTES
    AVISOS --> REPORTES
    LOGS --> REPORTES
    
    style ENTRADA fill:#e3f2fd
    style PROCESAMIENTO fill:#fff8e1
    style SALIDA fill:#e8f5e9
```

## Flujo de Integración

```mermaid
flowchart TB
    subgraph SISTEMAS_ORIGEN["🏢 SISTEMAS ORIGEN"]
        SIS1["Sistema<br/>Ventas"]
        SIS2["Sistema<br/>Cobranza"]
        SIS3["Sistema<br/>Créditos"]
        SIS4["Sistema<br/>Servicios"]
    end
    
    subgraph INTEGRACION["🔌 CAPA DE INTEGRACIÓN"]
        ETL["ETL /<br/>Integración"]
        VAL["Validación<br/>de Datos"]
    end
    
    subgraph PLD["🛡️ SISTEMA PLD"]
        direction TB
        BD[("Base de Datos<br/>PLD")]
        MOTOR["Motor de<br/>Monitoreo"]
        ADMIN["Módulo<br/>Administración"]
    end
    
    subgraph EXTERNOS["🌐 SISTEMAS EXTERNOS"]
        SAT["Portal SAT<br/>(UIF)"]
        LISTAS["Listas<br/>Restrictivas"]
    end
    
    SIS1 --> ETL
    SIS2 --> ETL
    SIS3 --> ETL
    SIS4 --> ETL
    
    ETL --> VAL
    VAL --> BD
    
    BD <--> MOTOR
    BD <--> ADMIN
    
    MOTOR -.->|"Consulta listas"| LISTAS
    ADMIN -->|"Envío avisos"| SAT
    
    style PLD fill:#e8f5e9
    style INTEGRACION fill:#fff3e0
```

## Componentes del Motor

```mermaid
mindmap
  root((Motor de<br/>Monitoreo PLD))
    FUNCIONES
      ObtenerValorUMAVigente
      ConvertirMontoAUMAs
      ConvertirUMAsAPesos
      ObtenerUmbralIdentificacion
      ObtenerUmbralAviso
      CalcularFechaLimitePresentacion
      ObtenerInicioMes
      ObtenerFinMes
      EvaluarSuperaUmbralIdentificacion
      EvaluarSuperaUmbralAviso
    EVALUACION
      EvaluarOperacionIndividual
      EvaluarOperacionAlInsertar
    ACUMULACION
      ActualizarAcumuladoMensual
      RecalcularAcumuladosMensuales
      ObtenerAcumuladoCliente
      ObtenerHistorialAcumuladosCliente
    ALERTAS_AVISOS
      GenerarAvisoUIF
      GenerarAvisosAutomaticos
      ObtenerAlertasPendientes
      ObtenerAvisosPendientes
      ActualizarEstatusAlerta
      ActualizarEstatusAviso
    MOTOR_PRINCIPAL
      EjecutarMonitoreoPLD
      ResumenMonitoreoPLD
      ObtenerDetalleOperacionesCliente
```

## Descripción de Capas

### Capa de Presentación
- **Portal Web**: Interfaz para administradores de PLD
- **Reportes**: Dashboards y reportes de cumplimiento
- **Portal SAT**: Sistema externo para presentación de avisos

### Capa de Aplicación
- **API**: Servicios REST para operaciones del motor
- **Scheduler**: Ejecución programada del monitoreo

### Motor de Monitoreo
- **Funciones**: Cálculos y conversiones (UMA, umbrales, fechas)
- **Procedimientos**: Lógica de negocio principal
- **Consultas**: Obtención de información y reportes

### Capa de Datos
- **Catálogos**: Configuración del sistema
- **Transaccional**: Operaciones, alertas y avisos
