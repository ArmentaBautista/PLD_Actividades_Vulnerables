USE [OGIX_PLD_Dev]
GO

/****** Object:  Table [dbo].[DocumentoKYC]    Script Date: 13/12/2025 01:10:13 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DocumentoKYC](
	[IdEmpresa] [int] NOT NULL,
	[DocumentoId] [int] IDENTITY(1,1) NOT NULL,
	[ClienteId] [int] NOT NULL,
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
 CONSTRAINT [PK_DocumentoKYC] PRIMARY KEY CLUSTERED 
(
	[DocumentoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[DocumentoKYC] ADD  CONSTRAINT [DF_kyc_documents_fecha_subida]  DEFAULT (getdate()) FOR [Fecha]
GO

ALTER TABLE [dbo].[DocumentoKYC] ADD  CONSTRAINT [DF_kyc_documents_hora_subida]  DEFAULT (CONVERT([time],getdate())) FOR [Hora]
GO

ALTER TABLE [dbo].[DocumentoKYC] ADD  CONSTRAINT [DF_DocumentoKYC_EstaActivo]  DEFAULT ((1)) FOR [EstaActivo]
GO

ALTER TABLE [dbo].[DocumentoKYC]  WITH CHECK ADD  CONSTRAINT [FK_DocumentoKYC_Cliente] FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Cliente] ([ClienteId])
GO

ALTER TABLE [dbo].[DocumentoKYC] CHECK CONSTRAINT [FK_DocumentoKYC_Cliente]
GO

ALTER TABLE [dbo].[DocumentoKYC]  WITH CHECK ADD  CONSTRAINT [FK_DocumentoKYC_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([EmpresaId])
GO

ALTER TABLE [dbo].[DocumentoKYC] CHECK CONSTRAINT [FK_DocumentoKYC_Empresa]
GO

ALTER TABLE [dbo].[DocumentoKYC]  WITH CHECK ADD  CONSTRAINT [FK_DocumentoKYC_TipoDocumento] FOREIGN KEY([TipoDocumentoId])
REFERENCES [dbo].[TipoDocumento] ([TipoDocumentoId])
GO

ALTER TABLE [dbo].[DocumentoKYC] CHECK CONSTRAINT [FK_DocumentoKYC_TipoDocumento]
GO

ALTER TABLE [dbo].[DocumentoKYC]  WITH CHECK ADD  CONSTRAINT [FK_DocumentoKYC_Usuario] FOREIGN KEY([IdUsuarioVerifico])
REFERENCES [dbo].[Usuario] ([UsuarioId])
GO

ALTER TABLE [dbo].[DocumentoKYC] CHECK CONSTRAINT [FK_DocumentoKYC_Usuario]
GO

