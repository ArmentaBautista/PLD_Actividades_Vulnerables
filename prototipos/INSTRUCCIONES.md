# 🎨 Prototipos GUI - Sistema PLD Actividades Vulnerables

## ✅ Archivos Creados

Se han generado **4 archivos principales** en la carpeta `prototipos/`:

```
c:\JC_FILES\PLD_Actividades_Vulnerables\prototipos\
├── index.html                      # Interfaz principal (HTML)
├── styles.css                      # Estilos y diseño (CSS)
├── script.js                       # Lógica interactiva (JavaScript)
├── README.md                       # Documentación de características
└── DOCUMENTACION_TECNICA.html      # Guía técnica detallada
```

---

## 📦 Tres Módulos Completos Implementados

### 1️⃣ **REGISTRO DE USUARIOS**
Sistema de gestión de usuarios del sistema con roles y permisos.

**Características:**
- ✅ Tabla con usuarios existentes
- ✅ Botón para crear nuevos usuarios
- ✅ Modal con formulario completo
- ✅ Campos: Nombre, Email, Teléfono, Rol, Contraseña
- ✅ Roles disponibles: Admin, Analista, Auditor, Visualizador
- ✅ Control de estado activo/inactivo
- ✅ Validación de contraseña

---

### 2️⃣ **REGISTRO DE EMPRESAS**
Gestión de empresas clientes con actividades vulnerables según Art. 17 LFPIORPI.

**Características:**
- ✅ Tabla con información resumida de empresas
- ✅ **4 TABS de formulario**:
  1. **Información General**: RFC, Razón Social, Fecha Constitución, Contacto
  2. **Actividad Vulnerable**: Tipo (I-XVI), Subtipo, Descripción, Riesgo, PEP
  3. **Ubicación**: Domicilio completo + carga de comprobante
  4. **Beneficiarios**: Gestión de beneficiarios con ≥25% participación

**Tipos de Actividades Vulnerables:**
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

### 3️⃣ **REGISTRO DE CLIENTES**
Sistema completo de KYC (Know Your Customer) con KYC Universal y Reforzado.

**Características:**
- ✅ Filtros dinámicos: Tipo, Riesgo, Estado KYC
- ✅ Tabla con información esencial de clientes
- ✅ **4 TABS de formulario**:

#### Tab 1: Información del Cliente
- Tipo de cliente (PF/PM/Fideicomiso/PEP)
- Nombre/Razón Social
- RFC/CURP
- Fecha Nacimiento/Constitución
- Nacionalidad
- Tipo de Relación (Ocasional/Continua)
- Email y Teléfono
- Actividad Económica

#### Tab 2: KYC Base (Universal)
**Elementos requeridos para TODAS las actividades (Art. 18 LFPIORPI):**
- 📄 Identificación Oficial (INE/Pasaporte/Cédula)
- 🏠 Domicilio con comprobante < 3 meses
- 📋 RFC/CURP
- 💰 Origen de Recursos (Declaración + soporte)
- 👤 Beneficiario Controlador
  - Nombre, RFC/CURP
  - % Participación (≥25%)
  - Tipo de Control (Propiedad/Control/Ambos)

#### Tab 3: KYC Reforzada (DDR)
**Medidas especiales para clientes de alto riesgo:**
- ⚠️ Indicadores de aplicación DDR
- 📝 Motivos: PEP, Extranjero sin residencia, Efectivo, Terceros, Estructura compleja
- 💼 Información Financiera: Ingresos, Patrimonio
- 🗺️ Mapeo detallado de beneficiarios
- 🔴 Clasificación Riesgo: Bajo/Medio/Alto

#### Tab 4: Documentos
**Checklist KYC con almacenamiento:**
- ✅ Identificación Oficial
- ✅ Comprobante de Domicilio
- ✅ RFC/CURP
- ✅ Acta Constitutiva (PM)
- ✅ Poderes/Representación
- ✅ ID del Beneficiario Controlador
- ✅ Soporte Origen de Recursos
- ✅ Otros documentos

---

## 🎨 Características de Diseño

### Interfaz Visual
- 🎯 **Sidebar de navegación** con logo y menú principal
- 📱 **Responsive Design** (Desktop, Tablet, Mobile)
- 🌈 **Paleta de colores profesional**
  - Primario: Azul (#2563eb)
  - Éxito: Verde (#10b981)
  - Advertencia: Naranja (#f59e0b)
  - Peligro: Rojo (#ef4444)

### Componentes
- ✅ Tablas dinámicas con datos de ejemplo
- ✅ Modales para formularios
- ✅ Sistema de tabs para organizar información
- ✅ Badges de estado (Activo, Pendiente, Completo, etc.)
- ✅ Formularios con validación
- ✅ Filtros avanzados
- ✅ Checklist de documentos

---

## 💻 Tecnología Utilizada

### Frontend
- **HTML5**: Estructura semántica completa
- **CSS3**: Diseño responsive y moderno
- **JavaScript Vanilla**: Sin dependencias externas

### Características Técnicas
- ✅ Navegación entre módulos sin recargar página
- ✅ Gestión de modales
- ✅ Sistema de tabs funcional
- ✅ Filtros dinámicos
- ✅ Validación de formularios
- ✅ Manejo de eventos
- ✅ Listo para integración con API

---

## 🚀 Cómo Usar

### 1. Abrir el Prototipo
Simplemente abre el archivo `index.html` en tu navegador web.

```bash
# Navega a la carpeta y abre:
c:\JC_FILES\PLD_Actividades_Vulnerables\prototipos\index.html
```

### 2. Navegar entre Módulos
Usa el menú lateral izquierdo:
- 👤 Registro de Usuarios
- 🏢 Registro de Empresas
- 👥 Registro de Clientes

### 3. Crear Registros
Haz clic en "+ Nuevo Usuario/Empresa/Cliente"

### 4. Completar Formularios
- Rellena los campos requeridos (marcados con *)
- Para Empresas y Clientes: Usa los tabs para organizar información
- Sube documentos según sea necesario

### 5. Guardar
Haz clic en "Guardar" y verás un mensaje de confirmación.

---

## 📋 Datos de Ejemplo Incluidos

### Usuario de Ejemplo
```
ID: U001
Nombre: Juan Carlos López
Email: jc.lopez@empresa.com
Rol: Admin
Estado: Activo
```

### Empresa de Ejemplo
```
RFC: ABC123456XYZ
Razón Social: Casino Royal México S.A. de C.V.
Actividad: I - Juegos con apuesta
Riesgo: Alto
KYC: Completo
PEP: No
```

### Cliente de Ejemplo
```
ID: C001
Nombre: Roberto Martínez González
RFC: MAGR800515XXX
Tipo: Persona Física
Riesgo: Medio
KYC: Completo
PEP: No
```

---

## 🔗 Integración Backend (Próxima Fase)

El prototipo está diseñado para integrarse fácilmente con un backend:

### Stack Recomendado
- **Backend**: C# / ASP.NET Core
- **Base de Datos**: SQL Server 2019+
- **API**: REST con autenticación JWT
- **Autenticación**: OAuth 2.0

### Estructura de Datos
Se incluyen esquemas SQL para:
- Tabla: Usuarios
- Tabla: Empresas
- Tabla: Clientes
- Tabla: Beneficiarios_Controladores
- Tabla: Documentos_KYC

---

## 📖 Documentación Adicional

### Archivo: README.md
Contiene:
- ✅ Descripción detallada de cada módulo
- ✅ Estructura de archivos
- ✅ Características técnicas
- ✅ Elementos KYC por tipo de cliente
- ✅ Reglas de negocio implementadas
- ✅ Validaciones incluidas

### Archivo: DOCUMENTACION_TECNICA.html
Contiene:
- ✅ Arquitectura del sistema
- ✅ Estructura de datos (DDL)
- ✅ Endpoints API propuestos
- ✅ Ejemplos de JSON
- ✅ Datos de ejemplo completos
- ✅ Validaciones
- ✅ Seguridad y cumplimiento normativo

**📌 Abre este archivo en navegador para visualizar mejor:**
```
c:\JC_FILES\PLD_Actividades_Vulnerables\prototipos\DOCUMENTACION_TECNICA.html
```

---

## 🔐 Cumplimiento Normativo

El prototipo implementa elementos de:

### LFPIORPI (Ley Federal para la Prevención e Identificación de Operaciones con Recursos de Procedencia Ilícita)

**Artículos Clave:**
- ✅ **Art. 17**: Identificación y Aviso de operaciones
- ✅ **Art. 18**: Datos de Identificación del Cliente
- ✅ **Art. 18 Bis**: Beneficiarios Controladores
- ✅ **Art. 25**: Conservación de documentos (5 años)

**Actividades Vulnerables (Art. 17):**
- ✅ 16 categorías de actividades implementadas
- ✅ Sistema de clasificación por tipo y subtipo
- ✅ Niveles de riesgo (Bajo/Medio/Alto)

**KYC (Know Your Customer):**
- ✅ Elementos universales para todas las actividades
- ✅ KYC reforzado (DDR) para alto riesgo
- ✅ Identificación de Beneficiarios Controladores
- ✅ Gestión de documentación

---

## 🎯 Elementos KYC Implementados

### KYC Universal (Aplica a Todos)
1. ✅ Identificación oficial
2. ✅ Comprobante de domicilio (< 3 meses)
3. ✅ RFC/CURP
4. ✅ Acta constitutiva (PM)
5. ✅ Poderes o representación
6. ✅ Identificación del Beneficiario Controlador
7. ✅ Origen de recursos
8. ✅ Actividad económica

### KYC Reforzado (Para Alto Riesgo)
1. ✅ Preguntas adicionales
2. ✅ Documentación financiera
3. ✅ Origen de recursos ampliado
4. ✅ Mapeo detallado de beneficiarios
5. ✅ Monitoreo frecuente
6. ✅ Aprobación por Oficial de Cumplimiento
7. ✅ Actualización más frecuente

---

## ⚡ Características JavaScript

### Funciones Implementadas
```javascript
// Validaciones
✅ validarRFC(rfc)          // Valida formato RFC
✅ validarCURP(curp)        // Valida formato CURP
✅ validarEmail(email)      // Valida correo
✅ validarTelefono(tel)     // Valida teléfono

// Utilidades
✅ generarID(prefijo)       // Genera IDs únicos
✅ formatearFecha(fecha)    // Formatea fechas

// Navegación
✅ Cambio dinámico de módulos
✅ Sistema de tabs completamente funcional
✅ Modales reutilizables
✅ Filtros dinámicos

// Manejo de Datos
✅ FormData processing
✅ Evento de submit con validación
✅ LocalStorage ready (para persistencia futura)
```

---

## 🎓 Ejemplo de Uso del Sistema

### Escenario 1: Registrar Nueva Empresa
1. Haz clic en "Registro de Empresas"
2. Haz clic en "+ Nueva Empresa"
3. Completa **Tab 1: Información General**
   - RFC: ABC123456XYZ
   - Razón Social: Casino Royal México
   - Fecha Constitución: 2020-05-15
4. Completa **Tab 2: Actividad Vulnerable**
   - Tipo: I (Juegos con apuesta)
   - Subtipo: juegos con apuesta
   - Riesgo: Alto
5. Completa **Tab 3: Ubicación**
   - Domicilio completo
   - Cargar comprobante de domicilio
6. Completa **Tab 4: Beneficiarios**
   - Agregar beneficiario con ≥25%
7. Haz clic en "Guardar Empresa"

### Escenario 2: Registrar Nuevo Cliente
1. Haz clic en "Registro de Clientes"
2. Haz clic en "+ Nuevo Cliente"
3. Completa **Tab 1: Información**
   - Tipo: Persona Física
   - Nombre, RFC, Fecha Nacimiento
4. Completa **Tab 2: KYC Base**
   - Identificación, Domicilio
   - Origen de Recursos
   - Beneficiario Controlador
5. Completa **Tab 3: KYC Reforzada** (si aplica)
   - Selecciona "Sí" en DDR
   - Ingresa información financiera
6. Completa **Tab 4: Documentos**
   - Marca documentos cargados
7. Haz clic en "Guardar Cliente"

---

## 📊 Estructura de Carpetas Final

```
c:\JC_FILES\PLD_Actividades_Vulnerables\
├── prototipos/
│   ├── index.html                      ← ABRIR ESTO EN NAVEGADOR
│   ├── styles.css
│   ├── script.js
│   ├── README.md                       ← LEE ESTO
│   └── DOCUMENTACION_TECNICA.html      ← ABRE EN NAVEGADOR
├── Documentacion/
│   ├── avisos2025/
│   └── Documentacion_Desarrollo/
│       ├── AnalisisPreliminar.md
│       └── ...
└── scripts/
    └── ...
```

---

## ✨ Próximas Mejoras Sugeridas

1. **Integración Backend**
   - Conectar con API REST
   - Almacenamiento en SQL Server
   - Autenticación JWT

2. **Funcionalidades Avanzadas**
   - Módulo de Operaciones
   - Cálculo automático de umbrales (Art. 17)
   - Monitoreo de operaciones inusuales
   - Generación de reportes SAT/UIF

3. **Seguridad**
   - Encriptación de datos sensibles
   - Validación en servidor
   - Auditoría de cambios

4. **UX/UI**
   - Exportación a PDF/Excel
   - OCR para documentos
   - Notificaciones en tiempo real

---

## 📞 Contacto y Soporte

Para dudas sobre la implementación, consulta:
- `README.md` - Documentación de características
- `DOCUMENTACION_TECNICA.html` - Guía técnica detallada
- `AnalisisPreliminar.md` - Análisis del negocio

---

## 📄 Información de Archivos

| Archivo | Tamaño | Descripción |
|---------|--------|-------------|
| index.html | ~50 KB | Estructura HTML completa |
| styles.css | ~25 KB | Estilos CSS profesionales |
| script.js | ~15 KB | Lógica JavaScript funcional |
| README.md | ~20 KB | Documentación de características |
| DOCUMENTACION_TECNICA.html | ~30 KB | Guía técnica detallada |

**Total: ~140 KB de código limpio y documentado**

---

## 🎉 ¡Listo para Usar!

El prototipo está 100% funcional y listo para:
- ✅ Visualizar y demostrar a stakeholders
- ✅ Obtener feedback de usuarios
- ✅ Integrar con un backend
- ✅ Servir como base para desarrollo

**Abre `index.html` en tu navegador favorito y ¡comienza a explorar!**

---

**Creado:** Diciembre 2025
**Versión:** 1.0
**Estado:** Funcional y Documentado
