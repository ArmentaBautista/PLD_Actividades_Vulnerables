# Prototipos GUI - Sistema PLD Actividades Vulnerables

## 📋 Descripción General

Este proyecto contiene **tres prototipos GUI completos** (HTML, CSS, JavaScript) para un Sistema de Gestión de Prevención de Lavado de Dinero (PLD) enfocado en Actividades Vulnerables, según la **LFPIORPI (Ley Federal para la Prevención e Identificación de Operaciones con Recursos de Procedencia Ilícita)**.

## 🎯 Módulos Implementados

### 1. **Registro de Usuarios**
Sistema de gestión de usuarios del sistema con roles y permisos.

**Características:**
- ✅ Tabla de usuarios existentes
- ✅ Crear nuevo usuario
- ✅ Asignar roles (Admin, Analista, Auditor, Visualizador)
- ✅ Estado activo/inactivo
- ✅ Modal para agregar/editar usuarios
- ✅ Validación de contraseña

**Campos:**
- Nombre Completo
- Email
- Teléfono
- Rol del Usuario
- Contraseña
- Confirmación de Contraseña
- Estado Activo

---

### 2. **Registro de Empresas**
Gestión completa de empresas clientes con actividades vulnerables.

**Características:**
- ✅ Tabla de empresas con información resumida
- ✅ Sistema de tabs para organizar información
- ✅ Clasificación por tipo de actividad vulnerable (XVI categorías)
- ✅ Gestión de beneficiarios controladores
- ✅ Carga de comprobante de domicilio

**Tabs Implementados:**
1. **Información General**: RFC, Razón Social, Fecha de Constitución, Contacto
2. **Actividad Vulnerable**: Tipo y subtipo, descripción, nivel de riesgo, marcador PEP
3. **Ubicación**: Domicilio completo y comprobante
4. **Beneficiarios**: Gestión de beneficiarios con ≥25% de participación

**Tipos de Actividades Vulnerables (Artículo 17 LFPIORPI):**
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

---

### 3. **Registro de Clientes**
Sistema completo de KYC (Know Your Customer) con soporte para KYC Universal y Reforzado.

**Características:**
- ✅ Filtros por tipo de cliente, riesgo y estado KYC
- ✅ Tabla de clientes con información esencial
- ✅ Sistema de tabs para organizar información
- ✅ Gestión completa de documentación
- ✅ Identificación de Beneficiario Controlador
- ✅ Medidas de KYC Reforzada (DDR)
- ✅ Checklist de documentos

**Tipos de Cliente Soportados:**
- Persona Física Mexicana
- Persona Física Extranjera
- Persona Moral Mexicana
- Persona Moral Extranjera
- Fideicomiso
- Persona Políticamente Expuesta (PEP)

**Tabs Implementados:**

#### Tab 1: Información del Cliente
- Tipo de cliente
- Nombre/Razón Social
- RFC/CURP
- Fecha de Nacimiento/Constitución
- Nacionalidad
- Tipo de Relación (Ocasional/Continua)
- Contacto
- Actividad Económica

#### Tab 2: KYC Base (Universal)
Datos requeridos para TODAS las actividades vulnerables:
- **Identificación**: Documento oficial con número y vigencia
- **Domicilio**: Dirección completa con comprobante < 3 meses
- **Origen de Recursos**: Declaración de procedencia de fondos
- **Beneficiario Controlador**: 
  - Identificación de personas con ≥25% participación
  - Tipo de control (Propiedad/Control/Ambos)
  - Análisis de estructura corporativa

**Elementos KYC Universales (Art. 18 LFPIORPI):**
- ✅ ID Cliente único
- ✅ Tipo de Cliente (PF/PM/Fideicomiso/PEP)
- ✅ Datos de identificación
- ✅ Nacionalidad
- ✅ RFC/CURP
- ✅ Identificación oficial
- ✅ Domicilio verificado
- ✅ Actividad económica
- ✅ Origen de recursos
- ✅ Beneficiario Controlador
- ✅ Representante legal (PM)

#### Tab 3: KYC Reforzada (DDR)
Medidas especiales para clientes de alto riesgo:
- Indicadores de aplicación de DDR
- Motivos de medida reforzada
- Justificación
- Información financiera ampliada (ingresos, patrimonio)
- Estructura de propiedad detallada
- Mapeo de beneficiarios controladores
- Clasificación de riesgo (Bajo/Medio/Alto)

**Casos de DDR (Art. 18 Bis LFPIORPI):**
- ✅ Cliente es PEP Nacional o Extranjera
- ✅ Extranjero sin residencia habitual
- ✅ Operaciones significativas en efectivo
- ✅ Uso de terceros o representantes inusuales
- ✅ Estructuras jurídicas complejas

#### Tab 4: Documentos
Checklist de documentos requeridos con almacenamiento:
- 📄 Identificación Oficial
- 🏠 Comprobante de Domicilio
- 📋 RFC/CURP
- 📜 Acta Constitutiva (PM)
- ⚖️ Poderes/Representación
- 🔏 Identificación del Beneficiario Controlador
- 💰 Soporte del Origen de Recursos
- 📦 Otros documentos

---

## 🏗️ Estructura de Archivos

```
prototipos/
├── index.html          # Estructura HTML principal
├── styles.css          # Estilos CSS
├── script.js           # Lógica JavaScript
└── README.md           # Este archivo
```

## 🚀 Características Técnicas

### Frontend
- **HTML5**: Estructura semántica completa
- **CSS3**: Diseño responsive y moderno
- **JavaScript Vanilla**: Sin dependencias externas
- **Responsive Design**: Funciona en desktop, tablet y móvil

### Funcionalidades JavaScript
- ✅ Navegación entre módulos
- ✅ Gestión de modales
- ✅ Sistema de tabs
- ✅ Filtros dinámicos
- ✅ Validación de formularios
- ✅ Manejo de eventos
- ✅ Almacenamiento de datos (localStorage ready)

### Características de UI/UX
- 🎨 Paleta de colores profesional
- 🎯 Diseño intuitivo y consistente
- 📱 Fully responsive
- ♿ Accesibilidad básica
- ⚡ Animaciones suaves
- 🔔 Badges y estados visuales
- 📊 Tablas con datos de ejemplo

---

## 📖 Cómo Usar

### 1. Abrir el Prototipo
```bash
# Simplemente abre index.html en tu navegador
```

### 2. Navegar entre Módulos
Usa el menú lateral izquierdo para cambiar entre:
- 👤 Registro de Usuarios
- 🏢 Registro de Empresas
- 👥 Registro de Clientes

### 3. Crear Registros
Haz clic en el botón "+ Nuevo" de cada sección para abrir el modal correspondiente.

### 4. Rellenar Formularios
- **Usuarios**: Información básica y rol
- **Empresas**: 4 tabs con información completa
- **Clientes**: 4 tabs con KYC universal y reforzado

### 5. Guardar Datos
Completa los campos requeridos (*) y haz clic en "Guardar".

---

## 🔗 Integración con Base de Datos

El prototipo está diseñado para ser fácilmente integrable con un backend. Los datos se procesan mediante:

```javascript
// Ejemplo de captura de datos
formCliente.addEventListener('submit', (e) => {
    const formData = new FormData(formCliente);
    const cliente = {
        tipo: formData.get('tipo_cliente'),
        nombre: formData.get('nombre'),
        // ... más campos
    };
    // Enviar a API: fetch('/api/clientes', { method: 'POST', body: JSON.stringify(cliente) })
});
```

---

## 📋 Elementos KYC por Tipo de Cliente

### Persona Física Mexicana (Anexo 3)
- ✅ Identificación oficial mexicana
- ✅ Comprobante de domicilio
- ✅ RFC
- ✅ Datos de identificación

### Persona Moral Mexicana (Anexo 4)
- ✅ Acta constitutiva
- ✅ Poderes y representación
- ✅ RFC
- ✅ Domicilio legal
- ✅ Beneficiarios controladores

### Persona Física Extranjera (Anexo 5)
- ✅ Pasaporte
- ✅ Forma migratoria
- ✅ Comprobante domicilio temporal
- ✅ RFC (si aplica)

### Persona Moral Extranjera (Anexo 6)
- ✅ Documentos apostillados
- ✅ Acta constitutiva extranjera
- ✅ Representación legal
- ✅ Beneficiarios controladores

---

## 🎯 Reglas de Negocio Implementadas

### Clasificación de Riesgo
- **Bajo**: Entidades públicas, embajadas, personas establecidas
- **Medio**: Personas físicas, PM nacionales con actividad clara
- **Alto**: PEP, extranjeros, estructuras complejas, efectivo

### Beneficiario Controlador (Art. 18 Bis)
Identificación de personas con:
- ✅ ≥25% de participación directa o indirecta
- ✅ Control efectivo (nombramiento de consejeros, poder de decisión)
- ✅ Residual owner (ejecutivo más alto nivel)

### KYC Reforzada (DDR)
Aplicable cuando:
- ✅ Cliente es PEP
- ✅ Extranjero sin residencia
- ✅ Operaciones en efectivo significativo
- ✅ Terceros/representantes inusuales
- ✅ Estructura jurídica compleja

### Conservación de Documentos
- ✅ 5 años mínimo (Art. 25 LFPIORPI)
- ✅ Archivos digitales soportados

---

## 🔐 Validaciones Incluidas

```javascript
// Validar RFC
validarRFC('ABC123456XYZ') // true/false

// Validar Email
validarEmail('usuario@empresa.com') // true/false

// Generar ID
generarID('U') // U00123, U00456, etc.

// Formatear Fecha
formatearFecha('2025-01-15') // 15/01/2025
```

---

## 🎨 Paleta de Colores

| Uso | Color | Hex |
|-----|-------|-----|
| Primario | Azul | #2563eb |
| Éxito | Verde | #10b981 |
| Advertencia | Naranja | #f59e0b |
| Peligro | Rojo | #ef4444 |
| Info | Azul Cielo | #0ea5e9 |
| Fondo | Gris Claro | #f3f4f6 |

---

## 📱 Responsive Breakpoints

- **Desktop**: > 1200px
- **Tablet**: 768px - 1200px
- **Mobile**: < 768px
- **Small Mobile**: < 480px

---

## 🚦 Estados de Datos

### Usuarios
- Activo / Inactivo

### Empresas
- Bajo / Medio / Alto (Riesgo)
- Completo / Pendiente (KYC)
- PEP: Sí / No

### Clientes
- Bajo / Medio / Alto (Riesgo)
- Completo / Pendiente / Incompleto (KYC)
- PEP: Sí / No
- Sin DDR / Con DDR (KYC Reforzada)

---

## 🔄 Próximas Mejoras Sugeridas

1. **Backend Integration**
   - API REST para CRUD de usuarios, empresas, clientes
   - Base de datos SQL Server (sugerido según documentación)
   - Autenticación y autorización

2. **Features Avanzadas**
   - Módulo de Operaciones y Umbrales
   - Monitoreo de operaciones inusuales
   - Reportes y Avisos (Art. 17, 22 LFPIORPI)
   - Lista de PEPs actualizable
   - Verificación de listas de riesgo externas

3. **Seguridad**
   - Encriptación de datos sensibles
   - Validación en servidor
   - Auditoría de cambios
   - Control de acceso por rol

4. **Experiencia de Usuario**
   - Exportación a PDF/Excel
   - Carga de múltiples documentos
   - OCR para lectura de documentos
   - Notificaciones en tiempo real

5. **Cumplimiento Normativo**
   - Generador de reportes SAT/UIF
   - Cálculo automático de umbrales
   - Acumulación de operaciones (6 meses)
   - Registro de auditoría

---

## 📚 Referencias Normativas

- **LFPIORPI**: Ley Federal para la Prevención e Identificación de Operaciones con Recursos de Procedencia Ilícita
- **Reglas de Carácter General (RCG)**: Publicadas en DOF
- **Artículos Clave**:
  - Art. 17: Identificación y Aviso
  - Art. 18: Datos de Identificación
  - Art. 18 Bis: Beneficiarios Controladores
  - Art. 25: Conservación de Documentos

---

## 📞 Soporte

Para dudas o mejoras, revisa:
- `Documentacion/Documentacion_Desarrollo/AnalisisPreliminar.md`
- `Documentacion/Documentacion_Desarrollo/Reglas2025.md`

---

## 📄 Licencia

Proyecto de desarrollo para Sistema PLD - Actividades Vulnerables.
Año: 2025

---

**Última actualización:** Diciembre 2025
