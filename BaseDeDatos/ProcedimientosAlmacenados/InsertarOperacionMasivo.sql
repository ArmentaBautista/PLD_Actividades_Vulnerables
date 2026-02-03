SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[InsertarOperacionMasivo]
    @Operaciones [dbo].[typeOperacion] READONLY,
    @UsuarioAltaId INT,
    @RegistrosInsertados INT OUTPUT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;
    SET @RegistrosInsertados = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [dbo].[Operacion] (
            EmpresaId,
            ClienteId,
            TipoOperacionId,
            TipoSubOperacionId,
            OperacionPadreId,
            ProductoServicioId,
            DivisaId,
            Monto,
            FechaOperacion,
            HoraOperacion,
            FolioExterno,
            ActividadFraccion,
            UsuarioExterno,
            UsuarioAltaId
        )
        SELECT
            EmpresaId,
            ClienteId,
            TipoOperacionId,
            TipoSubOperacionId,
            OperacionPadreId,
            ProductoServicioId,
            DivisaId,
            Monto,
            FechaOperacion,
            HoraOperacion,
            FolioExterno,
            ActividadFraccion,
            UsuarioExterno,
            @UsuarioAltaId
        FROM @Operaciones;

        SET @RegistrosInsertados = @@ROWCOUNT;

        IF @RegistrosInsertados = 0
        BEGIN
            SET @RETURN_MESSAGE = 'No se insertaron registros, la tabla de operaciones está vacía';
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        COMMIT TRANSACTION;
        RETURN 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
