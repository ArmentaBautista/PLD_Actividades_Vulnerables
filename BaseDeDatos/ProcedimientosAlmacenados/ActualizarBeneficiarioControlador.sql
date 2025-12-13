SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ActualizarBeneficiarioControlador]
    @BeneficiarioControladorId INT,
    @IdEmpresa INT,
    @PersonaId INT,
    @ClienteId INT = NULL,
    @IdTipoControl INT,
    @PorcentajeCapital DECIMAL(5,2),
    @PorcentajeCapitalIndirecto DECIMAL(5,2) = NULL,
    @PorcentajeVoto DECIMAL(5,2) = NULL,
    @EsControlEfectivo BIT,
    @DescripcionMecanismo VARCHAR(MAX) = NULL,
    @FechaValidacionDocumentos DATE,
    @EsExtranjero BIT,
    @TipoEstanciaId INT = NULL,
    @FechaInicioEstancia DATE = NULL,
    @ActuaMedianteRepresentante BIT,
    @RepresentanteNombre VARCHAR(200) = NULL,
    @EsPep BIT,
    @CargoPep VARCHAR(255) = NULL,
    @FechaInclusionPep DATE = NULL,
    @OrdenCadenaControl INT = NULL,
    @Observaciones VARCHAR(MAX) = NULL,
    @FechaVerificacionDatos DATE,
    @MetodoVerificacion VARCHAR(100) = NULL,
    @VerificadoPor INT = NULL,
    @UsuarioModificacionId INT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;

    BEGIN TRY
        UPDATE [dbo].[BeneficiarioControlador]
        SET IdEmpresa = @IdEmpresa,
            PersonaId = @PersonaId,
            ClienteId = @ClienteId,
            IdTipoControl = @IdTipoControl,
            PorcentajeCapital = @PorcentajeCapital,
            PorcentajeCapitalIndirecto = @PorcentajeCapitalIndirecto,
            PorcentajeVoto = @PorcentajeVoto,
            EsControlEfectivo = @EsControlEfectivo,
            DescripcionMecanismo = @DescripcionMecanismo,
            FechaValidacionDocumentos = @FechaValidacionDocumentos,
            EsExtranjero = @EsExtranjero,
            TipoEstanciaId = @TipoEstanciaId,
            FechaInicioEstancia = @FechaInicioEstancia,
            ActuaMedianteRepresentante = @ActuaMedianteRepresentante,
            RepresentanteNombre = @RepresentanteNombre,
            EsPep = @EsPep,
            CargoPep = @CargoPep,
            FechaInclusionPep = @FechaInclusionPep,
            OrdenCadenaControl = @OrdenCadenaControl,
            Observaciones = @Observaciones,
            FechaVerificacionDatos = @FechaVerificacionDatos,
            MetodoVerificacion = @MetodoVerificacion,
            VerificadoPor = @VerificadoPor,
            FechaModificacion = GETDATE(),
            UsuarioModificacionId = @UsuarioModificacionId
        WHERE BeneficiarioControladorId = @BeneficiarioControladorId
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
