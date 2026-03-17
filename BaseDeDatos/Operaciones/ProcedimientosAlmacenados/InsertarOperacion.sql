SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[InsertarOperacion]
    @EmpresaActividadVulnerableId INT,
    @ClienteId INT = NULL,
    @TipoOperacionId INT,
    @TipoSubOperacionId INT,
    @FolioOperacion NVARCHAR(32) = NULL,
    @FolioOperacionPadre NVARCHAR(32) = NULL,
    @ProductoServicioId INT,
    @DivisaId INT,
    @Monto MONEY,
    @FechaOperacion DATE,
    @HoraOperacion TIME(7),
    @ActividadFraccion NVARCHAR(8),
    @UsuarioOperacion NVARCHAR(100) = NULL,
    @UsuarioAltaId INT,
    @OperacionId BIGINT OUTPUT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;
    SET @OperacionId = NULL;

    BEGIN TRY
        INSERT INTO [dbo].[Operacion] (
            EmpresaActividadVulnerableId,
            ClienteId,
            TipoOperacionId,
            TipoSubOperacionId,
            FolioOperacion,
            FolioOperacionPadre,
            ProductoServicioId,
            DivisaId,
            Monto,
            FechaOperacion,
            HoraOperacion,
            ActividadFraccion,
            UsuarioOperacion,
            UsuarioAltaId
        )
        VALUES (
            @EmpresaActividadVulnerableId,
            @ClienteId,
            @TipoOperacionId,
            @TipoSubOperacionId,
            @FolioOperacion,
            @FolioOperacionPadre,
            @ProductoServicioId,
            @DivisaId,
            @Monto,
            @FechaOperacion,
            @HoraOperacion,
            @ActividadFraccion,
            @UsuarioOperacion,
            @UsuarioAltaId
        );

        SET @OperacionId = SCOPE_IDENTITY();

        IF @OperacionId IS NULL
        BEGIN
            SET @RETURN_MESSAGE = 'No fue posible insertar la operación';
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
