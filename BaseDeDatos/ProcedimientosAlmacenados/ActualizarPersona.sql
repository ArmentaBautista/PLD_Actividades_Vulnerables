SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[ActualizarPersona]
    @PersonaId INT,
    @EmpresaId INT,
    @EsPersonaFisica BIT,
    @Nombre NVARCHAR(150),
    @Paterno NVARCHAR(150) = NULL,
    @Materno NVARCHAR(150) = NULL,
    @FechaNacimientoConstitucion DATE,
    @RFC NVARCHAR(13) = NULL,
    @CURP NVARCHAR(18) = NULL,
    @UsuarioModificacionId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        UPDATE [dbo].[Persona]
        SET EmpresaId = @EmpresaId,
            EsPersonaFisica = @EsPersonaFisica,
            Nombre = @Nombre,
            Paterno = @Paterno,
            Materno = @Materno,
            FechaNacimientoConstitucion = @FechaNacimientoConstitucion,
            RFC = @RFC,
            CURP = @CURP,
            FechaModificacion = GETDATE(),
            UsuarioModificacionId = @UsuarioModificacionId
        WHERE PersonaId = @PersonaId
          AND EstaActivo = 1;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @RETURN_MESSAGE = 'No fue posible realizar la operación, no hubo cambios';
            RETURN -1;
        END

        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
