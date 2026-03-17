
# Guía Técnica de Monitoreo PLD

## Actividades Vulnerables – LFPIORPI

**Marco normativo:**

A continuación te presento una **guía estructurada en tablas para diseñar reglas de negocio de monitoreo y acumulación de operaciones de Actividades Vulnerables** conforme a la **Ley Federal para la Prevención e Identificación de Operaciones con Recursos de Procedencia Ilícita (LFPIORPI)**, su Reglamento y las Reglas de Carácter General.

Estas reglas se utilizan normalmente para **parametrizar motores de monitoreo PLD/FT o controles internos** para determinar:

-   cuándo **identificar al cliente o usuario**,
-   cuándo **acumular operaciones**,
-   cuándo **generar un aviso**, y
-   cómo **determinar el periodo de acumulación**.

La obligación de identificar clientes y presentar avisos deriva principalmente del **artículo 17 de la LFPIORPI** y del **artículo 22 del Reglamento**, que establecen que se debe presentar aviso cuando el monto del acto u operación **individual o acumulado** alcance el umbral correspondiente.

---

# 1. Modelo general de monitoreo PLD para Actividades Vulnerables

## Objetivo

Diseñar reglas de negocio para:

* Identificación de clientes
* Monitoreo de operaciones
* Acumulación de operaciones
* Generación de avisos a la UIF
* Cumplimiento del plazo de reporte

---

# 2. Tabla base de lógica de monitoreo (regla general del sistema)

| Elemento de regla | Descripción | Fundamento |
| --- | --- | --- |
| Fecha del acto u operación | Se considera la fecha en que se celebra el acto u operación para efectos de identificación y aviso | Reglamento art. 5 |
| Tipo de evaluación | Puede ser **operación individual** o **acumulación de operaciones** | Art. 17 LFPIORPI |
| Periodo de acumulación | Generalmente **mensual por cliente o usuario** | Art. 17 LFPIORPI |
| Inicio del cómputo | Desde la **primera operación del mes calendario** | Práctica derivada del art. 17 |
| Umbral de identificación | Determina si debe integrarse expediente de identificación | Art. 17 |
| Umbral de aviso | Determina si debe presentarse aviso a la UIF | Art. 17 |
| Fecha límite para aviso | Día **17 del mes siguiente** a la operación | Art. 18 fr. VI LFPIORPI y Reglas |
| Identificador de acumulación | Cliente / Usuario / Beneficiario controlador | Reglas PLD |

---


# 3. Reglas para identificación de clientes

| Regla | Tipo operación        | Evaluación              | Umbral                  | Periodo    | Acción                     |
| ----- | --------------------- | ----------------------- | ----------------------- | ---------- | -------------------------- |
| R1    | Operación individual  | Comparar monto          | ≥ umbral identificación | N/A        | Integrar expediente        |
| R2    | Operaciones múltiples | Sumar operaciones       | ≥ umbral identificación | Mensual    | Integrar expediente        |
| R3    | Relación de negocios  | Operaciones recurrentes | Independiente del monto | Permanente | Identificación obligatoria |

### Lógica de sistema

```
Si monto_operacion >= umbral_identificacion
    requerir_identificacion_cliente

Si suma_operaciones_mes >= umbral_identificacion
    requerir_identificacion_cliente
```

---

# 4. Reglas para generación de avisos

| Regla | Evaluación             | Condición                   | Umbral       | Periodo   | Resultado       |
| ----- | ---------------------- | --------------------------- | ------------ | --------- | --------------- |
| R4    | Individual             | Monto ≥ umbral aviso        | Umbral aviso | Inmediato | Generar aviso   |
| R5    | Acumulada              | Suma mensual ≥ umbral aviso | Umbral aviso | Mensual   | Generar aviso   |
| R6    | Operación con indicios | Recursos ilícitos           | Sin umbral   | Inmediato | Aviso inmediato |

---

# 5. Reglas de acumulación de operaciones

| Regla | Unidad acumulación       | Campo control   | Periodo  | Reinicio              |
| ----- | ------------------------ | --------------- | -------- | --------------------- |
| AC1   | Cliente                  | ID cliente      | Mensual  | Primer día del mes    |

---

# 6. Matriz general de monitoreo por Actividad Vulnerable

| ID   | Actividad Vulnerable    | Evaluación       | Identificación | Aviso     | Acumulación | Periodo |
| ---- | ----------------------- | ---------------- | -------------- | --------- | ----------- | ------- |
| AV1  | Juegos con apuesta      | Individual       | 325 UMA        | 645 UMA   | Sí          | Mensual |
| AV2  | Tarjetas de crédito     | Individual       | 805 UMA        | 1,605 UMA | Sí          | Mensual |
| AV3  | Tarjetas prepagadas     | Individual       | 645 UMA        | 1,285 UMA | Sí          | Mensual |
| AV4  | Cheques de viajero      | Individual       | 645 UMA        | 1,285 UMA | Sí          | Mensual |
| AV5  | Mutuos y préstamos      | Individual       | 1,605 UMA      | 3,210 UMA | Sí          | Mensual |
| AV6  | Inmobiliarias           | Individual       | 805 UMA        | 1,605 UMA | Sí          | Mensual |
| AV7  | Metales preciosos       | Individual       | 805 UMA        | 1,605 UMA | Sí          | Mensual |
| AV8  | Obras de arte           | Individual       | 2,410 UMA      | 4,815 UMA | Sí          | Mensual |
| AV9  | Vehículos               | Individual       | 3,210 UMA      | 6,420 UMA | Sí          | Mensual |
| AV10 | Blindaje                | Individual       | 2,410 UMA      | 4,815 UMA | Sí          | Mensual |
| AV11 | Custodia de valores     | Individual       | 3,210 UMA      | 6,420 UMA | Sí          | Mensual |
| AV12 | Servicios profesionales | Individual       | 805 UMA        | 1,605 UMA | Sí          | Mensual |
| AV13 | Fedatarios públicos     | Depende del acto | Variable       | Variable  | Sí          | Mensual |
| AV14 | Comercio exterior       | Individual       | 3,210 UMA      | 6,420 UMA | Sí          | Mensual |
| AV15 | Donativos               | Individual       | 1,605 UMA      | 3,210 UMA | Sí          | Mensual |
| AV16 | Arrendamiento           | Individual       | 1,605 UMA      | 3,210 UMA | Sí          | Mensual |

---

# 6.1 Tabla de línea de tiempo de cumplimiento

| Evento | Momento | Acción |
| --- | --- | --- |
| Realización de operación | Día 0 | Registrar operación |
| Evaluación de umbral | Día 0 | Motor de monitoreo |
| Acumulación mensual | Durante el mes | Actualizar monto acumulado |
| Cierre de periodo | Último día del mes | Determinar operaciones avisables |
| Presentación de aviso | Hasta día 17 del mes siguiente | Enviar aviso en portal PLD |

Fundamento:  
Los avisos deben presentarse **a más tardar el día 17 del mes inmediato siguiente al acto u operación**.

---

# 7. Matriz de umbrales en UMA y pesos

**Referencia aproximada: UMA 2025 = $113.14 MXN**

| Actividad           | Identificación UMA | Aviso UMA | Identificación MXN | Aviso MXN |
| ------------------- | ------------------ | --------- | ------------------ | --------- |
| Juegos con apuesta  | 325                | 645       | $36,770            | $72,971   |
| Tarjetas crédito    | 805                | 1,605     | $91,077            | $181,590  |
| Tarjetas prepagadas | 645                | 1,285     | $72,971            | $145,399  |
| Cheques viajero     | 645                | 1,285     | $72,971            | $145,399  |
| Mutuos              | 1,605              | 3,210     | $181,590           | $363,180  |
| Inmobiliario        | 805                | 1,605     | $91,077            | $181,590  |
| Metales             | 805                | 1,605     | $91,077            | $181,590  |
| Arte                | 2,410              | 4,815     | $272,668           | $544,771  |
| Vehículos           | 3,210              | 6,420     | $363,180           | $726,360  |
| Blindaje            | 2,410              | 4,815     | $272,668           | $544,771  |
| Custodia valores    | 3,210              | 6,420     | $363,180           | $726,360  |
| Profesionales       | 805                | 1,605     | $91,077            | $181,590  |
| Donativos           | 1,605              | 3,210     | $181,590           | $363,180  |
| Arrendamiento       | 1,605              | 3,210     | $181,590           | $363,180  |

---

# 8. Ejemplo práctico de acumulación

Cliente realiza operaciones de joyería:

| Fecha    | Monto   |
| -------- | ------- |
| 5 enero  | $90,000 |
| 12 enero | $80,000 |
| 28 enero | $60,000 |

Acumulación mensual:

```
90,000
+ 80,000
+ 60,000
= 230,000
```

Resultado:

* No supera umbral individual
* Sí puede superar **umbral acumulado**
* Se genera **aviso**

---

# 9. Matriz general de monitoreo por Actividad Vulnerable (modelo de reglas)

| ID  | Actividad Vulnerable (Art. 17) | Evaluación | Umbral Identificación | Umbral Aviso | Acumulación | Periodo | Evento de control |
| --- | --- | --- | --- | --- | --- | --- | --- |
| AV1 | Juegos con apuesta, concursos o sorteos | Individual | ≥ 325 UMA | ≥ 645 UMA | Sí  | Mensual | Al registrar operación |
| AV2 | Emisión o comercialización de tarjetas de servicio o crédito | Individual | ≥ 805 UMA | ≥ 1,605 UMA | Sí  | Mensual | Al emitir o comercializar |
| AV3 | Tarjetas prepagadas o monederos | Individual | ≥ 645 UMA | ≥ 1,285 UMA | Sí  | Mensual | Al cargar saldo |
| AV4 | Cheques de viajero | Individual | ≥ 645 UMA | ≥ 1,285 UMA | Sí  | Mensual | Al vender |
| AV5 | Mutuo, préstamo o crédito no financiero | Individual | ≥ 1,605 UMA | ≥ 3,210 UMA | Sí  | Mensual | Al otorgar crédito |
| AV6 | Construcción, desarrollo o intermediación inmobiliaria | Individual | ≥ 805 UMA | ≥ 1,605 UMA | Sí  | Mensual | Al celebrar contrato |
| AV7 | Comercialización de metales y piedras preciosas | Individual | ≥ 805 UMA | ≥ 1,605 UMA | Sí  | Mensual | Al vender |
| AV8 | Subasta o comercialización de obras de arte | Individual | ≥ 2,410 UMA | ≥ 4,815 UMA | Sí  | Mensual | Al vender |
| AV9 | Comercialización de vehículos terrestres, marítimos o aéreos | Individual | ≥ 3,210 UMA | ≥ 6,420 UMA | Sí  | Mensual | Al vender |
| AV10 | Servicios de blindaje de vehículos o inmuebles | Individual | ≥ 2,410 UMA | ≥ 4,815 UMA | Sí  | Mensual | Al contratar |
| AV11 | Traslado o custodia de valores | Individual | ≥ 3,210 UMA | ≥ 6,420 UMA | Sí  | Mensual | Al contratar |
| AV12 | Servicios profesionales (abogados, contadores, etc.) | Individual | ≥ 805 UMA | ≥ 1,605 UMA | Sí  | Mensual | Al celebrar acto |
| AV13 | Servicios de fe pública (notarios/corredores) | Individual | Depende del acto | Depende del acto | Sí  | Mensual | Al formalizar acto |
| AV14 | Comercio exterior (agentes aduanales) | Individual | ≥ 3,210 UMA | ≥ 6,420 UMA | Sí  | Mensual | Al realizar operación |
| AV15 | Donativos de organizaciones sin fines de lucro | Individual | ≥ 1,605 UMA | ≥ 3,210 UMA | Sí  | Mensual | Al recibir donativo |
| AV16 | Arrendamiento de bienes inmuebles | Individual | ≥ 1,605 UMA | ≥ 3,210 UMA | Sí  | Mensual | Al recibir renta |

---

# 10. Tabla de temporalidad de monitoreo

| Evento | Momento | Acción del sistema |
| --- | --- | --- |
| Registro operación | Día de operación | Guardar transacción |
| Evaluación individual | Inmediata | Comparar con umbrales |
| Actualización acumulado | Cada operación | Sumar monto mensual |
| Cierre de periodo | Fin de mes | Identificar operaciones avisables |

---


