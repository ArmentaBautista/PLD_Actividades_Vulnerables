SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[InsertarBeneficiarioControlador]
    @EmpresaId INT,
    @PersonaId INT,
    @ClienteId INT = NULL,
    @IdTipoControl INT,
    @PorcentajeCapital DECIMAL(5,2),
    @PorcentajeCapitalIndirecto DECIMAL(5,2) = NULL,
    @PorcentajeVoto DECIMAL(5,2) = NULL,
    @EsControlEfectivo BIT = 0,
    @DescripcionMecanismo VARCHAR(MAX) = NULL,
    @FechaValidacionDocumentos DATE,
    @EsExtranjero BIT = 0,
    @TipoEstanciaId INT = NULL,
    @FechaInicioEstancia DATE = NULL,
    @ActuaMedianteRepresentante BIT = 0,
    @RepresentanteNombre VARCHAR(200) = NULL,
    @EsPep BIT = 0,
    @CargoPep VARCHAR(255) = NULL,
    @FechaInclusionPep DATE = NULL,
    @OrdenCadenaControl INT = NULL,
    @Observaciones VARCHAR(MAX) = NULL,
    @FechaVerificacionDatos DATE,
    @MetodoVerificacion VARCHAR(100) = NULL,
    @VerificadoPor INT = NULL,
    @UsuarioAltaId INT,
    @BeneficiarioControladorId INT OUTPUT,
    @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @RETURN_MESSAGE = NULL;
    SET @BeneficiarioControladorId = NULL;

    BEGIN TRY
        INSERT INTO [dbo].[BeneficiarioControlador] (
            EmpresaId,
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
            UsuarioAltaId
        )
        VALUES (
            @EmpresaId,
            @PersonaId,
            @ClienteId,
            @IdTipoControl,
            @PorcentajeCapital,
            @PorcentajeCapitalIndirecto,
            @PorcentajeVoto,
            @EsControlEfectivo,
            @DescripcionMecanismo,
            @FechaValidacionDocumentos,
            @EsExtranjero,
            @TipoEstanciaId,
            @FechaInicioEstancia,
            @ActuaMedianteRepresentante,
            @RepresentanteNombre,
            @EsPep,
            @CargoPep,
            @FechaInclusionPep,
            @OrdenCadenaControl,
            @Observaciones,
            @FechaVerificacionDatos,
            @MetodoVerificacion,
            @VerificadoPor,
            @UsuarioAltaId
        );

        SET @BeneficiarioControladorId = SCOPE_IDENTITY();
        RETURN 0;
    END TRY
    BEGIN CATCH
        SET @RETURN_MESSAGE = ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END
GO
