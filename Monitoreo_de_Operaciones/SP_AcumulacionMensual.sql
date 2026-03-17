-- =============================================
-- Procedimientos de Acumulación Mensual
-- =============================================

-- =============================================
-- Procedimiento: ActualizarAcumuladoMensual
-- Descripción: Actualiza o crea el registro de acumulado mensual para un cliente
-- =============================================
IF OBJECT_ID('dbo.ActualizarAcumuladoMensual', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ActualizarAcumuladoMensual;
GO

CREATE PROCEDURE dbo.ActualizarAcumuladoMensual
    @EmpresaId INT,
    @ClienteId INT,
    @ActividadVulnerableId INT,
    @Mes INT,
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @MontoAcumulado MONEY;
    DECLARE @MontoAcumuladoUMAs DECIMAL(18,4);
    DECLARE @NumeroOperaciones INT;
    DECLARE @UmbralIdentificacionUMAs INT;
    DECLARE @UmbralAvisoUMAs INT;
    DECLARE @SuperaUmbralIdentificacion BIT = 0;
    DECLARE @SuperaUmbralAviso BIT = 0;
    DECLARE @FechaReferencia DATE;
    DECLARE @FechaInicioMes DATE;
    DECLARE @FechaFinMes DATE;
    
    -- Calcular fechas del período
    SET @FechaReferencia = DATEFROMPARTS(@Anio, @Mes, 1);
    SET @FechaInicioMes = dbo.ObtenerInicioMes(@FechaReferencia);
    SET @FechaFinMes = dbo.ObtenerFinMes(@FechaReferencia);
    
    -- Calcular acumulado del mes
    SELECT 
        @MontoAcumulado = ISNULL(SUM(
            CASE 
                WHEN o.DivisaId = 1 THEN o.Monto
                ELSE o.Monto * ISNULL(o.FactorDivisa, 1)
            END
        ), 0),
        @NumeroOperaciones = COUNT(*)
    FROM dbo.Operacion o
    INNER JOIN dbo.EmpresaActividadVulnerable eav ON o.EmpresaActividadVulnerableId = eav.EmpresaActividadVulnerableId
    WHERE eav.EmpresaId = @EmpresaId
      AND o.ClienteId = @ClienteId
      AND eav.ActividadVulnerableId = @ActividadVulnerableId
      AND o.FechaOperacion >= @FechaInicioMes
      AND o.FechaOperacion <= @FechaFinMes
      AND o.EstaActivo = 1;
    
    -- Convertir a UMAs (usar fecha fin de mes para el cálculo)
    SET @MontoAcumuladoUMAs = dbo.ConvertirMontoAUMAs(@MontoAcumulado, @FechaFinMes);
    
    -- Obtener umbrales
    SET @UmbralIdentificacionUMAs = dbo.ObtenerUmbralIdentificacion(@ActividadVulnerableId);
    SET @UmbralAvisoUMAs = dbo.ObtenerUmbralAviso(@ActividadVulnerableId);
    
    -- Evaluar si supera umbrales
    IF @UmbralIdentificacionUMAs > 0 AND @MontoAcumuladoUMAs >= @UmbralIdentificacionUMAs
        SET @SuperaUmbralIdentificacion = 1;
    
    IF @UmbralAvisoUMAs > 0 AND @MontoAcumuladoUMAs >= @UmbralAvisoUMAs
        SET @SuperaUmbralAviso = 1;
    
    -- Insertar o actualizar registro de acumulado
    MERGE dbo.AcumuladoMensualCliente AS target
    USING (
        SELECT 
            @EmpresaId AS EmpresaId,
            @ClienteId AS ClienteId,
            @ActividadVulnerableId AS ActividadVulnerableId,
            @Mes AS PeriodoMes,
            @Anio AS PeriodoAnio
    ) AS source
    ON (
        target.EmpresaId = source.EmpresaId
        AND target.ClienteId = source.ClienteId
        AND target.ActividadVulnerableId = source.ActividadVulnerableId
        AND target.PeriodoMes = source.PeriodoMes
        AND target.PeriodoAnio = source.PeriodoAnio
    )
    WHEN MATCHED THEN
        UPDATE SET
            MontoAcumulado = @MontoAcumulado,
            MontoAcumuladoUMAs = @MontoAcumuladoUMAs,
            NumeroOperaciones = @NumeroOperaciones,
            SuperaUmbralIdentificacion = @SuperaUmbralIdentificacion,
            SuperaUmbralAviso = @SuperaUmbralAviso,
            RequiereAviso = @SuperaUmbralAviso,
            FechaUltimaActualizacion = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (
            EmpresaId, ClienteId, ActividadVulnerableId, PeriodoMes, PeriodoAnio,
            MontoAcumulado, MontoAcumuladoUMAs, NumeroOperaciones,
            SuperaUmbralIdentificacion, SuperaUmbralAviso, RequiereAviso
        )
        VALUES (
            @EmpresaId, @ClienteId, @ActividadVulnerableId, @Mes, @Anio,
            @MontoAcumulado, @MontoAcumuladoUMAs, @NumeroOperaciones,
            @SuperaUmbralIdentificacion, @SuperaUmbralAviso, @SuperaUmbralAviso
        );
    
    -- Generar alertas por acumulado si corresponde
    -- Alerta por identificación acumulada
    IF @SuperaUmbralIdentificacion = 1
    BEGIN
        IF NOT EXISTS (
            SELECT 1 FROM dbo.AlertaMonitoreo 
            WHERE EmpresaId = @EmpresaId
              AND ClienteId = @ClienteId
              AND ActividadVulnerableId = @ActividadVulnerableId
              AND TipoAlertaId = 2 -- IDEN_ACU
              AND FechaPeriodoInicio = @FechaInicioMes
              AND FechaPeriodoFin = @FechaFinMes
              AND EstaActivo = 1
        )
        BEGIN
            INSERT INTO dbo.AlertaMonitoreo (
                EmpresaId, ClienteId, ActividadVulnerableId, TipoAlertaId,
                FechaPeriodoInicio, FechaPeriodoFin, MontoEvaluado, MontoEnUMAs,
                UmbralAplicado, Descripcion
            )
            VALUES (
                @EmpresaId, @ClienteId, @ActividadVulnerableId, 2, -- IDEN_ACU
                @FechaInicioMes, @FechaFinMes, @MontoAcumulado, @MontoAcumuladoUMAs,
                @UmbralIdentificacionUMAs,
                'Acumulado mensual supera umbral de identificación. Total: ' + 
                FORMAT(@MontoAcumulado, 'C', 'es-MX') + ' (' + CAST(ROUND(@MontoAcumuladoUMAs, 2) AS NVARCHAR(20)) + ' UMAs) en ' +
                CAST(@NumeroOperaciones AS NVARCHAR(10)) + ' operaciones.'
            );
        END
    END
    
    -- Alerta por aviso acumulado
    IF @SuperaUmbralAviso = 1
    BEGIN
        IF NOT EXISTS (
            SELECT 1 FROM dbo.AlertaMonitoreo 
            WHERE EmpresaId = @EmpresaId
              AND ClienteId = @ClienteId
              AND ActividadVulnerableId = @ActividadVulnerableId
              AND TipoAlertaId = 4 -- AVISO_ACU
              AND FechaPeriodoInicio = @FechaInicioMes
              AND FechaPeriodoFin = @FechaFinMes
              AND EstaActivo = 1
        )
        BEGIN
            INSERT INTO dbo.AlertaMonitoreo (
                EmpresaId, ClienteId, ActividadVulnerableId, TipoAlertaId,
                FechaPeriodoInicio, FechaPeriodoFin, MontoEvaluado, MontoEnUMAs,
                UmbralAplicado, Descripcion
            )
            VALUES (
                @EmpresaId, @ClienteId, @ActividadVulnerableId, 4, -- AVISO_ACU
                @FechaInicioMes, @FechaFinMes, @MontoAcumulado, @MontoAcumuladoUMAs,
                @UmbralAvisoUMAs,
                'Acumulado mensual supera umbral de aviso. Total: ' + 
                FORMAT(@MontoAcumulado, 'C', 'es-MX') + ' (' + CAST(ROUND(@MontoAcumuladoUMAs, 2) AS NVARCHAR(20)) + ' UMAs) en ' +
                CAST(@NumeroOperaciones AS NVARCHAR(10)) + ' operaciones. Requiere aviso a UIF.'
            );
        END
    END
END
GO

-- =============================================
-- Procedimiento: RecalcularAcumuladosMensuales
-- Descripción: Recalcula todos los acumulados de un período
-- =============================================
IF OBJECT_ID('dbo.RecalcularAcumuladosMensuales', 'P') IS NOT NULL
    DROP PROCEDURE dbo.RecalcularAcumuladosMensuales;
GO

CREATE PROCEDURE dbo.RecalcularAcumuladosMensuales
    @EmpresaId INT = NULL,  -- NULL para todas las empresas
    @Mes INT,
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalProcesados INT = 0;
    DECLARE @ClienteIdActual INT;
    DECLARE @ActividadIdActual INT;
    DECLARE @EmpresaIdActual INT;
    
    -- Cursor para procesar cada combinación cliente/actividad con operaciones en el mes
    DECLARE curClientes CURSOR LOCAL FAST_FORWARD FOR
        SELECT DISTINCT 
            eav.EmpresaId,
            o.ClienteId,
            eav.ActividadVulnerableId
        FROM dbo.Operacion o
        INNER JOIN dbo.EmpresaActividadVulnerable eav ON o.EmpresaActividadVulnerableId = eav.EmpresaActividadVulnerableId
        WHERE (@EmpresaId IS NULL OR eav.EmpresaId = @EmpresaId)
          AND MONTH(o.FechaOperacion) = @Mes
          AND YEAR(o.FechaOperacion) = @Anio
          AND o.EstaActivo = 1
          AND o.ClienteId IS NOT NULL;
    
    OPEN curClientes;
    FETCH NEXT FROM curClientes INTO @EmpresaIdActual, @ClienteIdActual, @ActividadIdActual;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Actualizar acumulado para este cliente
        EXEC dbo.ActualizarAcumuladoMensual
            @EmpresaId = @EmpresaIdActual,
            @ClienteId = @ClienteIdActual,
            @ActividadVulnerableId = @ActividadIdActual,
            @Mes = @Mes,
            @Anio = @Anio;
        
        SET @TotalProcesados = @TotalProcesados + 1;
        
        FETCH NEXT FROM curClientes INTO @EmpresaIdActual, @ClienteIdActual, @ActividadIdActual;
    END
    
    CLOSE curClientes;
    DEALLOCATE curClientes;
    
    SELECT @TotalProcesados AS ClientesProcesados, @Mes AS Mes, @Anio AS Anio;
END
GO

-- =============================================
-- Procedimiento: ObtenerAcumuladoCliente
-- Descripción: Obtiene el acumulado mensual de un cliente
-- =============================================
IF OBJECT_ID('dbo.ObtenerAcumuladoCliente', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ObtenerAcumuladoCliente;
GO

CREATE PROCEDURE dbo.ObtenerAcumuladoCliente
    @EmpresaId INT,
    @ClienteId INT,
    @ActividadVulnerableId INT = NULL,
    @Mes INT = NULL,
    @Anio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Si no se especifica mes/año, usar el actual
    IF @Mes IS NULL SET @Mes = MONTH(GETDATE());
    IF @Anio IS NULL SET @Anio = YEAR(GETDATE());
    
    SELECT 
        amc.AcumuladoMensualClienteId,
        amc.EmpresaId,
        e.Nombre AS NombreEmpresa,
        amc.ClienteId,
        amc.ActividadVulnerableId,
        av.Descripcion AS ActividadVulnerable,
        amc.PeriodoMes,
        amc.PeriodoAnio,
        amc.MontoAcumulado,
        amc.MontoAcumuladoUMAs,
        amc.NumeroOperaciones,
        amc.SuperaUmbralIdentificacion,
        amc.SuperaUmbralAviso,
        amc.RequiereAviso,
        amc.AvisoGenerado,
        dbo.ObtenerUmbralIdentificacion(amc.ActividadVulnerableId) AS UmbralIdentificacionUMAs,
        dbo.ObtenerUmbralAviso(amc.ActividadVulnerableId) AS UmbralAvisoUMAs,
        amc.FechaUltimaActualizacion
    FROM dbo.AcumuladoMensualCliente amc
    INNER JOIN dbo.Empresa e ON amc.EmpresaId = e.EmpresaId
    INNER JOIN dbo.ActividadVulnerable av ON amc.ActividadVulnerableId = av.ActividadVulnerableId
    WHERE amc.EmpresaId = @EmpresaId
      AND amc.ClienteId = @ClienteId
      AND (@ActividadVulnerableId IS NULL OR amc.ActividadVulnerableId = @ActividadVulnerableId)
      AND amc.PeriodoMes = @Mes
      AND amc.PeriodoAnio = @Anio;
END
GO

-- =============================================
-- Procedimiento: ObtenerHistorialAcumuladosCliente
-- Descripción: Obtiene el historial de acumulados de un cliente
-- =============================================
IF OBJECT_ID('dbo.ObtenerHistorialAcumuladosCliente', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ObtenerHistorialAcumuladosCliente;
GO

CREATE PROCEDURE dbo.ObtenerHistorialAcumuladosCliente
    @EmpresaId INT,
    @ClienteId INT,
    @FechaDesde DATE = NULL,
    @FechaHasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Por defecto, últimos 12 meses
    IF @FechaDesde IS NULL SET @FechaDesde = DATEADD(MONTH, -12, GETDATE());
    IF @FechaHasta IS NULL SET @FechaHasta = GETDATE();
    
    SELECT 
        amc.PeriodoAnio,
        amc.PeriodoMes,
        av.Codigo AS CodigoActividad,
        av.Descripcion AS ActividadVulnerable,
        amc.MontoAcumulado,
        amc.MontoAcumuladoUMAs,
        amc.NumeroOperaciones,
        CASE WHEN amc.SuperaUmbralIdentificacion = 1 THEN 'Sí' ELSE 'No' END AS SuperaIdentificacion,
        CASE WHEN amc.SuperaUmbralAviso = 1 THEN 'Sí' ELSE 'No' END AS SuperaAviso,
        CASE WHEN amc.AvisoGenerado = 1 THEN 'Generado' ELSE 'Pendiente' END AS EstatusAviso
    FROM dbo.AcumuladoMensualCliente amc
    INNER JOIN dbo.ActividadVulnerable av ON amc.ActividadVulnerableId = av.ActividadVulnerableId
    WHERE amc.EmpresaId = @EmpresaId
      AND amc.ClienteId = @ClienteId
      AND DATEFROMPARTS(amc.PeriodoAnio, amc.PeriodoMes, 1) >= @FechaDesde
      AND DATEFROMPARTS(amc.PeriodoAnio, amc.PeriodoMes, 1) <= @FechaHasta
    ORDER BY amc.PeriodoAnio DESC, amc.PeriodoMes DESC, av.Descripcion;
END
GO

PRINT 'Procedimientos de acumulación mensual creados exitosamente.';
GO
