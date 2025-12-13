SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ActualizarDocumentoKYC]
    @DocumentoId INT,
    @IdEmpresa INT,
    @ClienteId INT,
    @TipoDocumentoId INT,
    @Numero NVARCHAR(100) = NULL,
    @Archivo VARBINARY(MAX),
    @FileHash NVARCHAR(128) = NULL,
    @IdUsuarioVerifico INT = NULL,
    @UsuarioModificacionId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        UPDATE [dbo].[DocumentoKYC]
        SET IdEmpresa = @IdEmpresa,
            ClienteId = @ClienteId,
            TipoDocumentoId = @TipoDocumentoId,
            Numero = @Numero,
            Archivo = @Archivo,
            FileHash = @FileHash,
            IdUsuarioVerifico = @IdUsuarioVerifico,
            FechaModificacion = GETDATE(),
            UsuarioModificacionId = @UsuarioModificacionId
        WHERE DocumentoId = @DocumentoId
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
