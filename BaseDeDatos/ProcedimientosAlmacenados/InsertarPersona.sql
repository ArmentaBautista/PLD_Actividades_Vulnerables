SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[InsertarPersona]
    @EmpresaId INT,
    @EsPersonaFisica BIT = 1,
    @Nombre NVARCHAR(150),
    @Paterno NVARCHAR(150) = NULL,
    @Materno NVARCHAR(150) = NULL,
    @FechaNacimientoConstitucion DATE,
    @RFC NVARCHAR(13) = NULL,
    @CURP NVARCHAR(18) = NULL,
    @UsuarioAltaId INT,
    @PersonaId INT OUTPUT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;
    SET @PersonaId = NULL;

    BEGIN TRY
        INSERT INTO [dbo].[Persona] (
            EmpresaId,
            EsPersonaFisica,
            Nombre,
            Paterno,
            Materno,
            FechaNacimientoConstitucion,
            RFC,
            CURP,
            UsuarioAltaId
        )
        VALUES (
            @EmpresaId,
            @EsPersonaFisica,
            @Nombre,
            @Paterno,
            @Materno,
            @FechaNacimientoConstitucion,
            @RFC,
            @CURP,
            @UsuarioAltaId
        );

        SET @PersonaId = SCOPE_IDENTITY();
        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
