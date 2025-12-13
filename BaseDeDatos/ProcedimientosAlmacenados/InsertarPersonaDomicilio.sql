SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertarPersonaDomicilio]
    @EmpresaId INT,
    @PersonaId INT,
    @DomicilioId INT,
    @TipoDomicilioId INT,
    @UsuarioAltaId INT,
    @PersonaDomicilioId INT OUTPUT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;
    SET @PersonaDomicilioId = NULL;

    BEGIN TRY
        INSERT INTO [dbo].[PersonaDomicilio] (
            EmpresaId,
            PersonaId,
            DomicilioId,
            TipoDomicilioId,
            UsuarioAltaId
        )
        VALUES (
            @EmpresaId,
            @PersonaId,
            @DomicilioId,
            @TipoDomicilioId,
            @UsuarioAltaId
        );

        SET @PersonaDomicilioId = SCOPE_IDENTITY();
        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
