USE [OGIX_PLD_Dev]
GO

/****** Object:  Table [dbo].[BeneficiarioControlador]    Script Date: 13/12/2025 01:07:39 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BeneficiarioControlador](
	[IdEmpresa] [int] NOT NULL,
	[BeneficiarioControladorId] [int] IDENTITY(1,1) NOT NULL,
	[PersonaId] [int] NOT NULL,
	[ClienteId] [int] NULL,
	[IdTipoControl] [int] NOT NULL,
	[PorcentajeCapital] [decimal](5, 2) NOT NULL,
	[PorcentajeCapitalIndirecto] [decimal](5, 2) NULL,
	[PorcentajeVoto] [decimal](5, 2) NULL,
	[EsControlEfectivo] [bit] NOT NULL,
	[DescripcionMecanismo] [varchar](max) NULL,
	[FechaValidacionDocumentos] [date] NOT NULL,
	[EsExtranjero] [bit] NOT NULL,
	[TipoEstanciaId] [int] NULL,
	[FechaInicioEstancia] [date] NULL,
	[ActuaMedianteRepresentante] [bit] NOT NULL,
	[RepresentanteNombre] [varchar](200) NULL,
	[EsPep] [bit] NOT NULL,
	[CargoPep] [varchar](255) NULL,
	[FechaInclusionPep] [date] NULL,
	[OrdenCadenaControl] [int] NULL,
	[Observaciones] [varchar](max) NULL,
	[FechaVerificacionDatos] [date] NOT NULL,
	[MetodoVerificacion] [varchar](100) NULL,
	[VerificadoPor] [int] NULL,
	[FechaAlta] [datetime2](7) NOT NULL,
	[UsuarioAltaId] [int] NOT NULL,
	[FechaModificacion] [datetime2](7) NULL,
	[UsuarioModificacionId] [int] NULL,
	[FechaBaja] [datetime2](7) NULL,
	[UsuarioBajaId] [int] NULL,
	[EstaActivo] [bit] NOT NULL,
 CONSTRAINT [PK_BeneficiarioControlador] PRIMARY KEY CLUSTERED 
(
	[BeneficiarioControladorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[BeneficiarioControlador] ADD  CONSTRAINT [DF__Beneficia__EsCon__2FEF161B]  DEFAULT ((0)) FOR [EsControlEfectivo]
GO

ALTER TABLE [dbo].[BeneficiarioControlador] ADD  CONSTRAINT [DF__Beneficia__EsExt__30E33A54]  DEFAULT ((0)) FOR [EsExtranjero]
GO

ALTER TABLE [dbo].[BeneficiarioControlador] ADD  CONSTRAINT [DF__Beneficia__Actua__32CB82C6]  DEFAULT ((0)) FOR [ActuaMedianteRepresentante]
GO

ALTER TABLE [dbo].[BeneficiarioControlador] ADD  CONSTRAINT [DF__Beneficia__EsPep__33BFA6FF]  DEFAULT ((0)) FOR [EsPep]
GO

ALTER TABLE [dbo].[BeneficiarioControlador] ADD  CONSTRAINT [DF_BeneficiarioControlador_FechaAlta]  DEFAULT (getdate()) FOR [FechaAlta]
GO

ALTER TABLE [dbo].[BeneficiarioControlador] ADD  CONSTRAINT [DF_BeneficiarioControlador_EstaActivo]  DEFAULT ((1)) FOR [EstaActivo]
GO

ALTER TABLE [dbo].[BeneficiarioControlador]  WITH CHECK ADD  CONSTRAINT [FK_BeneficiarioControlador_Cliente] FOREIGN KEY([ClienteId])
REFERENCES [dbo].[Cliente] ([ClienteId])
GO

ALTER TABLE [dbo].[BeneficiarioControlador] CHECK CONSTRAINT [FK_BeneficiarioControlador_Cliente]
GO

ALTER TABLE [dbo].[BeneficiarioControlador]  WITH CHECK ADD  CONSTRAINT [FK_BeneficiarioControlador_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [dbo].[Empresa] ([EmpresaId])
GO

ALTER TABLE [dbo].[BeneficiarioControlador] CHECK CONSTRAINT [FK_BeneficiarioControlador_Empresa]
GO

ALTER TABLE [dbo].[BeneficiarioControlador]  WITH CHECK ADD  CONSTRAINT [FK_BeneficiarioControlador_Persona] FOREIGN KEY([PersonaId])
REFERENCES [dbo].[Persona] ([PersonaId])
GO

ALTER TABLE [dbo].[BeneficiarioControlador] CHECK CONSTRAINT [FK_BeneficiarioControlador_Persona]
GO

ALTER TABLE [dbo].[BeneficiarioControlador]  WITH CHECK ADD  CONSTRAINT [FK_BeneficiarioControlador_TipoEstanciaMigratoria] FOREIGN KEY([TipoEstanciaId])
REFERENCES [dbo].[TipoEstanciaMigratoria] ([TipoEstanciaId])
GO

ALTER TABLE [dbo].[BeneficiarioControlador] CHECK CONSTRAINT [FK_BeneficiarioControlador_TipoEstanciaMigratoria]
GO

