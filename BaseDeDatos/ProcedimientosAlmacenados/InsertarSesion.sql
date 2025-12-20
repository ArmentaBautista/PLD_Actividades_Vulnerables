CREATE PROCEDURE [dbo].[InsertarSesion]
    @SesionId BIGINT,
    @UsuarioId INT,
    @Fecha DATE,
    @Inicio DATETIME2,
    @IP NVARCHAR(45) = NULL,
    @Dispositivo NVARCHAR(200) = NULL,
    @TokenSesion NVARCHAR(512) = NULL,
    @RETURN_MESSAGE NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar en la tabla Sesion
        INSERT INTO [dbo].[Sesion] (
            [SesionId],
            [UsuarioId],
            [Fecha],
            [Inicio],
            [Fin],
            [IP],
            [Dispositivo],
            [TokenSesion]
        )
        VALUES (
            @SesionId,
            @UsuarioId,
            @Fecha,
            @Inicio,
            NULL,
            @IP,
            @Dispositivo,
            @TokenSesion
        );

        -- Insertar en la tabla SesionActiva
        INSERT INTO [dbo].[SesionActiva] (
            [SesionId]
        )
        VALUES (
            @SesionId
        );

        COMMIT TRANSACTION;

        SET @RETURN_MESSAGE = 'Sesión insertada correctamente.';
        RETURN 0
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @RETURN_MESSAGE = 'Error al insertar la sesión: ' + ERROR_MESSAGE();
        RETURN -1
    END CATCH
END
GO
