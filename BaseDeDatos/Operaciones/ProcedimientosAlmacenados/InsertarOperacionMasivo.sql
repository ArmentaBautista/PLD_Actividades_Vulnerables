SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Tipo de dato para inserción masiva de operaciones
-- =============================================
IF TYPE_ID(N'dbo.typeOperacion') IS NOT NULL
    DROP PROC [dbo].[InsertarOperacionMasivo]
    DROP TYPE [dbo].[typeOperacion];
GO

CREATE TYPE [dbo].[typeOperacion] AS TABLE
(
    [EmpresaActividadVulnerableId] [int] NOT NULL,
    [ClienteId] [int] NULL,
    [TipoOperacionId] [int] NOT NULL,
    [TipoSubOperacionId] [int] NOT NULL,
    [FolioOperacion] [nvarchar](32) NULL,
    [FolioOperacionPadre] [nvarchar](32) NULL,
    [ProductoServicioId] [int] NOT NULL,
    [DivisaId] [int] NOT NULL,
    [Monto] [money] NOT NULL,
    [FechaOperacion] [date] NOT NULL,
    [HoraOperacion] [time](7) NOT NULL,
    [ActividadFraccion] [nvarchar](8) NOT NULL,
    [UsuarioOperacion] [nvarchar](100) NULL
);
GO


CREATE OR ALTER PROCEDURE [dbo].[InsertarOperacionMasivo]
    @Operaciones [dbo].[typeOperacion] READONLY,
    @UsuarioAltaId INT,
    @RegistrosInsertados INT OUTPUT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;
    SET @RegistrosInsertados = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [dbo].[Operacion] (
            EmpresaActividadVulnerableId,
            ClienteId,
            TipoOperacionId,
            TipoSubOperacionId,
            FolioOperacion,
            FolioOperacionPadre,
            ProductoServicioId,
            DivisaId,
            Monto,
            FechaOperacion,
            HoraOperacion,
            ActividadFraccion,
            UsuarioOperacion,
            UsuarioAltaId
        )
        SELECT
            EmpresaActividadVulnerableId,
            ClienteId,
            TipoOperacionId,
            TipoSubOperacionId,
            FolioOperacion,
            FolioOperacionPadre,
            ProductoServicioId,
            DivisaId,
            Monto,
            FechaOperacion,
            HoraOperacion,
            ActividadFraccion,
            UsuarioOperacion,
            @UsuarioAltaId
        FROM @Operaciones;

        SET @RegistrosInsertados = @@ROWCOUNT;

        IF @RegistrosInsertados = 0
        BEGIN
            SET @RETURN_MESSAGE = 'No se insertaron registros, la tabla de operaciones está vacía';
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        COMMIT TRANSACTION;
        RETURN 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
