# Prototipos GUI - Sistema PLD Actividades Vulnerables

## 📋 Descripción General

Este proyecto contiene **tres prototipos GUI completos** (HTML, CSS, JavaScript) para un Sistema de Gestión de Prevención de Lavado de Dinero (PLD) enfocado en Actividades Vulnerables, según la **LFPIORPI (Ley Federal para la Prevención e Identificación de Operaciones con Recursos de Procedencia Ilícita)**.

Los prototipos están **completamente alineados con la estructura de base de datos SQL Server** definida en `Definicion_Base_de_Datos.sql`.

## 🎯 Módulos Implementados

### 1. **Registro de Usuarios** ✅ Actualizado
Sistema de autenticación del sistema.

**Arquitectura Simplificada (DB: Usuario)**
- Email (campo único, identificador)
- Contraseña (con confirmación)

**Características:**
- Validación de matching de contraseñas
- Tabla de usuarios activos
- Crear, editar, eliminar usuarios
- Estado automático: Activo

---

### 2. **Registro de Empresas** ✅ Actualizado
Gestión de empresas/personas morales y personas físicas con actividades vulnerables.

**Estructura de Tabs:**

#### Tab 1: Información General
**Selector Tipo de Cliente (CONDICIONAL):**
- Persona Física → Muestra campos:
  - Nombre, Apellido Paterno, Apellido Materno, Fecha Nacimiento, RFC, CURP
- Persona Moral → Muestra campos:
  - Razón Social, Fecha de Constitución

**Campos Generales (SIEMPRE VISIBLES):**
- Nacionalidad (México / Extranjera)
- Email
- Teléfono

**Mapeo DB:** Persona (tipo_persona, apellido_paterno, apellido_materno, fecha_nacimiento, nombre, rfc, curp, razon_social, fecha_constitucion)

#### Tab 2: Actividad Vulnerable
**Catálogo XVI Actividades:**
- I: Juegos con apuesta
- II: Tarjetas y cupones de valor
- III: Cheques de viajero
- IV: Mutuo, préstamo o crédito
- V: Bienes inmuebles
- VI: Metales y piedras preciosas
- VII: Obras de arte
- VIII: Vehículos
- IX: Traslado o custodia de valores
- X: Servicios de blindaje
- XI: Servicios de fe pública
- XII: Arrendamiento
- XIII: Servicios profesionales
- XIV: Comercio exterior
- XV: Donativos
- XVI: Intercambio de activos virtuales

**Mapeo DB:** Persona (actividad_vulnerable_id)

#### Tab 3: Ubicación
**Estructura Domicilio (Completo - 10 componentes):**
- Calle * (nombre de la calle)
- Entre Calles * (referencias cruzadas)
- Número Exterior * (número principal)
- Número Interior (departamento, oficina)
- Código Postal * (5 dígitos)
- Referencias (información adicional)
- Asentamiento (Catálogo - SEPOMEX) *
- Ciudad (Catálogo) *
- Municipio (Catálogo) *
- Estado (Catálogo) *
- País (Catálogo) *

**Mapeo DB:** Domicilio (calle, entre_calles, numero_exterior, numero_interior, codigo_postal, referencias, asentamiento_id, ciudad_id, municipio_id, estado_id, pais_id)

#### Tab 4: Beneficiarios Controladores
**Estructura Dinámica (Add/Remove):**
Cada beneficiario contiene:

**Campos Básicos:**
- % Capital * (0-100)
- % Capital Indirecto (0-100)
- % Voto (0-100)
- ¿Es Control Efectivo? (checkbox)
- Descripción del Mecanismo de Control (textarea)

**Documentación:**
- Doc. Identificación (URL)
- Doc. Control (URL)
- Doc. Comprobante Domicilio (URL)
- Fecha Validación Documentos

**Condicional: ¿Es Extranjero?**
- Fecha Inicio Estancia
- Doc. Migratorio (URL)

**Condicional: ¿Actúa Mediante Representante?**
- Nombre del Representante
- Doc. Identificación Representante (URL)

**Condicional: ¿Es PEP?**
- Cargo
- Fecha Inclusión

**Validación:**
- Fecha Verificación de Datos
- Método de Verificación
- Verificado Por (nombre)

**Mapeo DB:** BeneficiarioControlador (porcentaje_capital, porcentaje_capital_indirecto, porcentaje_voto, es_control_efectivo, descripcion_mecanismo, doc_identificacion_url, doc_control_url, doc_comprobante_domicilio_url, fecha_validacion_documentos, es_extranjero, fecha_inicio_estancia, doc_migratorio_url, actua_mediante_representante, nombre_representante, doc_identificacion_representante_url, es_pep, cargo_pep, fecha_inclusion_pep, fecha_verificacion_datos, metodo_verificacion, verificado_por)

---

### 3. **Registro de Clientes** ✅ Actualizado
Gestión de clientes personas físicas con KYC completo.

**Estructura de Tabs:**

#### Tab 1: Información
**Datos Personales Básicos:**
- Nombre * (campo de texto)
- Apellido Paterno *
- Apellido Materno
- Fecha de Nacimiento *
- RFC * (13 caracteres)
- CURP * (18 caracteres)
- Email *
- Teléfono *
- Actividad Vulnerable * (catálogo XVI)
- Nacionalidad * (México / Extranjera)

**Mapeo DB:** PersonaEmail, PersonaTelefono

#### Tab 2: KYC Base
**Domicilio (Estructura Completa 10 componentes):**
- Calle *
- Entre Calles *
- Número Exterior *
- Número Interior
- Código Postal *
- Referencias
- Asentamiento (Catálogo) *
- Ciudad (Catálogo) *
- Municipio (Catálogo) *
- Estado (Catálogo) *
- País *

**Origen de Recursos:**
- Descripción textual * (textarea)

**Mapeo DB:** Domicilio, Cliente (origen_recursos)

#### Tab 3: KYC Reforzada (Medidas Reforzadas)

**¿Es Extranjero? (Radio buttons):**
- SÍ → Muestra:
  - Tipo de Estancia Migratoria (dropdown):
    - Residente Temporal
    - Residente Permanente
    - Visitante
    - Otra
- NO → Oculta campo de estancia

**Beneficiarios Controladores (Dinámica):**
Cada beneficiario:
- % Capital *
- ¿Es Control Efectivo? (checkbox)
- Descripción del Mecanismo
- ¿Es PEP? (checkbox) → Muestra:
  - Cargo
  - Fecha Inclusión
- Remover (botón)

**Mapeo DB:** BeneficiarioControlador, Cliente (tipo_estancia_migratoria)

#### Tab 4: Documentos
**Checklist de Documentos Requeridos:**
- Identificación oficial (URL)
- Comprobante de domicilio < 3 meses (URL)
- Cédula de RFC (URL)
- Comprobante de ingresos (URL)
- Referencias patrimoniales (URL)

**Proceso de Validación:**
- Fecha Validación Documentos
- Fecha Verificación Datos
- Método de Verificación (texto)
- Verificado Por (texto)

**Mapeo DB:** Cliente (fecha_validacion_documentos, fecha_verificacion_datos, metodo_verificacion, verificado_por)

---

## 🗄️ Alineación con Base de Datos SQL Server

**Tablas Utilizadas:**

| Tabla | Módulo | Campos Utilizados |
|-------|--------|------------------|
| `Usuario` | Usuarios | email, password |
| `Persona` | Empresas | tipo_persona, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, rfc, curp, razon_social, fecha_constitucion, nacionalidad, actividad_vulnerable_id |
| `Domicilio` | Empresas, Clientes | calle, entre_calles, numero_exterior, numero_interior, codigo_postal, referencias, asentamiento_id, ciudad_id, municipio_id, estado_id, pais_id |
| `BeneficiarioControlador` | Empresas, Clientes | porcentaje_capital, porcentaje_capital_indirecto, porcentaje_voto, es_control_efectivo, descripcion_mecanismo, doc_identificacion_url, doc_control_url, doc_comprobante_domicilio_url, fecha_validacion_documentos, es_extranjero, fecha_inicio_estancia, doc_migratorio_url, actua_mediante_representante, nombre_representante, doc_identificacion_representante_url, es_pep, cargo_pep, fecha_inclusion_pep, fecha_verificacion_datos, metodo_verificacion, verificado_por |
| `PersonaEmail` | Clientes | email |
| `PersonaTelefono` | Clientes | telefono |
| `Cliente` | Clientes | origen_recursos, tipo_estancia_migratoria, fecha_validacion_documentos, fecha_verificacion_datos, metodo_verificacion, verificado_por |
| `Asentamiento` | Ubicación (Catálogo) | nombre, codigo_postal, municipio_id |
| `Ciudad` | Ubicación (Catálogo) | nombre, estado_id |
| `Municipio` | Ubicación (Catálogo) | nombre, estado_id |
| `Estado` | Ubicación (Catálogo) | nombre, pais_id |
| `Pais` | Ubicación (Catálogo) | nombre, codigo_iso |

---

## 🔧 Características Técnicas

### HTML (`index.html` - 950+ líneas)
- ✅ Estructura semántica HTML5
- ✅ 3 modales con tabs internos
- ✅ Formularios con validación básica HTML5
- ✅ Listas dinámicas (beneficiarios, documentos)
- ✅ Sistema de filtros en Clientes
- ✅ Tablas de datos con acciones

### CSS (`styles.css` - 860+ líneas)
- ✅ Design responsivo (mobile, tablet, desktop)
- ✅ Colores corporativos (#2563eb principal)
- ✅ Animaciones y transiciones suaves
- ✅ Badges de estado con colores significativos
- ✅ Estilos para tabs, modales, formularios
- ✅ Grid/Flexbox para layouts
- ✅ Sombras y efectos visuales profesionales

### JavaScript (`script.js` - 420+ líneas)
- ✅ Navegación entre módulos
- ✅ Gestión de modales (mostrar/ocultar)
- ✅ Cambio de tabs dinámico
- ✅ Lógica condicional:
  - **Empresas**: Mostrar campos PF o PM según selección de Tipo
  - **Clientes**: Mostrar Estancia Migratoria si es Extranjero
- ✅ Gestión dinámica de beneficiarios:
  - Agregar/remover beneficiarios
  - Mostrar/ocultar campos condicionales (Extranjero, Representante, PEP)
- ✅ Validación de formularios
- ✅ Manejo de eventos de checkboxes y radio buttons
- ✅ Almacenamiento temporal de datos en memoria (ready para API)

---

## 🚀 Cómo Usar

### 1. Abrir el Prototipo
```bash
Abrir `index.html` en navegador web moderno (Chrome, Firefox, Edge, Safari)
```

### 2. Navegación
- Clic en opciones del sidebar para cambiar entre módulos
- Cada módulo tiene tabla de datos existentes + botón "Nuevo"

### 3. Flujo de Usuarios
1. Clic **"+ Nuevo Usuario"**
2. Ingresar Email y Contraseña
3. Guardar

### 4. Flujo de Empresas
1. Clic **"+ Nueva Empresa"**
2. **Tab 1 - Información General**:
   - Seleccionar Tipo (PF/PM)
   - Llenar datos según tipo
   - Ingresar Nacionalidad, Email, Teléfono
3. **Tab 2 - Actividad Vulnerable**:
   - Seleccionar actividad del catálogo XVI
4. **Tab 3 - Ubicación**:
   - Completar domicilio en 10 componentes
   - Seleccionar de catálogos (Asentamiento, Ciudad, etc.)
5. **Tab 4 - Beneficiarios**:
   - Agregar beneficiarios (+)
   - Completar campos financieros (%)
   - Marcar condicionales (Extranjero, Representante, PEP)
   - Remover si necesario (-)
6. Guardar

### 5. Flujo de Clientes
1. Clic **"+ Nuevo Cliente"**
2. **Tab 1 - Información**:
   - Datos personales, RFC, CURP, Email, Teléfono
   - Actividad Vulnerable y Nacionalidad
3. **Tab 2 - KYC Base**:
   - Domicilio en 10 componentes
   - Origen de Recursos (textarea)
4. **Tab 3 - KYC Reforzada**:
   - Marcar si es Extranjero (muestra Estancia Migratoria)
   - Agregar Beneficiarios Controladores
5. **Tab 4 - Documentos**:
   - Marcar documentos y pegar URLs
   - Completar fechas y responsables
6. Guardar

---

## 📱 Características de UX

### Campos Condicionales Implementados
1. **Empresas - Tipo de Cliente (PF/PM)**
   - Muestra/oculta automáticamente según selección
   - Validación de campos requeridos según tipo

2. **Clientes - Extranjero**
   - Radio buttons SÍ/NO
   - Muestra Estancia Migratoria si es SÍ

3. **Beneficiarios - Es Extranjero**
   - Checkbox
   - Muestra Estancia y Doc. Migratorio si está marcado

4. **Beneficiarios - Actúa Mediante Representante**
   - Checkbox
   - Muestra datos del Representante si está marcado

5. **Beneficiarios - Es PEP**
   - Checkbox
   - Muestra Cargo y Fecha Inclusión si está marcado

### Listas Dinámicas
- **Agregar Beneficiarios**: Botón "+ Agregar" crea nuevo item con numeración automática
- **Remover Beneficiarios**: Botón "Remover" elimina item (mínimo 1 requerido)
- Cada nuevo item limpia campos y aplica listeners de eventos

---

## 🔐 Seguridad y Validación

### HTML5 Validation
- ✅ Campos required
- ✅ Type="email" con validación
- ✅ Type="date" con selector
- ✅ Number fields con min/max

### JavaScript Validation
- ✅ Validación de contraseñas matching
- ✅ Validación de tipo de cliente seleccionado
- ✅ Mínimo 1 beneficiario requerido
- ✅ Confirmación antes de eliminar beneficiario

### Frontend-Ready para Backend
- ✅ Console.log de datos para debugging
- ✅ Objetos JSON estructurados listos para API
- ✅ IDs auto-generados (U001, E001, C001)
- ✅ Timestamps automáticos

---

## 📝 Notas de Implementación

### Ready para Conectar Backend
- Los formularios generan objetos JSON listos para POST a `/api/usuarios`, `/api/empresas`, `/api/clientes`
- Cambiar `console.log()` por `fetch()` calls
- Modal cierra automáticamente al guardar

### Catálogos (Próxima Fase)
- Asentamiento, Ciudad, Municipio, Estado, País actualmente vacíos
- Deberían poblarse vía API desde tabla de catálogos SQL

### Almacenamiento
- Actualmente guarda en memoria (tabla se vacía al refresh)
- Para persistencia: usar localStorage o backend API

---

## 📄 Archivos Incluidos

```
prototipos/
├── index.html                 (950+ líneas - estructura completa)
├── styles.css                 (860 líneas - todos los estilos)
├── script.js                  (420+ líneas - lógica y eventos)
├── README.md                  (este archivo)
├── DOCUMENTACION_TECNICA.html (especificaciones técnicas)
├── INSTRUCCIONES.md           (guía para usuarios)
├── RESUMEN_EJECUTIVO.md       (overview ejecutivo)
└── INICIO.html                (página de bienvenida)
```

---

## 🎓 Conformidad Normativa

- ✅ Artículo 17 LFPIORPI: XVI categorías de actividades vulnerables
- ✅ Artículo 25 LFPIORPI: 5 años conservación documentos
- ✅ KYC (Know Your Customer): Datos personales completos
- ✅ DDR (Debida Diligencia Reforzada): Tab específico para medidas reforzadas
- ✅ Beneficiarios Controladores: 25%+ participación registrada
- ✅ PEP: Marcador y registro de cargo

---

## 👨‍💻 Desarrollado por

Prototipo GUI para Sistema PLD - 2025

---

## 📞 Soporte

Para consultas sobre campos, validaciones o alineación con base de datos:
- Revisar `Definicion_Base_de_Datos.sql`
- Revisar `ChangesForPrototypes.md`
- Consultar `DOCUMENTACION_TECNICA.html`
