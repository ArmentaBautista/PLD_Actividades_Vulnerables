USE [OGIX_PLD_Dev]
GO

/****** Object:  Table [dbo].[Persona]    Script Date: 13/12/2025 12:48:05 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Persona](
	[EmpresaId] [INT] NOT NULL,
	[PersonaId] [INT] IDENTITY(1,1) NOT NULL,
	[EsPersonaFisica] [BIT] NULL,
	[Nombre] [NVARCHAR](150) NOT NULL,
	[Paterno] [NVARCHAR](150) NULL,
	[Materno] [NVARCHAR](150) NULL,
	[FechaNacimientoConstitucion] [DATE] NOT NULL,
	[RFC] [NVARCHAR](13) NULL,
	[CURP] [NVARCHAR](18) NULL,
	[FechaAlta] [DATETIME] NOT NULL,
	[HoraAlta] [TIME](7) NOT NULL,
	[UsuarioAltaId] [INT] NOT NULL,
	[FechaModificacion] [DATETIME2](7) NULL,
	[UsuarioModificacionId] [INT] NULL,
	[FechaBaja] [DATETIME] NULL,
	[HoraBaja] [TIME](7) NULL,
	[UsuarioBajaId] [INT] NULL,
	[EstaActivo] [BIT] NOT NULL,
 CONSTRAINT [PK_Persona] PRIMARY KEY CLUSTERED 
(
	[PersonaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Persona] ADD  CONSTRAINT [DEFAULT_Persona_EsPersonaFisica]  DEFAULT ((1)) FOR [EsPersonaFisica]
GO

ALTER TABLE [dbo].[Persona] ADD  CONSTRAINT [DF_Persona_FechaAlta]  DEFAULT (GETDATE()) FOR [FechaAlta]
GO

ALTER TABLE [dbo].[Persona] ADD  CONSTRAINT [DF_Persona_HoraAlta]  DEFAULT (CONVERT([TIME],GETDATE())) FOR [HoraAlta]
GO

ALTER TABLE [dbo].[Persona] ADD  CONSTRAINT [DF_Persona_EstaActivo]  DEFAULT ((1)) FOR [EstaActivo]
GO

ALTER TABLE [dbo].[Persona]  WITH CHECK ADD  CONSTRAINT [FK_Persona_Empresa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Empresa] ([EmpresaId])
GO

ALTER TABLE [dbo].[Persona] CHECK CONSTRAINT [FK_Persona_Empresa]
GO


