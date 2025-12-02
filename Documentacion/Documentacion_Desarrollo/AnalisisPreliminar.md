
# Funcionalidad: OnBoarding de Empresas (Actividades Vulerables)
---
## Contexto
--- 
## Reglas de Negocio:
- Considerar la identificación del **Tipo y SubTipo de Actividad Vulerable**

--- 
| Codigo | Tipo                                                             | SubTipo                                                                                                                                |
|--------|------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| I      | Juegos con apuesta                                               | juegos con apuesta                                                                                                                     |
| I      | Juegos con apuesta                                               | concursos o sorteos                                                                                                                    |
| I      | Juegos con apuesta                                               | venta de boletos, fichas o comprobantes                                                                                                |
| II     | Tarjetas y cupones de valor                                      | Tarjetas prepagadas                                                                                                                    |
| II     | Tarjetas y cupones de valor                                      | Tarjetas de servicios                                                                                                                  |
| II     | Tarjetas y cupones de valor                                      | Cupones                                                                                                                                |
| II     | Tarjetas y cupones de valor                                      | Monederos electrónicos u otros instrumentos que almacenen valor monetario.                                                             |
| III    | Cheques de viajero                                               |                                                                                                                                        |
| IV     | Mutuo, préstamo o crédito                                        | mutuos                                                                                                                                 |
| IV     | Mutuo, préstamo o crédito                                        | préstamos o créditos                                                                                                                   |
| V      | Desarrollo o comercialización de bienes inmuebles                | desarrollo de bienes inmuebles,                                                                                                        |
| V      | Desarrollo o comercialización de bienes inmuebles                | intermediación o                                                                                                                       |
| V      | Desarrollo o comercialización de bienes inmuebles                | comercialización (venta).                                                                                                              |
| VI     | Comercialización o intermediación de metales y piedras preciosas |                                                                                                                                        |
| VII    | Obras de arte                                                    |                                                                                                                                        |
| VIII   | Vehículos                                                        | terrestres                                                                                                                             |
| VIII   | Vehículos                                                        | aéreos                                                                                                                                 |
| VIII   | Vehículos                                                        | marítimos.                                                                                                                             |
| IX     | Traslado o custodia de valores                                   | dinero,                                                                                                                                |
| IX     | Traslado o custodia de valores                                   | valores,                                                                                                                               |
| IX     | Traslado o custodia de valores                                   | metales preciosos,                                                                                                                     |
| IX     | Traslado o custodia de valores                                   | joyas u objetos de valor.                                                                                                              |
| X      | Servicios de blindaje                                            | vehículos,                                                                                                                             |
| X      | Servicios de blindaje                                            | inmuebles,                                                                                                                             |
| X      | Servicios de blindaje                                            | otros bienes.                                                                                                                          |
| XI     | Servicios de fe pública                                          | Notarios,                                                                                                                              |
| XI     | Servicios de fe pública                                          | Corredores públicos,                                                                                                                   |
| XI     | Servicios de fe pública                                          | Fedatarios públicos en general, en actos específicos detallados en la ley (compraventa, constitución de derechos, fideicomisos, etc.). |
| XII    | Arrendamiento                                                    |                                                                                                                                        |
| XIII   | Servicios profesionales independientes                           | compra/venta de bienes,                                                                                                                |
| XIII   | Servicios profesionales independientes                           | manejo de recursos,                                                                                                                    |
| XIII   | Servicios profesionales independientes                           | administración y transferencia de valores,                                                                                             |
| XIII   | Servicios profesionales independientes                           | organización de aportaciones de capital,                                                                                               |
| XIII   | Servicios profesionales independientes                           | creación de personas morales, fideicomisos u otros vehículos corporativos.                                                             |
| XIV    | Comercio exterior                                                |                                                                                                                                        |
| XV     | Donativos                                                        |                                                                                                                                        |
| XVI    | Intercambio de activos virtuales                                 | intercambio entre activos virtuales,                                                                                                   |
| XVI    | Intercambio de activos virtuales                                 | intercambio entre activos virtuales y moneda de curso legal,                                                                           |
| XVI    | Intercambio de activos virtuales                                 | transferencia, custodia o administración de activos virtuales.                                                                         |
---



# Funcionalidad: Catálogo de Clientes
---
## Contexto 
Artículo 18. Quienes realicen las Actividades Vulnerables a que se refiere el artículo anterior tendrán las obligaciones siguientes: 
I. Identificar y conocer de manera directa a las personas Clientes o Usuarias con quienes realicen la Actividad Vulnerable y verificar su identidad basándose en documentos u otros medios de identificación con reconocimiento oficial, así como recabar copia de los mismos, de conformidad con las Reglas de carácter general que emita la Secretaría; Fracción reformada DOF 16-07-2025 

---
## Reglas de Negocio:
- Identificar al cliente
- Posible uso de listas de riesgo internas y externas como QeQ
- Identificar el tipo de relación "Solo Cliente", "Relación de Negocios"
- Donde el tipo de relación sea "Relación de Negocios", debe solicitarse información de su actividad y ocupación,  **basándose entre otros, en los avisos de inscripción y actualización de actividades**.
- Cuando la Cliente o Usuaria sea persona moral, fideicomiso u otra figura jurídica, recabar documentos u otros medios de identificación con reconocimiento oficial que permita identificar a su Beneficiario Controlador
- Cuando la Cliente o Usuaria sea persona física, recabar la declaración acerca de si tiene o no conocimiento de la existencia de una persona Beneficiario Controlador y, en su caso, la documentación que permita identificarla, de conformidad con las Reglas de carácter general que emita la Secretaría; Fracción reformada DOF 16-07-2025. **¿Cúales son estas reglas**

### Elementos KYC que son iguales para TODAS las Actividades Vulnerables

-- Identificación del Cliente o Usuario (art. 18, fracc. II LFPIORPI).
-- Identificación del Beneficiario Controlador (art. 3, fracc. III LFPIORPI).
-- Integración de expediente con:
-- Identificación oficial.
-- Comprobante de domicilio.
-- RFC y acta constitutiva para personas morales.
-- Poderes o documentos que acrediten representación.
-- Verificación de información.
-- Conservación 5 años (art. 25 LFPIORPI).
-- Medidas reforzadas cuando el cliente es Persona Políticamente Expuesta (PEP).
-- Clasificación de riesgo (Reglas de Carácter General, Capítulo II).

### TABLA GENERAL DE DATOS BASE – KYC UNIVERSAL
| Campo | Descripción | Obligatorio | Fundamento |
|-------|-------------|-------------|-------------|
| ID Cliente | Identificador interno único | Sí | Control interno |
| Tipo de Cliente | PF / PM / Fideicomiso / PEP | Sí | Art. 18-I LFPIORPI |
| Nombre / Razón Social | Datos de identificación | Sí | Art. 18-I |
| Nacionalidad | Para evaluar riesgo geográfico | Sí | Art. 18 |
| Fecha de nacimiento / Constitución | Identificación | Sí | Art. 18 |
| RFC / CURP | Identificación fiscal | Sí | Art. 18 |
| Identificación oficial | INE / Pasaporte / Cédula | Sí | Art. 18 |
| Domicilio | Comprobante < 3 meses | Sí | Art. 18 |
| Actividad económica | Declaración formal | Sí | Art. 18 |
| Origen de recursos | Declaración + soporte | Sí (cuando aplique) | Art. 18 |
| Beneficiario Controlador | Nombre, % participación | Sí (PM) | Art. 18 Bis |
| Representante legal | Datos completos | PM | Art. 18 |
| Medio de contacto | Tel, correo | Sí | Control interno |
| Tipo de Relación | Ocasional / Continua | Sí | Enfoque basado en riesgo |
| Clasificación de Riesgo | Bajo / Medio / Alto | Sí | RCG Cap. II |
| Documentos cargados | Lista de archivos | Sí | Art. 18 |

---
### KYC reforzado según nivel de riesgo (independientemente de la actividad)
Cuando el cliente es:
-- PEP
-- Extranjero sin residencia habitual
-- Opera en efectivo
-- Utiliza terceros o representantes inusuales
-- Estructuras jurídicas complejas
Se debe aplicar debida diligencia reforzada (DDR):
Preguntas adicionales.
-- Documentación financiera.
-- Origen de recursos.
-- Verificación más profunda del beneficiario controlador.
### TABLA DE DATOS – KYC REFORZADA
| Componente KYC | Medida Reforzada | Objetivo de PLD/FT |
|----------------|------------------|---------------------|
| Identificación | Datos adicionales (actividad, propósito, ingresos) | Conocer a detalle al cliente |
| Verificación | Comprobación documental ampliada | Validar información |
| Origen de recursos | Declaración + soporte documental | Evitar recursos ilícitos |
| Beneficiario controlador | Mapeo detallado de estructura | Identificar dueño real |
| Monitoreo | Observación frecuente de operaciones | Detectar patrones inusuales |
| Aprobación interna | Revisión por Oficial de Cumplimiento | Mayor control |
| Actualización | Más frecuente | Mantener información vigente |
| Clasificación | Riesgo Alto | Activar controles especiales |

### TABLAS POR ACTIVIDAD
1. Juegos con apuesta (Fracción I)
| Campo | Descripción |
|--------|-------------|
| Tipo de operación | Venta de fichas / boletos / apuestas / premios |
| Monto de la operación | Cantidad total pagada o jugada |
| Medio de pago | Efectivo / transferencia / tarjeta |
| Fecha y hora | Para acumulación de 6 meses |
| Número de ficha(s) | En caso de control interno |
| Dinámica del juego | Apuesta simple, máquinas, mesa |
| Premios pagados | Con detalle y método de pago |
| Acumulación 6 meses | Total acumulado del cliente |

2. Tarjetas prepagadas, cupones, monederos (Fracción II)
| Campo | Descripción |
|--------|-------------|
| Tipo de tarjeta / cupón | Prepagada / monedero / vale |
| Valor almacenado | Monto cargado |
| Número de tarjeta | Identificador único |
| Medio de pago | Tarjeta / efectivo / transferencia |
| Frecuencia de recargas | Para acumulación |

3. Cheques de viajero (Fracción III)
| Campo | Descripción |
|--------|-------------|
| Emisor del cheque | Marca / institución |
| Número del cheque | Identificador |
| Valor del cheque | Monto |
| Serie / lote | Control interno |
| Medio de pago | Cómo se adquirió |

---
### TABLA POR TIPO DE CLIENTE (ANEXOS)
| Tipo de Cliente                                            | Anexo aplicable                     | Base legal                          | Consecuencia en KYC                                                                        |
| ---------------------------------------------------------- | ----------------------------------- | ----------------------------------- | ------------------------------------------------------------------------------------------ |
| **PF mexicana o extranjera residente temporal/permanente** | **Anexo 3**                         | Art. 12 fracción I RCG              | Identificación oficial mexicana o pasaporte + condición migratoria + comprobante domicilio |
| **PM mexicana**                                            | **Anexo 4**                         | Art. 12 fracción II RCG             | Acta constitutiva, poderes, RFC, domicilio legal                                           |
| **PM mexicana de derecho público**                         | **Anexo 4 Bis**                     | Art. 12 fracción II Bis RCG         | Documento de creación, identificación de funcionario actuante                              |
| **PF extranjera visitante o distinta a residente**         | **Anexo 5**                         | Art. 12 fracción III RCG            | Pasaporte + forma migratoria + domicilio temporal                                          |
| **PM extranjera**                                          | **Anexo 6**                         | Art. 12 fracción IV RCG             | Documentos apostillados/ legalizados: acta constitutiva extranjera + representación        |
| **Embajada, consulado u organismo internacional**          | **Anexo 6 Bis**                     | Art. 12 fracción IV Bis RCG         | Documentos que acreditan misión diplomática + funcionarios designados                      |
| **PM, dependencias y entidades del régimen simplificado**  | **Anexo 7 A (lista)** y **Anexo 7** | Art. 12 fracción V RCG y Anexo 7-A  | Se aplican medidas simplificadas (expediente más ligero)                                   |
| **PM de derecho público en régimen simplificado**          | **Anexo 7 Bis A** + **Anexo 7 Bis** | Art. 12 fracción V Bis RCG          | KYC simplificado para entidades públicas listadas                                          |


---






```
JCA ¿CÓMO SE IDENTIFICA?
1. Entender la estructura del cliente
Analizar:
Accionistas
Participaciones directas e indirectas
Socios finales
Estructuras en cascada
Fideicomisos
Contratos de control
Personas con poder de decisión

En el caso de entidades financieras, las Disposiciones piden identificar a quien ejerce Control; por ejemplo, en las DCG de SOFOMES se define control como tener más del 50%, capacidad de nombrar consejeros o adquirir 25% o más del capital social .

2.Identificar a quien posee o controla más del 25%
Estas personas físicas son, por regla general, beneficiarios controladores.
Participación directa (acciones a su nombre).
Participación indirecta (a través de sociedades intermedias).
Participación por instrumentos financieros con derechos de voto.
Participación en fideicomisos (fideicomitente, fideicomisario, comité técnico, etc.).
Si alguien tiene 25% o más, se le identifica.

3. Si no existe alguien con ≥ 25%, identificar a quien ejerza CONTROL
Ejemplos:
Quien puede imponer decisiones en asamblea.
Quien puede designar o destituir a la mayoría del consejo.
Quien dirige la estrategia del negocio.
Quien controla la firma o tiene poderes amplios y efectivos.
Quien controla la administración vía contrato.

4. Si no se identifica a nadie por propiedad ni control: identificar al “ejecutivo de más alto nivel”
Esto es el mecanismo de “residual owner” del estándar GAFI:
Director General
Administrador Único
Presidente del Consejo
Se documenta el análisis demostrando que no existe un propietario ni controlador

5. Determinar si existen múltiples beneficiarios controladores
Es común que existan varios BC simultáneos:
Accionistas con participaciones significativas.
Socios con control conjunto.
Integrantes de un Comité Técnico en un fideicomiso.
Todos deben registrarse.

```


- Almacenar la informaciíon de los clientes y sus operaciones, así como los documentos relacionados.
- Identificar y dar seguimiento a los actos u operaciones que
lleven a cabo con Personas Políticamente Expuestas *Por lo tanto considerar la indentificación de las PEPs nacionales o extrajeras*. **Si forman parte de un grupo empresarial, considerar sucursales y filiales**
- Puede no ser obligatorio tener el expediente al momento del registro, sino posterior e incluso al momento de la operaciíon. **Manejar el apartado de expediente como un componente independiente del catálogo de clientes**

---
# Funcionalidad: Operaciones
---
## Contexto
Articulo 17
## Reglas de Negocio:
- Contar con mecanismos automatizados que les permitan llevar a cabo un monitoreo permanente de los actos u operaciones que realicen con las personas Clientes o Usuarias para **identificar aquellas que no se encuentren dentro del perfil transaccional** de las personas Clientes o Usuarias conforme a las reglas de carácter general.
```
JCA Considerar niveles de seguimiento, tal que se notifiquen de manera resaltada, las operaciones que pertenecen a peps o de alto riesgo
```
---

# Reglas de Identificación y Aviso (LFPIORPI – Art. 17)
# y Reglas de Acumulación (Reglamento Art. 7)

| Concepto | Descripción | Fundamento | Resultado |
|----------|-------------|------------|-----------|
| **Operación individual** | Cada operación se evalúa por sí sola para determinar si rebasa los umbrales de identificación o aviso. | Art. 17 LFPIORPI | Si una sola operación rebasa el umbral → se identifica y/o se reporta. |
| **Acumulación de operaciones** | Las operaciones de un mismo cliente, del mismo tipo de acto, se suman en un período de 6 meses. | Art. 7 Reglamento LFPIORPI | Si la suma rebasa el umbral → se presenta aviso (aunque ninguna operación individual lo rebase). |
| **Límite temporal de 6 meses** | Solo se acumulan operaciones dentro de una ventana móvil de 6 meses. | Art. 7 Reglamento LFPIORPI | Operaciones separadas por más de 6 meses no se acumulan. |
| **Acumulación por cliente** | La suma aplica únicamente respecto al mismo cliente (identidad, RFC, datos de identificación). | Art. 7 Reglamento LFPIORPI | No se acumulan operaciones entre clientes distintos. |
| **Acumulación por tipo de acto u operación** | La acumulación se hace solo entre actos de la misma fracción del artículo 17. | Art. 7 Reglamento LFPIORPI | No se suman operaciones de diferentes tipos (ejemplo: arrendamiento con venta de vehículo). |
| **Identificación obligatoria** | Se realiza cuando la operación individual o acumulada alcanza el umbral de identificación. | Art. 17 LFPIORPI | Se integra expediente de identificación del cliente. |
| **Aviso obligatorio** | Se presenta cuando la operación individual o acumulada alcanza el umbral de aviso. | Art. 17 LFPIORPI y Art. 22 Reglamento | Se envía el aviso ante el SAT/UIF antes del día 17 del mes siguiente. |
| **Operaciones fraccionadas voluntariamente** | Si se detecta intención de fraccionar para evadir umbrales, aun sin llegar por acumulación formal. | Regla general de prevención (criterios UIF) | Se debe avisar usando el criterio de sospecha (24 horas). |
---
(Ejemplo basado en tu caso de fichas de $40,000)
# Reglas aplicadas a Juegos con Apuesta (Fracción I – Casinos)
# Umbrales 2025: Identificación = $35,286 / Aviso = $70,023

| Escenario | Total operación | ¿Identificación? | ¿Aviso? | Regla aplicable |
|-----------|----------------|------------------|---------|------------------|
| Una sola operación: cliente compra 2 fichas por $40,000 cada una | $80,000 | Sí | **Sí** | Operación individual rebasa umbral de aviso |
| Mismo día, dos operaciones separadas de $40,000 | $80,000 acumulado | Sí | **Sí** | Acumulación dentro de 6 meses |
| Días distintos, pero dentro del mismo mes o semestre (ej. marzo 5 y marzo 20) | $80,000 acumulado | Sí | **Sí** | Acumulación dentro de 6 meses |
| Operaciones separadas por más de 6 meses | No acumula | Sí (cada operación lo rebasa) | No | No acumulación por límite de 6 meses |
| Compra de $30,000 + $30,000 dentro de 6 meses | $60,000 | No | No | No se alcanza umbral de aviso ni de identificación |
| Compra de $50,000 + $30,000 en 6 meses | $80,000 | Sí | **Sí** | Identificación en ambas, aviso por acumulación |




---

# Funcionalidad: Avisos e Informes
---
## Contexto

## Reglas de Negocio:
-- En caso de sospecha o de contar con información basada en hechos o indicios, de que los recursos relacionados con los actos u operaciones pudieran provenir o estar destinados a la comisión de los Delitos de Operaciones con Recursos de Procedencia Ilícita, **deberán presentar Aviso dentro de las 24 horas siguientes** en que tuvieron conocimiento de dicha información o se generó la sospecha, incluso si el acto u operación no se celebró, considerando las guías que para tal efecto emita la Secretaría

### Presentación de Avisos
- Plazo: A más tardar el día 17 del mes siguiente a la operación.
- Si no hay operaciones objeto de aviso. Debe enviarse un Informe en Ceros (Reglas art. 25).
- Avisos extraordinarios (Reglas art. 27), Presentación de AvisosSi existen indicios o hechos de posible lavado, se presentan dentro de 24 horas.


---

#Funcionalidad: Evaluación con Enfoque Basado en Riesgos
---
## Contexto
DOF 16-07-2025
## Reglas de Negocio:
Llevar a cabo una evaluación con un enfoque basado en Riesgos, en términos de las reglas de carácter general que al efecto emita la Secretaría, que les permita identificar, analizar, entender y mitigar sus Riesgos, así como los de las personas Clientes o Usuarias

### Políticas de PLD/FT, controles internos y manual
- Matriz de riesgo (geográfico, transaccional, clientela, canales).
- Clasificación de clientes por nivel de riesgo.
- Monitoreo de operaciones inusuales.
- Reporte interno al REC.

### Impacto del Tipo de Cliente en el nivel de riesgo
- PM extranjera → Riesgo mayor por jurisdicción, transparencia corporativa.
- PF extranjera visitante → Riesgo por temporalidad.
- Embajadas/organismos internacionales → Riesgo bajo por naturaleza.
- Entidades del Anexo 7-A → Bajo riesgo → Medidas simplificadas.

---