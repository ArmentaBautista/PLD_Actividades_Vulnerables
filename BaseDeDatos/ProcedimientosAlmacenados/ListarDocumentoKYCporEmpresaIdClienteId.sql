SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[ListarDocumentoKYCporEmpresaIdClienteId]
    @EmpresaId INT,
    @ClienteId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        SELECT
            DocumentoId,
            EmpresaId,
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
        WHERE EmpresaId = @EmpresaId AND ClienteId = @ClienteId;


        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
