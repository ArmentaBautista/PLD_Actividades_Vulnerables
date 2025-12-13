// ============================================
// VARIABLES GLOBALES
// ============================================

let beneficiarioCount = 1;
let clienteBeneficiarioCount = 1;

// Catálogos de SubTipos de Actividad
const subtiposActividad = {
    'i': ['Ruleta', 'Póker', 'Máquinas tragamonedas', 'Otros juegos de apuesta'],
    'ii': ['Tarjetas de crédito', 'Tarjetas de débito', 'Cupones de regalo', 'Otras tarjetas'],
    'iii': ['Cheques viajero emisión', 'Cheques viajero cambio', 'Otros servicios'],
    'iv': ['Mutuo', 'Préstamo personal', 'Crédito hipotecario', 'Crédito al consumidor'],
    'v': ['Compraventa', 'Arrendamiento', 'Alquiler temporal', 'Otro inmuebles'],
    'vi': ['Oro', 'Plata', 'Diamantes', 'Joyas combinadas'],
    'vii': ['Cuadros', 'Esculturas', 'Antigüedades', 'Colecciones'],
    'viii': ['Automóviles', 'Motocicletas', 'Camiones', 'Otros vehículos'],
    'ix': ['Transporte de valores', 'Custodia de valores', 'Ambos servicios'],
    'x': ['Blindaje de vehículos', 'Blindaje de inmuebles', 'Consultoría', 'Mantenimiento'],
    'xi': ['Notaría', 'Corredor', 'Agente aduanal', 'Peritaje'],
    'xii': ['Inmuebles residenciales', 'Inmuebles comerciales', 'Equipos', 'Vehículos'],
    'xiii': ['Consultoría financiera', 'Asesoría legal', 'Contador público', 'Otras profesiones'],
    'xiv': ['Exportación', 'Importación', 'Agenciamiento', 'Representación'],
    'xv': ['Donativo a ONG', 'Donativo a educación', 'Donativo a iglesia', 'Otros donativos'],
    'xvi': ['Criptomonedas', 'Tokens', 'NFT', 'Otros activos virtuales']
};

// Catálogos de Origen de Recursos
const origenesRecursos = {
    'salario': 'Salario / Ingresos por empleo',
    'negocio': 'Ingresos de negocio propio',
    'inversion': 'Rendimientos de inversión',
    'herencia': 'Herencia o donativo',
    'venta-activos': 'Venta de bienes o activos',
    'prestamo': 'Préstamo bancario',
    'otros': 'Otros ingresos'
};

// ============================================
// FUNCIONES AUXILIARES
// ============================================

function mostrarModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.add('active');
    }
}

function ocultarModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.remove('active');
    }
}

function abrirTab(tabName) {
    const tabs = document.querySelectorAll('.tab-content');
    tabs.forEach(tab => {
        tab.classList.remove('active');
    });
    const tab = document.getElementById('tab-' + tabName);
    if (tab) {
        tab.classList.add('active');
    }
}

function getFileName(input) {
    return input.files.length > 0 ? input.files[0].name : 'Sin archivo';
}

// ============================================
// NAVEGACIÓN ENTRE MÓDULOS
// ============================================

document.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', (e) => {
        e.preventDefault();
        
        document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
        link.classList.add('active');
        
        const module = link.getAttribute('data-module');
        
        document.querySelectorAll('.module-section').forEach(section => {
            section.classList.remove('active');
        });
        
        document.getElementById(module).classList.add('active');
        
        const title = link.textContent.trim();
        document.getElementById('page-title').textContent = title;
    });
});

// ============================================
// MÓDULO: USUARIOS (Email + Password)
// ============================================

const btnNewUsuario = document.getElementById('btn-new-usuario');
const modalUsuario = document.getElementById('modal-usuario');
const formUsuario = document.getElementById('form-usuario');
const btnCancelUsuario = document.getElementById('btn-cancel-usuario');

if (btnNewUsuario) {
    btnNewUsuario.addEventListener('click', () => {
        document.getElementById('modal-title-usuario').textContent = 'Nuevo Usuario';
        formUsuario.reset();
        mostrarModal('modal-usuario');
    });
}

if (btnCancelUsuario) {
    btnCancelUsuario.addEventListener('click', () => {
        ocultarModal('modal-usuario');
    });
}

if (formUsuario) {
    formUsuario.addEventListener('submit', (e) => {
        e.preventDefault();
        
        const email = document.getElementById('usuario-email').value;
        const password = document.getElementById('usuario-password').value;
        const confirmPassword = document.getElementById('usuario-confirm-password').value;
        
        if (password !== confirmPassword) {
            alert('Las contraseñas no coinciden');
            return;
        }
        
        const usuario = {
            id: 'U' + String(Math.floor(Math.random() * 10000)).padStart(3, '0'),
            email: email,
            fecha_creacion: new Date().toISOString().split('T')[0]
        };
        
        console.log('Nuevo Usuario:', usuario);
        alert('Usuario creado exitosamente:\n' + email);
        ocultarModal('modal-usuario');
        formUsuario.reset();
    });
}

// Cerrar modal al hacer click en X
document.querySelectorAll('.close').forEach(closeBtn => {
    closeBtn.addEventListener('click', (e) => {
        e.target.closest('.modal').classList.remove('active');
    });
});

// Cerrar modal al hacer click fuera del contenido
window.addEventListener('click', (e) => {
    if (e.target.classList.contains('modal')) {
        e.target.classList.remove('active');
    }
});

// ============================================
// MÓDULO: EMPRESAS - Tipo Selector
// ============================================

const btnNewEmpresa = document.getElementById('btn-new-empresa');
const modalEmpresa = document.getElementById('modal-empresa');
const formEmpresa = document.getElementById('form-empresa');
const btnCancelEmpresa = document.getElementById('btn-cancel-empresa');
const tipoClienteSelect = document.getElementById('empresa-tipo-cliente');
const camposPF = document.getElementById('campos-pf');
const camposPM = document.getElementById('campos-pm');
const tipoC_Select = document.getElementById('empresa-tipo-cliente2');
const campos_PF = document.getElementById('campos-pf2');
const campos_PM = document.getElementById('campos-pm2');

// DEBUG: Verify Clientes elements are found
console.log('Clientes Type Selector (tipoC_Select):', tipoC_Select);
console.log('Clientes PF Fields (campos_PF):', campos_PF);
console.log('Clientes PM Fields (campos_PM):', campos_PM);

if (btnNewEmpresa) {
    btnNewEmpresa.addEventListener('click', () => {
        document.getElementById('modal-title-empresa').textContent = 'Nueva Empresa';
        formEmpresa.reset();
        tipoClienteSelect.value = '';
        camposPF.style.display = 'none';
        camposPM.style.display = 'none';
        beneficiarioCount = 1;
        mostrarModal('modal-empresa');
    });
}

if (btnCancelEmpresa) {
    btnCancelEmpresa.addEventListener('click', () => {
        ocultarModal('modal-empresa');
    });
}

// Cambiar campos según tipo de cliente
if (tipoClienteSelect) {
    tipoClienteSelect.addEventListener('change', (e) => {
        const tipo = e.target.value;
        
        if (tipo === 'pf') {
            camposPF.style.display = 'block';
            camposPM.style.display = 'none';
        } else if (tipo === 'pm') {
            camposPF.style.display = 'none';
            camposPM.style.display = 'block';
        } else {
            camposPF.style.display = 'none';
            camposPM.style.display = 'none';
        }
    });
}

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

// Cambiar campos según tipo de BENEFICIARIO CONTROLADOR en KYC Reforzada
const tipoBeneficiarioSelect = document.getElementById('cliente-tipo-beneficiario');
const camposPFBeneficiario = document.getElementById('cliente-campos-pf-beneficiario');
const camposPMBeneficiario = document.getElementById('cliente-campos-pm-beneficiario');

console.log('Setting up Beneficiario Controlador listener, tipoBeneficiarioSelect is:', tipoBeneficiarioSelect);
if (tipoBeneficiarioSelect) {
    console.log('✓ Beneficiario type selector found, attaching change listener');
    tipoBeneficiarioSelect.addEventListener('change', (e) => {
        console.log('Beneficiario type changed to:', e.target.value);
        const tipo = e.target.value;
        
        if (tipo === 'pf') {
            console.log('Showing PF fields for beneficiario, hiding PM fields');
            camposPFBeneficiario.style.display = 'block';
            camposPMBeneficiario.style.display = 'none';
        } else if (tipo === 'pm') {
            console.log('Showing PM fields for beneficiario, hiding PF fields');
            camposPFBeneficiario.style.display = 'none';
            camposPMBeneficiario.style.display = 'block';
        } else {
            console.log('Hiding both PF and PM fields for beneficiario');
            camposPFBeneficiario.style.display = 'none';
            camposPMBeneficiario.style.display = 'none';
        }
    });
} else {
    console.log('✗ Beneficiario type selector NOT FOUND');
}

// Cambio de tabs en Empresas
document.querySelectorAll('#modal-empresa .tab-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
        e.preventDefault();
        const tabName = btn.getAttribute('data-tab');
        
        document.querySelectorAll('#modal-empresa .tab-btn').forEach(b => {
            b.classList.remove('active');
        });
        btn.classList.add('active');
        
        document.querySelectorAll('#modal-empresa .tab-content').forEach(tab => {
            tab.classList.remove('active');
        });
        document.getElementById('tab-' + tabName).classList.add('active');
    });
});

// Agregar beneficiario controlador
const btnAddBeneficiario = document.getElementById('btn-add-beneficiario');
if (btnAddBeneficiario) {
    btnAddBeneficiario.addEventListener('click', (e) => {
        e.preventDefault();
        beneficiarioCount++;
        
        const template = document.querySelector('.beneficiario-item').cloneNode(true);
        template.querySelector('h5').textContent = 'Beneficiario #' + beneficiarioCount;
        
        // Limpiar campos
        template.querySelectorAll('input, textarea').forEach(field => {
            if (field.type === 'checkbox') {
                field.checked = false;
            } else {
                field.value = '';
            }
        });
        
        // Ocultar campos condicionales
        template.querySelector('.beneficiario-extranjero').style.display = 'none';
        template.querySelector('.beneficiario-representante-info').style.display = 'none';
        template.querySelector('.beneficiario-pep-info').style.display = 'none';
        
        // Agregar listeners
        agregarListenersBeneficiario(template);
        
        // Agregar al DOM
        document.getElementById('beneficiarios-list').appendChild(template);
    });
}

// Funcionalidad de beneficiario (extranjero, representante, PEP)
function agregarListenersBeneficiario(element) {
    const checkExtranjero = element.querySelector('.beneficiario-es-extranjero');
    const checkRepresenta = element.querySelector('.beneficiario-representa');
    const checkPEP = element.querySelector('.beneficiario-es-pep');
    const btnRemove = element.querySelector('.btn-remove-beneficiario');
    
    // Manejar cambio extranjero
    if (checkExtranjero) {
        checkExtranjero.addEventListener('change', function() {
            element.querySelector('.beneficiario-extranjero').style.display = 
                this.checked ? 'block' : 'none';
        });
    }
    
    // Manejar cambio representante
    if (checkRepresenta) {
        checkRepresenta.addEventListener('change', function() {
            element.querySelector('.beneficiario-representante-info').style.display = 
                this.checked ? 'block' : 'none';
        });
    }
    
    // Manejar cambio PEP
    if (checkPEP) {
        checkPEP.addEventListener('change', function() {
            element.querySelector('.beneficiario-pep-info').style.display = 
                this.checked ? 'block' : 'none';
        });
    }
    
    // Manejar inputs file
    element.querySelectorAll('input[type="file"]').forEach(fileInput => {
        fileInput.addEventListener('change', function() {
            const label = this.parentElement.querySelector('label');
            if (this.files.length > 0) {
                label.textContent = label.getAttribute('data-original') || label.textContent;
                label.textContent += ` (${this.files[0].name})`;
            }
        });
    });
    
    // Manejar remover
    if (btnRemove) {
        btnRemove.addEventListener('click', (e) => {
            e.preventDefault();
            if (document.querySelectorAll('.beneficiario-item').length > 1) {
                element.remove();
                beneficiarioCount--;
            } else {
                alert('Debe haber al menos un beneficiario controlador');
            }
        });
    }
}

// Agregar listeners iniciales a beneficiarios existentes
document.querySelectorAll('.beneficiario-item').forEach(item => {
    agregarListenersBeneficiario(item);
});

if (formEmpresa) {
    formEmpresa.addEventListener('submit', (e) => {
        e.preventDefault();
        
        const tipoCliente = tipoClienteSelect.value;
        if (!tipoCliente) {
            alert('Seleccione el tipo de cliente');
            return;
        }
        
        const empresa = {
            id: 'E' + String(Math.floor(Math.random() * 10000)).padStart(3, '0'),
            tipo_cliente: tipoCliente,
            email: document.getElementById('empresa-email').value,
            telefono: document.getElementById('empresa-telefono').value,
            actividad: document.getElementById('empresa-tipo-actividad').value,
            fecha_creacion: new Date().toISOString().split('T')[0]
        };
        
        if (tipoCliente === 'pf') {
            empresa.nombre = document.getElementById('empresa-nombre').value;
            empresa.paterno = document.getElementById('empresa-paterno').value;
            empresa.materno = document.getElementById('empresa-materno').value;
            empresa.fecha_nac = document.getElementById('empresa-fecha-nac').value;
            empresa.rfc = document.getElementById('empresa-rfc').value;
            empresa.curp = document.getElementById('empresa-curp').value;
        } else {
            empresa.razon_social = document.getElementById('empresa-razon-social').value;
            empresa.fecha_constitucion = document.getElementById('empresa-fecha-constitucion').value;
        }
        
        console.log('Nueva Empresa:', empresa);
        alert('Empresa creada exitosamente');
        ocultarModal('modal-empresa');
        formEmpresa.reset();
    });
}

// ============================================
// MÓDULO: CLIENTES
// ============================================

const btnNewCliente = document.getElementById('btn-new-cliente');
const modalCliente = document.getElementById('modal-cliente');
const formCliente = document.getElementById('form-cliente');
const btnCancelCliente = document.getElementById('btn-cancel-cliente');
const radioExtranjero = document.querySelectorAll('input[name="cliente-es-extranjero"]');
const tipoEstanciaGroup = document.getElementById('tipo-estancia-group');
const tipoActividadSelect = document.getElementById('cliente-tipo-actividad');
const subtipoActividadSelect = document.getElementById('cliente-subtipo-actividad');

// Inicializar SubTipo de Actividad
if (tipoActividadSelect && subtipoActividadSelect) {
    tipoActividadSelect.addEventListener('change', function() {
        const tipo = this.value;
        subtipoActividadSelect.innerHTML = '<option value="">Seleccionar SubTipo</option>';
        
        if (tipo && subtiposActividad[tipo]) {
            subtiposActividad[tipo].forEach(subtipo => {
                const option = document.createElement('option');
                option.value = subtipo.toLowerCase();
                option.textContent = subtipo;
                subtipoActividadSelect.appendChild(option);
            });
        }
    });
}

if (btnNewCliente) {
    btnNewCliente.addEventListener('click', () => {
        document.getElementById('modal-title-cliente').textContent = 'Nuevo Cliente';
        formCliente.reset();
        clienteBeneficiarioCount = 1;
        tipoEstanciaGroup.style.display = 'none';
        radioExtranjero.forEach(radio => radio.checked = radio.value === 'no');
        if (subtipoActividadSelect) {
            subtipoActividadSelect.innerHTML = '<option value="">Seleccionar SubTipo</option>';
        }
        mostrarModal('modal-cliente');
    });
}

if (btnCancelCliente) {
    btnCancelCliente.addEventListener('click', () => {
        ocultarModal('modal-cliente');
    });
}

// Cambio de tabs en Clientes
document.querySelectorAll('#modal-cliente .tab-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
        e.preventDefault();
        const tabName = btn.getAttribute('data-tab');
        
        document.querySelectorAll('#modal-cliente .tab-btn').forEach(b => {
            b.classList.remove('active');
        });
        btn.classList.add('active');
        
        document.querySelectorAll('#modal-cliente .tab-content').forEach(tab => {
            tab.classList.remove('active');
        });
        document.getElementById('tab-' + tabName).classList.add('active');
    });
});

// Mostrar/ocultar Tipo de Estancia Migratoria
if (radioExtranjero) {
    radioExtranjero.forEach(radio => {
        radio.addEventListener('change', function() {
            if (this.value === 'si') {
                tipoEstanciaGroup.style.display = 'block';
            } else {
                tipoEstanciaGroup.style.display = 'none';
            }
        });
    });
}

// Agregar beneficiario controlador cliente
const btnAddClienteBeneficiario = document.getElementById('btn-add-cliente-beneficiario');
if (btnAddClienteBeneficiario) {
    btnAddClienteBeneficiario.addEventListener('click', (e) => {
        e.preventDefault();
        clienteBeneficiarioCount++;
        
        const template = document.querySelector('.cliente-beneficiario-item').cloneNode(true);
        template.querySelector('h5').textContent = 'Beneficiario #' + clienteBeneficiarioCount;
        
        // Limpiar campos
        template.querySelectorAll('input, textarea').forEach(field => {
            if (field.type === 'checkbox') {
                field.checked = false;
            } else if (field.type === 'file') {
                field.value = '';
            } else {
                field.value = '';
            }
        });
        
        // Ocultar campos condicionales
        template.querySelector('.cliente-beneficiario-extranjero').style.display = 'none';
        template.querySelector('.cliente-beneficiario-representante-info').style.display = 'none';
        template.querySelector('.cliente-beneficiario-pep-info').style.display = 'none';
        
        // Agregar listeners
        agregarListenersClienteBeneficiario(template);
        
        // Agregar al DOM
        document.getElementById('cliente-beneficiarios-list').appendChild(template);
    });
}

// Funcionalidad de beneficiario cliente (extranjero, representante, PEP)
function agregarListenersClienteBeneficiario(element) {
    const checkExtranjero = element.querySelector('.cliente-beneficiario-es-extranjero');
    const checkRepresenta = element.querySelector('.cliente-beneficiario-representa');
    const checkPEP = element.querySelector('.cliente-beneficiario-es-pep');
    const btnRemove = element.querySelector('.btn-remove-cliente-beneficiario');
    
    // Manejar cambio extranjero
    if (checkExtranjero) {
        checkExtranjero.addEventListener('change', function() {
            element.querySelector('.cliente-beneficiario-extranjero').style.display = 
                this.checked ? 'block' : 'none';
        });
    }
    
    // Manejar cambio representante
    if (checkRepresenta) {
        checkRepresenta.addEventListener('change', function() {
            element.querySelector('.cliente-beneficiario-representante-info').style.display = 
                this.checked ? 'block' : 'none';
        });
    }
    
    // Manejar cambio PEP
    if (checkPEP) {
        checkPEP.addEventListener('change', function() {
            element.querySelector('.cliente-beneficiario-pep-info').style.display = 
                this.checked ? 'block' : 'none';
        });
    }
    
    // Manejar inputs file
    element.querySelectorAll('input[type="file"]').forEach(fileInput => {
        fileInput.addEventListener('change', function() {
            const label = this.parentElement.querySelector('label');
            const originalText = label.textContent.split('(')[0].trim();
            if (this.files.length > 0) {
                label.textContent = originalText + ` (${this.files[0].name})`;
            } else {
                label.textContent = originalText;
            }
        });
    });
    
    // Manejar remover
    if (btnRemove) {
        btnRemove.addEventListener('click', (e) => {
            e.preventDefault();
            if (document.querySelectorAll('.cliente-beneficiario-item').length > 1) {
                element.remove();
                clienteBeneficiarioCount--;
            } else {
                alert('Debe haber al menos un beneficiario controlador');
            }
        });
    }
}

// Agregar listeners iniciales a beneficiarios clientes existentes
document.querySelectorAll('.cliente-beneficiario-item').forEach(item => {
    agregarListenersClienteBeneficiario(item);
});

// Manejar inputs file en documentos
document.querySelectorAll('#modal-cliente input[type="file"]').forEach(fileInput => {
    fileInput.addEventListener('change', function() {
        const label = this.parentElement.querySelector('label');
        const originalText = label.textContent.split('(')[0].trim();
        if (this.files.length > 0) {
            label.textContent = originalText + ` (${this.files[0].name})`;
        } else {
            label.textContent = originalText;
        }
    });
});

if (formCliente) {
    formCliente.addEventListener('submit', (e) => {
        e.preventDefault();
        
        const cliente = {
            id: 'C' + String(Math.floor(Math.random() * 10000)).padStart(3, '0'),
            nombre: document.getElementById('cliente-nombre').value,
            apellido_paterno: document.getElementById('cliente-apellido-paterno').value,
            apellido_materno: document.getElementById('cliente-apellido-materno').value,
            rfc: document.getElementById('cliente-rfc').value,
            curp: document.getElementById('cliente-curp').value,
            email: document.getElementById('cliente-email').value,
            telefono: document.getElementById('cliente-telefono').value,
            tipo_actividad: document.getElementById('cliente-tipo-actividad').value,
            subtipo_actividad: subtipoActividadSelect ? subtipoActividadSelect.value : '',
            nacionalidad: document.getElementById('cliente-nacionalidad').value,
            origen_recursos: document.getElementById('cliente-origen-recursos').value,
            es_extranjero: document.querySelector('input[name="cliente-es-extranjero"]:checked').value,
            fecha_creacion: new Date().toISOString().split('T')[0]
        };
        
        console.log('Nuevo Cliente:', cliente);
        alert('Cliente creado exitosamente');
        ocultarModal('modal-cliente');
        formCliente.reset();
    });
}
