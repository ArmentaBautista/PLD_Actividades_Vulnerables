# 🔧 FIX: Campos Condicionales Persona Física/Moral en Clientes

## 📋 Problema Identificado

Los campos condicionales para **Persona Física** y **Persona Moral** en la sección de "Registro de Clientes" no se mostraban/ocultaban al cambiar el tipo.

### Síntomas
- Selector de tipo (`Persona Física` / `Persona Moral`) visible
- Campos condicionales NUNCA se mostraban, sin importar qué se seleccionara
- En Empresas funcionaba correctamente

---

## 🔍 Causa Raíz

**Problema HTML estructural:** El modal de Clientes tenía **divs tab-content anidados incorrectamente**:

```html
<!-- INCORRECTO: Doble tab-content anidado -->
<div class="tab-content active" id="tab-cliente-info">
    <h4>Datos Personales</h4>
    
    <div class="tab-content active" id="tab-info-general">  <!-- ❌ NO DEBERÍA ESTAR -->
        <h4>Tipo de Cliente</h4>
        <select id="empresa-tipo-cliente2">...</select>
        <div id="campos-pf2">...</div>
        <div id="campos-pm2">...</div>
    </div>  <!-- ❌ Cierre incorrecto -->
</div>
```

### Por qué fallaba
En `styles.css`:
```css
.tab-content {
    display: none;  /* ← Oculto por defecto */
}

.tab-content.active {
    display: block;  /* ← Visible solo con clase 'active' */
}
```

La estructura anidada creaba problemas de CSS en cascada que no se reflejaban bien en JavaScript.

---

## ✅ Solución Implementada

### Cambios en `index.html` (líneas 454-543)

**Antes (INCORRECTO):**
```html
<div class="tab-content active" id="tab-cliente-info">
    <h4>Datos Personales</h4>
    <div class="tab-content active" id="tab-info-general">  <!-- ❌ EXTRA -->
        <h4>Tipo de Cliente</h4>
        <select id="empresa-tipo-cliente2">...</select>
        <!-- campos-pf2, campos-pm2 -->
    </div>  <!-- ❌ CIERRE EXTRA -->
</div>
```

**Después (CORRECTO):**
```html
<div class="tab-content active" id="tab-cliente-info">
    <h4>Datos Personales</h4>
    
    <h4>Tipo de Cliente</h4>  <!-- ✅ Directamente en tab-cliente-info -->
    <select id="empresa-tipo-cliente2">...</select>
    
    <!-- Campos Persona Física -->
    <div id="campos-pf2" style="display: none;">...</div>
    
    <!-- Campos Persona Moral -->
    <div id="campos-pm2" style="display: none;">...</div>
    
    <!-- Campos Generales -->
    <h4>Datos Generales</h4>
    ...
</div>
```

---

## 🔧 Cambios en `script.js`

### Se agregó logging para debug (líneas 170-178)

```javascript
const tipoC_Select = document.getElementById('empresa-tipo-cliente2');
const campos_PF = document.getElementById('campos-pf2');
const campos_PM = document.getElementById('campos-pm2');

// DEBUG: Verificar que los elementos se encuentren
console.log('Clientes Type Selector (tipoC_Select):', tipoC_Select);
console.log('Clientes PF Fields (campos_PF):', campos_PF);
console.log('Clientes PM Fields (campos_PM):', campos_PM);
```

### Se mejoró el event listener (líneas 218-234)

```javascript
// Cambiar campos según tipo de CLIENTE
console.log('Setting up Clientes listener, tipoC_Select is:', tipoC_Select);
if (tipoC_Select) {
    console.log('✓ Clientes type selector found, attaching change listener');
    tipoC_Select.addEventListener('change', (e) => {
        console.log('Clientes type changed to:', e.target.value);
        const tipo = e.target.value;
        
        if (tipo === 'pf') {
            console.log('Showing PF fields, hiding PM fields');
            campos_PF.style.display = 'block';
            campos_PM.style.display = 'none';
        } else if (tipo === 'pm') {
            console.log('Showing PM fields, hiding PF fields');
            campos_PF.style.display = 'none';
            campos_PM.style.display = 'block';
        } else {
            console.log('Hiding both PF and PM fields');
            campos_PF.style.display = 'none';
            campos_PM.style.display = 'none';
        }
    });
} else {
    console.log('✗ Clientes type selector NOT FOUND');
}
```

---

## 🧪 Verificación

### Cómo probar el fix

1. **Abrir** el archivo `index.html` en el navegador
2. **Hacer clic** en botón "Nuevo Cliente"
3. **Modal se abre** y muestra "Información" tab
4. **Seleccionar** "Persona Física" → Deben aparecer campos:
   - Nombre
   - Apellido Paterno
   - Apellido Materno
   - Fecha de Nacimiento
   - RFC
   - CURP

5. **Seleccionar** "Persona Moral" → Deben aparecer campos:
   - Razón Social
   - Fecha de Constitución

6. **Verificar** en la consola del navegador (`F12` → Consola) que aparezcan logs:
   ```
   Clientes Type Selector (tipoC_Select): <select id="empresa-tipo-cliente2">
   Clientes PF Fields (campos_PF): <div id="campos-pf2">
   Clientes PM Fields (campos_PM): <div id="campos-pm2">
   ✓ Clientes type selector found, attaching change listener
   Clientes type changed to: pf
   Showing PF fields, hiding PM fields
   ```

---

## 📝 Archivos Modificados

| Archivo | Líneas | Cambios |
|---------|--------|---------|
| `index.html` | 454-543 | Removido div anidado `tab-info-general`, ajustadas indentaciones y estructura |
| `script.js` | 170-234 | Agregado console.log para debug del event listener |

---

## 🎯 Resultado Esperado

✅ **Funcionamiento correcto:**
- Selector de Tipo (Persona Física / Moral) visible y funcional
- Campos PF mostrados/ocultados según selección
- Campos PM mostrados/ocultados según selección
- Console logs confirman que event listener está activo
- Compatible con tabs navigation (Información, KYC Base, etc.)

---

## 📚 Notas Técnicas

### Estructura Correcta (Ahora)
```
modal-cliente
  └─ tab-cliente-info (active)
      ├─ selector (empresa-tipo-cliente2)
      ├─ campos-pf2 (hidden por defecto)
      └─ campos-pm2 (hidden por defecto)
  └─ tab-cliente-kyc
  └─ tab-cliente-kyc-reforzada
  └─ tab-cliente-documentos
```

### IDs Utilizados
- Selector: `#empresa-tipo-cliente2`
- Persona Física: `#campos-pf2`
- Persona Moral: `#campos-pm2`

---

## ✨ Comparación con Empresas

La solución asimila exactamente el patrón **exitoso** de la sección Empresas:

| Elemento | Empresas | Clientes |
|----------|----------|----------|
| Selector ID | `empresa-tipo-cliente` | `empresa-tipo-cliente2` |
| PF Fields ID | `campos-pf` | `campos-pf2` |
| PM Fields ID | `campos-pm` | `campos-pm2` |
| Event Listener | ✅ Funcional | ✅ Ahora Funcional |
| HTML Structure | ✅ Correcta | ✅ Corregida |

---

## 🚀 Próximos Pasos

1. ✅ Verificar que campos muestran/ocultan correctamente
2. ✅ Confirmar console logs aparecen sin errores
3. ⏳ Remover console.log statements una vez confirmado que funciona (opcional, ayuda con debugging)
4. ⏳ Registrar un nuevo cliente de prueba para confirmar campos de formulario funcionan

