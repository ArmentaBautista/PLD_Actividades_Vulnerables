# Diagrama de Decisión - Evaluación de Umbrales

Este diagrama muestra la lógica de decisión para evaluar si una operación o acumulado requiere identificación o aviso.

## Árbol de Decisión Principal

```mermaid
flowchart TD
    START([🔄 Operación<br/>Recibida]) --> A
    
    A["Obtener datos:<br/>• Monto<br/>• Fecha<br/>• Actividad Vulnerable<br/>• Cliente"]
    
    A --> B["Convertir Monto a UMAs<br/>MontoUMAs = Monto ÷ ValorUMA"]
    
    B --> C{"¿MontoUMAs ≥<br/>Umbral Identificación?"}
    
    C -->|"Sí"| D["🔔 Alerta: IDEN_IND<br/>Requiere identificación cliente"]
    C -->|"No"| E{"¿MontoUMAs ≥<br/>Umbral Aviso?"}
    
    D --> E
    
    E -->|"Sí"| F["⚠️ Alerta: AVISO_IND<br/>Operación avisable"]
    E -->|"No"| G["✓ Sin alerta individual"]
    
    F --> H["Actualizar Acumulado<br/>Mensual del Cliente"]
    G --> H
    
    H --> I["Calcular:<br/>AcumuladoUMAs = Σ Operaciones Mes"]
    
    I --> J{"¿AcumuladoUMAs ≥<br/>Umbral Identificación?"}
    
    J -->|"Sí"| K["🔔 Alerta: IDEN_ACU<br/>Requiere identificación por acumulado"]
    J -->|"No"| L{"¿AcumuladoUMAs ≥<br/>Umbral Aviso?"}
    
    K --> L
    
    L -->|"Sí"| M["⚠️ Alerta: AVISO_ACU<br/>Requiere aviso por acumulado"]
    L -->|"No"| N["✓ Sin alerta acumulada"]
    
    M --> O["Marcar: RequiereAviso = 1"]
    N --> P([Fin Evaluación])
    O --> P
    
    style D fill:#fff3e0,stroke:#ff9800
    style F fill:#ffecb3,stroke:#ffc107
    style K fill:#fff3e0,stroke:#ff9800
    style M fill:#ffecb3,stroke:#ffc107
    style G fill:#c8e6c9,stroke:#4caf50
    style N fill:#c8e6c9,stroke:#4caf50
```

## Matriz de Decisión por Actividad Vulnerable

```mermaid
flowchart LR
    subgraph ACTIVIDAD["📋 Actividad Vulnerable"]
        AV["Identificar<br/>Actividad"]
    end
    
    subgraph UMBRALES["📊 Umbrales (UMAs)"]
        direction TB
        U1["Juegos/Apuestas<br/>ID: 325 | AV: 645"]
        U2["Tarjetas Crédito<br/>ID: 805 | AV: 1,285"]
        U3["Tarjetas Prepago<br/>ID: 645 | AV: 645"]
        U4["Mutuos/Préstamos<br/>ID: 1,605 | AV: 3,210"]
        U5["Inmobiliaria<br/>ID: 8,025 | AV: 16,050"]
        U6["Metales Preciosos<br/>ID: 805 | AV: 1,605"]
        U7["Vehículos<br/>ID: 3,210 | AV: 6,420"]
        U8["...otras actividades"]
    end
    
    subgraph EVALUACION["⚖️ Evaluación"]
        E1{"Monto ≥<br/>Umbral ID?"}
        E2{"Monto ≥<br/>Umbral AV?"}
    end
    
    subgraph RESULTADO["📤 Resultado"]
        R1["Identificar Cliente"]
        R2["Generar Aviso"]
        R3["Sin acción"]
    end
    
    AV --> UMBRALES
    UMBRALES --> E1
    E1 -->|"Sí"| R1
    E1 -->|"No"| E2
    E2 -->|"Sí"| R2
    E2 -->|"No"| R3
    
    style R1 fill:#fff3e0
    style R2 fill:#ffecb3
    style R3 fill:#c8e6c9
```

## Decisión de Generación de Aviso

```mermaid
flowchart TD
    A([🗓️ Fin de Mes]) --> B{"¿Existe acumulado<br/>del cliente en mes?"}
    
    B -->|"No"| C([Sin acción])
    B -->|"Sí"| D{"¿RequiereAviso = 1?"}
    
    D -->|"No"| C
    D -->|"Sí"| E{"¿AvisoGenerado = 0?"}
    
    E -->|"No"| F([Aviso ya existe])
    E -->|"Sí"| G["Generar Aviso UIF"]
    
    G --> H["Asociar todas las<br/>operaciones del mes"]
    
    H --> I["Calcular fecha límite<br/>(Día 17 mes siguiente)"]
    
    I --> J["Establecer estatus:<br/>Pendiente"]
    
    J --> K["Marcar acumulado:<br/>AvisoGenerado = 1"]
    
    K --> L["Actualizar alertas:<br/>Estatus = Procesada"]
    
    L --> M([✅ Aviso Generado])
    
    style G fill:#e3f2fd
    style M fill:#c8e6c9
```

## Evaluación de Restricción de Efectivo

```mermaid
flowchart TD
    A([💵 Pago en Efectivo]) --> B{"¿Tipo de<br/>operación?"}
    
    B --> C["Inmuebles"]
    B --> D["Vehículos"]
    B --> E["Joyas/Metales"]
    B --> F["Obras Arte"]
    B --> G["Blindaje"]
    B --> H["Otra"]
    
    C --> C1{"Monto > 8,025 UMAs<br/>(~$908,000 MXN)?"}
    D --> D1{"Monto > 3,210 UMAs<br/>(~$363,000 MXN)?"}
    E --> E1{"Monto > 3,210 UMAs<br/>(~$363,000 MXN)?"}
    F --> F1{"Monto > 3,210 UMAs<br/>(~$363,000 MXN)?"}
    G --> G1{"Monto > 3,210 UMAs<br/>(~$363,000 MXN)?"}
    H --> OK([✅ Permitido])
    
    C1 -->|"Sí"| RECH["⛔ RECHAZAR<br/>No permitido en efectivo"]
    C1 -->|"No"| OK
    D1 -->|"Sí"| RECH
    D1 -->|"No"| OK
    E1 -->|"Sí"| RECH
    E1 -->|"No"| OK
    F1 -->|"Sí"| RECH
    F1 -->|"No"| OK
    G1 -->|"Sí"| RECH
    G1 -->|"No"| OK
    
    RECH --> ALT["Usar forma de pago alternativa:<br/>• Transferencia bancaria<br/>• Cheque nominativo<br/>• Tarjeta<br/>• SPEI"]
    
    style RECH fill:#ffcdd2,stroke:#c62828
    style OK fill:#c8e6c9,stroke:#2e7d32
```

## Tabla Resumen de Umbrales

```mermaid
%%{init: {'theme': 'base', 'themeVariables': { 'fontSize': '14px'}}}%%
flowchart LR
    subgraph TABLA["📊 UMBRALES POR ACTIVIDAD (UMAs)"]
        direction TB
        
        T1["<b>Actividad</b> | <b>Identificación</b> | <b>Aviso</b>"]
        T2["Juegos/Apuestas | 325 | 645"]
        T3["Tarjetas Crédito | 805 | 1,285"]
        T4["Tarjetas Prepago | 645 | 645"]
        T5["Cheques Viajero | 645 | 645"]
        T6["Mutuos/Préstamos | 1,605 | 3,210"]
        T7["Inmobiliaria | 8,025 | 16,050"]
        T8["Metales Preciosos | 805 | 1,605"]
        T9["Obras Arte | 2,410 | 4,815"]
        T10["Vehículos | 3,210 | 6,420"]
        T11["Blindaje | 2,410 | 4,815"]
        T12["Custodia Valores | 3,210 | 6,420"]
        T13["Serv. Profesionales | 805 | 1,605"]
        T14["Comercio Exterior | 645 | 645"]
        T15["Donativos | 1,605 | 3,210"]
        T16["Arrendamiento | 1,605 | 3,210"]
        T17["Activos Virtuales | 645 | 645"]
        
        T1 --- T2 --- T3 --- T4 --- T5 --- T6 --- T7 --- T8 --- T9 --- T10 --- T11 --- T12 --- T13 --- T14 --- T15 --- T16 --- T17
    end
    
    NOTE["<b>Nota:</b><br/>UMA 2025 = $113.14 MXN"]
    
    TABLA --- NOTE
```

## Fórmulas Clave

| Cálculo | Fórmula |
|---------|---------|
| **Monto en UMAs** | `MontoUMAs = MontoPesos ÷ ValorUMADiario` |
| **Umbral en Pesos** | `UmbralPesos = UmbralUMAs × ValorUMADiario` |
| **Fecha Límite Aviso** | `FechaLimite = Día 17 del mes siguiente a la operación` |
| **Acumulado Mensual** | `Acumulado = Σ (Operaciones del cliente en el mes)` |

## Ejemplo Práctico

```
Operación: Venta de joyería
Monto: $250,000 MXN
Fecha: 15 de marzo 2026
ValorUMA: $113.14

Cálculo:
MontoUMAs = $250,000 ÷ $113.14 = 2,209.72 UMAs

Evaluación (Metales Preciosos):
- Umbral Identificación: 805 UMAs → 2,209.72 ≥ 805 ✓ REQUIERE IDENTIFICACIÓN
- Umbral Aviso: 1,605 UMAs → 2,209.72 ≥ 1,605 ✓ REQUIERE AVISO

Resultado:
- Generar Alerta IDEN_IND
- Generar Alerta AVISO_IND
- Fecha límite aviso: 17 de abril 2026
```
