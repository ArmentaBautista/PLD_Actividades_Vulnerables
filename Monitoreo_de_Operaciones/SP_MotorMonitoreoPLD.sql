-- =============================================
-- Motor Principal de Monitoreo PLD
-- =============================================

-- =============================================
-- Procedimiento: EjecutarMonitoreoPLD
-- Descripción: Procedimiento principal que ejecuta el ciclo completo de monitoreo
-- =============================================
IF OBJECT_ID('dbo.EjecutarMonitoreoPLD', 'P') IS NOT NULL
    DROP PROCEDURE dbo.EjecutarMonitoreoPLD;
GO

CREATE PROCEDURE dbo.EjecutarMonitoreoPLD
    @EmpresaId INT = NULL,          -- NULL para todas las empresas
    @Mes INT = NULL,                 -- NULL para mes actual
    @Anio INT = NULL,                -- NULL para año actual
    @GenerarAvisos BIT = 0,          -- Si se deben generar avisos automáticamente
    @UsuarioId INT = 1               -- Usuario que ejecuta el proceso
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    
    DECLARE @LogId BIGINT;
    DECLARE @FechaInicio DATETIME2 = GETDATE();
    DECLARE @OperacionesProcesadas INT = 0;
    DECLARE @AlertasGeneradas INT = 0;
    DECLARE @AvisosGenerados INT = 0;
    DECLARE @MensajeError NVARCHAR(MAX);
    
    -- Establecer período por defecto (mes actual)
    IF @Mes IS NULL SET @Mes = MONTH(GETDATE());
    IF @Anio IS NULL SET @Anio = YEAR(GETDATE());
    
    -- Registrar inicio de ejecución
    INSERT INTO dbo.LogMonitoreo (TipoProceso, FechaInicio, EmpresaId, PeriodoMes, PeriodoAnio)
    VALUES ('MONITOREO_COMPLETO', @FechaInicio, @EmpresaId, @Mes, @Anio);
    
    SET @LogId = SCOPE_IDENTITY();
    
    BEGIN TRY
        PRINT '======================================';
        PRINT 'INICIO MONITOREO PLD';
        PRINT 'Período: ' + CAST(@Mes AS NVARCHAR(2)) + '/' + CAST(@Anio AS NVARCHAR(4));
        PRINT 'Empresa: ' + ISNULL(CAST(@EmpresaId AS NVARCHAR(10)), 'TODAS');
        PRINT '======================================';
        
        -- ========================================
        -- PASO 1: Recalcular acumulados mensuales
        -- ========================================
        PRINT '';
        PRINT '>> Paso 1: Recalculando acumulados mensuales...';
        
        DECLARE @ClientesProcesados INT;
        
        EXEC dbo.RecalcularAcumuladosMensuales
            @EmpresaId = @EmpresaId,
            @Mes = @Mes,
            @Anio = @Anio;
        
        SELECT @OperacionesProcesadas = COUNT(*)
        FROM dbo.AcumuladoMensualCliente
        WHERE (@EmpresaId IS NULL OR EmpresaId = @EmpresaId)
          AND PeriodoMes = @Mes
          AND PeriodoAnio = @Anio;
        
        PRINT '   Clientes procesados: ' + CAST(@OperacionesProcesadas AS NVARCHAR(10));
        
        -- ========================================
        -- PASO 2: Contar alertas generadas
        -- ========================================
        PRINT '';
        PRINT '>> Paso 2: Contando alertas generadas...';
        
        DECLARE @FechaInicioMes DATE = DATEFROMPARTS(@Anio, @Mes, 1);
        DECLARE @FechaFinMes DATE = EOMONTH(@FechaInicioMes);
        
        SELECT @AlertasGeneradas = COUNT(*)
        FROM dbo.AlertaMonitoreo
        WHERE (@EmpresaId IS NULL OR EmpresaId = @EmpresaId)
          AND FechaPeriodoInicio >= @FechaInicioMes
          AND FechaPeriodoFin <= @FechaFinMes
          AND EstaActivo = 1;
        
        PRINT '   Alertas en el período: ' + CAST(@AlertasGeneradas AS NVARCHAR(10));
        
        -- ========================================
        -- PASO 3: Generar avisos (si está habilitado)
        -- ========================================
        IF @GenerarAvisos = 1
        BEGIN
            PRINT '';
            PRINT '>> Paso 3: Generando avisos automáticos...';
            
            DECLARE @ResultadoAvisos TABLE (AvisosGenerados INT);
            
            INSERT INTO @ResultadoAvisos
            EXEC dbo.GenerarAvisosAutomaticos
                @EmpresaId = @EmpresaId,
                @Mes = @Mes,
                @Anio = @Anio,
                @UsuarioId = @UsuarioId;
            
            SELECT @AvisosGenerados = ISNULL(AvisosGenerados, 0)
            FROM @ResultadoAvisos;
            
            PRINT '   Avisos generados: ' + CAST(@AvisosGenerados AS NVARCHAR(10));
        END
        ELSE
        BEGIN
            PRINT '';
            PRINT '>> Paso 3: Generación de avisos deshabilitada (usar @GenerarAvisos = 1)';
        END
        
        -- ========================================
        -- PASO 4: Resumen final
        -- ========================================
        PRINT '';
        PRINT '======================================';
        PRINT 'RESUMEN DE EJECUCIÓN';
        PRINT '======================================';
        
        -- Actualizar log con resultados
        UPDATE dbo.LogMonitoreo
        SET FechaFin = GETDATE(),
            OperacionesProcesadas = @OperacionesProcesadas,
            AlertasGeneradas = @AlertasGeneradas,
            AvisosGenerados = @AvisosGenerados,
            EstatusEjecucion = 'COMPLETADO'
        WHERE LogMonitoreoId = @LogId;
        
        -- Resumen de resultados
        SELECT 
            'Monitoreo PLD' AS Proceso,
            CAST(@Mes AS NVARCHAR(2)) + '/' + CAST(@Anio AS NVARCHAR(4)) AS Periodo,
            @OperacionesProcesadas AS ClientesProcesados,
            @AlertasGeneradas AS AlertasEnPeriodo,
            @AvisosGenerados AS AvisosGenerados,
            DATEDIFF(SECOND, @FechaInicio, GETDATE()) AS TiempoEjecucionSegundos,
            'COMPLETADO' AS Estatus;
        
        -- Detalle de alertas pendientes
        SELECT 
            ta.Descripcion AS TipoAlerta,
            COUNT(*) AS Cantidad
        FROM dbo.AlertaMonitoreo am
        INNER JOIN dbo.TipoAlerta ta ON am.TipoAlertaId = ta.TipoAlertaId
        WHERE (@EmpresaId IS NULL OR am.EmpresaId = @EmpresaId)
          AND am.FechaPeriodoInicio >= @FechaInicioMes
          AND am.FechaPeriodoFin <= @FechaFinMes
          AND am.EstatusAlertaId = 1 -- Pendiente
          AND am.EstaActivo = 1
        GROUP BY ta.Descripcion
        ORDER BY COUNT(*) DESC;
        
        -- Avisos pendientes de presentar
        SELECT 
            COUNT(*) AS AvisosPendientes,
            SUM(CASE WHEN FechaLimitePresentacion < GETDATE() THEN 1 ELSE 0 END) AS AvisosVencidos,
            SUM(CASE WHEN DATEDIFF(DAY, GETDATE(), FechaLimitePresentacion) BETWEEN 0 AND 5 THEN 1 ELSE 0 END) AS AvisosUrgentes
        FROM dbo.AvisoUIF
        WHERE (@EmpresaId IS NULL OR EmpresaId = @EmpresaId)
          AND EstatusAvisoId IN (1, 2, 3) -- Pendiente, En Preparación, Listo
          AND EstaActivo = 1;
        
    END TRY
    BEGIN CATCH
        SET @MensajeError = ERROR_MESSAGE();
        
        UPDATE dbo.LogMonitoreo
        SET FechaFin = GETDATE(),
            EstatusEjecucion = 'ERROR',
            MensajeError = @MensajeError
        WHERE LogMonitoreoId = @LogId;
        
        PRINT '';
        PRINT '!! ERROR EN MONITOREO: ' + @MensajeError;
        
        THROW;
    END CATCH
END
GO

-- =============================================
-- Procedimiento: ResumenMonitoreoPLD
-- Descripción: Genera un resumen ejecutivo del estado de monitoreo
-- =============================================
IF OBJECT_ID('dbo.ResumenMonitoreoPLD', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ResumenMonitoreoPLD;
GO

CREATE PROCEDURE dbo.ResumenMonitoreoPLD
    @EmpresaId INT = NULL,
    @Mes INT = NULL,
    @Anio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @Mes IS NULL SET @Mes = MONTH(GETDATE());
    IF @Anio IS NULL SET @Anio = YEAR(GETDATE());
    
    DECLARE @FechaInicioMes DATE = DATEFROMPARTS(@Anio, @Mes, 1);
    DECLARE @FechaFinMes DATE = EOMONTH(@FechaInicioMes);
    
    -- 1. Resumen General
    SELECT 
        'RESUMEN GENERAL' AS Seccion,
        (SELECT COUNT(DISTINCT ClienteId) 
         FROM dbo.Operacion o
         INNER JOIN dbo.EmpresaActividadVulnerable eav ON o.EmpresaActividadVulnerableId = eav.EmpresaActividadVulnerableId
         WHERE (@EmpresaId IS NULL OR eav.EmpresaId = @EmpresaId)
           AND o.FechaOperacion >= @FechaInicioMes
           AND o.FechaOperacion <= @FechaFinMes
           AND o.EstaActivo = 1) AS ClientesConOperaciones,
        (SELECT COUNT(*) 
         FROM dbo.Operacion o
         INNER JOIN dbo.EmpresaActividadVulnerable eav ON o.EmpresaActividadVulnerableId = eav.EmpresaActividadVulnerableId
         WHERE (@EmpresaId IS NULL OR eav.EmpresaId = @EmpresaId)
           AND o.FechaOperacion >= @FechaInicioMes
           AND o.FechaOperacion <= @FechaFinMes
           AND o.EstaActivo = 1) AS TotalOperaciones,
        (SELECT ISNULL(SUM(CASE WHEN o.DivisaId = 1 THEN o.Monto ELSE o.Monto * ISNULL(o.FactorDivisa, 1) END), 0)
         FROM dbo.Operacion o
         INNER JOIN dbo.EmpresaActividadVulnerable eav ON o.EmpresaActividadVulnerableId = eav.EmpresaActividadVulnerableId
         WHERE (@EmpresaId IS NULL OR eav.EmpresaId = @EmpresaId)
           AND o.FechaOperacion >= @FechaInicioMes
           AND o.FechaOperacion <= @FechaFinMes
           AND o.EstaActivo = 1) AS MontoTotalOperaciones;
    
    -- 2. Estado de Alertas
    SELECT 
        ea.Nombre AS EstatusAlerta,
        COUNT(*) AS Cantidad
    FROM dbo.AlertaMonitoreo am
    INNER JOIN dbo.EstatusAlerta ea ON am.EstatusAlertaId = ea.EstatusAlertaId
    WHERE (@EmpresaId IS NULL OR am.EmpresaId = @EmpresaId)
      AND am.FechaPeriodoInicio >= @FechaInicioMes
      AND am.FechaPeriodoFin <= @FechaFinMes
      AND am.EstaActivo = 1
    GROUP BY ea.EstatusAlertaId, ea.Nombre
    ORDER BY ea.EstatusAlertaId;
    
    -- 3. Alertas por Tipo
    SELECT 
        ta.Codigo AS Tipo,
        ta.Descripcion,
        COUNT(*) AS Cantidad
    FROM dbo.AlertaMonitoreo am
    INNER JOIN dbo.TipoAlerta ta ON am.TipoAlertaId = ta.TipoAlertaId
    WHERE (@EmpresaId IS NULL OR am.EmpresaId = @EmpresaId)
      AND am.FechaPeriodoInicio >= @FechaInicioMes
      AND am.FechaPeriodoFin <= @FechaFinMes
      AND am.EstaActivo = 1
    GROUP BY ta.TipoAlertaId, ta.Codigo, ta.Descripcion
    ORDER BY COUNT(*) DESC;
    
    -- 4. Clientes que Requieren Aviso
    SELECT 
        amc.ClienteId,
        av.Descripcion AS ActividadVulnerable,
        amc.MontoAcumulado,
        amc.MontoAcumuladoUMAs,
        amc.NumeroOperaciones,
        CASE WHEN amc.AvisoGenerado = 1 THEN 'Generado' ELSE 'Pendiente' END AS EstatusAviso
    FROM dbo.AcumuladoMensualCliente amc
    INNER JOIN dbo.ActividadVulnerable av ON amc.ActividadVulnerableId = av.ActividadVulnerableId
    WHERE (@EmpresaId IS NULL OR amc.EmpresaId = @EmpresaId)
      AND amc.PeriodoMes = @Mes
      AND amc.PeriodoAnio = @Anio
      AND amc.RequiereAviso = 1
    ORDER BY amc.AvisoGenerado, amc.MontoAcumuladoUMAs DESC;
    
    -- 5. Estado de Avisos
    SELECT 
        ea.Nombre AS EstatusAviso,
        COUNT(*) AS Cantidad,
        SUM(a.MontoTotalOperaciones) AS MontoTotal
    FROM dbo.AvisoUIF a
    INNER JOIN dbo.EstatusAviso ea ON a.EstatusAvisoId = ea.EstatusAvisoId
    WHERE (@EmpresaId IS NULL OR a.EmpresaId = @EmpresaId)
      AND a.PeriodoMes = @Mes
      AND a.PeriodoAnio = @Anio
      AND a.EstaActivo = 1
    GROUP BY ea.EstatusAvisoId, ea.Nombre
    ORDER BY ea.EstatusAvisoId;
    
    -- 6. Avisos por Vencer
    SELECT 
        a.AvisoUIFId,
        a.ClienteId,
        av.Descripcion AS ActividadVulnerable,
        a.MontoTotalOperaciones,
        a.MontoTotalEnUMAs,
        a.FechaLimitePresentacion,
        DATEDIFF(DAY, GETDATE(), a.FechaLimitePresentacion) AS DiasRestantes,
        CASE 
            WHEN a.FechaLimitePresentacion < GETDATE() THEN 'VENCIDO'
            WHEN DATEDIFF(DAY, GETDATE(), a.FechaLimitePresentacion) <= 5 THEN 'URGENTE'
            ELSE 'EN TIEMPO'
        END AS Prioridad
    FROM dbo.AvisoUIF a
    INNER JOIN dbo.ActividadVulnerable av ON a.ActividadVulnerableId = av.ActividadVulnerableId
    WHERE (@EmpresaId IS NULL OR a.EmpresaId = @EmpresaId)
      AND a.EstatusAvisoId IN (1, 2, 3)
      AND a.EstaActivo = 1
    ORDER BY a.FechaLimitePresentacion;
END
GO

-- =============================================
-- Procedimiento: ObtenerDetalleOperacionesCliente
-- Descripción: Obtiene el detalle de operaciones de un cliente en un período
-- =============================================
IF OBJECT_ID('dbo.ObtenerDetalleOperacionesCliente', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ObtenerDetalleOperacionesCliente;
GO

CREATE PROCEDURE dbo.ObtenerDetalleOperacionesCliente
    @EmpresaId INT,
    @ClienteId INT,
    @Mes INT,
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FechaInicioMes DATE = DATEFROMPARTS(@Anio, @Mes, 1);
    DECLARE @FechaFinMes DATE = EOMONTH(@FechaInicioMes);
    
    -- Información del cliente y resumen
    SELECT 
        amc.ClienteId,
        amc.PeriodoMes,
        amc.PeriodoAnio,
        av.Descripcion AS ActividadVulnerable,
        amc.MontoAcumulado,
        amc.MontoAcumuladoUMAs,
        amc.NumeroOperaciones,
        dbo.ObtenerUmbralIdentificacion(amc.ActividadVulnerableId) AS UmbralIdentificacionUMAs,
        dbo.ObtenerUmbralAviso(amc.ActividadVulnerableId) AS UmbralAvisoUMAs,
        CASE WHEN amc.SuperaUmbralIdentificacion = 1 THEN 'Sí' ELSE 'No' END AS SuperaIdentificacion,
        CASE WHEN amc.SuperaUmbralAviso = 1 THEN 'Sí' ELSE 'No' END AS SuperaAviso,
        CASE WHEN amc.AvisoGenerado = 1 THEN 'Generado' ELSE 'Pendiente' END AS EstatusAviso
    FROM dbo.AcumuladoMensualCliente amc
    INNER JOIN dbo.ActividadVulnerable av ON amc.ActividadVulnerableId = av.ActividadVulnerableId
    WHERE amc.EmpresaId = @EmpresaId
      AND amc.ClienteId = @ClienteId
      AND amc.PeriodoMes = @Mes
      AND amc.PeriodoAnio = @Anio;
    
    -- Detalle de operaciones
    SELECT 
        o.Id AS OperacionId,
        o.FolioOperacion,
        o.FechaOperacion,
        o.HoraOperacion,
        to1.Tipo AS TipoOperacion,
        to2.Tipo AS TipoSubOperacion,
        ps.Nombre AS ProductoServicio,
        d.Nombre AS Divisa,
        o.Monto AS MontoOriginal,
        CASE 
            WHEN o.DivisaId = 1 THEN o.Monto
            ELSE o.Monto * ISNULL(o.FactorDivisa, 1)
        END AS MontoMXN,
        dbo.ConvertirMontoAUMAs(
            CASE WHEN o.DivisaId = 1 THEN o.Monto ELSE o.Monto * ISNULL(o.FactorDivisa, 1) END,
            o.FechaOperacion
        ) AS MontoUMAs,
        o.UsuarioOperacion
    FROM dbo.Operacion o
    INNER JOIN dbo.EmpresaActividadVulnerable eav ON o.EmpresaActividadVulnerableId = eav.EmpresaActividadVulnerableId
    INNER JOIN dbo.TipoOperacion to1 ON o.TipoOperacionId = to1.TipoOperacionId
    INNER JOIN dbo.TipoOperacion to2 ON o.TipoSubOperacionId = to2.TipoOperacionId
    INNER JOIN dbo.ProductoServicio ps ON o.ProductoServicioId = ps.ProductoServicioId
    INNER JOIN dbo.Divisa d ON o.DivisaId = d.DivisaId
    WHERE eav.EmpresaId = @EmpresaId
      AND o.ClienteId = @ClienteId
      AND o.FechaOperacion >= @FechaInicioMes
      AND o.FechaOperacion <= @FechaFinMes
      AND o.EstaActivo = 1
    ORDER BY o.FechaOperacion, o.HoraOperacion;
    
    -- Alertas relacionadas
    SELECT 
        am.AlertaMonitoreoId,
        ta.Descripcion AS TipoAlerta,
        ea.Nombre AS Estatus,
        am.MontoEvaluado,
        am.MontoEnUMAs,
        am.UmbralAplicado,
        am.Descripcion,
        am.FechaGeneracion
    FROM dbo.AlertaMonitoreo am
    INNER JOIN dbo.TipoAlerta ta ON am.TipoAlertaId = ta.TipoAlertaId
    INNER JOIN dbo.EstatusAlerta ea ON am.EstatusAlertaId = ea.EstatusAlertaId
    WHERE am.EmpresaId = @EmpresaId
      AND am.ClienteId = @ClienteId
      AND am.FechaPeriodoInicio >= @FechaInicioMes
      AND am.FechaPeriodoFin <= @FechaFinMes
      AND am.EstaActivo = 1
    ORDER BY am.FechaGeneracion DESC;
END
GO

PRINT 'Motor principal de monitoreo PLD creado exitosamente.';
GO
