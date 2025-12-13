SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[InsertarDomicilio]
    @EmpresaId INT,
    @Calle NVARCHAR(255),
    @EntreCalles NVARCHAR(255),
    @NumeroExterior NVARCHAR(20),
    @NumeroInterior NVARCHAR(20) = NULL,
    @AsentamientoId INT,
    @Referencias NVARCHAR(MAX) = NULL,
    @UsuarioAltaId INT,
    @DomicilioId INT OUTPUT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;
    SET @DomicilioId = NULL;

    BEGIN TRY
        INSERT INTO [dbo].[Domicilio] (
            EmpresaId,
            Calle,
            EntreCalles,
            NumeroExterior,
            NumeroInterior,
            AsentamientoId,
            Referencias,
            UsuarioAltaId
        )
        VALUES (
            @EmpresaId,
            @Calle,
            @EntreCalles,
            @NumeroExterior,
            @NumeroInterior,
            @AsentamientoId,
            @Referencias,
            @UsuarioAltaId
        );

        SET @DomicilioId = SCOPE_IDENTITY();
        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
