SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerDocumentoKYC]
    @DocumentoId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        SELECT
            DocumentoId,
            IdEmpresa,
            ClienteId,
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
        FROM [dbo].[DocumentoKYC]
        WHERE DocumentoId = @DocumentoId;

        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
