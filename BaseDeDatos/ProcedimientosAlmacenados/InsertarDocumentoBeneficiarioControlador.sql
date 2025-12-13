SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[InsertarDocumentoBeneficiarioControlador]
    @EmpresaId INT,
    @BeneficiarioControladorId INT,
    @TipoDocumentoId INT,
    @Numero NVARCHAR(100) = NULL,
    @Archivo VARBINARY(MAX),
    @FileHash NVARCHAR(128) = NULL,
    @IdUsuarioVerifico INT = NULL,
    @UsuarioAltaId INT,
    @DocumentoId INT OUTPUT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;
    SET @DocumentoId = NULL;

    BEGIN TRY
        INSERT INTO [dbo].[DocumentoBeneficiarioControlador] (
            EmpresaId,
            BeneficiarioControladorId,
            TipoDocumentoId,
            Numero,
            Archivo,
            FileHash,
            IdUsuarioVerifico,
            UsuarioAltaId
        )
        VALUES (
            @EmpresaId,
            @BeneficiarioControladorId,
            @TipoDocumentoId,
            @Numero,
            @Archivo,
            @FileHash,
            @IdUsuarioVerifico,
            @UsuarioAltaId
        );

        SET @DocumentoId = SCOPE_IDENTITY();
        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
