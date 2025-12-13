USE [OGIX_PLD_Dev]
GO

/****** Object:  Table [dbo].[PersonaDomicilio]    Script Date: 13/12/2025 12:53:11 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PersonaDomicilio](
	[EmpresaId] [int] NOT NULL,
	[PersonaDomicilioId] [int] IDENTITY(1,1) NOT NULL,
	[PersonaId] [int] NOT NULL,
	[DomicilioId] [int] NOT NULL,
	[TipoDomicilioId] [int] NOT NULL,
	[FechaAlta] [datetime] NOT NULL,
	[HoraAlta] [time](7) NOT NULL,
	[UsuarioAltaId] [int] NOT NULL,
	[FechaModificacion] [datetime2](7) NULL,
	[UsuarioModificacionId] [int] NULL,
	[FechaBaja] [datetime] NULL,
	[HoraBaja] [time](7) NULL,
	[UsuarioBajaId] [int] NULL,
	[EstaActivo] [bit] NOT NULL,
 CONSTRAINT [PK_PersonaDomicilio] PRIMARY KEY CLUSTERED 
(
	[PersonaDomicilioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PersonaDomicilio] ADD  CONSTRAINT [DF_PersonaDomicilio_FechaAlta]  DEFAULT (getdate()) FOR [FechaAlta]
GO

ALTER TABLE [dbo].[PersonaDomicilio] ADD  CONSTRAINT [DF_PersonaDomicilio_HoraAlta]  DEFAULT (CONVERT([time],getdate())) FOR [HoraAlta]
GO

ALTER TABLE [dbo].[PersonaDomicilio] ADD  CONSTRAINT [DF_PersonaDomicilio_EstaActivo]  DEFAULT ((1)) FOR [EstaActivo]
GO

ALTER TABLE [dbo].[PersonaDomicilio]  WITH CHECK ADD  CONSTRAINT [FK_PersonaDomicilio_Domicilio] FOREIGN KEY([DomicilioId])
REFERENCES [dbo].[Domicilio] ([DomicilioId])
GO

ALTER TABLE [dbo].[PersonaDomicilio] CHECK CONSTRAINT [FK_PersonaDomicilio_Domicilio]
GO

ALTER TABLE [dbo].[PersonaDomicilio]  WITH CHECK ADD  CONSTRAINT [FK_PersonaDomicilio_Empresa] FOREIGN KEY([EmpresaId])
REFERENCES [dbo].[Empresa] ([EmpresaId])
GO

ALTER TABLE [dbo].[PersonaDomicilio] CHECK CONSTRAINT [FK_PersonaDomicilio_Empresa]
GO

ALTER TABLE [dbo].[PersonaDomicilio]  WITH CHECK ADD  CONSTRAINT [FK_PersonaDomicilio_Persona] FOREIGN KEY([PersonaId])
REFERENCES [dbo].[Persona] ([PersonaId])
GO

ALTER TABLE [dbo].[PersonaDomicilio] CHECK CONSTRAINT [FK_PersonaDomicilio_Persona]
GO

ALTER TABLE [dbo].[PersonaDomicilio]  WITH CHECK ADD  CONSTRAINT [FK_PersonaDomicilio_TipoDomicilio] FOREIGN KEY([TipoDomicilioId])
REFERENCES [dbo].[TipoDomicilio] ([TipoDomicilioId])
GO

ALTER TABLE [dbo].[PersonaDomicilio] CHECK CONSTRAINT [FK_PersonaDomicilio_TipoDomicilio]
GO

