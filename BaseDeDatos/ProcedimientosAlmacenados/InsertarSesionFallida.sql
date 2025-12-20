CREATE PROCEDURE [dbo].[InsertarSesionFallida]
    @Correo NVARCHAR(255) = NULL,
    @Contrasena NVARCHAR(255) = NULL,
    @MotivoId INT,
    @Fecha DATE,
    @Hora TIME(7),
    @IP NVARCHAR(45) = NULL,
    @Dispositivo NVARCHAR(200) = NULL,
    @RETURN_MESSAGE NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO [dbo].[SesionFallida] (
            [Correo],
            [Contrasena],
            [MotivoId],
            [Fecha],
            [Hora],
            [IP],
            [Dispositivo]
        )
        VALUES (
            @Correo,
            @Contrasena,
            @MotivoId,
            @Fecha,
            @Hora,
            @IP,
            @Dispositivo
        );

        SET @RETURN_MESSAGE = 'Sesión fallida registrada correctamente.';
        RETURN 0
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = 'Error al registrar la sesión fallida: ' + ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
