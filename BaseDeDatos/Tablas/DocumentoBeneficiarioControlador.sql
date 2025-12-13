USE [OGIX_PLD_Dev]
GO

/****** Object:  Table [dbo].[DocumentoBeneficiarioControlador]    Script Date: 13/12/2025 01:09:27 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DocumentoBeneficiarioControlador](
	[IdEmpresa] [int] NOT NULL,
	[DocumentoId] [int] IDENTITY(1,1) NOT NULL,
	[BeneficiarioControladorId] [int] NOT NULL,
	[TipoDocumentoId] [int] NOT NULL,
	[Numero] [nvarchar](100) NULL,
	[Archivo] [varbinary](max) NOT NULL,
	[FileHash] [nvarchar](128) NULL,
	[IdUsuarioVerifico] [int] NULL,
	[Fecha] [date] NOT NULL,
	[Hora] [time](7) NOT NULL,
	[UsuarioAltaId] [int] NOT NULL,
	[FechaModificacion] [datetime2](7) NULL,
	[UsuarioModificacionId] [int] NULL,
	[FechaBaja] [datetime2](7) NULL,
	[UsuarioBajaId] [int] NULL,
	[EstaActivo] [bit] NOT NULL,
 CONSTRAINT [PK_DocumentoBeneficiarioControlador] PRIMARY KEY CLUSTERED 
(
	[DocumentoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[DocumentoBeneficiarioControlador] ADD  CONSTRAINT [DF_DocumentoBeneficiarioControlador_Fecha]  DEFAULT (getdate()) FOR [Fecha]
GO

ALTER TABLE [dbo].[DocumentoBeneficiarioControlador] ADD  CONSTRAINT [DF_DocumentoBeneficiarioControlador_Hora]  DEFAULT (CONVERT([time],getdate())) FOR [Hora]
GO

ALTER TABLE [dbo].[DocumentoBeneficiarioControlador] ADD  CONSTRAINT [DF_DocumentoBeneficiarioControlador_EstaActivo]  DEFAULT ((1)) FOR [EstaActivo]
GO

ALTER TABLE [dbo].[DocumentoBeneficiarioControlador]  WITH CHECK ADD  CONSTRAINT [FK_DocumentoBeneficiarioControlador_BeneficiarioControladorId] FOREIGN KEY([BeneficiarioControladorId])
REFERENCES [dbo].[BeneficiarioControlador] ([BeneficiarioControladorId])
GO

ALTER TABLE [dbo].[DocumentoBeneficiarioControlador] CHECK CONSTRAINT [FK_DocumentoBeneficiarioControlador_BeneficiarioControladorId]
GO

ALTER TABLE [dbo].[DocumentoBeneficiarioControlador]  WITH CHECK ADD  CONSTRAINT [FK_DocumentoBeneficiarioControlador_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([EmpresaId])
GO

ALTER TABLE [dbo].[DocumentoBeneficiarioControlador] CHECK CONSTRAINT [FK_DocumentoBeneficiarioControlador_Empresa]
GO

ALTER TABLE [dbo].[DocumentoBeneficiarioControlador]  WITH CHECK ADD  CONSTRAINT [FK_DocumentoBeneficiarioControlador_TipoDocumento] FOREIGN KEY([TipoDocumentoId])
REFERENCES [dbo].[TipoDocumento] ([TipoDocumentoId])
GO

ALTER TABLE [dbo].[DocumentoBeneficiarioControlador] CHECK CONSTRAINT [FK_DocumentoBeneficiarioControlador_TipoDocumento]
GO

ALTER TABLE [dbo].[DocumentoBeneficiarioControlador]  WITH CHECK ADD  CONSTRAINT [FK_DocumentoBeneficiarioControlador_Usuario] FOREIGN KEY([IdUsuarioVerifico])
REFERENCES [dbo].[Usuario] ([UsuarioId])
GO

ALTER TABLE [dbo].[DocumentoBeneficiarioControlador] CHECK CONSTRAINT [FK_DocumentoBeneficiarioControlador_Usuario]
GO

