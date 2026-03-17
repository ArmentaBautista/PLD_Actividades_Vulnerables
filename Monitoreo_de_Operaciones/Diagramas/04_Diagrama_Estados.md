# Diagramas de Estados del Motor de Monitoreo PLD

Estos diagramas muestran el ciclo de vida de las alertas y avisos en el sistema.

## Ciclo de Vida de una Alerta

```mermaid
stateDiagram-v2
    [*] --> Pendiente: Alerta generada
    
    Pendiente --> EnRevision: Usuario inicia revisión
    Pendiente --> Descartada: Falso positivo detectado
    
    EnRevision --> Confirmada: Alerta validada
    EnRevision --> Descartada: No amerita acción
    EnRevision --> Pendiente: Requiere más análisis
    
    Confirmada --> Procesada: Aviso generado
    
    Descartada --> [*]
    Procesada --> [*]
    
    note right of Pendiente
        Estado inicial
        Requiere atención
    end note
    
    note right of EnRevision
        Analista revisando
        la alerta
    end note
    
    note right of Confirmada
        Alerta válida
        Pendiente de aviso
    end note
    
    note right of Procesada
        Aviso generado
        Estado final OK
    end note
    
    note right of Descartada
        No requiere acción
        Estado final
    end note
```

### Tabla de Estados de Alerta

| Estado | ID | Descripción | Acción Siguiente |
|--------|---:|-------------|------------------|
| **Pendiente** | 1 | Alerta recién generada | Iniciar revisión o descartar |
| **En Revisión** | 2 | En proceso de análisis | Confirmar o descartar |
| **Confirmada** | 3 | Validada, requiere aviso | Generar aviso |
| **Descartada** | 4 | No amerita acción | Ninguna (final) |
| **Procesada** | 5 | Aviso generado | Ninguna (final) |

---

## Ciclo de Vida de un Aviso

```mermaid
stateDiagram-v2
    [*] --> Pendiente: Aviso creado
    
    Pendiente --> EnPreparacion: Iniciar preparación
    
    EnPreparacion --> Listo: Datos completos
    EnPreparacion --> Pendiente: Faltan datos
    
    Listo --> Enviado: Enviar al portal SAT
    Listo --> EnPreparacion: Corrección necesaria
    
    Enviado --> Confirmado: Portal confirma recepción
    Enviado --> Rechazado: Portal rechaza
    
    Rechazado --> EnPreparacion: Corregir y reenviar
    
    Confirmado --> [*]
    
    note right of Pendiente
        Aviso generado
        automáticamente
    end note
    
    note right of EnPreparacion
        Validando datos
        del cliente y operaciones
    end note
    
    note right of Listo
        Listo para enviar
        al portal del SAT
    end note
    
    note right of Enviado
        Esperando confirmación
        del portal
    end note
    
    note right of Confirmado
        Aviso aceptado
        por la UIF ✓
    end note
    
    note right of Rechazado
        Requiere corrección
        y reenvío
    end note
```

### Tabla de Estados de Aviso

| Estado | ID | Descripción | Acción Siguiente |
|--------|---:|-------------|------------------|
| **Pendiente** | 1 | Aviso recién creado | Iniciar preparación |
| **En Preparación** | 2 | Validando datos | Marcar como listo |
| **Listo** | 3 | Datos completos | Enviar al portal |
| **Enviado** | 4 | Enviado a la UIF | Esperar confirmación |
| **Confirmado** | 5 | Aceptado por la UIF | Ninguna (final) |
| **Rechazado** | 6 | Rechazado por el portal | Corregir datos |

---

## Línea de Tiempo de un Aviso

```mermaid
gantt
    title Línea de Tiempo del Proceso de Aviso (Ejemplo: Operaciones de Marzo 2026)
    dateFormat  YYYY-MM-DD
    
    section Operaciones
    Período de operaciones          :active, op, 2026-03-01, 2026-03-31
    
    section Monitoreo
    Evaluación continua             :mon, 2026-03-01, 2026-03-31
    Cierre de mes                   :milestone, cierre, 2026-03-31, 0d
    
    section Generación
    Generar avisos                  :gen, 2026-04-01, 2026-04-05
    
    section Presentación
    Ventana de presentación         :crit, pres, 2026-04-01, 2026-04-17
    Fecha límite                    :milestone, crit, limite, 2026-04-17, 0d
    
    section Confirmación
    Espera confirmación             :conf, 2026-04-17, 2026-04-20
```

---

## Tipos de Alerta y su Transición

```mermaid
flowchart LR
    subgraph INDIVIDUAL["Operación Individual"]
        A1[IDEN_IND<br/>Identificación] 
        A2[AVISO_IND<br/>Aviso]
    end
    
    subgraph ACUMULADO["Acumulado Mensual"]
        A3[IDEN_ACU<br/>Identificación]
        A4[AVISO_ACU<br/>Aviso]
    end
    
    subgraph ESPECIAL["Casos Especiales"]
        A5[EFECTIVO<br/>Restricción]
        A6[INDICIOS<br/>Sospecha]
    end
    
    A1 -->|"Cliente identificado"| OK1[✓ Expediente]
    A2 -->|"Se incluye en aviso"| AV1[📤 Aviso UIF]
    
    A3 -->|"Cliente identificado"| OK2[✓ Expediente]
    A4 -->|"Se genera aviso"| AV2[📤 Aviso UIF]
    
    A5 -->|"Rechazar operación"| RECH[⛔ Rechazada]
    A6 -->|"Aviso inmediato"| AV3[📤 Aviso Urgente]
    
    style A1 fill:#fff3e0
    style A2 fill:#ffecb3
    style A3 fill:#fff3e0
    style A4 fill:#ffecb3
    style A5 fill:#ffcdd2
    style A6 fill:#f8bbd0
    style AV1 fill:#c8e6c9
    style AV2 fill:#c8e6c9
    style AV3 fill:#c8e6c9
```

## Descripción de Tipos de Alerta

| Código | Tipo | Descripción | Acción Requerida |
|--------|------|-------------|------------------|
| `IDEN_IND` | Identificación Individual | Operación individual supera umbral | Integrar expediente KYC |
| `IDEN_ACU` | Identificación Acumulada | Acumulado mensual supera umbral | Integrar expediente KYC |
| `AVISO_IND` | Aviso Individual | Operación individual supera umbral aviso | Incluir en aviso mensual |
| `AVISO_ACU` | Aviso Acumulado | Acumulado mensual supera umbral aviso | Generar aviso UIF |
| `EFECTIVO` | Restricción Efectivo | Intento de pago en efectivo sobre límite | Rechazar operación |
| `INDICIOS` | Indicios | Operación sospechosa detectada | Aviso inmediato |
