SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[EliminarPersonaDomicilio]
    @PersonaDomicilioId INT,
    @UsuarioBajaId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        UPDATE [dbo].[PersonaDomicilio]
        SET EstaActivo = 0,
            FechaBaja = GETDATE(),
            HoraBaja = CONVERT(TIME, GETDATE()),
            UsuarioBajaId = @UsuarioBajaId
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
