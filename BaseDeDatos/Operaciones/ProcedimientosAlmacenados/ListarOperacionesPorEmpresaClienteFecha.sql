SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[ListarOperacionesPorEmpresaClienteFecha]
    @EmpresaActividadVulnerableId INT,
    @ClienteId INT = NULL,
    @FechaInicio DATE,
    @FechaFin DATE,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        SELECT
            Id,
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
            FechaAlta,
            HoraAlta,
            UsuarioAltaId,
            EstaActivo
        FROM [dbo].[Operacion]
        WHERE EmpresaId = @EmpresaId
          AND (@ClienteId IS NULL OR ClienteId = @ClienteId)
          AND FechaOperacion BETWEEN @FechaInicio AND @FechaFin
          AND EstaActivo = 1
        ORDER BY FechaOperacion DESC, HoraOperacion DESC;

        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
