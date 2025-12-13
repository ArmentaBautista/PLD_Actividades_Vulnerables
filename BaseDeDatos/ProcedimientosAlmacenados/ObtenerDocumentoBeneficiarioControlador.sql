SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[ObtenerDocumentoBeneficiarioControlador]
    @DocumentoId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        SELECT
            DocumentoId,
            EmpresaId,
            BeneficiarioControladorId,
            TipoDocumentoId,
            Numero,
            Archivo,
            FileHash,
            IdUsuarioVerifico,
            Fecha,
            Hora,
            UsuarioAltaId,
            FechaModificacion,
            UsuarioModificacionId,
            FechaBaja,
            UsuarioBajaId,
            EstaActivo
        FROM [dbo].[DocumentoBeneficiarioControlador]
        WHERE DocumentoId = @DocumentoId;

        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
