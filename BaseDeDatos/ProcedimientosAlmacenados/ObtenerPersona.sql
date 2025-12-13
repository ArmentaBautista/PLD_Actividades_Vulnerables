SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerPersona]
    @PersonaId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        SELECT
            PersonaId,
            EmpresaId,
            EsPersonaFisica,
            Nombre,
            Paterno,
            Materno,
            FechaNacimientoConstitucion,
            RFC,
            CURP,
            FechaAlta,
            HoraAlta,
            UsuarioAltaId,
            FechaModificacion,
            UsuarioModificacionId,
            FechaBaja,
            HoraBaja,
            UsuarioBajaId,
            EstaActivo
        FROM [dbo].[Persona]
        WHERE PersonaId = @PersonaId;

        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
