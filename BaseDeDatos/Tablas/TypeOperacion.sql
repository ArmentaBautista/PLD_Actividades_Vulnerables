SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Tipo de dato para inserción masiva de operaciones
-- =============================================
IF TYPE_ID(N'dbo.typeOperacion') IS NOT NULL
    DROP TYPE [dbo].[typeOperacion];
GO

CREATE TYPE [dbo].[typeOperacion] AS TABLE
(
    [EmpresaId] [int] NOT NULL,
    [ClienteId] [int] NULL,
    [TipoOperacionId] [int] NOT NULL,
    [TipoSubOperacionId] [int] NOT NULL,
    [OperacionPadreId] [bigint] NULL,
    [ProductoServicioId] [int] NOT NULL,
    [DivisaId] [int] NOT NULL,
    [Monto] [money] NOT NULL,
    [FechaOperacion] [date] NOT NULL,
    [HoraOperacion] [time](7) NOT NULL,
    [FolioExterno] [nvarchar](32) NULL,
    [ActividadFraccion] [nvarchar](8) NOT NULL,
    [UsuarioExterno] [nvarchar](100) NULL
);
GO
