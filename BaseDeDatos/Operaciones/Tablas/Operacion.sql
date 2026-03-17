SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DROP TABLE [dbo].[Operacion] 
CREATE TABLE [dbo].[Operacion](
	[EmpresaActividadVulnerableId] [int] NOT NULL,
	[Id] [bigint] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[ClienteId] [int] NULL,
	[TipoOperacionId] [int] NOT NULL,
	[TipoSubOperacionId] [int] NOT NULL,
    [FolioOperacion] nvarchar(32) NULL,
	[FolioOperacionPadre] nvarchar(32) NULL,
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
	[EstaActivo] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Operacion] ADD  CONSTRAINT [DF_Operacion_FechaAlta]  DEFAULT (getdate()) FOR [FechaAlta]
GO
ALTER TABLE [dbo].[Operacion] ADD  CONSTRAINT [DF_Operacion_HoraAlta]  DEFAULT (CONVERT([time],getdate())) FOR [HoraAlta]
GO
ALTER TABLE [dbo].[Operacion] ADD  CONSTRAINT [DF_Operacion_EstaActivo]  DEFAULT ((1)) FOR [EstaActivo]
GO
alter TABLE dbo.Operacion add CONSTRAINT FK_EmpresaActividadVulnerable_EmpresaId FOREIGN KEY (EmpresaActividadVulnerableId) 
    REFERENCES dbo.EmpresaActividadVulnerable (EmpresaActividadVulnerableId)
GO
alter TABLE dbo.Operacion add CONSTRAINT FK_Operacion_ClienteId FOREIGN KEY (ClienteId) 
    REFERENCES dbo.Cliente (ClienteId)
GO
alter TABLE dbo.Operacion add CONSTRAINT FK_Operacion_TipoOperacionId FOREIGN KEY (TipoOperacionId) 
    REFERENCES dbo.TipoOperacion (TipoOperacionId)
GO
alter TABLE dbo.Operacion add CONSTRAINT FK_Operacion_TipoSubOperacionId FOREIGN KEY (TipoSubOperacionId) 
    REFERENCES dbo.TipoOperacion (TipoOperacionId)
GO
alter TABLE dbo.Operacion add CONSTRAINT FK_Operacion_ProductoServicioId FOREIGN KEY (ProductoServicioId) 
    REFERENCES dbo.ProductoServicio (ProductoServicioId)
GO
alter TABLE dbo.Operacion add CONSTRAINT FK_Operacion_DivisaId FOREIGN KEY (DivisaId) 
    REFERENCES dbo.Divisa (DivisaId)
GO
alter TABLE dbo.Operacion add CONSTRAINT FK_Operacion_UsuarioAltaId FOREIGN KEY (UsuarioAltaId) 
    REFERENCES dbo.Usuario (UsuarioId)
GO


