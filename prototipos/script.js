// ============================================
// VARIABLES GLOBALES
// ============================================

const subtiposActividades = {
    i: ['juegos con apuesta', 'concursos o sorteos', 'venta de boletos, fichas o comprobantes'],
    ii: ['Tarjetas prepagadas', 'Tarjetas de servicios', 'Cupones', 'Monederos electrónicos'],
    iii: [],
    iv: ['mutuos', 'préstamos o créditos'],
    v: ['desarrollo de bienes inmuebles', 'intermediación', 'comercialización (venta)'],
    vi: [],
    vii: [],
    viii: ['terrestres', 'aéreos', 'marítimos'],
    ix: ['dinero', 'valores', 'metales preciosos', 'joyas u objetos de valor'],
    x: ['vehículos', 'inmuebles', 'otros bienes'],
    xi: ['Notarios', 'Corredores públicos', 'Fedatarios públicos'],
    xii: [],
    xiii: ['compra/venta de bienes', 'manejo de recursos', 'administración y transferencia de valores', 'organización de aportaciones de capital', 'creación de personas morales, fideicomisos u otros vehículos corporativos'],
    xiv: [],
    xv: [],
    xvi: ['intercambio entre activos virtuales', 'intercambio entre activos virtuales y moneda de curso legal', 'transferencia, custodia o administración de activos virtuales']
};

// ============================================
// NAVEGACIÓN ENTRE MÓDULOS
// ============================================

document.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', (e) => {
        e.preventDefault();
        
        // Remover clase active de todos los links
        document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
        // Agregar clase active al link clickeado
        link.classList.add('active');
        
        // Obtener el módulo a mostrar
        const module = link.getAttribute('data-module');
        
        // Ocultar todos los módulos
        document.querySelectorAll('.module-section').forEach(section => {
            section.classList.remove('active');
        });
        
        // Mostrar el módulo seleccionado
        document.getElementById(module).classList.add('active');
        
        // Actualizar título de la página
        const title = link.textContent.trim();
        document.getElementById('page-title').textContent = title;
    });
});

// ============================================
// MÓDULO: USUARIOS
// ============================================

const btnNewUsuario = document.getElementById('btn-new-usuario');
const modalUsuario = document.getElementById('modal-usuario');
const formUsuario = document.getElementById('form-usuario');
const btnCancelUsuario = document.getElementById('btn-cancel-usuario');

btnNewUsuario.addEventListener('click', () => {
    document.getElementById('modal-title-usuario').textContent = 'Nuevo Usuario';
    formUsuario.reset();
    modalUsuario.classList.add('active');
});

btnCancelUsuario.addEventListener('click', () => {
    modalUsuario.classList.remove('active');
});

formUsuario.addEventListener('submit', (e) => {
    e.preventDefault();
    
    const formData = new FormData(formUsuario);
    const usuario = {
        id: 'U' + String(Math.floor(Math.random() * 10000)).padStart(3, '0'),
        nombre: formData.get('nombre'),
        email: formData.get('email'),
        rol: formData.get('rol'),
        activo: formData.get('activo') ? 'Activo' : 'Inactivo',
        fecha_creacion: new Date().toISOString().split('T')[0]
    };
    
    console.log('Nuevo Usuario:', usuario);
    alert('Usuario creado exitosamente:\n' + usuario.nombre);
    modalUsuario.classList.remove('active');
    formUsuario.reset();
});

// ============================================
// MÓDULO: EMPRESAS
// ============================================

const btnNewEmpresa = document.getElementById('btn-new-empresa');
const modalEmpresa = document.getElementById('modal-empresa');
const formEmpresa = document.getElementById('form-empresa');
const btnCancelEmpresa = document.getElementById('btn-cancel-empresa');
const tipoActividadSelect = document.getElementById('empresa-tipo-actividad');
const subtipoActividadSelect = document.getElementById('empresa-subtipo-actividad');
const btnAddBeneficiario = document.getElementById('btn-add-beneficiario');

btnNewEmpresa.addEventListener('click', () => {
    document.getElementById('modal-title-empresa').textContent = 'Nueva Empresa';
    formEmpresa.reset();
    cambiarTabEmpresa('info-general');
    modalEmpresa.classList.add('active');
});

btnCancelEmpresa.addEventListener('click', () => {
    modalEmpresa.classList.remove('active');
});

// Cambiar subtipos cuando se selecciona tipo de actividad
tipoActividadSelect.addEventListener('change', () => {
    const tipo = tipoActividadSelect.value;
    subtipoActividadSelect.innerHTML = '<option value="">Seleccionar subtipo</option>';
    
    if (tipo && subtiposActividades[tipo]) {
        subtiposActividades[tipo].forEach(subtipo => {
            const option = document.createElement('option');
            option.value = subtipo.toLowerCase().replace(/\s+/g, '_');
            option.textContent = subtipo;
            subtipoActividadSelect.appendChild(option);
        });
    }
});

// Tabs en modal de empresa
document.querySelectorAll('#modal-empresa .tab-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
        e.preventDefault();
        const tab = btn.getAttribute('data-tab');
        cambiarTabEmpresa(tab);
    });
});

function cambiarTabEmpresa(tabName) {
    // Remover clase active de todos los tabs y contenidos
    document.querySelectorAll('#modal-empresa .tab-btn').forEach(btn => btn.classList.remove('active'));
    document.querySelectorAll('#modal-empresa .tab-content').forEach(content => content.classList.remove('active'));
    
    // Agregar clase active al tab seleccionado
    document.querySelector(`#modal-empresa .tab-btn[data-tab="${tabName}"]`).classList.add('active');
    document.getElementById(`tab-${tabName}`).classList.add('active');
}

// Agregar beneficiario
btnAddBeneficiario.addEventListener('click', (e) => {
    e.preventDefault();
    const beneficiariosList = document.getElementById('beneficiarios-list');
    const newBeneficiario = document.createElement('div');
    newBeneficiario.className = 'beneficiario-item';
    newBeneficiario.innerHTML = `
        <div class="form-row">
            <div class="form-group">
                <label>Nombre del Beneficiario *</label>
                <input type="text" class="beneficiario-nombre" placeholder="Nombre completo" required>
            </div>
            <div class="form-group">
                <label>% Participación *</label>
                <input type="number" class="beneficiario-participacion" placeholder="25" min="0" max="100" required>
            </div>
        </div>
        <div class="form-row">
            <div class="form-group">
                <label>RFC/CURP *</label>
                <input type="text" class="beneficiario-rfc" placeholder="RFC o CURP" required>
            </div>
            <div class="form-group">
                <label>Nacionalidad *</label>
                <select class="beneficiario-nacionalidad" required>
                    <option value="">Seleccionar</option>
                    <option value="mexico">Mexicano</option>
                    <option value="extranjero">Extranjero</option>
                </select>
            </div>
        </div>
        <button type="button" class="btn-small btn-delete btn-remove-beneficiario">Remover</button>
    `;
    
    beneficiariosList.appendChild(newBeneficiario);
    
    newBeneficiario.querySelector('.btn-remove-beneficiario').addEventListener('click', (e) => {
        e.preventDefault();
        newBeneficiario.remove();
    });
});

// Remover beneficiario (delegado)
document.addEventListener('click', (e) => {
    if (e.target.classList.contains('btn-remove-beneficiario')) {
        e.preventDefault();
        e.target.closest('.beneficiario-item').remove();
    }
});

formEmpresa.addEventListener('submit', (e) => {
    e.preventDefault();
    
    const formData = new FormData(formEmpresa);
    const empresa = {
        rfc: formData.get('rfc'),
        razon_social: formData.get('razon_social'),
        tipo_actividad: formData.get('tipo_actividad'),
        clasificacion_riesgo: formData.get('clasificacion_riesgo'),
        es_pep: formData.get('es_pep') ? 'Sí' : 'No'
    };
    
    console.log('Nueva Empresa:', empresa);
    alert('Empresa registrada exitosamente:\n' + empresa.razon_social);
    modalEmpresa.classList.remove('active');
    formEmpresa.reset();
});

// ============================================
// MÓDULO: CLIENTES
// ============================================

const btnNewCliente = document.getElementById('btn-new-cliente');
const modalCliente = document.getElementById('modal-cliente');
const formCliente = document.getElementById('form-cliente');
const btnCancelCliente = document.getElementById('btn-cancel-cliente');
const tieneBC = document.getElementsByName('tiene-bc');
const bcFields = document.getElementById('bc-fields');
const ddrAplicaSelect = document.getElementById('cliente-ddr-aplica');
const ddrCampos = document.getElementById('ddr-campos');

btnNewCliente.addEventListener('click', () => {
    document.getElementById('modal-title-cliente').textContent = 'Nuevo Cliente';
    formCliente.reset();
    cambiarTabCliente('cliente-info');
    modalCliente.classList.add('active');
});

btnCancelCliente.addEventListener('click', () => {
    modalCliente.classList.remove('active');
});

// Tabs en modal de cliente
document.querySelectorAll('#modal-cliente .tab-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
        e.preventDefault();
        const tab = btn.getAttribute('data-tab');
        cambiarTabCliente(tab);
    });
});

function cambiarTabCliente(tabName) {
    // Remover clase active de todos los tabs y contenidos
    document.querySelectorAll('#modal-cliente .tab-btn').forEach(btn => btn.classList.remove('active'));
    document.querySelectorAll('#modal-cliente .tab-content').forEach(content => content.classList.remove('active'));
    
    // Agregar clase active al tab seleccionado
    document.querySelector(`#modal-cliente .tab-btn[data-tab="${tabName}"]`).classList.add('active');
    document.getElementById(`tab-${tabName}`).classList.add('active');
}

// Mostrar/ocultar campos de Beneficiario Controlador
tieneBC.forEach(radio => {
    radio.addEventListener('change', () => {
        if (document.querySelector('input[name="tiene-bc"]:checked').value === 'si') {
            bcFields.style.display = 'block';
        } else {
            bcFields.style.display = 'none';
        }
    });
});

// Mostrar/ocultar campos de DDR
ddrAplicaSelect.addEventListener('change', () => {
    if (ddrAplicaSelect.value === 'si') {
        ddrCampos.style.display = 'block';
    } else {
        ddrCampos.style.display = 'none';
    }
});

// Hacer que los checkboxes de documentos abran el file input
document.querySelectorAll('.documento-item .doc-check').forEach(checkbox => {
    checkbox.addEventListener('change', (e) => {
        const fileInput = e.target.closest('.documento-item').querySelector('.doc-file');
        if (e.target.checked) {
            fileInput.click();
        }
    });
});

formCliente.addEventListener('submit', (e) => {
    e.preventDefault();
    
    const formData = new FormData(formCliente);
    const cliente = {
        tipo: formData.get('tipo_cliente'),
        nombre: formData.get('nombre'),
        rfc: formData.get('rfc'),
        tipo_relacion: formData.get('tipo_relacion'),
        clasificacion_riesgo: formData.get('clasificacion_riesgo'),
        ddr_aplica: formData.get('ddr_aplica')
    };
    
    console.log('Nuevo Cliente:', cliente);
    alert('Cliente registrado exitosamente:\n' + cliente.nombre);
    modalCliente.classList.remove('active');
    formCliente.reset();
});

// ============================================
// CERRAR MODAL AL HACER CLICK FUERA
// ============================================

window.addEventListener('click', (e) => {
    if (e.target === modalUsuario) {
        modalUsuario.classList.remove('active');
    }
    if (e.target === modalEmpresa) {
        modalEmpresa.classList.remove('active');
    }
    if (e.target === modalCliente) {
        modalCliente.classList.remove('active');
    }
});

// Cerrar modal con botón X
document.querySelectorAll('.close').forEach(closeBtn => {
    closeBtn.addEventListener('click', (e) => {
        e.target.closest('.modal').classList.remove('active');
    });
});

// ============================================
// FILTROS EN CLIENTES
// ============================================

document.getElementById('filter-tipo-cliente').addEventListener('change', filtrarClientes);
document.getElementById('filter-riesgo').addEventListener('change', filtrarClientes);
document.getElementById('filter-kyc').addEventListener('change', filtrarClientes);

function filtrarClientes() {
    const tipo = document.getElementById('filter-tipo-cliente').value;
    const riesgo = document.getElementById('filter-riesgo').value;
    const kyc = document.getElementById('filter-kyc').value;
    
    console.log('Filtros aplicados:', { tipo, riesgo, kyc });
    // Aquí irían las llamadas a API para filtrar
}

// ============================================
// ACCIONES DE TABLA
// ============================================

document.addEventListener('click', (e) => {
    if (e.target.classList.contains('btn-edit')) {
        alert('Funcionalidad de edición en desarrollo');
    }
    if (e.target.classList.contains('btn-view')) {
        alert('Funcionalidad de vista en desarrollo');
    }
    if (e.target.classList.contains('btn-delete')) {
        if (confirm('¿Está seguro de que desea eliminar este registro?')) {
            alert('Registro eliminado');
        }
    }
});

// ============================================
// VALIDACIONES
// ============================================

function validarRFC(rfc) {
    const regexRFC = /^[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{3}$/;
    return regexRFC.test(rfc);
}

function validarEmail(email) {
    const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regexEmail.test(email);
}

// ============================================
// INICIALIZACIÓN
// ============================================

document.addEventListener('DOMContentLoaded', () => {
    console.log('Sistema PLD - Actividades Vulnerables cargado correctamente');
    
    // Simular autenticación
    console.log('Usuario: Admin');
    console.log('Módulos disponibles: Usuarios, Empresas, Clientes');
});

// ============================================
// UTILITIES
// ============================================

// Generar ID único
function generarID(prefijo) {
    return prefijo + String(Math.floor(Math.random() * 100000)).padStart(5, '0');
}

// Formatear fecha
function formatearFecha(fecha) {
    const opciones = { year: 'numeric', month: '2-digit', day: '2-digit' };
    return new Date(fecha).toLocaleDateString('es-MX', opciones);
}

// Exportar función para pruebas
window.utilidades = {
    validarRFC,
    validarEmail,
    generarID,
    formatearFecha
};
