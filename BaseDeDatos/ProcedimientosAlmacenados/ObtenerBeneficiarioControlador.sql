SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerBeneficiarioControlador]
    @BeneficiarioControladorId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        SELECT
            BeneficiarioControladorId,
            IdEmpresa,
            PersonaId,
            ClienteId,
            IdTipoControl,
            PorcentajeCapital,
            PorcentajeCapitalIndirecto,
            PorcentajeVoto,
            EsControlEfectivo,
            DescripcionMecanismo,
            FechaValidacionDocumentos,
            EsExtranjero,
            TipoEstanciaId,
            FechaInicioEstancia,
            ActuaMedianteRepresentante,
            RepresentanteNombre,
            EsPep,
            CargoPep,
            FechaInclusionPep,
            OrdenCadenaControl,
            Observaciones,
            FechaVerificacionDatos,
            MetodoVerificacion,
            VerificadoPor,
            FechaAlta,
            UsuarioAltaId,
            FechaModificacion,
            UsuarioModificacionId,
            FechaBaja,
            UsuarioBajaId,
            EstaActivo
        FROM [dbo].[BeneficiarioControlador]
        WHERE BeneficiarioControladorId = @BeneficiarioControladorId;

        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
