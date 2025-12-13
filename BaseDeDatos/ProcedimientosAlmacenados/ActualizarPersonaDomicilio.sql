SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[ActualizarPersonaDomicilio]
    @PersonaDomicilioId INT,
    @EmpresaId INT,
    @PersonaId INT,
    @DomicilioId INT,
    @TipoDomicilioId INT,
    @UsuarioModificacionId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        UPDATE [dbo].[PersonaDomicilio]
        SET EmpresaId = @EmpresaId,
            PersonaId = @PersonaId,
            DomicilioId = @DomicilioId,
            TipoDomicilioId = @TipoDomicilioId,
            FechaModificacion = GETDATE(),
            UsuarioModificacionId = @UsuarioModificacionId
        WHERE PersonaDomicilioId = @PersonaDomicilioId
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
