SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[ActualizarDomicilio]
    @DomicilioId INT,
    @EmpresaId INT,
    @Calle NVARCHAR(255),
    @EntreCalles NVARCHAR(255),
    @NumeroExterior NVARCHAR(20),
    @NumeroInterior NVARCHAR(20) = NULL,
    @AsentamientoId INT,
    @Referencias NVARCHAR(MAX) = NULL,
    @UsuarioModificacionId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        UPDATE [dbo].[Domicilio]
        SET EmpresaId = @EmpresaId,
            Calle = @Calle,
            EntreCalles = @EntreCalles,
            NumeroExterior = @NumeroExterior,
            NumeroInterior = @NumeroInterior,
            AsentamientoId = @AsentamientoId,
            Referencias = @Referencias,
            FechaModificacion = GETDATE(),
            UsuarioModificacionId = @UsuarioModificacionId
        WHERE DomicilioId = @DomicilioId
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
