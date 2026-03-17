# Diagrama de Secuencia del Motor de Monitoreo PLD

Este diagrama muestra la interacción entre los procedimientos almacenados durante el proceso de monitoreo.

## Secuencia: Registro y Evaluación de Operación

```mermaid
sequenceDiagram
    autonumber
    participant App as 📱 Aplicación
    participant Op as 📄 Operacion
    participant Eval as ⚖️ EvaluarOperacionIndividual
    participant FnUMA as 🔢 ConvertirMontoAUMAs
    participant FnUmb as 📊 ObtenerUmbralIdentificacion
    participant Alerta as 🔔 AlertaMonitoreo
    participant Acum as 📈 ActualizarAcumuladoMensual
    participant AcumTab as 💾 AcumuladoMensualCliente

    App->>Op: INSERT operación
    activate Op
    Op-->>App: OperacionId
    deactivate Op
    
    App->>Eval: EvaluarOperacionAlInsertar(OperacionId)
    activate Eval
    
    Eval->>Op: SELECT datos operación
    Op-->>Eval: Monto, Fecha, Cliente, Actividad
    
    Eval->>FnUMA: ConvertirMontoAUMAs(Monto, Fecha)
    activate FnUMA
    FnUMA->>FnUMA: ObtenerValorUMAVigente(Fecha)
    FnUMA-->>Eval: MontoEnUMAs
    deactivate FnUMA
    
    Eval->>FnUmb: ObtenerUmbralIdentificacion(ActividadId)
    FnUmb-->>Eval: UmbralIdentificaciónUMAs
    
    Eval->>FnUmb: ObtenerUmbralAviso(ActividadId)
    FnUmb-->>Eval: UmbralAvisoUMAs
    
    alt Monto >= Umbral Identificación
        Eval->>Alerta: INSERT alerta IDEN_IND
        Alerta-->>Eval: AlertaId
    end
    
    alt Monto >= Umbral Aviso
        Eval->>Alerta: INSERT alerta AVISO_IND
        Alerta-->>Eval: AlertaId
    end
    
    Eval->>Acum: ActualizarAcumuladoMensual(Empresa, Cliente, Actividad, Mes, Año)
    activate Acum
    
    Acum->>Op: SELECT SUM(operaciones del mes)
    Op-->>Acum: MontoAcumulado, NumOperaciones
    
    Acum->>FnUMA: ConvertirMontoAUMAs(Acumulado, FechaFinMes)
    FnUMA-->>Acum: AcumuladoEnUMAs
    
    Acum->>AcumTab: MERGE acumulado mensual
    AcumTab-->>Acum: ✓
    
    alt Acumulado >= Umbral Identificación
        Acum->>Alerta: INSERT alerta IDEN_ACU
    end
    
    alt Acumulado >= Umbral Aviso
        Acum->>Alerta: INSERT alerta AVISO_ACU
    end
    
    Acum-->>Eval: ✓
    deactivate Acum
    
    Eval-->>App: Resultado evaluación
    deactivate Eval
```

## Secuencia: Ejecución del Monitoreo Completo

```mermaid
sequenceDiagram
    autonumber
    participant Admin as 👤 Administrador
    participant Motor as 🔄 EjecutarMonitoreoPLD
    participant Log as 📋 LogMonitoreo
    participant Recalc as 🔁 RecalcularAcumuladosMensuales
    participant Acum as 📈 ActualizarAcumuladoMensual
    participant GenAv as 📤 GenerarAvisosAutomaticos
    participant Aviso as 📃 GenerarAvisoUIF
    participant AvisoTab as 💾 AvisoUIF

    Admin->>Motor: EXEC EjecutarMonitoreoPLD @Mes, @Anio, @GenerarAvisos=1
    activate Motor
    
    Motor->>Log: INSERT inicio proceso
    Log-->>Motor: LogId
    
    rect rgb(230, 245, 255)
        Note over Motor,Acum: PASO 1: Recalcular Acumulados
        Motor->>Recalc: RecalcularAcumuladosMensuales(@EmpresaId, @Mes, @Anio)
        activate Recalc
        
        loop Por cada Cliente con operaciones
            Recalc->>Acum: ActualizarAcumuladoMensual(...)
            Acum-->>Recalc: ✓
        end
        
        Recalc-->>Motor: ClientesProcesados
        deactivate Recalc
    end
    
    rect rgb(255, 243, 224)
        Note over Motor,Aviso: PASO 2: Contar Alertas
        Motor->>Motor: SELECT COUNT(*) FROM AlertaMonitoreo
        Motor-->>Motor: AlertasGeneradas
    end
    
    rect rgb(232, 245, 233)
        Note over Motor,AvisoTab: PASO 3: Generar Avisos
        Motor->>GenAv: GenerarAvisosAutomaticos(@EmpresaId, @Mes, @Anio, @UsuarioId)
        activate GenAv
        
        loop Por cada Cliente con RequiereAviso=1 AND AvisoGenerado=0
            GenAv->>Aviso: GenerarAvisoUIF(...)
            activate Aviso
            
            Aviso->>AvisoTab: INSERT aviso
            AvisoTab-->>Aviso: AvisoUIFId
            
            Aviso->>AvisoTab: INSERT operaciones del aviso
            
            Aviso->>Aviso: UPDATE AcumuladoMensualCliente SET AvisoGenerado=1
            
            Aviso->>Aviso: UPDATE AlertaMonitoreo SET Estatus=Procesada
            
            Aviso-->>GenAv: AvisoUIFId
            deactivate Aviso
        end
        
        GenAv-->>Motor: AvisosGenerados
        deactivate GenAv
    end
    
    Motor->>Log: UPDATE fin proceso, resultados
    
    Motor-->>Admin: Resumen: Clientes, Alertas, Avisos
    deactivate Motor
```

## Secuencia: Generación de Aviso Individual

```mermaid
sequenceDiagram
    autonumber
    participant Usuario as 👤 Usuario
    participant GenAv as 📤 GenerarAvisoUIF
    participant Acum as 💾 AcumuladoMensualCliente
    participant FnUmb as 📊 ObtenerUmbralAviso
    participant FnFecha as 📅 CalcularFechaLimitePresentacion
    participant AvisoTab as 📃 AvisoUIF
    participant OpAviso as 🔗 AvisoUIFOperacion
    participant Alerta as 🔔 AlertaMonitoreo

    Usuario->>GenAv: GenerarAvisoUIF(@EmpresaId, @ClienteId, @ActividadId, @Mes, @Anio, @UsuarioId)
    activate GenAv
    
    GenAv->>AvisoTab: SELECT * WHERE mismo período
    AvisoTab-->>GenAv: ¿Existe?
    
    alt Ya existe aviso
        GenAv-->>Usuario: ERROR: Ya existe aviso para este período
    else No existe
        GenAv->>Acum: SELECT MontoAcumulado, NumOperaciones
        Acum-->>GenAv: Datos acumulado
        
        GenAv->>FnUmb: ObtenerUmbralAviso(@ActividadId)
        FnUmb-->>GenAv: UmbralUMAs
        
        alt Monto < Umbral
            GenAv-->>Usuario: ERROR: No supera umbral de aviso
        else Monto >= Umbral
            GenAv->>FnFecha: CalcularFechaLimitePresentacion(@FechaFinMes)
            FnFecha-->>GenAv: Día 17 del mes siguiente
            
            GenAv->>GenAv: BEGIN TRANSACTION
            
            GenAv->>AvisoTab: INSERT aviso
            AvisoTab-->>GenAv: AvisoUIFId
            
            GenAv->>OpAviso: INSERT operaciones del período
            OpAviso-->>GenAv: ✓
            
            GenAv->>Acum: UPDATE AvisoGenerado = 1
            Acum-->>GenAv: ✓
            
            GenAv->>Alerta: UPDATE alertas a Procesada
            Alerta-->>GenAv: ✓
            
            GenAv->>GenAv: COMMIT TRANSACTION
            
            GenAv-->>Usuario: AvisoUIFId, Datos del aviso
        end
    end
    
    deactivate GenAv
```

## Notas

- Las funciones escalares (`ConvertirMontoAUMAs`, `ObtenerUmbralIdentificacion`, etc.) se ejecutan sincrónicamente
- Los procedimientos de acumulación y generación de avisos utilizan transacciones para garantizar integridad
- El motor principal registra cada ejecución en `LogMonitoreo` para auditoría
