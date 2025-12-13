SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerPersonaDomicilio]
    @PersonaDomicilioId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        SELECT
            PersonaDomicilioId,
            EmpresaId,
            PersonaId,
            DomicilioId,
            TipoDomicilioId,
            FechaAlta,
            HoraAlta,
            UsuarioAltaId,
            FechaModificacion,
            UsuarioModificacionId,
            FechaBaja,
            HoraBaja,
            UsuarioBajaId,
            EstaActivo
        FROM [dbo].[PersonaDomicilio]
        WHERE PersonaDomicilioId = @PersonaDomicilioId;

        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
