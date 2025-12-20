
CREATE TABLE [dbo].[Sesion]
(
[SesionId] [bigint] NOT NULL,
[UsuarioId] [int] NOT NULL,
[Fecha] [date] NOT NULL,
[Inicio] [datetime2] NOT NULL,
[Fin] [datetime2] NULL,
[IP] [nvarchar] (45) COLLATE Modern_Spanish_CI_AI NULL,
[Dispositivo] [nvarchar] (200) COLLATE Modern_Spanish_CI_AI NULL,
[TokenSesion] [nvarchar] (512) COLLATE Modern_Spanish_CI_AI NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sesion] ADD CONSTRAINT [PK_Sesion] PRIMARY KEY CLUSTERED ([SesionId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sesion] ADD CONSTRAINT [FK_Sesion_Usuario] FOREIGN KEY ([UsuarioId]) REFERENCES [dbo].[Usuario] ([UsuarioId])
GO


CREATE TABLE [dbo].[SesionActiva]
(
[SesionId] [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SesionActiva] ADD CONSTRAINT [FK_SesionActiva_Sesion] FOREIGN KEY ([SesionId]) REFERENCES [dbo].[Sesion] ([SesionId])
GO


CREATE TABLE [dbo].[SesionFallida](
	[Correo] [nvarchar](255) NULL,
	[Contrasena] [nvarchar](255) NULL,
	[MotivoId] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[Hora] [time](7) NOT NULL,
	[IP] [nvarchar](45) NULL,
	[Dispositivo] [nvarchar](200) NULL
) ON [PRIMARY]
GO


USE [OGIX_PLD_Dev]
GO

/****** Object:  Table [dbo].[MotivoSesionFallida]    Script Date: 20/12/2025 12:45:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MotivoSesionFallida](
	[Id] [int] NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
	[EstaActivo] [bit] NOT NULL,
 CONSTRAINT [PK_MotivoSesionFallida] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

