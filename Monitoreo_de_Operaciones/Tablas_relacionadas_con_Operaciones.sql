

if OBJECT_ID('dbo.ValorUMA') is NULL
BEGIN
    create table dbo.ValorUMA(
        ValorUMAId INT IDENTITY,
        ValorDiario NUMERIC(11,2) NOT NULL CONSTRAINT DF_ValorUMA_ValorDiario DEFAULT (0),
        ValorMensual NUMERIC(11,2) NOT NULL CONSTRAINT DF_ValorUMA_ValorMensual DEFAULT (0),
        ValorAnual NUMERIC(11,2) NOT NULL CONSTRAINT DF_ValorUMA_ValorAnual DEFAULT (0),
        InicioVigencia DATE NOT NULL CONSTRAINT DF_ValorUMA_FinVigencia DEFAULT ('19000101'),
        FinVigencia DATE NOT NULL CONSTRAINT DF_ValorUMA_InicioVigencia DEFAULT ('19000101'),

        CONSTRAINT PK_ValorUMA PRIMARY KEY (ValorUMAId)
    )
END
GO

if OBJECT_ID('dbo.UmbralIdentificacionCliente') is NULL
BEGIN
    create table dbo.UmbralIdentificacionCliente(   
        UmbralIdentificacionClienteId INT IDENTITY,
        ActividadVulnerableId INT NOT NULL,
        UmbralEnUMAs INT NOT NULL CONSTRAINT DF_UmbralIdentificacionCliente_UmbralEnUMAs DEFAULT (0),

        CONSTRAINT PK_UmbralIdentificacionCliente PRIMARY KEY (UmbralIdentificacionClienteId),
        CONSTRAINT FK_UmbralIdentificacionCliente_ActividadVulnerable FOREIGN KEY (ActividadVulnerableId) REFERENCES ActividadVulnerable(ActividadVulnerableId)
        
    )

    CREATE NONCLUSTERED INDEX IX_UmbralIdentificacionCliente_ActividadVulnerableId on dbo.UmbralIdentificacionCliente(ActividadVulnerableId)
END
GO

if OBJECT_ID('dbo.UmbralPresentacionAviso') is NULL
BEGIN
    create table dbo.UmbralPresentacionAviso(   
        UmbralPresentacionAvisoId INT IDENTITY,
        ActividadVulnerableId INT NOT NULL,
        UmbralEnUMAs INT NOT NULL CONSTRAINT DF_UmbralPresentacionAviso_UmbralEnUMAs DEFAULT (0),

        CONSTRAINT PK_UmbralPresentacionAviso PRIMARY KEY (UmbralPresentacionAvisoId),
        CONSTRAINT FK_UmbralPresentacionAviso_ActividadVulnerable FOREIGN KEY (ActividadVulnerableId) REFERENCES ActividadVulnerable(ActividadVulnerableId)
    )

    CREATE NONCLUSTERED INDEX IX_UmbralPresentacionAviso_ActividadVulnerableId on dbo.UmbralPresentacionAviso(ActividadVulnerableId)
END
GO


-- Tabla: ActividadVulnerable
CREATE TABLE [dbo].[ActividadVulnerable](
    [ActividadVulnerableId] [int] IDENTITY(1,1) NOT NULL,
    [Codigo] [nvarchar](20) NOT NULL,
    [Descripcion] [nvarchar](700) NOT NULL,
    [FechaAlta] [datetime2](7) NOT NULL,
    [UsuarioAltaId] [int] NOT NULL,
    [FechaModificacion] [datetime2](7) NULL,
    [UsuarioModificacionId] [int] NULL,
    [FechaBaja] [datetime2](7) NULL,
    [UsuarioBajaId] [int] NULL,
    [EstaActivo] [bit] NOT NULL,
    CONSTRAINT [PK_ActividadVulnerable] PRIMARY KEY CLUSTERED ([ActividadVulnerableId] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO

ALTER TABLE [dbo].[ActividadVulnerable] ADD CONSTRAINT [DF_ActividadVulnerable_FechaAlta] DEFAULT (GETDATE()) FOR [FechaAlta];
GO

ALTER TABLE [dbo].[ActividadVulnerable] ADD CONSTRAINT [DF_ActividadVulnerable_EstaActivo] DEFAULT ((1)) FOR [EstaActivo];
GO

-- Tabla: Empresa
CREATE TABLE [dbo].[Empresa](
    [EmpresaId] [int] IDENTITY(1,1) NOT NULL,
    [Nombre] [nvarchar](255) NOT NULL,
    [RFC] [nvarchar](13) NULL,
    [CURP] [nvarchar](18) NULL,
    [ActividadVulnerableId] [int] NULL,
    [GiroMercantilId] [int] NULL,
    [FechaAlta] [datetime2](7) NOT NULL,
    [UsuarioAltaId] [int] NULL,
    [FechaModificacion] [datetime2](7) NULL,
    [UsuarioModificacionId] [int] NULL,
    [FechaBaja] [datetime2](7) NULL,
    [UsuarioBajaId] [int] NULL,
    [EstaActivo] [bit] NOT NULL,
    CONSTRAINT [PK_Empresa] PRIMARY KEY CLUSTERED ([EmpresaId] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO

CREATE UNIQUE NONCLUSTERED INDEX [UK_Empresa_RFC] ON [dbo].[Empresa]
(
    [RFC] ASC
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];
GO

ALTER TABLE [dbo].[Empresa] ADD CONSTRAINT [DF_Empresa_FechaAlta] DEFAULT (GETDATE()) FOR [FechaAlta];
GO

ALTER TABLE [dbo].[Empresa] ADD CONSTRAINT [DF_Empresa_EstaActivo] DEFAULT ((1)) FOR [EstaActivo];
GO

ALTER TABLE [dbo].[Empresa] WITH CHECK ADD CONSTRAINT [FK_Empresa_ActividadVulnerable_ActividadVulnerableId] 
    FOREIGN KEY([ActividadVulnerableId]) REFERENCES [dbo].[ActividadVulnerable] ([ActividadVulnerableId]);
GO

-- Tabla: EmpresaActividadVulnerable
CREATE TABLE [dbo].[EmpresaActividadVulnerable](
    [EmpresaActividadVulnerableId] [int] IDENTITY(1,1) NOT NULL,
    [EmpresaId] [int] NOT NULL,
    [ActividadVulnerableId] [int] NOT NULL,
    [FechaAlta] [datetime] NOT NULL,
    [HoraAlta] [time](7) NOT NULL,
    [UsuarioAltaId] [int] NOT NULL,
    [FechaBaja] [datetime] NULL,
    [HoraBaja] [time](7) NULL,
    [UsuarioBajaId] [int] NULL,
    [EstaActivo] [bit] NOT NULL,
    CONSTRAINT [PK__EmpresaA__581698F6C6013F41] PRIMARY KEY CLUSTERED ([EmpresaActividadVulnerableId] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO

CREATE NONCLUSTERED INDEX [IX_EmpresaActividadVulnerable_EmpresaId] ON [dbo].[EmpresaActividadVulnerable]
(
    [EmpresaId] ASC
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];
GO

CREATE NONCLUSTERED INDEX [IX_EmpresaActividadVulnerable_ActividadVulnerableId] ON [dbo].[EmpresaActividadVulnerable]
(
    [ActividadVulnerableId] ASC
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];
GO

ALTER TABLE [dbo].[EmpresaActividadVulnerable] WITH CHECK ADD CONSTRAINT [FK_EmpresaActividadVulnerable_Empresa] 
    FOREIGN KEY([EmpresaId]) REFERENCES [dbo].[Empresa] ([EmpresaId]);
GO

ALTER TABLE [dbo].[EmpresaActividadVulnerable] WITH CHECK ADD CONSTRAINT [FK_EmpresaActividadVulnerable_ActividadVulnerable] 
    FOREIGN KEY([ActividadVulnerableId]) REFERENCES [dbo].[ActividadVulnerable] ([ActividadVulnerableId]);
GO

-- Tabla: Cliente
CREATE TABLE [dbo].[Cliente](
    [EmpresaId] [int] NOT NULL,
    [ClienteId] [int] IDENTITY(1,1) NOT NULL,
    [TipoClienteId] [int] NOT NULL,
    [ActividadEconomicaId] [int] NOT NULL,
    [OrigenRecursoId] [int] NOT NULL,
    [PersonaId] [int] NOT NULL,
    [PersonaRepresentanteLegalId] [int] NULL,
    [FechaAlta] [date] NOT NULL,
    [HoraAlta] [time](7) NOT NULL,
    [FechaBaja] [date] NULL,
    [HoraBaja] [time](7) NULL,
    [UsuarioAltaId] [int] NOT NULL,
    [FechaModificacion] [datetime2](7) NULL,
    [UsuarioModificacionId] [int] NULL,
    [UsuarioBajaId] [int] NULL,
    [EstaActivo] [bit] NOT NULL,
    CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED ([ClienteId] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO

ALTER TABLE [dbo].[Cliente] ADD CONSTRAINT [DF_Cliente_FechaAlta] DEFAULT (GETDATE()) FOR [FechaAlta];
GO

ALTER TABLE [dbo].[Cliente] ADD CONSTRAINT [DF_Cliente_HoraAlta] DEFAULT (CONVERT([time], GETDATE())) FOR [HoraAlta];
GO

ALTER TABLE [dbo].[Cliente] ADD CONSTRAINT [DF_Cliente_EstaActivo] DEFAULT ((1)) FOR [EstaActivo];
GO

ALTER TABLE [dbo].[Cliente] WITH CHECK ADD CONSTRAINT [FK_Cliente_Empresa] 
    FOREIGN KEY([EmpresaId]) REFERENCES [dbo].[Empresa] ([EmpresaId]);
GO

-- Tabla: TipoOperacion
CREATE TABLE [dbo].[TipoOperacion](
    [TipoOperacionId] [int] NOT NULL,
    [Tipo] [nvarchar](100) NOT NULL,
    [FechaAlta] [datetime2](7) NOT NULL,
    [UsuarioAltaId] [int] NOT NULL,
    [FechaModificacion] [datetime2](7) NULL,
    [UsuarioModificacionId] [int] NULL,
    [FechaBaja] [datetime2](7) NULL,
    [UsuarioBajaId] [int] NULL,
    [EstaActivo] [bit] NOT NULL,
    CONSTRAINT [PK_TipoOperacion] PRIMARY KEY CLUSTERED ([TipoOperacionId] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO

ALTER TABLE [dbo].[TipoOperacion] ADD CONSTRAINT [DF_TipoOperacion_FechaAlta] DEFAULT (GETDATE()) FOR [FechaAlta];
GO

ALTER TABLE [dbo].[TipoOperacion] ADD CONSTRAINT [DF_TipoOperacion_EstaActivo] DEFAULT ((1)) FOR [EstaActivo];
GO

-- Tabla: ProductoServicio
CREATE TABLE [dbo].[ProductoServicio](
    [EmpresaId] [int] NOT NULL,
    [ProductoServicioId] [int] NOT NULL,
    [Nombre] [nvarchar](100) NOT NULL,
    [FechaAlta] [datetime2](7) NOT NULL,
    [UsuarioAltaId] [int] NOT NULL,
    [FechaModificacion] [datetime2](7) NULL,
    [UsuarioModificacionId] [int] NULL,
    [FechaBaja] [datetime2](7) NULL,
    [UsuarioBajaId] [int] NULL,
    [EstaActivo] [bit] NOT NULL,
    CONSTRAINT [PK_ProductoServicio] PRIMARY KEY CLUSTERED ([ProductoServicioId] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO

ALTER TABLE [dbo].[ProductoServicio] ADD CONSTRAINT [DF_ProductoServicio_FechaAlta] DEFAULT (GETDATE()) FOR [FechaAlta];
GO

ALTER TABLE [dbo].[ProductoServicio] ADD CONSTRAINT [DF_ProductoServicio_EstaActivo] DEFAULT ((1)) FOR [EstaActivo];
GO

ALTER TABLE [dbo].[ProductoServicio] WITH CHECK ADD CONSTRAINT [FK_ProductoServicio_Empresa] 
    FOREIGN KEY([EmpresaId]) REFERENCES [dbo].[Empresa] ([EmpresaId]);
GO

-- Tabla: Divisa
CREATE TABLE [dbo].[Divisa](
    [DivisaId] [int] IDENTITY(1,1) NOT NULL,
    [CodigoMoneda] [char](3) NOT NULL,
    [Nombre] [nvarchar](100) NOT NULL,
    [Simbolo] [nvarchar](10) NOT NULL,
    [FechaAlta] [datetime2](7) NOT NULL,
    [UsuarioAltaId] [int] NOT NULL,
    [FechaModificacion] [datetime2](7) NULL,
    [UsuarioModificacionId] [int] NULL,
    [FechaBaja] [datetime2](7) NULL,
    [UsuarioBajaId] [int] NULL,
    [EstaActivo] [bit] NOT NULL,
    CONSTRAINT [PK_Divisa] PRIMARY KEY CLUSTERED ([DivisaId] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO

ALTER TABLE [dbo].[Divisa] ADD CONSTRAINT [DF_Divisa_FechaAlta] DEFAULT (GETDATE()) FOR [FechaAlta];
GO

ALTER TABLE [dbo].[Divisa] ADD CONSTRAINT [DF_Divisa_EstaActivo] DEFAULT ((1)) FOR [EstaActivo];
GO

-- Tabla: Usuario
CREATE TABLE [dbo].[Usuario](
    [UsuarioId] [int] IDENTITY(1,1) NOT NULL,
    [Correo] [nvarchar](255) NULL,
    [RolId] [int] NULL,
    [Contrasena] [nvarchar](255) NULL,
    [FechaAlta] [date] NOT NULL,
    [HoraAlta] [time](7) NOT NULL,
    [UsuarioAltaId] [int] NULL,
    [FechaModificacion] [datetime2](7) NULL,
    [UsuarioModificacionId] [int] NULL,
    [FechaBaja] [datetime2](7) NULL,
    [UsuarioBajaId] [int] NULL,
    [EstaActivo] [bit] NOT NULL,
    CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED ([UsuarioId] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO

ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT [DF_Usuario_FechaAlta] DEFAULT (GETDATE()) FOR [FechaAlta];
GO

ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT [DF_Usuario_HoraAlta] DEFAULT (CONVERT([time], GETDATE())) FOR [HoraAlta];
GO

ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT [DF_Usuario_EstaActivo] DEFAULT ((1)) FOR [EstaActivo];
GO

-- Tabla: Operacion
CREATE TABLE [dbo].[Operacion](
    [EmpresaActividadVulnerableId] [int] NOT NULL,
    [Id] [bigint] IDENTITY(1,1) NOT NULL,
    [ClienteId] [int] NULL,
    [TipoOperacionId] [int] NOT NULL, -- Se relaciona con [dbo].[TipoOperacion] puede ser cualquier [TipoOperacionId] a excepción de 500 o 501
    [TipoSubOperacionId] [int] NOT NULL, -- Se relaciona con [dbo].[TipoOperacion] solo puede ser [TipoOperacionId] 500 o 501 (deposito o retiro)
    [FolioOperacion] [nvarchar](32) NULL,
    [FolioOperacionPadre] [nvarchar](32) NULL,
    [ProductoServicioId] [int] NOT NULL,
    [DivisaId] [int] NOT NULL,
    [Monto] [money] NOT NULL,
    [FechaOperacion] [date] NOT NULL,
    [HoraOperacion] [time](7) NOT NULL,
    [ActividadFraccion] [nvarchar](8) NOT NULL,
    [UsuarioOperacion] [nvarchar](100) NULL,
    [FechaAlta] [date] NOT NULL,
    [HoraAlta] [time](7) NOT NULL,
    [UsuarioAltaId] [int] NOT NULL,
    [EstaActivo] [bit] NOT NULL,
    [FactorDivisa] [decimal](18,6) NULL,
    CONSTRAINT [PK__Operacio__3214EC075BAED578] PRIMARY KEY CLUSTERED ([Id] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];
GO

ALTER TABLE [dbo].[Operacion] ADD CONSTRAINT [DF_Operacion_FechaAlta] DEFAULT (GETDATE()) FOR [FechaAlta];
GO

ALTER TABLE [dbo].[Operacion] ADD CONSTRAINT [DF_Operacion_HoraAlta] DEFAULT (CONVERT([time], GETDATE())) FOR [HoraAlta];
GO

ALTER TABLE [dbo].[Operacion] ADD CONSTRAINT [DF_Operacion_EstaActivo] DEFAULT ((1)) FOR [EstaActivo];
GO

ALTER TABLE [dbo].[Operacion] WITH CHECK ADD CONSTRAINT [FK_EmpresaActividadVulnerable_EmpresaId] 
    FOREIGN KEY([EmpresaActividadVulnerableId]) REFERENCES [dbo].[EmpresaActividadVulnerable] ([EmpresaActividadVulnerableId]);
GO

ALTER TABLE [dbo].[Operacion] WITH CHECK ADD CONSTRAINT [FK_Operacion_ClienteId] 
    FOREIGN KEY([ClienteId]) REFERENCES [dbo].[Cliente] ([ClienteId]);
GO

ALTER TABLE [dbo].[Operacion] WITH CHECK ADD CONSTRAINT [FK_Operacion_TipoOperacionId] 
    FOREIGN KEY([TipoOperacionId]) REFERENCES [dbo].[TipoOperacion] ([TipoOperacionId]);
GO

ALTER TABLE [dbo].[Operacion] WITH CHECK ADD CONSTRAINT [FK_Operacion_TipoSubOperacionId] 
    FOREIGN KEY([TipoSubOperacionId]) REFERENCES [dbo].[TipoOperacion] ([TipoOperacionId]);
GO

ALTER TABLE [dbo].[Operacion] WITH CHECK ADD CONSTRAINT [FK_Operacion_ProductoServicioId] 
    FOREIGN KEY([ProductoServicioId]) REFERENCES [dbo].[ProductoServicio] ([ProductoServicioId]);
GO

ALTER TABLE [dbo].[Operacion] WITH CHECK ADD CONSTRAINT [FK_Operacion_DivisaId] 
    FOREIGN KEY([DivisaId]) REFERENCES [dbo].[Divisa] ([DivisaId]);
GO

ALTER TABLE [dbo].[Operacion] WITH CHECK ADD CONSTRAINT [FK_Operacion_UsuarioAltaId] 
    FOREIGN KEY([UsuarioAltaId]) REFERENCES [dbo].[Usuario] ([UsuarioId]);
GO