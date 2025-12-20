CREATE PROCEDURE [dbo].[CerrarSesion]
    @SesionId BIGINT,
    @Fin DATETIME2,
    @RETURN_MESSAGE NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Verificar que la sesión existe
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Sesion] WHERE [SesionId] = @SesionId)
        BEGIN
            SET @RETURN_MESSAGE = 'La sesión especificada no existe.';
            RETURN -1;
        END

        -- Verificar que la sesión está activa
        IF NOT EXISTS (SELECT 1 FROM [dbo].[SesionActiva] WHERE [SesionId] = @SesionId)
        BEGIN
            SET @RETURN_MESSAGE = 'La sesión especificada no está activa.';
            RETURN -1;
        END

        BEGIN TRANSACTION;

        -- Actualizar el campo Fin en la tabla Sesion
        UPDATE [dbo].[Sesion]
        SET [Fin] = @Fin
        WHERE [SesionId] = @SesionId;

        -- Eliminar el registro de SesionActiva
        DELETE FROM [dbo].[SesionActiva]
        WHERE [SesionId] = @SesionId;

        COMMIT TRANSACTION;

        SET @RETURN_MESSAGE = 'Sesión cerrada correctamente.';
        RETURN 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @RETURN_MESSAGE = 'Error al cerrar la sesión: ' + ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
