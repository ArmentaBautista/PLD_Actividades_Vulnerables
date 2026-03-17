-- =============================================
-- Funciones para el Motor de Monitoreo PLD
-- =============================================

-- =============================================
-- Función: ObtenerValorUMAVigente
-- Descripción: Obtiene el valor del UMA vigente para una fecha específica
-- =============================================
IF OBJECT_ID('dbo.ObtenerValorUMAVigente', 'FN') IS NOT NULL
    DROP FUNCTION dbo.ObtenerValorUMAVigente;
GO

CREATE FUNCTION dbo.ObtenerValorUMAVigente
(
    @Fecha DATE
)
RETURNS DECIMAL(11,2)
AS
BEGIN
    DECLARE @ValorUMA DECIMAL(11,2);
    
    SELECT TOP 1 @ValorUMA = ValorDiario
    FROM dbo.ValorUMA
    WHERE @Fecha >= InicioVigencia 
      AND @Fecha <= FinVigencia
    ORDER BY InicioVigencia DESC;
    
    -- Si no hay valor vigente, usar el último disponible
    IF @ValorUMA IS NULL
    BEGIN
        SELECT TOP 1 @ValorUMA = ValorDiario
        FROM dbo.ValorUMA
        ORDER BY InicioVigencia DESC;
    END
    
    -- Valor por defecto si no hay registros (UMA 2025)
    IF @ValorUMA IS NULL
        SET @ValorUMA = 113.14;
    
    RETURN @ValorUMA;
END
GO

-- =============================================
-- Función: ConvertirMontoAUMAs
-- Descripción: Convierte un monto en pesos a su equivalente en UMAs
-- =============================================
IF OBJECT_ID('dbo.ConvertirMontoAUMAs', 'FN') IS NOT NULL
    DROP FUNCTION dbo.ConvertirMontoAUMAs;
GO

CREATE FUNCTION dbo.ConvertirMontoAUMAs
(
    @Monto MONEY,
    @Fecha DATE
)
RETURNS DECIMAL(18,4)
AS
BEGIN
    DECLARE @ValorUMA DECIMAL(11,2);
    DECLARE @MontoUMAs DECIMAL(18,4);
    
    SET @ValorUMA = dbo.ObtenerValorUMAVigente(@Fecha);
    
    IF @ValorUMA > 0
        SET @MontoUMAs = CAST(@Monto AS DECIMAL(18,4)) / @ValorUMA;
    ELSE
        SET @MontoUMAs = 0;
    
    RETURN @MontoUMAs;
END
GO

-- =============================================
-- Función: ConvertirUMAsAPesos
-- Descripción: Convierte UMAs a su equivalente en pesos
-- =============================================
IF OBJECT_ID('dbo.ConvertirUMAsAPesos', 'FN') IS NOT NULL
    DROP FUNCTION dbo.ConvertirUMAsAPesos;
GO

CREATE FUNCTION dbo.ConvertirUMAsAPesos
(
    @UMAs DECIMAL(18,4),
    @Fecha DATE
)
RETURNS MONEY
AS
BEGIN
    DECLARE @ValorUMA DECIMAL(11,2);
    DECLARE @Monto MONEY;
    
    SET @ValorUMA = dbo.ObtenerValorUMAVigente(@Fecha);
    SET @Monto = CAST(@UMAs * @ValorUMA AS MONEY);
    
    RETURN @Monto;
END
GO

-- =============================================
-- Función: ObtenerUmbralIdentificacion
-- Descripción: Obtiene el umbral de identificación para una actividad vulnerable
-- =============================================
IF OBJECT_ID('dbo.ObtenerUmbralIdentificacion', 'FN') IS NOT NULL
    DROP FUNCTION dbo.ObtenerUmbralIdentificacion;
GO

CREATE FUNCTION dbo.ObtenerUmbralIdentificacion
(
    @ActividadVulnerableId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @UmbralUMAs INT;
    
    SELECT @UmbralUMAs = UmbralEnUMAs
    FROM dbo.UmbralIdentificacionCliente
    WHERE ActividadVulnerableId = @ActividadVulnerableId;
    
    -- Si no hay umbral configurado, retornar 0
    IF @UmbralUMAs IS NULL
        SET @UmbralUMAs = 0;
    
    RETURN @UmbralUMAs;
END
GO

-- =============================================
-- Función: ObtenerUmbralAviso
-- Descripción: Obtiene el umbral de aviso para una actividad vulnerable
-- =============================================
IF OBJECT_ID('dbo.ObtenerUmbralAviso', 'FN') IS NOT NULL
    DROP FUNCTION dbo.ObtenerUmbralAviso;
GO

CREATE FUNCTION dbo.ObtenerUmbralAviso
(
    @ActividadVulnerableId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @UmbralUMAs INT;
    
    SELECT @UmbralUMAs = UmbralEnUMAs
    FROM dbo.UmbralPresentacionAviso
    WHERE ActividadVulnerableId = @ActividadVulnerableId;
    
    -- Si no hay umbral configurado, retornar 0
    IF @UmbralUMAs IS NULL
        SET @UmbralUMAs = 0;
    
    RETURN @UmbralUMAs;
END
GO

-- =============================================
-- Función: ObtenerUmbralIdentificacionEnPesos
-- Descripción: Obtiene el umbral de identificación en pesos para una fecha
-- =============================================
IF OBJECT_ID('dbo.ObtenerUmbralIdentificacionEnPesos', 'FN') IS NOT NULL
    DROP FUNCTION dbo.ObtenerUmbralIdentificacionEnPesos;
GO

CREATE FUNCTION dbo.ObtenerUmbralIdentificacionEnPesos
(
    @ActividadVulnerableId INT,
    @Fecha DATE
)
RETURNS MONEY
AS
BEGIN
    DECLARE @UmbralUMAs INT;
    DECLARE @UmbralPesos MONEY;
    
    SET @UmbralUMAs = dbo.ObtenerUmbralIdentificacion(@ActividadVulnerableId);
    SET @UmbralPesos = dbo.ConvertirUMAsAPesos(@UmbralUMAs, @Fecha);
    
    RETURN @UmbralPesos;
END
GO

-- =============================================
-- Función: ObtenerUmbralAvisoEnPesos
-- Descripción: Obtiene el umbral de aviso en pesos para una fecha
-- =============================================
IF OBJECT_ID('dbo.ObtenerUmbralAvisoEnPesos', 'FN') IS NOT NULL
    DROP FUNCTION dbo.ObtenerUmbralAvisoEnPesos;
GO

CREATE FUNCTION dbo.ObtenerUmbralAvisoEnPesos
(
    @ActividadVulnerableId INT,
    @Fecha DATE
)
RETURNS MONEY
AS
BEGIN
    DECLARE @UmbralUMAs INT;
    DECLARE @UmbralPesos MONEY;
    
    SET @UmbralUMAs = dbo.ObtenerUmbralAviso(@ActividadVulnerableId);
    SET @UmbralPesos = dbo.ConvertirUMAsAPesos(@UmbralUMAs, @Fecha);
    
    RETURN @UmbralPesos;
END
GO

-- =============================================
-- Función: CalcularFechaLimitePresentacion
-- Descripción: Calcula la fecha límite para presentar aviso (día 17 del mes siguiente)
-- =============================================
IF OBJECT_ID('dbo.CalcularFechaLimitePresentacion', 'FN') IS NOT NULL
    DROP FUNCTION dbo.CalcularFechaLimitePresentacion;
GO

CREATE FUNCTION dbo.CalcularFechaLimitePresentacion
(
    @FechaOperacion DATE
)
RETURNS DATE
AS
BEGIN
    DECLARE @FechaLimite DATE;
    DECLARE @MesSiguiente DATE;
    
    -- Obtener el primer día del mes siguiente
    SET @MesSiguiente = DATEADD(MONTH, DATEDIFF(MONTH, 0, @FechaOperacion) + 1, 0);
    
    -- El día 17 del mes siguiente
    SET @FechaLimite = DATEADD(DAY, 16, @MesSiguiente);
    
    RETURN @FechaLimite;
END
GO

-- =============================================
-- Función: ObtenerInicioMes
-- Descripción: Obtiene el primer día del mes para una fecha
-- =============================================
IF OBJECT_ID('dbo.ObtenerInicioMes', 'FN') IS NOT NULL
    DROP FUNCTION dbo.ObtenerInicioMes;
GO

CREATE FUNCTION dbo.ObtenerInicioMes
(
    @Fecha DATE
)
RETURNS DATE
AS
BEGIN
    RETURN DATEADD(MONTH, DATEDIFF(MONTH, 0, @Fecha), 0);
END
GO

-- =============================================
-- Función: ObtenerFinMes
-- Descripción: Obtiene el último día del mes para una fecha
-- =============================================
IF OBJECT_ID('dbo.ObtenerFinMes', 'FN') IS NOT NULL
    DROP FUNCTION dbo.ObtenerFinMes;
GO

CREATE FUNCTION dbo.ObtenerFinMes
(
    @Fecha DATE
)
RETURNS DATE
AS
BEGIN
    RETURN EOMONTH(@Fecha);
END
GO

-- =============================================
-- Función: EvaluarSuperaUmbralIdentificacion
-- Descripción: Evalúa si un monto supera el umbral de identificación
-- =============================================
IF OBJECT_ID('dbo.EvaluarSuperaUmbralIdentificacion', 'FN') IS NOT NULL
    DROP FUNCTION dbo.EvaluarSuperaUmbralIdentificacion;
GO

CREATE FUNCTION dbo.EvaluarSuperaUmbralIdentificacion
(
    @ActividadVulnerableId INT,
    @Monto MONEY,
    @Fecha DATE
)
RETURNS BIT
AS
BEGIN
    DECLARE @MontoUMAs DECIMAL(18,4);
    DECLARE @UmbralUMAs INT;
    DECLARE @Supera BIT = 0;
    
    SET @MontoUMAs = dbo.ConvertirMontoAUMAs(@Monto, @Fecha);
    SET @UmbralUMAs = dbo.ObtenerUmbralIdentificacion(@ActividadVulnerableId);
    
    IF @UmbralUMAs > 0 AND @MontoUMAs >= @UmbralUMAs
        SET @Supera = 1;
    
    RETURN @Supera;
END
GO

-- =============================================
-- Función: EvaluarSuperaUmbralAviso
-- Descripción: Evalúa si un monto supera el umbral de aviso
-- =============================================
IF OBJECT_ID('dbo.EvaluarSuperaUmbralAviso', 'FN') IS NOT NULL
    DROP FUNCTION dbo.EvaluarSuperaUmbralAviso;
GO

CREATE FUNCTION dbo.EvaluarSuperaUmbralAviso
(
    @ActividadVulnerableId INT,
    @Monto MONEY,
    @Fecha DATE
)
RETURNS BIT
AS
BEGIN
    DECLARE @MontoUMAs DECIMAL(18,4);
    DECLARE @UmbralUMAs INT;
    DECLARE @Supera BIT = 0;
    
    SET @MontoUMAs = dbo.ConvertirMontoAUMAs(@Monto, @Fecha);
    SET @UmbralUMAs = dbo.ObtenerUmbralAviso(@ActividadVulnerableId);
    
    IF @UmbralUMAs > 0 AND @MontoUMAs >= @UmbralUMAs
        SET @Supera = 1;
    
    RETURN @Supera;
END
GO

-- =============================================
-- Función TVF: ObtenerOperacionesMesCliente
-- Descripción: Obtiene las operaciones de un cliente en un mes específico
-- =============================================
IF OBJECT_ID('dbo.ObtenerOperacionesMesCliente', 'IF') IS NOT NULL
    DROP FUNCTION dbo.ObtenerOperacionesMesCliente;
GO

CREATE FUNCTION dbo.ObtenerOperacionesMesCliente
(
    @EmpresaId INT,
    @ClienteId INT,
    @ActividadVulnerableId INT,
    @Mes INT,
    @Anio INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        o.Id AS OperacionId,
        o.ClienteId,
        o.FechaOperacion,
        o.Monto,
        o.DivisaId,
        o.FactorDivisa,
        CASE 
            WHEN o.DivisaId = 1 THEN o.Monto -- Asumiendo DivisaId=1 es MXN
            ELSE o.Monto * ISNULL(o.FactorDivisa, 1)
        END AS MontoMXN,
        dbo.ConvertirMontoAUMAs(
            CASE 
                WHEN o.DivisaId = 1 THEN o.Monto
                ELSE o.Monto * ISNULL(o.FactorDivisa, 1)
            END,
            o.FechaOperacion
        ) AS MontoUMAs,
        o.TipoOperacionId,
        o.TipoSubOperacionId,
        o.ProductoServicioId,
        o.FolioOperacion
    FROM dbo.Operacion o
    INNER JOIN dbo.EmpresaActividadVulnerable eav ON o.EmpresaActividadVulnerableId = eav.EmpresaActividadVulnerableId
    WHERE eav.EmpresaId = @EmpresaId
      AND o.ClienteId = @ClienteId
      AND eav.ActividadVulnerableId = @ActividadVulnerableId
      AND MONTH(o.FechaOperacion) = @Mes
      AND YEAR(o.FechaOperacion) = @Anio
      AND o.EstaActivo = 1
);
GO

-- =============================================
-- Función TVF: ObtenerResumenAcumuladoMensual
-- Descripción: Calcula el resumen acumulado mensual por cliente
-- =============================================
IF OBJECT_ID('dbo.ObtenerResumenAcumuladoMensual', 'IF') IS NOT NULL
    DROP FUNCTION dbo.ObtenerResumenAcumuladoMensual;
GO

CREATE FUNCTION dbo.ObtenerResumenAcumuladoMensual
(
    @EmpresaId INT,
    @Mes INT,
    @Anio INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        eav.EmpresaId,
        o.ClienteId,
        eav.ActividadVulnerableId,
        @Mes AS PeriodoMes,
        @Anio AS PeriodoAnio,
        SUM(CASE 
            WHEN o.DivisaId = 1 THEN o.Monto
            ELSE o.Monto * ISNULL(o.FactorDivisa, 1)
        END) AS MontoAcumulado,
        SUM(dbo.ConvertirMontoAUMAs(
            CASE 
                WHEN o.DivisaId = 1 THEN o.Monto
                ELSE o.Monto * ISNULL(o.FactorDivisa, 1)
            END,
            o.FechaOperacion
        )) AS MontoAcumuladoUMAs,
        COUNT(*) AS NumeroOperaciones,
        MIN(o.FechaOperacion) AS PrimeraOperacion,
        MAX(o.FechaOperacion) AS UltimaOperacion
    FROM dbo.Operacion o
    INNER JOIN dbo.EmpresaActividadVulnerable eav ON o.EmpresaActividadVulnerableId = eav.EmpresaActividadVulnerableId
    WHERE eav.EmpresaId = @EmpresaId
      AND MONTH(o.FechaOperacion) = @Mes
      AND YEAR(o.FechaOperacion) = @Anio
      AND o.EstaActivo = 1
      AND o.ClienteId IS NOT NULL
    GROUP BY eav.EmpresaId, o.ClienteId, eav.ActividadVulnerableId
);
GO

PRINT 'Funciones de monitoreo creadas exitosamente.';
GO
