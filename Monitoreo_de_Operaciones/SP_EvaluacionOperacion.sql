-- =============================================
-- Procedimiento: EvaluarOperacionIndividual
-- Descripción: Evalúa una operación individual contra los umbrales de identificación y aviso
-- =============================================
IF OBJECT_ID('dbo.EvaluarOperacionIndividual', 'P') IS NOT NULL
    DROP PROCEDURE dbo.EvaluarOperacionIndividual;
GO

CREATE PROCEDURE dbo.EvaluarOperacionIndividual
    @OperacionId BIGINT,
    @GenerarAlerta BIT = 1,
    -- Parámetros de salida
    @SuperaUmbralIdentificacion BIT OUTPUT,
    @SuperaUmbralAviso BIT OUTPUT,
    @MontoUMAs DECIMAL(18,4) OUTPUT,
    @UmbralIdentificacionUMAs INT OUTPUT,
    @UmbralAvisoUMAs INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @EmpresaId INT;
    DECLARE @ClienteId INT;
    DECLARE @ActividadVulnerableId INT;
    DECLARE @Monto MONEY;
    DECLARE @FechaOperacion DATE;
    DECLARE @MontoMXN MONEY;
    DECLARE @DivisaId INT;
    DECLARE @FactorDivisa DECIMAL(18,6);
    
    -- Inicializar valores
    SET @SuperaUmbralIdentificacion = 0;
    SET @SuperaUmbralAviso = 0;
    SET @MontoUMAs = 0;
    SET @UmbralIdentificacionUMAs = 0;
    SET @UmbralAvisoUMAs = 0;
    
    -- Obtener datos de la operación
    SELECT 
        @EmpresaId = eav.EmpresaId,
        @ClienteId = o.ClienteId,
        @ActividadVulnerableId = eav.ActividadVulnerableId,
        @Monto = o.Monto,
        @FechaOperacion = o.FechaOperacion,
        @DivisaId = o.DivisaId,
        @FactorDivisa = o.FactorDivisa
    FROM dbo.Operacion o
    INNER JOIN dbo.EmpresaActividadVulnerable eav ON o.EmpresaActividadVulnerableId = eav.EmpresaActividadVulnerableId
    WHERE o.Id = @OperacionId
      AND o.EstaActivo = 1;
    
    -- Si no se encontró la operación, salir
    IF @ClienteId IS NULL
    BEGIN
        RAISERROR('Operación no encontrada o inactiva: %d', 16, 1, @OperacionId);
        RETURN;
    END
    
    -- Calcular monto en MXN
    SET @MontoMXN = CASE 
        WHEN @DivisaId = 1 THEN @Monto  -- Asumiendo DivisaId=1 es MXN
        ELSE @Monto * ISNULL(@FactorDivisa, 1)
    END;
    
    -- Convertir a UMAs
    SET @MontoUMAs = dbo.ConvertirMontoAUMAs(@MontoMXN, @FechaOperacion);
    
    -- Obtener umbrales
    SET @UmbralIdentificacionUMAs = dbo.ObtenerUmbralIdentificacion(@ActividadVulnerableId);
    SET @UmbralAvisoUMAs = dbo.ObtenerUmbralAviso(@ActividadVulnerableId);
    
    -- Evaluar umbral de identificación
    IF @UmbralIdentificacionUMAs > 0 AND @MontoUMAs >= @UmbralIdentificacionUMAs
        SET @SuperaUmbralIdentificacion = 1;
    
    -- Evaluar umbral de aviso
    IF @UmbralAvisoUMAs > 0 AND @MontoUMAs >= @UmbralAvisoUMAs
        SET @SuperaUmbralAviso = 1;
    
    -- Generar alertas si está habilitado
    IF @GenerarAlerta = 1
    BEGIN
        -- Alerta por identificación
        IF @SuperaUmbralIdentificacion = 1
        BEGIN
            -- Verificar si ya existe alerta para esta operación
            IF NOT EXISTS (
                SELECT 1 FROM dbo.AlertaMonitoreo 
                WHERE OperacionId = @OperacionId 
                  AND TipoAlertaId = 1 -- IDEN_IND
                  AND EstaActivo = 1
            )
            BEGIN
                INSERT INTO dbo.AlertaMonitoreo (
                    EmpresaId, ClienteId, ActividadVulnerableId, TipoAlertaId,
                    FechaPeriodoInicio, FechaPeriodoFin, MontoEvaluado, MontoEnUMAs,
                    UmbralAplicado, OperacionId, Descripcion
                )
                VALUES (
                    @EmpresaId, @ClienteId, @ActividadVulnerableId, 1, -- IDEN_IND
                    @FechaOperacion, @FechaOperacion, @MontoMXN, @MontoUMAs,
                    @UmbralIdentificacionUMAs, @OperacionId,
                    'Operación individual supera umbral de identificación. Monto: ' + 
                    FORMAT(@MontoMXN, 'C', 'es-MX') + ' (' + CAST(@MontoUMAs AS NVARCHAR(20)) + ' UMAs)'
                );
            END
        END
        
        -- Alerta por aviso
        IF @SuperaUmbralAviso = 1
        BEGIN
            -- Verificar si ya existe alerta para esta operación
            IF NOT EXISTS (
                SELECT 1 FROM dbo.AlertaMonitoreo 
                WHERE OperacionId = @OperacionId 
                  AND TipoAlertaId = 3 -- AVISO_IND
                  AND EstaActivo = 1
            )
            BEGIN
                INSERT INTO dbo.AlertaMonitoreo (
                    EmpresaId, ClienteId, ActividadVulnerableId, TipoAlertaId,
                    FechaPeriodoInicio, FechaPeriodoFin, MontoEvaluado, MontoEnUMAs,
                    UmbralAplicado, OperacionId, Descripcion
                )
                VALUES (
                    @EmpresaId, @ClienteId, @ActividadVulnerableId, 3, -- AVISO_IND
                    @FechaOperacion, @FechaOperacion, @MontoMXN, @MontoUMAs,
                    @UmbralAvisoUMAs, @OperacionId,
                    'Operación individual supera umbral de aviso. Monto: ' + 
                    FORMAT(@MontoMXN, 'C', 'es-MX') + ' (' + CAST(@MontoUMAs AS NVARCHAR(20)) + ' UMAs). Requiere aviso a UIF.'
                );
            END
        END
    END
    
    -- Retornar resultado
    SELECT 
        @OperacionId AS OperacionId,
        @MontoMXN AS MontoMXN,
        @MontoUMAs AS MontoUMAs,
        @UmbralIdentificacionUMAs AS UmbralIdentificacionUMAs,
        @UmbralAvisoUMAs AS UmbralAvisoUMAs,
        @SuperaUmbralIdentificacion AS SuperaUmbralIdentificacion,
        @SuperaUmbralAviso AS SuperaUmbralAviso,
        CASE WHEN @SuperaUmbralIdentificacion = 1 THEN 'Requiere identificación' ELSE 'No requiere identificación' END AS ResultadoIdentificacion,
        CASE WHEN @SuperaUmbralAviso = 1 THEN 'Requiere aviso a UIF' ELSE 'No requiere aviso' END AS ResultadoAviso;
END
GO

-- =============================================
-- Procedimiento: EvaluarOperacionAlInsertar
-- Descripción: Trigger-like procedure para evaluar operación al momento de insertar
-- Se puede llamar desde un trigger o desde la aplicación
-- =============================================
IF OBJECT_ID('dbo.EvaluarOperacionAlInsertar', 'P') IS NOT NULL
    DROP PROCEDURE dbo.EvaluarOperacionAlInsertar;
GO

CREATE PROCEDURE dbo.EvaluarOperacionAlInsertar
    @OperacionId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SuperaUmbralIdentificacion BIT;
    DECLARE @SuperaUmbralAviso BIT;
    DECLARE @MontoUMAs DECIMAL(18,4);
    DECLARE @UmbralIdentificacionUMAs INT;
    DECLARE @UmbralAvisoUMAs INT;
    DECLARE @EmpresaId INT;
    DECLARE @ClienteId INT;
    DECLARE @ActividadVulnerableId INT;
    DECLARE @FechaOperacion DATE;
    DECLARE @Mes INT;
    DECLARE @Anio INT;
    
    -- Evaluar operación individual
    EXEC dbo.EvaluarOperacionIndividual 
        @OperacionId = @OperacionId,
        @GenerarAlerta = 1,
        @SuperaUmbralIdentificacion = @SuperaUmbralIdentificacion OUTPUT,
        @SuperaUmbralAviso = @SuperaUmbralAviso OUTPUT,
        @MontoUMAs = @MontoUMAs OUTPUT,
        @UmbralIdentificacionUMAs = @UmbralIdentificacionUMAs OUTPUT,
        @UmbralAvisoUMAs = @UmbralAvisoUMAs OUTPUT;
    
    -- Obtener datos para actualizar acumulado
    SELECT 
        @EmpresaId = eav.EmpresaId,
        @ClienteId = o.ClienteId,
        @ActividadVulnerableId = eav.ActividadVulnerableId,
        @FechaOperacion = o.FechaOperacion
    FROM dbo.Operacion o
    INNER JOIN dbo.EmpresaActividadVulnerable eav ON o.EmpresaActividadVulnerableId = eav.EmpresaActividadVulnerableId
    WHERE o.Id = @OperacionId;
    
    IF @ClienteId IS NOT NULL
    BEGIN
        SET @Mes = MONTH(@FechaOperacion);
        SET @Anio = YEAR(@FechaOperacion);
        
        -- Actualizar acumulado mensual
        EXEC dbo.ActualizarAcumuladoMensual 
            @EmpresaId = @EmpresaId,
            @ClienteId = @ClienteId,
            @ActividadVulnerableId = @ActividadVulnerableId,
            @Mes = @Mes,
            @Anio = @Anio;
    END
END
GO

PRINT 'Procedimientos de evaluación individual creados exitosamente.';
GO
