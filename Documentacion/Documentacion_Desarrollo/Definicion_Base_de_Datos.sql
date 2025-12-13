

USE ogix_pld_dev;
GO  
 
 /* =====================
   Tabla: dbo.Rol
   ===================== */
IF OBJECT_ID(N'dbo.Rol', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Rol (
        EmpresaId INT NOT NULL CONSTRAINT FK_Rol_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        RolId INT NOT NULL CONSTRAINT PK_Rol PRIMARY KEY IDENTITY,
        Rol NVARCHAR(50) NULL,
        FechaAlta            DATETIME2(7) CONSTRAINT DF_Rol_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_Rol_EstaActivoAud DEFAULT (1) NOT NULL
    );
END;


/* =====================
   Tabla: dbo.Usuario
   ===================== */
IF OBJECT_ID(N'dbo.Usuario', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Usuario (
        UsuarioId INT NOT NULL CONSTRAINT PK_Usuario PRIMARY KEY IDENTITY,
        Correo NVARCHAR(255) NULL,
        RolId INT NULL CONSTRAINT FK_Usuario_Rol FOREIGN KEY (RolId) REFERENCES dbo.Rol(RolId),
        Contrasena NVARCHAR(255) NULL,
        FechaAlta DATE NOT NULL CONSTRAINT DF_Usuario_FechaAlta DEFAULT GETDATE(),
        HoraAlta TIME NOT NULL CONSTRAINT DF_Usuario_HoraAlta DEFAULT CONVERT(TIME, GETDATE()),
        UsuarioAltaId           INT          NULL,
        FechaModificacion       DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja               DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo              BIT          CONSTRAINT DF_Usuario_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO

insert into dbo.Usuario (Correo, Contrasena, EstaActivo) values ('carlos.armenta@intelix.mx', 'Password123', 1);

/* =====================
   Tabla: dbo.Empresa
   ===================== */
IF OBJECT_ID(N'dbo.Empresa', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Empresa (
        EmpresaId INT NOT NULL CONSTRAINT PK_Empresa PRIMARY KEY IDENTITY,
        Nombre NVARCHAR(255) NOT NULL,
        RFC NVARCHAR(13) NULL,
        CURP NVARCHAR(18) NULL,
        -- Auditoria
        FechaAlta            DATETIME2(7) CONSTRAINT DF_Empresa_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_Empresa_EstaActivo DEFAULT (1) NOT NULL
    );
END;

-- insertar una empresa por defecto si no existe
IF NOT EXISTS (SELECT 1 FROM dbo.Empresa WHERE EmpresaId in (1,2))  
BEGIN
    INSERT INTO dbo.Empresa (Nombre, RFC) VALUES ('Intelix', 'INT010203ABC');
    INSERT INTO dbo.Empresa (Nombre, RFC) VALUES ('Sistesp', 'INT020304XYZ');
END;
GO

/* =====================
   Tabla: dbo.UsuarioEmpresa
   ===================== */
IF OBJECT_ID(N'dbo.UsuarioEmpresa', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.UsuarioEmpresa (
        UsuarioEmpresaId INT NOT NULL CONSTRAINT PK_UsuarioEmpresa PRIMARY KEY IDENTITY,
        UsuarioId INT NOT NULL CONSTRAINT FK_UsuarioEmpresa_Usuario FOREIGN KEY REFERENCES dbo.Usuario(UsuarioId),
        EmpresaId INT NOT NULL CONSTRAINT FK_UsuarioEmpresa_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        FechaAlta DATETIME NOT NULL CONSTRAINT DF_UsuarioEmpresa_FechaAlta DEFAULT GETDATE(),
        HoraAlta TIME NOT NULL CONSTRAINT DF_UsuarioEmpresa_HoraAlta DEFAULT CONVERT(TIME, GETDATE()),
        EstaActivo              BIT          CONSTRAINT DF_UsuarioEmpresa_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO


/* =====================
   Tabla: dbo.TipoCliente
   ===================== */
IF OBJECT_ID(N'dbo.TipoCliente', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TipoCliente (
        EmpresaId INT NOT NULL CONSTRAINT FK_TipoCliente_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        TipoClienteId INT NOT NULL CONSTRAINT PK_TipoCliente PRIMARY KEY,
        Codigo NVARCHAR(20) NOT NULL,
        TipoCliente NVARCHAR(20) NOT NULL,
        -- Auditoria
        FechaAlta            DATETIME2(7) CONSTRAINT DF_TipoCliente_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_TiposClientes_EstaActivo DEFAULT (1) NOT NULL
    );
END;

/* =====================
   Tabla: dbo.Pais
   ===================== */
IF OBJECT_ID(N'dbo.Pais', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Pais (
        EmpresaId INT NOT NULL CONSTRAINT FK_Pais_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        PaisId INT NOT NULL CONSTRAINT PK_Pais PRIMARY KEY,
        Codigo NVARCHAR(20) NOT NULL,
        Pais NVARCHAR(20) NOT NULL,
        ExclusionGAFI BIT NOT NULL CONSTRAINT DF_Pais_ExclusionGAFI DEFAULT (0),
        FechaAlta            DATETIME2(7) CONSTRAINT DF_Pais_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_Pais_EstaActivo DEFAULT (1) NOT NULL
    );
END;

/* =====================
   Tabla: dbo.Nacionalidad
   ===================== */
IF OBJECT_ID(N'dbo.Nacionalidad', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Nacionalidad (
        EmpresaId INT NOT NULL CONSTRAINT FK_Nacionalidad_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        NacionalidadId INT NOT NULL CONSTRAINT PK_Nacionalidad PRIMARY KEY,
        Codigo NVARCHAR(20) NOT NULL,
        Nacionalidad NVARCHAR(20) NOT NULL,
        PaisId INT NOT NULL CONSTRAINT FK_Nacionalidad_Pais FOREIGN KEY REFERENCES dbo.Pais(PaisId),
        FechaAlta            DATETIME2(7) CONSTRAINT DF_Nacionalidad_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_Nacionalidad_EstaActivo DEFAULT (1) NOT NULL
    );
END;

/* =====================
   Tabla: dbo.Estado
   ===================== */
IF OBJECT_ID(N'dbo.Estado', N'U') IS NULL
BEGIN 
    CREATE TABLE dbo.Estado (
        EmpresaId INT NOT NULL CONSTRAINT FK_Estado_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        EstadoId INT NOT NULL CONSTRAINT PK_Estado PRIMARY KEY,
        Codigo NVARCHAR(20) NOT NULL,
        Estado NVARCHAR(100) NOT NULL,
        PaisId INT NOT NULL CONSTRAINT FK_Estado_Pais FOREIGN KEY REFERENCES dbo.Pais(PaisId),
        FechaAlta            DATETIME2(7) CONSTRAINT DF_Estado_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_Estado_EstaActivo DEFAULT (1) NOT NULL
    );
END;

/* =====================
   Tabla: dbo.Municipio
   ===================== */
IF OBJECT_ID(N'dbo.Municipio', N'U') IS NULL
BEGIN  
    CREATE TABLE dbo.Municipio (
        EmpresaId INT NOT NULL CONSTRAINT FK_Municipio_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        MunicipioId INT NOT NULL CONSTRAINT PK_Municipio PRIMARY KEY,
        Codigo NVARCHAR(20) NOT NULL,
        Municipio NVARCHAR(100) NOT NULL,
        EstadoId INT NOT NULL CONSTRAINT FK_Municipio_Estado FOREIGN KEY REFERENCES dbo.Estado(EstadoId),
        FechaAlta            DATETIME2(7) CONSTRAINT DF_Municipio_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_Municipio_EstaActivo DEFAULT (1) NOT NULL
    );
END;

/* =====================
   Tabla: dbo.CiudadLocalidad
   ===================== */
IF OBJECT_ID(N'dbo.CiudadLocalidad', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CiudadLocalidad (
        EmpresaId INT NOT NULL CONSTRAINT FK_CiudadLocalidad_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        CiudadLocalidadId INT NOT NULL CONSTRAINT PK_CiudadLocalidad PRIMARY KEY,
        Codigo NVARCHAR(20) NOT NULL,
        CiudadLocalidad NVARCHAR(100) NOT NULL,
        EstadoId INT NOT NULL CONSTRAINT FK_CiudadLocalidad_Estado FOREIGN KEY REFERENCES dbo.Estado(EstadoId),
        FechaAlta            DATETIME2(7) CONSTRAINT DF_CiudadLocalidad_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_CiudadLocalidad_EstaActivo DEFAULT (1) NOT NULL
    );
END;

/* =====================
   Tabla: dbo.Asentamiento
   ===================== */
IF OBJECT_ID(N'dbo.Asentamiento', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Asentamiento (
        EmpresaId INT NOT NULL CONSTRAINT FK_Asentamiento_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        AsentamientoId INT NOT NULL CONSTRAINT PK_Asentamiento PRIMARY KEY,
        Codigo NVARCHAR(20) NOT NULL,
        Asentamiento NVARCHAR(20) NOT NULL,
        CodigoPostal NVARCHAR(10) NOT NULL,
        MunicipioId INT NOT NULL CONSTRAINT FK_Asentamiento_Municipio FOREIGN KEY REFERENCES dbo.Municipio(MunicipioId),
        CiudadLocalidadId INT NOT NULL CONSTRAINT FK_Asentamiento_CiudadLocalidad FOREIGN KEY REFERENCES dbo.CiudadLocalidad(CiudadLocalidadId),
        FechaAlta            DATETIME2(7) CONSTRAINT DF_Asentamiento_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_Asentamiento_EstaActivo DEFAULT (1) NOT NULL
    );
END;

/* =====================
   Tabla: dbo.Domicilio
   ===================== */
IF OBJECT_ID(N'dbo.Domicilio', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Domicilio (
        EmpresaId INT NOT NULL CONSTRAINT FK_Domicilio_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        DomicilioId INT NOT NULL CONSTRAINT PK_Domicilio PRIMARY KEY IDENTITY,
        Calle NVARCHAR(255) NOT NULL,
        EntreCalles NVARCHAR(255) NOT NULL,
        NumeroExterior NVARCHAR(20) NOT NULL,
        NumeroInterior NVARCHAR(20) NULL,
        AsentamientoId INT NOT NULL CONSTRAINT FK_Domicilio_Asentamiento FOREIGN KEY REFERENCES dbo.Asentamiento(AsentamientoId),
        Referencias NVARCHAR(MAX) NULL,
        FechaAlta            DATETIME2(7) CONSTRAINT DF_Domicilio_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_Domicilio_EstaActivo DEFAULT (1) NOT NULL
    );
END;

/* =====================
   Tabla: dbo.TipoDomicilio
   ===================== */
IF OBJECT_ID(N'dbo.TipoDomicilio', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TipoDomicilio (
        EmpresaId INT NOT NULL CONSTRAINT FK_TipoDomicilio_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        TipoDomicilioId INT PRIMARY KEY,
        Tipo VARCHAR(50) NOT NULL UNIQUE,
        FechaAlta            DATETIME2(7) CONSTRAINT DF_TipoDomicilio_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_TipoDomicilio_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO

-- Datos recomendados
IF NOT EXISTS (select 1 from TipoDomicilio where TipoDomicilioId in (1,2,3,4))
BEGIN
    INSERT INTO TipoDomicilio (EmpresaId, TipoDomicilioId, Tipo, EstaActivo) VALUES
    (1,1, 'PRINCIPAL',1),
    (1,2, 'FISCAL',1),
    (1,3, 'LABORAL',1),
    (1,4, 'COBRANZA',1);
END;
GO



/* =====================
   Tabla: dbo.Persona
   ===================== */
IF OBJECT_ID(N'dbo.Persona', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Persona (
        EmpresaId INT NOT NULL CONSTRAINT FK_Persona_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        PersonaId INT NOT NULL CONSTRAINT PK_Persona PRIMARY KEY IDENTITY,
        Nombre NVARCHAR(150) NOT NULL,
        Paterno NVARCHAR(150) NULL,
        Materno NVARCHAR(150) NULL,
        FechaNacimientoConstitucion DATE NOT NULL,  
        RFC NVARCHAR(13) NULL,
        CURP NVARCHAR(18) NULL,
        FechaAlta DATETIME NOT NULL CONSTRAINT DF_Persona_FechaAlta DEFAULT GETDATE(),
        HoraAlta TIME NOT NULL CONSTRAINT DF_Persona_HoraAlta DEFAULT CONVERT(TIME, GETDATE()),
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja DATETIME NULL,
        HoraBaja TIME NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_Persona_EstaActivo DEFAULT (1) NOT NULL  
    );
END;
GO

/* =====================
   Tabla: dbo.UsuarioPersona
   ===================== */
IF OBJECT_ID(N'dbo.UsuarioPersona', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.UsuarioPersona (
        UsuarioPersonaId INT NOT NULL CONSTRAINT PK_UsuarioPersona PRIMARY KEY IDENTITY,
        UsuarioId INT NOT NULL CONSTRAINT FK_UsuarioPersona_Usuario FOREIGN KEY REFERENCES dbo.Usuario(UsuarioId),
        PersonaId INT NOT NULL CONSTRAINT FK_UsuarioPersona_Persona FOREIGN KEY REFERENCES dbo.Persona(PersonaId),
        FechaAlta DATETIME NOT NULL CONSTRAINT DF_UsuarioPersona_FechaAlta DEFAULT GETDATE(),
        HoraAlta TIME NOT NULL CONSTRAINT DF_UsuarioPersona_HoraAlta DEFAULT CONVERT(TIME, GETDATE()),
        EstaActivo              BIT          CONSTRAINT DF_UsuarioPersona_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO


/* =====================
   Tabla: dbo.PersonaDomicilio
   ===================== */
IF OBJECT_ID(N'dbo.PersonaDomicilio', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PersonaDomicilio (
        EmpresaId INT NOT NULL CONSTRAINT FK_PersonaDomicilio_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        PersonaDomicilioId INT NOT NULL CONSTRAINT PK_PersonaDomicilio PRIMARY KEY IDENTITY,
        PersonaId INT NOT NULL CONSTRAINT FK_PersonaDomicilio_Persona FOREIGN KEY REFERENCES dbo.Persona(PersonaId),
        DomicilioId INT NOT NULL CONSTRAINT FK_PersonaDomicilio_Domicilio FOREIGN KEY REFERENCES dbo.Domicilio(DomicilioId),
        TipoDomicilioId INT NOT NULL CONSTRAINT FK_PersonaDomicilio_TipoDomicilio FOREIGN KEY REFERENCES dbo.TipoDomicilio(TipoDomicilioId),
        FechaAlta DATETIME NOT NULL CONSTRAINT DF_PersonaDomicilio_FechaAlta DEFAULT GETDATE(),
        HoraAlta TIME NOT NULL CONSTRAINT DF_PersonaDomicilio_HoraAlta DEFAULT CONVERT(TIME, GETDATE()),
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja DATETIME NULL,
        HoraBaja TIME NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_PersonaDomicilio_EstaActivo DEFAULT (1) NOT NULL  
    );
END;
GO


-- Índice único para asegurar un solo domicilio principal activo por persona
IF (SELECT 1 FROM sys.indexes ix WHERE ix.name='UX_Persona_Principal') IS NULL
BEGIN
    CREATE UNIQUE INDEX UX_Persona_Principal
    ON dbo.PersonaDomicilio(PersonaId)
    WHERE TipoDomicilioId = 1 and EstaActivo = 1;  -- 1 = PRINCIPAL
END;
GO




/* =====================
   Tabla: dbo.PersonaEmail
   ===================== */
IF OBJECT_ID(N'dbo.PersonaEmail', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PersonaEmail (
        EmpresaId     INT NOT NULL CONSTRAINT FK_PersonaEmail_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        PersonaEmailId     INT IDENTITY(1,1) PRIMARY KEY,
        PersonaId   INT NOT NULL,
        Email       VARCHAR(255) NOT NULL,
        EsPrincipal BIT NOT NULL DEFAULT 0,
        FechaAlta            DATETIME2(7) CONSTRAINT DF_PersonaEmail_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_PersonaEmail_EstaActivo DEFAULT (1) NOT NULL,
        CONSTRAINT FK_PersonaEmail_Persona
            FOREIGN KEY (PersonaId) REFERENCES dbo.Persona(PersonaId),

        CONSTRAINT UQ_PersonaEmail_Email
            UNIQUE (Email) -- Asegura un solo email principal activo por persona
    );
END;
GO

-- Índice único para asegurar un solo email principal activo por persona
IF (SELECT 1 FROM sys.indexes ix WHERE ix.name='UX_PersonaEmail_Principal') is null
BEGIN
    CREATE UNIQUE INDEX UX_PersonaEmail_Principal
    ON dbo.PersonaEmail(PersonaId)
    WHERE EsPrincipal = 1 AND EstaActivo = 1;  -- 1 = PRINCIPAL
END;
GO


/* =====================
   Tabla: dbo.TipoTelefono
   ===================== */
IF OBJECT_ID(N'dbo.TipoTelefono', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TipoTelefono (
        EmpresaId INT NOT NULL CONSTRAINT FK_TipoTelefono_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        TipoTelefonoId INT PRIMARY KEY,
        Tipo VARCHAR(50) NOT NULL UNIQUE,
        EstaActivo BIT NOT NULL CONSTRAINT DF_TipoTelefono_Activo DEFAULT (1)  
    );

END;
GO

-- Datos recomendados
IF NOT EXISTS (select 1 from TipoTelefono where TipoTelefonoId in (1,2,3))
BEGIN
    INSERT INTO TipoTelefono (EmpresaId, TipoTelefonoId, Tipo, EstaActivo) VALUES
    (1,1, 'MÓVIL',1),
    (1,2, 'CASA',1),
    (1,3, 'TRABAJO',1);
END;
GO


/* =====================
   Tabla: dbo.PersonaTelefono
   ===================== */
IF OBJECT_ID(N'dbo.PersonaTelefono', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PersonaTelefono (
        EmpresaId  INT NOT NULL CONSTRAINT FK_PersonaTelefono_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        PersonaTelefonoId  INT IDENTITY(1,1) PRIMARY KEY,
        PersonaId   INT NOT NULL,
        CodigoPais  VARCHAR(5) NOT NULL CONSTRAINT DF_PersonaTelefono_CodigoPais DEFAULT '+52', -- ej: '+52'
        Telefono    VARCHAR(10) NOT NULL,
        TipoTelefonoId INT NOT NULL CONSTRAINT FK_PersonaTelefono_TipoTelefono FOREIGN KEY REFERENCES dbo.TipoTelefono(TipoTelefonoId),
        FechaAlta            DATETIME2(7) CONSTRAINT DF_PersonaTelefono_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_PersonaTelefono_EstaActivo DEFAULT (1) NOT NULL,
        CONSTRAINT FK_PersonaTelefono_Personas
            FOREIGN KEY (PersonaId) REFERENCES dbo.Persona(PersonaId)  
    );  
END;
GO



/* =====================
   Tabla: dbo.PersonaNacionalidad
   ===================== */
IF OBJECT_ID(N'dbo.PersonaNacionalidad', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PersonaNacionalidad (
        EmpresaId INT NOT NULL CONSTRAINT FK_PersonaNacionalidad_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        PersonaNacionalidadId INT NOT NULL CONSTRAINT PK_PersonaNacionalidad PRIMARY KEY IDENTITY,
        PersonaId INT NOT NULL CONSTRAINT FK_PersonaNacionalidad_Persona FOREIGN KEY REFERENCES dbo.Persona(PersonaId),
        NacionalidadId INT NOT NULL CONSTRAINT FK_PersonaNacionalidad_Nacionalidad FOREIGN KEY REFERENCES dbo.Nacionalidad(NacionalidadId),
        FechaAlta               DATETIME2(7) CONSTRAINT DF_PersonaNacionalidad_FechaAlta     DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion       DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja               DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo              BIT          CONSTRAINT DF_PersonaNacionalidad_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO





/* =====================
   Tabla: dbo.ActividadEconomica
   ===================== */
IF OBJECT_ID(N'dbo.ActividadEconomica', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ActividadEconomica (
        EmpresaId INT NOT NULL CONSTRAINT FK_ActividadEconomica_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        ActividadEconomicaId INT NOT NULL CONSTRAINT PK_ActividadEconomica PRIMARY KEY,
        Codigo NVARCHAR(20) NOT NULL,
        ActividadEconomica NVARCHAR(255) NOT NULL,
        FechaAlta            DATETIME2(7) CONSTRAINT DF_ActividadEconomica_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion       DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja               DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo              BIT          CONSTRAINT DF_ActividadEconomica_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO

/* =====================
   Tabla: dbo.OrigenRecurso
   ===================== */
IF OBJECT_ID(N'dbo.OrigenRecurso', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.OrigenRecurso (
        EmpresaId INT NOT NULL CONSTRAINT FK_OrigenRecurso_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        OrigenRecursoId INT NOT NULL CONSTRAINT PK_OrigenRecurso PRIMARY KEY,
        Codigo NVARCHAR(20) NOT NULL,
        OrigenRecursos NVARCHAR(255) NOT NULL,
        FechaAlta            DATETIME2(7) CONSTRAINT DF_OrigenRecurso_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion       DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja               DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo              BIT          CONSTRAINT DF_OrigenRecurso_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO

/* =====================
   Tabla: dbo.Cliente
   ===================== */
IF OBJECT_ID(N'dbo.Cliente', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Cliente (
        EmpresaId INT NOT NULL CONSTRAINT FK_Cliente_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        ClienteId INT NOT NULL CONSTRAINT PK_Cliente PRIMARY KEY IDENTITY,
        TipoClienteId INT NOT NULL CONSTRAINT FK_Cliente_TipoCliente FOREIGN KEY REFERENCES dbo.TipoCliente(TipoClienteId),
        ActividadEconomicaId INT NOT NULL CONSTRAINT FK_Cliente_ActividadEconomica FOREIGN KEY REFERENCES dbo.ActividadEconomica(ActividadEconomicaId),
        OrigenRecursoId INT NOT NULL CONSTRAINT FK_Cliente_OrigenRecurso FOREIGN KEY REFERENCES dbo.OrigenRecurso(OrigenRecursoId),
        PersonaId INT NOT NULL CONSTRAINT FK_Cliente_Persona FOREIGN KEY REFERENCES dbo.Persona(PersonaId),
        PersonaRepresentanteLegalId INT NULL CONSTRAINT FK_Cliente_Persona_RepresentanteLegal FOREIGN KEY REFERENCES dbo.Persona(PersonaId),
        FechaAlta DATE NOT NULL CONSTRAINT DF_Cliente_FechaAlta DEFAULT GETDATE(),
        HoraAlta TIME NOT NULL CONSTRAINT DF_Cliente_HoraAlta DEFAULT CONVERT(TIME, GETDATE()),
        FechaBaja DATE NULL,
        HoraBaja TIME NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion       DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo              BIT          CONSTRAINT DF_Cliente_EstaActivo DEFAULT (1) NOT NULL
    );
END;
    

/* =====================
   Tabla: dbo.ClienteDomicilio
   ===================== */
IF OBJECT_ID(N'dbo.ClienteDomicilio', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ClienteDomicilio (
        IdEmpresa INT NOT NULL CONSTRAINT FK_ClienteDomicilio_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        ClienteDomicilioId INT NOT NULL CONSTRAINT PK_ClienteDomicilio PRIMARY KEY IDENTITY,
        ClienteId INT NOT NULL CONSTRAINT FK_ClienteDomicilio_Cliente FOREIGN KEY REFERENCES dbo.Cliente(ClienteId),
        DomicilioId INT NOT NULL CONSTRAINT FK_ClienteDomicilio_Domicilio FOREIGN KEY REFERENCES dbo.Domicilio(DomicilioId),
        TipoDomicilioId INT NOT NULL CONSTRAINT FK_ClienteDomicilio_TipoDomicilio FOREIGN KEY REFERENCES dbo.TipoDomicilio(TipoDomicilioId),
        FechaAlta               DATETIME2(7) CONSTRAINT DF_ClienteDomicilio_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion       DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja               DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo              BIT          CONSTRAINT DF_ClienteDomicilio_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO

/* =====================
   Tabla: dbo.TipoControlBeneficiarioControlador
   ===================== */
IF OBJECT_ID(N'dbo.TipoControlBeneficiarioControlador', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TipoControlBeneficiarioControlador (
        IdEmpresa INT NOT NULL CONSTRAINT FK_TipoControlBeneficiarioControlador_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        TipoControlId INT PRIMARY KEY,
        Tipo VARCHAR(50) NOT NULL UNIQUE,
        FechaAlta               DATETIME2(7) CONSTRAINT DF_TipoControlBeneficiarioControlador_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion       DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja               DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo              BIT          CONSTRAINT DF_TipoControlBeneficiarioControlador_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO

-- Datos recomendados
IF NOT EXISTS (select 1 from TipoControlBeneficiarioControlador where TipoControlId in (1,2,3))
BEGIN
    INSERT INTO TipoControlBeneficiarioControlador (IdEmpresa, TipoControlId, Tipo, EstaActivo, UsuarioAltaId) VALUES
    (1,1, 'DIRECTO',1, 1),
    (1,2, 'INDIRECTO',1, 1),
    (1,3, 'AMBOS',1, 1);
END;
GO

/* =====================
   Tabla: dbo.FormaControlBeneficiarioControlador
   ===================== */
IF OBJECT_ID(N'dbo.FormaControlBeneficiarioControlador', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.FormaControlBeneficiarioControlador (
        IdEmpresa INT NOT NULL CONSTRAINT FK_FormaControlBeneficiarioControlador_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        FormaControlId INT PRIMARY KEY,
        FormaControl VARCHAR(50) NOT NULL UNIQUE,
        FechaAlta               DATETIME2(7) CONSTRAINT DF_FormaControlBeneficiarioControlador_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion       DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja               DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo              BIT          CONSTRAINT DF_FormaControlBeneficiarioControlador_EstaActivo DEFAULT (1) NOT NULL
    );
END;

-- Datos recomendados
IF NOT EXISTS (select 1 from FormaControlBeneficiarioControlador where FormaControlId in (1,2,3))
BEGIN
    INSERT INTO FormaControlBeneficiarioControlador (IdEmpresa, FormaControlId, FormaControl, EstaActivo, UsuarioAltaId) VALUES
    (1,1, 'PROPIEDAD', 1, 1),
    (1,2, 'VOTO', 1, 1),
    (1,3, 'FIDEICOMISO', 1, 1);
END;
GO

/* =====================
   Tabla: dbo.TipoEstanciaMigratoria
   ===================== */
IF OBJECT_ID(N'dbo.TipoEstanciaMigratoria', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TipoEstanciaMigratoria (
        IdEmpresa INT NOT NULL CONSTRAINT FK_TipoEstanciaMigratoria_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        TipoEstanciaId INT PRIMARY KEY,
        Tipo VARCHAR(100) NOT NULL UNIQUE,
        FechaAlta               DATETIME2(7) CONSTRAINT DF_TipoEstanciaMigratoria_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion       DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja               DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo              BIT          CONSTRAINT DF_TipoEstanciaMigratoria_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO  

-- Datos recomendados
IF NOT EXISTS (select 1 from TipoEstanciaMigratoria where TipoEstanciaId in (1,2,3,4))
BEGIN
    INSERT INTO TipoEstanciaMigratoria(IdEmpresa, TipoEstanciaId, Tipo, EstaActivo, UsuarioAltaId) VALUES
    (1,1, 'TEMPORAL', 1, 1),
    (1,2, 'RESIDENTE', 1, 1),
    (1,3, 'TRABAJO', 1, 1),
    (1,4, 'ESTUDIANTE', 1, 1);
END;
GO

/* =====================
   Tabla: dbo.BeneficiarioControlador
   ===================== */
IF OBJECT_ID(N'dbo.BeneficiarioControlador', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.BeneficiarioControlador (
        IdEmpresa INT NOT NULL CONSTRAINT FK_BeneficiarioControlador_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        BeneficiarioControladorId INT NOT NULL CONSTRAINT PK_BeneficiarioControlador PRIMARY KEY IDENTITY,
        PersonaId INT NOT NULL CONSTRAINT FK_BeneficiarioControlador_Persona FOREIGN KEY REFERENCES dbo.Persona(PersonaId),
        ClienteId INT NOT NULL CONSTRAINT FK_BeneficiarioControlador_Cliente FOREIGN KEY REFERENCES dbo.Cliente(ClienteId),
        
        -- Control / Participación
        IdTipoControl INT NOT NULL,      -- Propiedad, Voto, Fideicomiso, etc.
        PorcentajeCapital DECIMAL(5,2) NOT NULL,
        PorcentajeCapitalIndirecto DECIMAL(5,2) NULL,
        PorcentajeVoto DECIMAL(5,2) NULL,
        EsControlEfectivo BIT NOT NULL DEFAULT (0),
        DescripcionMecanismo VARCHAR(MAX) NULL,

        -- Documentación soporte
        DocumentoIdentificacionUrl VARCHAR(MAX) NOT NULL,
        DocumentoIdentificacionHash VARCHAR(128) NOT NULL,
        DocumentoControlUrl VARCHAR(MAX) NOT NULL,
        DocumentoControlHash VARCHAR(128) NOT NULL,
        ComprobanteDomicilioUrl VARCHAR(MAX) NULL,
        FechaValidacionDocumentos DATE NOT NULL,

        -- Condición migratoria (para extranjeros)
        EsExtranjero BIT NOT NULL DEFAULT (0),
        TipoEstanciaId INT NULL CONSTRAINT FK_BeneficiarioControlador_TipoEstanciaMigratoria FOREIGN KEY REFERENCES dbo.TipoEstanciaMigratoria(TipoEstanciaId),
        FechaInicioEstancia DATE NULL,
        DocumentoMigratorioUrl VARCHAR(MAX) NULL,

        -- Representante (si aplica)
        ActuaMedianteRepresentante BIT NOT NULL DEFAULT (0),
        RepresentanteNombre VARCHAR(200) NULL,
        RepresentanteIdentificacionUrl VARCHAR(MAX) NULL,

        -- PEP - Persona Políticamente Expuesta
        EsPep BIT NOT NULL DEFAULT (0),
        CargoPep VARCHAR(255) NULL,
        FechaInclusionPep DATE NULL,

        -- Cadena de control
        OrdenCadenaControl INT NULL,
        Observaciones VARCHAR(MAX) NULL,

        -- Verificación y control
        FechaVerificacionDatos DATE NOT NULL,
        MetodoVerificacion VARCHAR(100) NULL,
        VerificadoPor INT NULL, -- Usuario interno
        
        -- Control
        FechaAlta            DATETIME2(7) CONSTRAINT DF_BeneficiarioControlador_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion       DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja               DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo              BIT          CONSTRAINT DF_BeneficiarioControlador_EstaActivo DEFAULT (1) NOT NULL
        
        
        );
END;

/* =====================
   Tabla: dbo.TipoDocumento
   ===================== */
IF OBJECT_ID(N'dbo.TipoDocumento', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TipoDocumento (
        IdEmpresa INT NOT NULL CONSTRAINT FK_TipoDocumento_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        TipoDocumentoId INT NOT NULL CONSTRAINT PK_TipoDocumento PRIMARY KEY,
        Tipo NVARCHAR(100) NOT NULL,
        FechaAlta            DATETIME2(7) CONSTRAINT DF_TipoDocumento_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion       DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja               DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo              BIT          CONSTRAINT DF_TipoDocumento_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO

/* =====================
   Tabla: dbo.DocumentoKYC
   ===================== */
IF OBJECT_ID(N'dbo.DocumentoKYC', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DocumentoKYC (
        IdEmpresa INT NOT NULL CONSTRAINT FK_DocumentoKYC_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        DocumentoKYCId INT NOT NULL CONSTRAINT PK_DocumentoKYC PRIMARY KEY IDENTITY,
        ClienteId INT NOT NULL CONSTRAINT FK_DocumentoKYC_Cliente FOREIGN KEY (ClienteId) REFERENCES dbo.Cliente(ClienteId),
        TipoDocumentoId INT NOT NULL CONSTRAINT FK_DocumentoKYC_TipoDocumento FOREIGN KEY (TipoDocumentoId) REFERENCES dbo.TipoDocumento(TipoDocumentoId),
        Numero NVARCHAR(100) NULL,
        UrlAlmacenamiento NVARCHAR(MAX) NOT NULL,
        FileHash NVARCHAR(128) NULL,
        IdUsuarioVerifico INT NULL CONSTRAINT FK_DocumentoKYC_Usuario FOREIGN KEY (IdUsuarioVerifico) REFERENCES dbo.Usuario(UsuarioId),
        Fecha DATE NOT NULL CONSTRAINT DF_kyc_documents_fecha_subida DEFAULT GETDATE(),
        Hora TIME NOT NULL CONSTRAINT DF_kyc_documents_hora_subida DEFAULT CONVERT(TIME, GETDATE()),
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion       DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja               DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo              BIT          CONSTRAINT DF_DocumentoKYC_EstaActivo DEFAULT (1) NOT NULL
    );
END;

/* =====================
   Tabla: dbo.TipoOperacion
   ===================== */
IF OBJECT_ID(N'dbo.TipoOperacion', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TipoOperacion (
        IdEmpresa INT NOT NULL CONSTRAINT FK_TipoOperacion_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        TipoOperacionId INT NOT NULL CONSTRAINT PK_TipoOperacion PRIMARY KEY,
        Tipo NVARCHAR(100) NOT NULL,
        FechaAlta            DATETIME2(7) CONSTRAINT DF_TipoOperacion_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_TipoOperacion_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO

/* =====================
   Tabla: dbo.ProductoServicio
   ===================== */
IF OBJECT_ID(N'dbo.ProductoServicio', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductoServicio (
        IdEmpresa INT NOT NULL CONSTRAINT FK_ProductoServicio_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        ProductoServicioId INT NOT NULL CONSTRAINT PK_ProductoServicio PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL,
        FechaAlta            DATETIME2(7) CONSTRAINT DF_ProductoServicio_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_ProductoServicio_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO

/* =====================
   Tabla: dbo.Divisa
   ===================== */
IF OBJECT_ID(N'dbo.Divisa', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Divisa (
        IdEmpresa INT NOT NULL CONSTRAINT FK_Divisa_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        DivisaId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Divisa PRIMARY KEY,
        CodigoMoneda CHAR(3) NOT NULL,
        Nombre NVARCHAR(100) NOT NULL,
        Simbolo NVARCHAR(10) NOT NULL,
        FechaAlta            DATETIME2(7) CONSTRAINT DF_Divisa_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_Divisa_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO

/* =====================
   Tabla: dbo.InstrumentoMonetario
   ===================== */
IF OBJECT_ID(N'dbo.InstrumentoMonetario', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.InstrumentoMonetario (
        IdEmpresa INT NOT NULL CONSTRAINT FK_InstrumentoMonetario_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        InstrumentoMonetarioId INT NOT NULL CONSTRAINT PK_InstrumentoMonetario PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL,
        FechaAlta            DATETIME2(7) CONSTRAINT DF_InstrumentoMonetario_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        UsuarioAltaId           INT          NOT NULL,
        FechaModificacion    DATETIME2(7) NULL,
        UsuarioModificacionId   INT          NULL,
        FechaBaja            DATETIME2(7) NULL,
        UsuarioBajaId           INT          NULL,
        EstaActivo           BIT          CONSTRAINT DF_InstrumentoMonetario_EstaActivo DEFAULT (1) NOT NULL
    );
END;
GO

/* =====================
   Tabla: dbo.Operacion
   ===================== */
IF OBJECT_ID(N'dbo.Operacion', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Operacion (
        IdEmpresa INT NOT NULL CONSTRAINT FK_Operacion_Empresa FOREIGN KEY REFERENCES dbo.Empresa(EmpresaId),
        OperacionId BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Operacion PRIMARY KEY,
        ClienteId INT NULL CONSTRAINT FK_Operacion_Cliente FOREIGN KEY REFERENCES dbo.Cliente(ClienteId),
        TipoOperacionId INT NOT NULL CONSTRAINT FK_Operacion_TipoOperacion FOREIGN KEY REFERENCES dbo.TipoOperacion(TipoOperacionId),
        TipoSubOperacionId INT NOT NULL CONSTRAINT FK_Operacion_SubTipoOperacion FOREIGN KEY REFERENCES dbo.TipoOperacion(TipoOperacionId),
        OperacionPadreId BIGINT NULL,
        ProductoServicioId INT NOT NULL CONSTRAINT FK_Operacion_ProductoServicio FOREIGN KEY REFERENCES dbo.ProductoServicio(ProductoServicioId),
        DivisaId INT NOT NULL CONSTRAINT FK_Operacion_Divisa FOREIGN KEY REFERENCES dbo.Divisa(DivisaId),
        Monto MONEY NOT NULL,
        FechaOperacion DATE NOT NULL,
        HoraOperacion TIME NOT NULL,
        FolioExterno NVARCHAR(32) NULL,
        ActividadFraccion NVARCHAR(8) NOT NULL,
        UsuarioExterno NVARCHAR(100) NULL,
        -- Control
        FechaAlta            DATE CONSTRAINT DF_Operacion_FechaAlta DEFAULT (GETDATE()) NOT NULL,
        HoraAlta            TIME CONSTRAINT DF_Operacion_HoraAlta DEFAULT (CONVERT(TIME, GETDATE())) NOT NULL,
        UsuarioAltaId           INT          NOT NULL ,
        EstaActivo BIT NOT NULL CONSTRAINT DF_Operacion_EstaActivo DEFAULT (1)
    );
END;
GO





/*

/* =====================
   Tabla: dbo.Accumulations6M
   ===================== */
IF OBJECT_ID(N'dbo.Accumulations6M', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Accumulations6M (
        AcId UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_accumulations_6m PRIMARY KEY DEFAULT NEWID(),
        ClientId INT NOT NULL,
        ActividadFraccion NVARCHAR(8) NOT NULL,
        PeriodoInicio DATE NOT NULL,
        PeriodoFin DATE NOT NULL,
        MontoAcumulado DECIMAL(18,2) NOT NULL,
        UltimaActualizacion DATETIMEOFFSET(7) NOT NULL CONSTRAINT DF_accumulations_6m_ultima_actualizacion DEFAULT SYSDATETIMEOFFSET(),
        CONSTRAINT UQ_accumulations_6m UNIQUE (ClientId, ActividadFraccion, PeriodoInicio),
        CONSTRAINT FK_accumulations_6m_clients FOREIGN KEY (ClientId) REFERENCES dbo.Clients(ClientId)
    );
END;
GO;




/* =====================
   Tabla: dbo.RiskScores
   ===================== */
IF OBJECT_ID(N'dbo.RiskScores', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.RiskScores (
        RiskId UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_risk_scores PRIMARY KEY DEFAULT NEWID(),
        ClientId INT NOT NULL,
        ScoreNum DECIMAL(5,2) NOT NULL,
        Nivel NVARCHAR(10) NOT NULL CONSTRAINT CK_risk_scores_nivel CHECK (nivel IN (N'BAJO', N'MEDIO', N'ALTO')),
        FactoresDetalle NVARCHAR(MAX) NULL CONSTRAINT CK_risk_scores_factores_ISJSON CHECK (FactoresDetalle IS NULL OR ISJSON(FactoresDetalle) = 1),
        FechaEvaluacion DATETIMEOFFSET(7) NOT NULL CONSTRAINT DF_risk_scores_fecha_evaluacion DEFAULT SYSDATETIMEOFFSET(),
        EvaluadoPor NVARCHAR(50) NOT NULL CONSTRAINT DF_risk_scores_evaluado_por DEFAULT N'SISTEMA',
        CONSTRAINT FK_risk_scores_clients FOREIGN KEY (ClientId) REFERENCES dbo.Clients(ClientId)
    );
END;

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'idx_risk_client' AND object_id = OBJECT_ID(N'dbo.RiskScores'))
BEGIN
    CREATE INDEX idx_risk_client ON dbo.RiskScores(ClientId);
END;

/* =====================
   Tabla: dbo.Alerts
   ===================== */
IF OBJECT_ID(N'dbo.Alerts', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Alerts (
        AlertId UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_alerts PRIMARY KEY DEFAULT NEWID(),
        ClientId INT NULL,
        OpId UNIQUEIDENTIFIER NULL,
        TipoAlerta NVARCHAR(50) NULL,
        Descripcion NVARCHAR(MAX) NULL,
        Prioridad NVARCHAR(10) NOT NULL CONSTRAINT DF_alerts_prioridad DEFAULT N'MEDIA',
        Estado NVARCHAR(20) NOT NULL CONSTRAINT DF_alerts_estado DEFAULT N'OPEN',
        FechaGenerada DATETIMEOFFSET(7) NOT NULL CONSTRAINT DF_alerts_fecha_generada DEFAULT SYSDATETIMEOFFSET(),
        FechaCierre DATETIMEOFFSET(7) NULL,
        CONSTRAINT FK_alerts_clients FOREIGN KEY (ClientId) REFERENCES dbo.Clients(ClientId),
        CONSTRAINT FK_alerts_operations FOREIGN KEY (OpId) REFERENCES dbo.Operations(OpId)
    );
END;

/* =====================
   Tabla: dbo.AuditLogs
   ===================== */
IF OBJECT_ID(N'dbo.AuditLogs', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AuditLogs (
        LogId UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_audit_logs PRIMARY KEY DEFAULT NEWID(),
        UserId UNIQUEIDENTIFIER NULL,
        Accion NVARCHAR(MAX) NULL,
        TablaAfectada NVARCHAR(128) NULL,
        RegistroAfectado UNIQUEIDENTIFIER NULL,
        Detalle NVARCHAR(MAX) NULL CONSTRAINT CK_audit_logs_detalle_ISJSON CHECK (Detalle IS NULL OR ISJSON(Detalle) = 1),
        Fecha DATETIMEOFFSET(7) NOT NULL CONSTRAINT DF_audit_logs_fecha DEFAULT SYSDATETIMEOFFSET(),
        IpOrigen NVARCHAR(50) NULL
    );
END;
*/




