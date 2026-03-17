-- =============================================
-- Datos Iniciales para el Motor de Monitoreo PLD
-- =============================================
-- Ejecutar después de crear las tablas

-- =============================================
-- 1. Valores del UMA
-- =============================================
IF NOT EXISTS (SELECT 1 FROM dbo.ValorUMA WHERE YEAR(InicioVigencia) = 2025)
BEGIN
    INSERT INTO dbo.ValorUMA (ValorDiario, ValorMensual, ValorAnual, InicioVigencia, FinVigencia)
    VALUES 
        (113.14, 3441.80, 41301.60, '2025-01-01', '2025-12-31');
    
    PRINT 'Valor UMA 2025 insertado.';
END
GO

-- Valores históricos de referencia
IF NOT EXISTS (SELECT 1 FROM dbo.ValorUMA WHERE YEAR(InicioVigencia) = 2024)
BEGIN
    INSERT INTO dbo.ValorUMA (ValorDiario, ValorMensual, ValorAnual, InicioVigencia, FinVigencia)
    VALUES 
        (108.57, 3302.30, 39627.60, '2024-01-01', '2024-12-31');
    
    PRINT 'Valor UMA 2024 insertado.';
END
GO

-- =============================================
-- 2. Catálogo de Actividades Vulnerables
-- =============================================
-- Insertar actividades vulnerables si no existen
IF NOT EXISTS (SELECT 1 FROM dbo.ActividadVulnerable WHERE Codigo = 'AV-01')
BEGIN
    INSERT INTO dbo.ActividadVulnerable (Codigo, Descripcion, UsuarioAltaId)
    VALUES 
        ('AV-01', 'Juegos con apuesta, concursos o sorteos', 1),
        ('AV-02', 'Emisión o comercialización de tarjetas de servicio o crédito', 1),
        ('AV-03', 'Emisión o comercialización de tarjetas prepagadas o monederos', 1),
        ('AV-04', 'Emisión o comercialización de cheques de viajero', 1),
        ('AV-05', 'Otorgamiento de mutuo, préstamo o crédito no financiero', 1),
        ('AV-06', 'Construcción, desarrollo o intermediación inmobiliaria', 1),
        ('AV-07', 'Comercialización de metales preciosos, joyas y piedras preciosas', 1),
        ('AV-08', 'Subasta o comercialización de obras de arte', 1),
        ('AV-09', 'Comercialización de vehículos terrestres, marítimos o aéreos', 1),
        ('AV-10', 'Servicios de blindaje de vehículos o inmuebles', 1),
        ('AV-11', 'Transporte o custodia de valores', 1),
        ('AV-12', 'Servicios profesionales independientes', 1),
        ('AV-13', 'Servicios de fe pública (notarios y corredores)', 1),
        ('AV-14', 'Comercio exterior (agentes aduanales)', 1),
        ('AV-15', 'Donativos de organizaciones sin fines de lucro', 1),
        ('AV-16', 'Arrendamiento de bienes inmuebles', 1),
        ('AV-17', 'Intercambio o custodia de activos virtuales', 1);
    
    PRINT 'Actividades Vulnerables insertadas.';
END
GO

-- =============================================
-- 3. Umbrales de Identificación (en UMAs)
-- =============================================
-- Basado en la Guía de Umbrales del Art. 17 LFPIORPI
IF NOT EXISTS (SELECT 1 FROM dbo.UmbralIdentificacionCliente)
BEGIN
    INSERT INTO dbo.UmbralIdentificacionCliente (ActividadVulnerableId, UmbralEnUMAs)
    SELECT av.ActividadVulnerableId, u.UmbralUMAs
    FROM dbo.ActividadVulnerable av
    CROSS APPLY (
        SELECT CASE av.Codigo
            WHEN 'AV-01' THEN 325    -- Juegos con apuesta
            WHEN 'AV-02' THEN 805    -- Tarjetas de crédito
            WHEN 'AV-03' THEN 645    -- Tarjetas prepagadas
            WHEN 'AV-04' THEN 645    -- Cheques de viajero
            WHEN 'AV-05' THEN 1605   -- Mutuos/préstamos
            WHEN 'AV-06' THEN 8025   -- Inmobiliaria
            WHEN 'AV-07' THEN 805    -- Metales preciosos
            WHEN 'AV-08' THEN 2410   -- Obras de arte
            WHEN 'AV-09' THEN 3210   -- Vehículos
            WHEN 'AV-10' THEN 2410   -- Blindaje
            WHEN 'AV-11' THEN 3210   -- Custodia valores
            WHEN 'AV-12' THEN 805    -- Servicios profesionales
            WHEN 'AV-13' THEN 8025   -- Fedatarios (variable)
            WHEN 'AV-14' THEN 645    -- Comercio exterior
            WHEN 'AV-15' THEN 1605   -- Donativos
            WHEN 'AV-16' THEN 1605   -- Arrendamiento
            WHEN 'AV-17' THEN 645    -- Activos virtuales
            ELSE 0
        END AS UmbralUMAs
    ) u
    WHERE u.UmbralUMAs > 0;
    
    PRINT 'Umbrales de Identificación insertados.';
END
GO

-- =============================================
-- 4. Umbrales de Presentación de Aviso (en UMAs)
-- =============================================
IF NOT EXISTS (SELECT 1 FROM dbo.UmbralPresentacionAviso)
BEGIN
    INSERT INTO dbo.UmbralPresentacionAviso (ActividadVulnerableId, UmbralEnUMAs)
    SELECT av.ActividadVulnerableId, u.UmbralUMAs
    FROM dbo.ActividadVulnerable av
    CROSS APPLY (
        SELECT CASE av.Codigo
            WHEN 'AV-01' THEN 645     -- Juegos con apuesta
            WHEN 'AV-02' THEN 1285    -- Tarjetas de crédito (corregido de guía)
            WHEN 'AV-03' THEN 645     -- Tarjetas prepagadas
            WHEN 'AV-04' THEN 645     -- Cheques de viajero
            WHEN 'AV-05' THEN 3210    -- Mutuos/préstamos
            WHEN 'AV-06' THEN 16050   -- Inmobiliaria (construcción/venta)
            WHEN 'AV-07' THEN 1605    -- Metales preciosos
            WHEN 'AV-08' THEN 4815    -- Obras de arte
            WHEN 'AV-09' THEN 6420    -- Vehículos
            WHEN 'AV-10' THEN 4815    -- Blindaje
            WHEN 'AV-11' THEN 6420    -- Custodia valores
            WHEN 'AV-12' THEN 1605    -- Servicios profesionales
            WHEN 'AV-13' THEN 16050   -- Fedatarios (variable, máximo)
            WHEN 'AV-14' THEN 645     -- Comercio exterior
            WHEN 'AV-15' THEN 3210    -- Donativos
            WHEN 'AV-16' THEN 3210    -- Arrendamiento
            WHEN 'AV-17' THEN 645     -- Activos virtuales
            ELSE 0
        END AS UmbralUMAs
    ) u
    WHERE u.UmbralUMAs > 0;
    
    PRINT 'Umbrales de Presentación de Aviso insertados.';
END
GO

-- =============================================
-- 5. Verificar datos insertados
-- =============================================
PRINT '';
PRINT '===========================================';
PRINT 'VERIFICACIÓN DE DATOS INICIALES';
PRINT '===========================================';

SELECT 'Valores UMA' AS Tabla, COUNT(*) AS Registros FROM dbo.ValorUMA
UNION ALL
SELECT 'Actividades Vulnerables', COUNT(*) FROM dbo.ActividadVulnerable
UNION ALL
SELECT 'Umbrales Identificación', COUNT(*) FROM dbo.UmbralIdentificacionCliente
UNION ALL
SELECT 'Umbrales Aviso', COUNT(*) FROM dbo.UmbralPresentacionAviso;

PRINT '';
PRINT 'DETALLE DE UMBRALES CONFIGURADOS:';
SELECT 
    av.Codigo,
    av.Descripcion AS ActividadVulnerable,
    ui.UmbralEnUMAs AS UmbralIdentificacionUMAs,
    dbo.ConvertirUMAsAPesos(ui.UmbralEnUMAs, GETDATE()) AS UmbralIdentificacionMXN,
    ua.UmbralEnUMAs AS UmbralAvisoUMAs,
    dbo.ConvertirUMAsAPesos(ua.UmbralEnUMAs, GETDATE()) AS UmbralAvisoMXN
FROM dbo.ActividadVulnerable av
LEFT JOIN dbo.UmbralIdentificacionCliente ui ON av.ActividadVulnerableId = ui.ActividadVulnerableId
LEFT JOIN dbo.UmbralPresentacionAviso ua ON av.ActividadVulnerableId = ua.ActividadVulnerableId
WHERE av.EstaActivo = 1
ORDER BY av.Codigo;

PRINT '';
PRINT 'Datos iniciales cargados exitosamente.';
GO
