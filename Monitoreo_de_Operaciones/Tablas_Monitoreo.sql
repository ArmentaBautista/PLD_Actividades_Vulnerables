-- =============================================
-- Tablas de soporte para el Motor de Monitoreo PLD
-- =============================================

-- Tabla: TipoAlerta
-- Catálogo de tipos de alerta generadas por el sistema
IF OBJECT_ID('dbo.TipoAlerta', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.TipoAlerta (
        TipoAlertaId INT IDENTITY(1,1) NOT NULL,
        Codigo NVARCHAR(20) NOT NULL,
        Descripcion NVARCHAR(200) NOT NULL,
        FechaAlta DATETIME2(7) NOT NULL CONSTRAINT DF_TipoAlerta_FechaAlta DEFAULT (GETDATE()),
        EstaActivo BIT NOT NULL CONSTRAINT DF_TipoAlerta_EstaActivo DEFAULT (1),
        
        CONSTRAINT PK_TipoAlerta PRIMARY KEY (TipoAlertaId)
    );

    -- Insertar tipos de alerta base
    INSERT INTO dbo.TipoAlerta (Codigo, Descripcion) VALUES
        ('IDEN_IND', 'Identificación requerida - Operación individual supera umbral'),
        ('IDEN_ACU', 'Identificación requerida - Acumulado mensual supera umbral'),
        ('AVISO_IND', 'Aviso requerido - Operación individual supera umbral'),
        ('AVISO_ACU', 'Aviso requerido - Acumulado mensual supera umbral'),
        ('EFECTIVO', 'Restricción de efectivo - Operación supera límite permitido'),
        ('INDICIOS', 'Aviso por indicios - Operación con posibles recursos ilícitos');
END
GO

-- Tabla: EstatusAlerta
-- Estados posibles de una alerta
IF OBJECT_ID('dbo.EstatusAlerta', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.EstatusAlerta (
        EstatusAlertaId INT NOT NULL,
        Nombre NVARCHAR(50) NOT NULL,
        Descripcion NVARCHAR(200) NULL,
        FechaAlta DATETIME2(7) NOT NULL CONSTRAINT DF_EstatusAlerta_FechaAlta DEFAULT (GETDATE()),
        EstaActivo BIT NOT NULL CONSTRAINT DF_EstatusAlerta_EstaActivo DEFAULT (1),
        
        CONSTRAINT PK_EstatusAlerta PRIMARY KEY (EstatusAlertaId)
    );

    -- Insertar estatus base
    INSERT INTO dbo.EstatusAlerta (EstatusAlertaId, Nombre, Descripcion) VALUES
        (1, 'Pendiente', 'Alerta generada pendiente de revisión'),
        (2, 'En Revisión', 'Alerta en proceso de análisis'),
        (3, 'Confirmada', 'Alerta confirmada, requiere acción'),
        (4, 'Descartada', 'Alerta descartada tras revisión'),
        (5, 'Procesada', 'Alerta procesada y aviso generado');
END
GO

-- Tabla: AlertaMonitoreo
-- Registra las alertas generadas por el motor de monitoreo
IF OBJECT_ID('dbo.AlertaMonitoreo', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.AlertaMonitoreo (
        AlertaMonitoreoId BIGINT IDENTITY(1,1) NOT NULL,
        EmpresaId INT NOT NULL,
        ClienteId INT NOT NULL,
        ActividadVulnerableId INT NOT NULL,
        TipoAlertaId INT NOT NULL,
        EstatusAlertaId INT NOT NULL CONSTRAINT DF_AlertaMonitoreo_Estatus DEFAULT (1),
        
        -- Información de la evaluación
        FechaPeriodoInicio DATE NOT NULL,
        FechaPeriodoFin DATE NOT NULL,
        MontoEvaluado MONEY NOT NULL,
        MontoEnUMAs DECIMAL(18,4) NOT NULL,
        UmbralAplicado DECIMAL(18,4) NOT NULL,
        
        -- Operación que disparó la alerta (NULL si es por acumulado)
        OperacionId BIGINT NULL,
        
        -- Descripción y notas
        Descripcion NVARCHAR(500) NULL,
        NotasRevision NVARCHAR(MAX) NULL,
        
        -- Auditoría
        FechaGeneracion DATETIME2(7) NOT NULL CONSTRAINT DF_AlertaMonitoreo_FechaGeneracion DEFAULT (GETDATE()),
        FechaRevision DATETIME2(7) NULL,
        UsuarioRevisionId INT NULL,
        FechaAlta DATETIME2(7) NOT NULL CONSTRAINT DF_AlertaMonitoreo_FechaAlta DEFAULT (GETDATE()),
        EstaActivo BIT NOT NULL CONSTRAINT DF_AlertaMonitoreo_EstaActivo DEFAULT (1),
        
        CONSTRAINT PK_AlertaMonitoreo PRIMARY KEY (AlertaMonitoreoId),
        CONSTRAINT FK_AlertaMonitoreo_Empresa FOREIGN KEY (EmpresaId) REFERENCES dbo.Empresa(EmpresaId),
        CONSTRAINT FK_AlertaMonitoreo_Cliente FOREIGN KEY (ClienteId) REFERENCES dbo.Cliente(ClienteId),
        CONSTRAINT FK_AlertaMonitoreo_ActividadVulnerable FOREIGN KEY (ActividadVulnerableId) REFERENCES dbo.ActividadVulnerable(ActividadVulnerableId),
        CONSTRAINT FK_AlertaMonitoreo_TipoAlerta FOREIGN KEY (TipoAlertaId) REFERENCES dbo.TipoAlerta(TipoAlertaId),
        CONSTRAINT FK_AlertaMonitoreo_EstatusAlerta FOREIGN KEY (EstatusAlertaId) REFERENCES dbo.EstatusAlerta(EstatusAlertaId)
    );

    CREATE NONCLUSTERED INDEX IX_AlertaMonitoreo_EmpresaId ON dbo.AlertaMonitoreo(EmpresaId);
    CREATE NONCLUSTERED INDEX IX_AlertaMonitoreo_ClienteId ON dbo.AlertaMonitoreo(ClienteId);
    CREATE NONCLUSTERED INDEX IX_AlertaMonitoreo_FechaPeriodo ON dbo.AlertaMonitoreo(FechaPeriodoInicio, FechaPeriodoFin);
    CREATE NONCLUSTERED INDEX IX_AlertaMonitoreo_Estatus ON dbo.AlertaMonitoreo(EstatusAlertaId) WHERE EstaActivo = 1;
END
GO

-- Tabla: EstatusAviso
-- Estados posibles de un aviso
IF OBJECT_ID('dbo.EstatusAviso', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.EstatusAviso (
        EstatusAvisoId INT NOT NULL,
        Nombre NVARCHAR(50) NOT NULL,
        Descripcion NVARCHAR(200) NULL,
        FechaAlta DATETIME2(7) NOT NULL CONSTRAINT DF_EstatusAviso_FechaAlta DEFAULT (GETDATE()),
        EstaActivo BIT NOT NULL CONSTRAINT DF_EstatusAviso_EstaActivo DEFAULT (1),
        
        CONSTRAINT PK_EstatusAviso PRIMARY KEY (EstatusAvisoId)
    );

    -- Insertar estatus base
    INSERT INTO dbo.EstatusAviso (EstatusAvisoId, Nombre, Descripcion) VALUES
        (1, 'Pendiente', 'Aviso pendiente de preparar'),
        (2, 'En Preparación', 'Aviso en proceso de preparación'),
        (3, 'Listo', 'Aviso listo para enviar al portal'),
        (4, 'Enviado', 'Aviso enviado a la UIF'),
        (5, 'Confirmado', 'Aviso confirmado por el portal'),
        (6, 'Rechazado', 'Aviso rechazado, requiere corrección');
END
GO

-- Tabla: AvisoUIF
-- Registra los avisos a presentar ante la UIF
IF OBJECT_ID('dbo.AvisoUIF', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.AvisoUIF (
        AvisoUIFId BIGINT IDENTITY(1,1) NOT NULL,
        EmpresaId INT NOT NULL,
        ClienteId INT NOT NULL,
        ActividadVulnerableId INT NOT NULL,
        EstatusAvisoId INT NOT NULL CONSTRAINT DF_AvisoUIF_Estatus DEFAULT (1),
        
        -- Período del aviso
        PeriodoMes INT NOT NULL,
        PeriodoAnio INT NOT NULL,
        FechaLimitePresentacion DATE NOT NULL,
        
        -- Información del aviso
        MontoTotalOperaciones MONEY NOT NULL,
        MontoTotalEnUMAs DECIMAL(18,4) NOT NULL,
        NumeroOperaciones INT NOT NULL,
        
        -- Datos del portal
        FolioAvisoPortal NVARCHAR(50) NULL,
        FechaEnvioPortal DATETIME2(7) NULL,
        FechaConfirmacionPortal DATETIME2(7) NULL,
        
        -- Observaciones
        Observaciones NVARCHAR(MAX) NULL,
        
        -- Auditoría
        FechaAlta DATETIME2(7) NOT NULL CONSTRAINT DF_AvisoUIF_FechaAlta DEFAULT (GETDATE()),
        UsuarioAltaId INT NOT NULL,
        FechaModificacion DATETIME2(7) NULL,
        UsuarioModificacionId INT NULL,
        EstaActivo BIT NOT NULL CONSTRAINT DF_AvisoUIF_EstaActivo DEFAULT (1),
        
        CONSTRAINT PK_AvisoUIF PRIMARY KEY (AvisoUIFId),
        CONSTRAINT FK_AvisoUIF_Empresa FOREIGN KEY (EmpresaId) REFERENCES dbo.Empresa(EmpresaId),
        CONSTRAINT FK_AvisoUIF_Cliente FOREIGN KEY (ClienteId) REFERENCES dbo.Cliente(ClienteId),
        CONSTRAINT FK_AvisoUIF_ActividadVulnerable FOREIGN KEY (ActividadVulnerableId) REFERENCES dbo.ActividadVulnerable(ActividadVulnerableId),
        CONSTRAINT FK_AvisoUIF_EstatusAviso FOREIGN KEY (EstatusAvisoId) REFERENCES dbo.EstatusAviso(EstatusAvisoId)
    );

    CREATE NONCLUSTERED INDEX IX_AvisoUIF_EmpresaId ON dbo.AvisoUIF(EmpresaId);
    CREATE NONCLUSTERED INDEX IX_AvisoUIF_ClienteId ON dbo.AvisoUIF(ClienteId);
    CREATE NONCLUSTERED INDEX IX_AvisoUIF_Periodo ON dbo.AvisoUIF(PeriodoAnio, PeriodoMes);
    CREATE NONCLUSTERED INDEX IX_AvisoUIF_Estatus ON dbo.AvisoUIF(EstatusAvisoId) WHERE EstaActivo = 1;
    CREATE UNIQUE INDEX UX_AvisoUIF_ClientePeriodo ON dbo.AvisoUIF(EmpresaId, ClienteId, ActividadVulnerableId, PeriodoAnio, PeriodoMes) WHERE EstaActivo = 1;
END
GO

-- Tabla: AvisoUIFOperacion
-- Relación entre avisos y operaciones incluidas
IF OBJECT_ID('dbo.AvisoUIFOperacion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.AvisoUIFOperacion (
        AvisoUIFOperacionId BIGINT IDENTITY(1,1) NOT NULL,
        AvisoUIFId BIGINT NOT NULL,
        OperacionId BIGINT NOT NULL,
        FechaAlta DATETIME2(7) NOT NULL CONSTRAINT DF_AvisoUIFOperacion_FechaAlta DEFAULT (GETDATE()),
        
        CONSTRAINT PK_AvisoUIFOperacion PRIMARY KEY (AvisoUIFOperacionId),
        CONSTRAINT FK_AvisoUIFOperacion_AvisoUIF FOREIGN KEY (AvisoUIFId) REFERENCES dbo.AvisoUIF(AvisoUIFId),
        CONSTRAINT FK_AvisoUIFOperacion_Operacion FOREIGN KEY (OperacionId) REFERENCES dbo.Operacion(Id)
    );

    CREATE NONCLUSTERED INDEX IX_AvisoUIFOperacion_AvisoUIFId ON dbo.AvisoUIFOperacion(AvisoUIFId);
    CREATE UNIQUE INDEX UX_AvisoUIFOperacion ON dbo.AvisoUIFOperacion(AvisoUIFId, OperacionId);
END
GO

-- Tabla: AcumuladoMensualCliente
-- Almacena el acumulado mensual por cliente para optimizar consultas
IF OBJECT_ID('dbo.AcumuladoMensualCliente', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.AcumuladoMensualCliente (
        AcumuladoMensualClienteId BIGINT IDENTITY(1,1) NOT NULL,
        EmpresaId INT NOT NULL,
        ClienteId INT NOT NULL,
        ActividadVulnerableId INT NOT NULL,
        PeriodoMes INT NOT NULL,
        PeriodoAnio INT NOT NULL,
        
        -- Acumulados
        MontoAcumulado MONEY NOT NULL CONSTRAINT DF_AcumuladoMensual_Monto DEFAULT (0),
        MontoAcumuladoUMAs DECIMAL(18,4) NOT NULL CONSTRAINT DF_AcumuladoMensual_UMAs DEFAULT (0),
        NumeroOperaciones INT NOT NULL CONSTRAINT DF_AcumuladoMensual_NumOps DEFAULT (0),
        
        -- Banderas de estado
        SuperaUmbralIdentificacion BIT NOT NULL CONSTRAINT DF_AcumuladoMensual_SuperaIden DEFAULT (0),
        SuperaUmbralAviso BIT NOT NULL CONSTRAINT DF_AcumuladoMensual_SuperaAviso DEFAULT (0),
        RequiereAviso BIT NOT NULL CONSTRAINT DF_AcumuladoMensual_RequiereAviso DEFAULT (0),
        AvisoGenerado BIT NOT NULL CONSTRAINT DF_AcumuladoMensual_AvisoGenerado DEFAULT (0),
        
        -- Auditoría
        FechaUltimaActualizacion DATETIME2(7) NOT NULL CONSTRAINT DF_AcumuladoMensual_FechaAct DEFAULT (GETDATE()),
        FechaAlta DATETIME2(7) NOT NULL CONSTRAINT DF_AcumuladoMensual_FechaAlta DEFAULT (GETDATE()),
        
        CONSTRAINT PK_AcumuladoMensualCliente PRIMARY KEY (AcumuladoMensualClienteId),
        CONSTRAINT FK_AcumuladoMensual_Empresa FOREIGN KEY (EmpresaId) REFERENCES dbo.Empresa(EmpresaId),
        CONSTRAINT FK_AcumuladoMensual_Cliente FOREIGN KEY (ClienteId) REFERENCES dbo.Cliente(ClienteId),
        CONSTRAINT FK_AcumuladoMensual_ActividadVulnerable FOREIGN KEY (ActividadVulnerableId) REFERENCES dbo.ActividadVulnerable(ActividadVulnerableId)
    );

    CREATE UNIQUE INDEX UX_AcumuladoMensual_ClientePeriodo ON dbo.AcumuladoMensualCliente(EmpresaId, ClienteId, ActividadVulnerableId, PeriodoAnio, PeriodoMes);
    CREATE NONCLUSTERED INDEX IX_AcumuladoMensual_Periodo ON dbo.AcumuladoMensualCliente(PeriodoAnio, PeriodoMes);
    CREATE NONCLUSTERED INDEX IX_AcumuladoMensual_RequiereAviso ON dbo.AcumuladoMensualCliente(RequiereAviso) WHERE RequiereAviso = 1 AND AvisoGenerado = 0;
END
GO

-- Tabla: LogMonitoreo
-- Registro de ejecuciones del motor de monitoreo
IF OBJECT_ID('dbo.LogMonitoreo', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.LogMonitoreo (
        LogMonitoreoId BIGINT IDENTITY(1,1) NOT NULL,
        TipoProceso NVARCHAR(50) NOT NULL,
        FechaInicio DATETIME2(7) NOT NULL,
        FechaFin DATETIME2(7) NULL,
        EmpresaId INT NULL,
        PeriodoMes INT NULL,
        PeriodoAnio INT NULL,
        
        -- Resultados
        OperacionesProcesadas INT NULL,
        AlertasGeneradas INT NULL,
        AvisosGenerados INT NULL,
        
        -- Estado
        EstatusEjecucion NVARCHAR(20) NOT NULL CONSTRAINT DF_LogMonitoreo_Estatus DEFAULT ('EN_PROCESO'),
        MensajeError NVARCHAR(MAX) NULL,
        
        CONSTRAINT PK_LogMonitoreo PRIMARY KEY (LogMonitoreoId)
    );

    CREATE NONCLUSTERED INDEX IX_LogMonitoreo_Fecha ON dbo.LogMonitoreo(FechaInicio DESC);
    CREATE NONCLUSTERED INDEX IX_LogMonitoreo_Empresa ON dbo.LogMonitoreo(EmpresaId, PeriodoAnio, PeriodoMes);
END
GO

PRINT 'Tablas de monitoreo creadas exitosamente.';
GO
