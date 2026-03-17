-- =============================================
-- Procedimientos de Generación de Alertas y Avisos
-- =============================================

-- =============================================
-- Procedimiento: GenerarAvisoUIF
-- Descripción: Genera un aviso para la UIF basado en el acumulado mensual
-- =============================================
IF OBJECT_ID('dbo.GenerarAvisoUIF', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GenerarAvisoUIF;
GO

CREATE PROCEDURE dbo.GenerarAvisoUIF
    @EmpresaId INT,
    @ClienteId INT,
    @ActividadVulnerableId INT,
    @Mes INT,
    @Anio INT,
    @UsuarioId INT,
    @AvisoUIFId BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    
    DECLARE @MontoTotal MONEY;
    DECLARE @MontoTotalUMAs DECIMAL(18,4);
    DECLARE @NumeroOperaciones INT;
    DECLARE @FechaLimite DATE;
    DECLARE @FechaInicioMes DATE;
    DECLARE @FechaFinMes DATE;
    
    SET @AvisoUIFId = 0;
    
    -- Calcular fechas del período
    SET @FechaInicioMes = DATEFROMPARTS(@Anio, @Mes, 1);
    SET @FechaFinMes = EOMONTH(@FechaInicioMes);
    SET @FechaLimite = dbo.CalcularFechaLimitePresentacion(@FechaFinMes);
    
    -- Verificar si ya existe aviso para este período
    IF EXISTS (
        SELECT 1 FROM dbo.AvisoUIF
        WHERE EmpresaId = @EmpresaId
          AND ClienteId = @ClienteId
          AND ActividadVulnerableId = @ActividadVulnerableId
          AND PeriodoMes = @Mes
          AND PeriodoAnio = @Anio
          AND EstaActivo = 1
    )
    BEGIN
        RAISERROR('Ya existe un aviso para este cliente en el período especificado.', 16, 1);
        RETURN;
    END
    
    -- Obtener datos del acumulado
    SELECT 
        @MontoTotal = MontoAcumulado,
        @MontoTotalUMAs = MontoAcumuladoUMAs,
        @NumeroOperaciones = NumeroOperaciones
    FROM dbo.AcumuladoMensualCliente
    WHERE EmpresaId = @EmpresaId
      AND ClienteId = @ClienteId
      AND ActividadVulnerableId = @ActividadVulnerableId
      AND PeriodoMes = @Mes
      AND PeriodoAnio = @Anio;
    
    -- Si no hay acumulado, calcularlo
    IF @MontoTotal IS NULL
    BEGIN
        SELECT 
            @MontoTotal = ISNULL(SUM(
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
        
        SET @MontoTotalUMAs = dbo.ConvertirMontoAUMAs(@MontoTotal, @FechaFinMes);
    END
    
    -- Verificar que supera umbral de aviso
    IF @MontoTotalUMAs < dbo.ObtenerUmbralAviso(@ActividadVulnerableId)
    BEGIN
        RAISERROR('El monto acumulado no supera el umbral de aviso para esta actividad.', 16, 1);
        RETURN;
    END
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Crear el aviso
        INSERT INTO dbo.AvisoUIF (
            EmpresaId, ClienteId, ActividadVulnerableId,
            PeriodoMes, PeriodoAnio, FechaLimitePresentacion,
            MontoTotalOperaciones, MontoTotalEnUMAs, NumeroOperaciones,
            UsuarioAltaId
        )
        VALUES (
            @EmpresaId, @ClienteId, @ActividadVulnerableId,
            @Mes, @Anio, @FechaLimite,
            @MontoTotal, @MontoTotalUMAs, @NumeroOperaciones,
            @UsuarioId
        );
        
        SET @AvisoUIFId = SCOPE_IDENTITY();
        
        -- Asociar las operaciones del período al aviso
        INSERT INTO dbo.AvisoUIFOperacion (AvisoUIFId, OperacionId)
        SELECT @AvisoUIFId, o.Id
        FROM dbo.Operacion o
        INNER JOIN dbo.EmpresaActividadVulnerable eav ON o.EmpresaActividadVulnerableId = eav.EmpresaActividadVulnerableId
        WHERE eav.EmpresaId = @EmpresaId
          AND o.ClienteId = @ClienteId
          AND eav.ActividadVulnerableId = @ActividadVulnerableId
          AND o.FechaOperacion >= @FechaInicioMes
          AND o.FechaOperacion <= @FechaFinMes
          AND o.EstaActivo = 1;
        
        -- Marcar acumulado como aviso generado
        UPDATE dbo.AcumuladoMensualCliente
        SET AvisoGenerado = 1,
            FechaUltimaActualizacion = GETDATE()
        WHERE EmpresaId = @EmpresaId
          AND ClienteId = @ClienteId
          AND ActividadVulnerableId = @ActividadVulnerableId
          AND PeriodoMes = @Mes
          AND PeriodoAnio = @Anio;
        
        -- Actualizar alertas relacionadas a procesadas
        UPDATE dbo.AlertaMonitoreo
        SET EstatusAlertaId = 5, -- Procesada
            FechaRevision = GETDATE(),
            UsuarioRevisionId = @UsuarioId
        WHERE EmpresaId = @EmpresaId
          AND ClienteId = @ClienteId
          AND ActividadVulnerableId = @ActividadVulnerableId
          AND TipoAlertaId IN (3, 4) -- AVISO_IND, AVISO_ACU
          AND FechaPeriodoInicio >= @FechaInicioMes
          AND FechaPeriodoFin <= @FechaFinMes
          AND EstatusAlertaId IN (1, 2, 3); -- Pendiente, En Revisión, Confirmada
        
        COMMIT TRANSACTION;
        
        -- Retornar información del aviso
        SELECT 
            a.AvisoUIFId,
            a.EmpresaId,
            e.Nombre AS NombreEmpresa,
            a.ClienteId,
            av.Descripcion AS ActividadVulnerable,
            a.PeriodoMes,
            a.PeriodoAnio,
            a.FechaLimitePresentacion,
            a.MontoTotalOperaciones,
            a.MontoTotalEnUMAs,
            a.NumeroOperaciones,
            ea.Nombre AS EstatusAviso
        FROM dbo.AvisoUIF a
        INNER JOIN dbo.Empresa e ON a.EmpresaId = e.EmpresaId
        INNER JOIN dbo.ActividadVulnerable av ON a.ActividadVulnerableId = av.ActividadVulnerableId
        INNER JOIN dbo.EstatusAviso ea ON a.EstatusAvisoId = ea.EstatusAvisoId
        WHERE a.AvisoUIFId = @AvisoUIFId;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END
GO

-- =============================================
-- Procedimiento: GenerarAvisosAutomaticos
-- Descripción: Genera avisos automáticamente para todos los clientes que superan umbral en un período
-- =============================================
IF OBJECT_ID('dbo.GenerarAvisosAutomaticos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GenerarAvisosAutomaticos;
GO

CREATE PROCEDURE dbo.GenerarAvisosAutomaticos
    @EmpresaId INT = NULL,  -- NULL para todas las empresas
    @Mes INT,
    @Anio INT,
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalAvisosGenerados INT = 0;
    DECLARE @AvisoId BIGINT;
    DECLARE @MensajeError NVARCHAR(MAX);
    
    -- Tabla temporal para almacenar clientes pendientes de aviso
    CREATE TABLE #ClientesPendientes (
        EmpresaId INT,
        ClienteId INT,
        ActividadVulnerableId INT,
        Procesado BIT DEFAULT 0
    );
    
    -- Obtener clientes que requieren aviso y no lo tienen generado
    INSERT INTO #ClientesPendientes (EmpresaId, ClienteId, ActividadVulnerableId)
    SELECT 
        amc.EmpresaId,
        amc.ClienteId,
        amc.ActividadVulnerableId
    FROM dbo.AcumuladoMensualCliente amc
    WHERE (@EmpresaId IS NULL OR amc.EmpresaId = @EmpresaId)
      AND amc.PeriodoMes = @Mes
      AND amc.PeriodoAnio = @Anio
      AND amc.RequiereAviso = 1
      AND amc.AvisoGenerado = 0;
    
    -- Procesar cada cliente
    DECLARE @EmpresaIdActual INT;
    DECLARE @ClienteIdActual INT;
    DECLARE @ActividadIdActual INT;
    
    DECLARE curClientes CURSOR LOCAL FAST_FORWARD FOR
        SELECT EmpresaId, ClienteId, ActividadVulnerableId
        FROM #ClientesPendientes
        WHERE Procesado = 0;
    
    OPEN curClientes;
    FETCH NEXT FROM curClientes INTO @EmpresaIdActual, @ClienteIdActual, @ActividadIdActual;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            EXEC dbo.GenerarAvisoUIF
                @EmpresaId = @EmpresaIdActual,
                @ClienteId = @ClienteIdActual,
                @ActividadVulnerableId = @ActividadIdActual,
                @Mes = @Mes,
                @Anio = @Anio,
                @UsuarioId = @UsuarioId,
                @AvisoUIFId = @AvisoId OUTPUT;
            
            SET @TotalAvisosGenerados = @TotalAvisosGenerados + 1;
            
            UPDATE #ClientesPendientes
            SET Procesado = 1
            WHERE EmpresaId = @EmpresaIdActual
              AND ClienteId = @ClienteIdActual
              AND ActividadVulnerableId = @ActividadIdActual;
        END TRY
        BEGIN CATCH
            SET @MensajeError = ERROR_MESSAGE();
            -- Continuar con el siguiente cliente
            PRINT 'Error generando aviso para Cliente ' + CAST(@ClienteIdActual AS NVARCHAR(10)) + ': ' + @MensajeError;
        END CATCH
        
        FETCH NEXT FROM curClientes INTO @EmpresaIdActual, @ClienteIdActual, @ActividadIdActual;
    END
    
    CLOSE curClientes;
    DEALLOCATE curClientes;
    
    DROP TABLE #ClientesPendientes;
    
    SELECT 
        @TotalAvisosGenerados AS AvisosGenerados,
        @Mes AS Mes,
        @Anio AS Anio;
END
GO

-- =============================================
-- Procedimiento: ObtenerAlertasPendientes
-- Descripción: Obtiene las alertas pendientes de revisión
-- =============================================
IF OBJECT_ID('dbo.ObtenerAlertasPendientes', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ObtenerAlertasPendientes;
GO

CREATE PROCEDURE dbo.ObtenerAlertasPendientes
    @EmpresaId INT = NULL,
    @ClienteId INT = NULL,
    @TipoAlertaId INT = NULL,
    @FechaDesde DATE = NULL,
    @FechaHasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Por defecto, último mes
    IF @FechaDesde IS NULL SET @FechaDesde = DATEADD(MONTH, -1, GETDATE());
    IF @FechaHasta IS NULL SET @FechaHasta = GETDATE();
    
    SELECT 
        am.AlertaMonitoreoId,
        am.EmpresaId,
        e.Nombre AS NombreEmpresa,
        am.ClienteId,
        av.Codigo AS CodigoActividad,
        av.Descripcion AS ActividadVulnerable,
        ta.Codigo AS CodigoTipoAlerta,
        ta.Descripcion AS TipoAlerta,
        ea.Nombre AS Estatus,
        am.FechaPeriodoInicio,
        am.FechaPeriodoFin,
        am.MontoEvaluado,
        am.MontoEnUMAs,
        am.UmbralAplicado,
        am.OperacionId,
        am.Descripcion,
        am.FechaGeneracion,
        DATEDIFF(DAY, am.FechaGeneracion, GETDATE()) AS DiasDesdeGeneracion
    FROM dbo.AlertaMonitoreo am
    INNER JOIN dbo.Empresa e ON am.EmpresaId = e.EmpresaId
    INNER JOIN dbo.ActividadVulnerable av ON am.ActividadVulnerableId = av.ActividadVulnerableId
    INNER JOIN dbo.TipoAlerta ta ON am.TipoAlertaId = ta.TipoAlertaId
    INNER JOIN dbo.EstatusAlerta ea ON am.EstatusAlertaId = ea.EstatusAlertaId
    WHERE am.EstatusAlertaId IN (1, 2) -- Pendiente, En Revisión
      AND am.EstaActivo = 1
      AND (@EmpresaId IS NULL OR am.EmpresaId = @EmpresaId)
      AND (@ClienteId IS NULL OR am.ClienteId = @ClienteId)
      AND (@TipoAlertaId IS NULL OR am.TipoAlertaId = @TipoAlertaId)
      AND am.FechaGeneracion >= @FechaDesde
      AND am.FechaGeneracion <= @FechaHasta
    ORDER BY am.FechaGeneracion DESC;
END
GO

-- =============================================
-- Procedimiento: ObtenerAvisosPendientes
-- Descripción: Obtiene los avisos pendientes de envío
-- =============================================
IF OBJECT_ID('dbo.ObtenerAvisosPendientes', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ObtenerAvisosPendientes;
GO

CREATE PROCEDURE dbo.ObtenerAvisosPendientes
    @EmpresaId INT = NULL,
    @IncluirProximosAVencer BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        a.AvisoUIFId,
        a.EmpresaId,
        e.Nombre AS NombreEmpresa,
        a.ClienteId,
        av.Codigo AS CodigoActividad,
        av.Descripcion AS ActividadVulnerable,
        a.PeriodoMes,
        a.PeriodoAnio,
        ea.Nombre AS Estatus,
        a.FechaLimitePresentacion,
        DATEDIFF(DAY, GETDATE(), a.FechaLimitePresentacion) AS DiasParaVencimiento,
        a.MontoTotalOperaciones,
        a.MontoTotalEnUMAs,
        a.NumeroOperaciones,
        a.FechaAlta,
        CASE 
            WHEN a.FechaLimitePresentacion < GETDATE() THEN 'VENCIDO'
            WHEN DATEDIFF(DAY, GETDATE(), a.FechaLimitePresentacion) <= 5 THEN 'URGENTE'
            WHEN DATEDIFF(DAY, GETDATE(), a.FechaLimitePresentacion) <= 10 THEN 'PRÓXIMO'
            ELSE 'EN TIEMPO'
        END AS Prioridad
    FROM dbo.AvisoUIF a
    INNER JOIN dbo.Empresa e ON a.EmpresaId = e.EmpresaId
    INNER JOIN dbo.ActividadVulnerable av ON a.ActividadVulnerableId = av.ActividadVulnerableId
    INNER JOIN dbo.EstatusAviso ea ON a.EstatusAvisoId = ea.EstatusAvisoId
    WHERE a.EstatusAvisoId IN (1, 2, 3) -- Pendiente, En Preparación, Listo
      AND a.EstaActivo = 1
      AND (@EmpresaId IS NULL OR a.EmpresaId = @EmpresaId)
      AND (
          @IncluirProximosAVencer = 1 
          OR a.FechaLimitePresentacion >= GETDATE()
      )
    ORDER BY a.FechaLimitePresentacion ASC;
END
GO

-- =============================================
-- Procedimiento: ActualizarEstatusAlerta
-- Descripción: Actualiza el estatus de una alerta
-- =============================================
IF OBJECT_ID('dbo.ActualizarEstatusAlerta', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ActualizarEstatusAlerta;
GO

CREATE PROCEDURE dbo.ActualizarEstatusAlerta
    @AlertaMonitoreoId BIGINT,
    @NuevoEstatusId INT,
    @NotasRevision NVARCHAR(MAX) = NULL,
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validar que el estatus existe
    IF NOT EXISTS (SELECT 1 FROM dbo.EstatusAlerta WHERE EstatusAlertaId = @NuevoEstatusId)
    BEGIN
        RAISERROR('Estatus de alerta no válido.', 16, 1);
        RETURN;
    END
    
    UPDATE dbo.AlertaMonitoreo
    SET EstatusAlertaId = @NuevoEstatusId,
        NotasRevision = CASE 
            WHEN @NotasRevision IS NOT NULL THEN 
                ISNULL(NotasRevision, '') + CHAR(13) + CHAR(10) + 
                '[' + CONVERT(NVARCHAR(20), GETDATE(), 120) + '] ' + @NotasRevision
            ELSE NotasRevision
        END,
        FechaRevision = GETDATE(),
        UsuarioRevisionId = @UsuarioId
    WHERE AlertaMonitoreoId = @AlertaMonitoreoId;
    
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Alerta no encontrada.', 16, 1);
        RETURN;
    END
    
    SELECT 
        am.AlertaMonitoreoId,
        ea.Nombre AS NuevoEstatus,
        am.FechaRevision,
        am.NotasRevision
    FROM dbo.AlertaMonitoreo am
    INNER JOIN dbo.EstatusAlerta ea ON am.EstatusAlertaId = ea.EstatusAlertaId
    WHERE am.AlertaMonitoreoId = @AlertaMonitoreoId;
END
GO

-- =============================================
-- Procedimiento: ActualizarEstatusAviso
-- Descripción: Actualiza el estatus de un aviso
-- =============================================
IF OBJECT_ID('dbo.ActualizarEstatusAviso', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ActualizarEstatusAviso;
GO

CREATE PROCEDURE dbo.ActualizarEstatusAviso
    @AvisoUIFId BIGINT,
    @NuevoEstatusId INT,
    @FolioPortal NVARCHAR(50) = NULL,
    @Observaciones NVARCHAR(MAX) = NULL,
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validar que el estatus existe
    IF NOT EXISTS (SELECT 1 FROM dbo.EstatusAviso WHERE EstatusAvisoId = @NuevoEstatusId)
    BEGIN
        RAISERROR('Estatus de aviso no válido.', 16, 1);
        RETURN;
    END
    
    UPDATE dbo.AvisoUIF
    SET EstatusAvisoId = @NuevoEstatusId,
        FolioAvisoPortal = ISNULL(@FolioPortal, FolioAvisoPortal),
        FechaEnvioPortal = CASE 
            WHEN @NuevoEstatusId = 4 THEN GETDATE()  -- Enviado
            ELSE FechaEnvioPortal
        END,
        FechaConfirmacionPortal = CASE 
            WHEN @NuevoEstatusId = 5 THEN GETDATE()  -- Confirmado
            ELSE FechaConfirmacionPortal
        END,
        Observaciones = CASE 
            WHEN @Observaciones IS NOT NULL THEN 
                ISNULL(Observaciones, '') + CHAR(13) + CHAR(10) + 
                '[' + CONVERT(NVARCHAR(20), GETDATE(), 120) + '] ' + @Observaciones
            ELSE Observaciones
        END,
        FechaModificacion = GETDATE(),
        UsuarioModificacionId = @UsuarioId
    WHERE AvisoUIFId = @AvisoUIFId;
    
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Aviso no encontrado.', 16, 1);
        RETURN;
    END
    
    SELECT 
        a.AvisoUIFId,
        ea.Nombre AS NuevoEstatus,
        a.FolioAvisoPortal,
        a.FechaEnvioPortal,
        a.FechaConfirmacionPortal
    FROM dbo.AvisoUIF a
    INNER JOIN dbo.EstatusAviso ea ON a.EstatusAvisoId = ea.EstatusAvisoId
    WHERE a.AvisoUIFId = @AvisoUIFId;
END
GO

PRINT 'Procedimientos de generación de alertas y avisos creados exitosamente.';
GO
