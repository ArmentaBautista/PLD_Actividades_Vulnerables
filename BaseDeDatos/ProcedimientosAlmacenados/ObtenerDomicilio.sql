SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerDomicilio]
    @DomicilioId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        SELECT
            DomicilioId,
            EmpresaId,
            Calle,
            EntreCalles,
            NumeroExterior,
            NumeroInterior,
            AsentamientoId,
            Referencias,
            FechaAlta,
            UsuarioAltaId,
            FechaModificacion,
            UsuarioModificacionId,
            FechaBaja,
            UsuarioBajaId,
            EstaActivo
        FROM [dbo].[Domicilio]
        WHERE DomicilioId = @DomicilioId;

        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
