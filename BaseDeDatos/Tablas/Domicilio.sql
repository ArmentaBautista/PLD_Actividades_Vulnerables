USE [OGIX_PLD_Dev]
GO

/****** Object:  Table [dbo].[Domicilio]    Script Date: 13/12/2025 12:52:05 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Domicilio](
	[EmpresaId] [int] NOT NULL,
	[DomicilioId] [int] IDENTITY(1,1) NOT NULL,
	[Calle] [nvarchar](255) NOT NULL,
	[EntreCalles] [nvarchar](255) NOT NULL,
	[NumeroExterior] [nvarchar](20) NOT NULL,
	[NumeroInterior] [nvarchar](20) NULL,
	[AsentamientoId] [int] NOT NULL,
	[Referencias] [nvarchar](max) NULL,
	[FechaAlta] [datetime2](7) NOT NULL,
	[UsuarioAltaId] [int] NOT NULL,
	[FechaModificacion] [datetime2](7) NULL,
	[UsuarioModificacionId] [int] NULL,
	[FechaBaja] [datetime2](7) NULL,
	[UsuarioBajaId] [int] NULL,
	[EstaActivo] [bit] NOT NULL,
 CONSTRAINT [PK_Domicilio] PRIMARY KEY CLUSTERED 
(
	[DomicilioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Domicilio] ADD  CONSTRAINT [DF_Domicilio_FechaAlta]  DEFAULT (getdate()) FOR [FechaAlta]
GO

ALTER TABLE [dbo].[Domicilio] ADD  CONSTRAINT [DF_Domicilio_EstaActivo]  DEFAULT ((1)) FOR [EstaActivo]
GO

ALTER TABLE [dbo].[Domicilio]  WITH CHECK ADD  CONSTRAINT [FK_Domicilio_Asentamiento] FOREIGN KEY([AsentamientoId])
REFERENCES [dbo].[Asentamiento] ([AsentamientoId])
GO

ALTER TABLE [dbo].[Domicilio] CHECK CONSTRAINT [FK_Domicilio_Asentamiento]
GO

ALTER TABLE [dbo].[Domicilio]  WITH CHECK ADD  CONSTRAINT [FK_Domicilio_Empresa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Empresa] ([EmpresaId])
GO

ALTER TABLE [dbo].[Domicilio] CHECK CONSTRAINT [FK_Domicilio_Empresa]
GO

