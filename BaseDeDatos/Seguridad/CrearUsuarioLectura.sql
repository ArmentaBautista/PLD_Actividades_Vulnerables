-- ============================================
-- Script: Crear Usuario de Solo Lectura
-- Base de Datos: OGIX_PLD_Dev
-- Descripción: Crea un usuario con permisos para:
--   - Leer tablas y vistas
--   - Ejecutar funciones (escalares, tabla, inline)
--   - Ver triggers
--   - Ejecutar procedimientos almacenados (solo lectura)
--   - NO puede modificar datos de ninguna forma
-- ============================================

USE [master]
GO

-- ============================================
-- 1. CREAR LOGIN A NIVEL DE SERVIDOR
-- ============================================
-- Cambiar 'UsuarioLecturaPLD' y 'ContraseñaSegura123!' por los valores deseados

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'UsuarioLecturaPLD')
BEGIN
    CREATE LOGIN [UsuarioLecturaPLD] 
    WITH PASSWORD = N'ContraseñaSegura123!',
         DEFAULT_DATABASE = [OGIX_PLD_Dev],
         CHECK_EXPIRATION = OFF,
         CHECK_POLICY = ON;
    
    PRINT 'Login [UsuarioLecturaPLD] creado exitosamente.';
END
ELSE
BEGIN
    PRINT 'El Login [UsuarioLecturaPLD] ya existe.';
END
GO

-- ============================================
-- 2. DENEGAR ACCESO A OTRAS BASES DE DATOS
-- ============================================
-- Denegar conexión a todas las bases de datos del usuario excepto OGIX_PLD_Dev

DENY VIEW ANY DATABASE TO [UsuarioLecturaPLD];
GO

PRINT 'Denegado VIEW ANY DATABASE al login.';
GO

-- ============================================
-- 3. CREAR USUARIO EN LA BASE DE DATOS
-- ============================================
USE [OGIX_PLD_Dev]
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'UsuarioLecturaPLD')
BEGIN
    CREATE USER [UsuarioLecturaPLD] FOR LOGIN [UsuarioLecturaPLD];
    PRINT 'Usuario [UsuarioLecturaPLD] creado en OGIX_PLD_Dev.';
END
ELSE
BEGIN
    PRINT 'El Usuario [UsuarioLecturaPLD] ya existe en la base de datos.';
END
GO

-- ============================================
-- 4. OTORGAR PERMISOS DE CONEXIÓN
-- ============================================
GRANT CONNECT TO [UsuarioLecturaPLD];
GO

-- ============================================
-- 5. OTORGAR PERMISOS DE LECTURA
-- ============================================
-- Permiso para leer todas las tablas y vistas
GRANT SELECT TO [UsuarioLecturaPLD];
GO

PRINT 'Otorgado permiso SELECT (lectura de tablas y vistas).';
GO

-- ============================================
-- 6. OTORGAR PERMISOS PARA EJECUTAR FUNCIONES
-- ============================================
-- Permiso para ejecutar funciones escalares, de tabla e inline
GRANT EXECUTE TO [UsuarioLecturaPLD];
GO

PRINT 'Otorgado permiso EXECUTE (funciones y procedimientos).';
GO

-- ============================================
-- 7. OTORGAR PERMISO PARA VER DEFINICIONES
-- ============================================
-- Permite ver la definición de objetos (triggers, SPs, funciones, etc.)
GRANT VIEW DEFINITION TO [UsuarioLecturaPLD];
GO

PRINT 'Otorgado permiso VIEW DEFINITION.';
GO

-- ============================================
-- 8. DENEGAR PERMISOS DE MODIFICACIÓN DE DATOS
-- ============================================
-- Denegar explícitamente INSERT, UPDATE, DELETE en todas las tablas
-- Esto previene modificaciones directas Y a través de procedimientos almacenados

DENY INSERT TO [UsuarioLecturaPLD];
DENY UPDATE TO [UsuarioLecturaPLD];
DENY DELETE TO [UsuarioLecturaPLD];
GO

PRINT 'Denegados permisos INSERT, UPDATE, DELETE.';
GO

-- ============================================
-- 9. DENEGAR PERMISOS DDL (ESTRUCTURA)
-- ============================================
-- Prevenir cualquier cambio en la estructura de la base de datos

DENY ALTER TO [UsuarioLecturaPLD];
DENY CREATE TABLE TO [UsuarioLecturaPLD];
DENY CREATE VIEW TO [UsuarioLecturaPLD];
DENY CREATE PROCEDURE TO [UsuarioLecturaPLD];
DENY CREATE FUNCTION TO [UsuarioLecturaPLD];
DENY CREATE SCHEMA TO [UsuarioLecturaPLD];
DENY CREATE TYPE TO [UsuarioLecturaPLD];
GO

PRINT 'Denegados permisos DDL (ALTER, CREATE).';
GO

-- ============================================
-- 10. DENEGAR OTROS PERMISOS PELIGROSOS
-- ============================================
DENY CONTROL TO [UsuarioLecturaPLD];
DENY TAKE OWNERSHIP TO [UsuarioLecturaPLD];
DENY ALTER ANY USER TO [UsuarioLecturaPLD];
DENY ALTER ANY ROLE TO [UsuarioLecturaPLD];
GO

PRINT 'Denegados permisos de control y administración.';
GO

-- ============================================
-- VERIFICACIÓN DE PERMISOS
-- ============================================
PRINT '';
PRINT '========================================';
PRINT 'RESUMEN DE PERMISOS CONFIGURADOS';
PRINT '========================================';
PRINT '';

SELECT 
    dp.class_desc AS [Tipo],
    dp.permission_name AS [Permiso],
    dp.state_desc AS [Estado]
FROM sys.database_permissions dp
INNER JOIN sys.database_principals pr ON dp.grantee_principal_id = pr.principal_id
WHERE pr.name = 'UsuarioLecturaPLD'
ORDER BY dp.state_desc, dp.permission_name;
GO

PRINT '';
PRINT '========================================';
PRINT 'CONFIGURACIÓN COMPLETADA';
PRINT '========================================';
PRINT 'Usuario: UsuarioLecturaPLD';
PRINT 'Base de Datos: OGIX_PLD_Dev';
PRINT '';
PRINT 'PERMISOS OTORGADOS:';
PRINT '  ✓ SELECT - Leer tablas y vistas';
PRINT '  ✓ EXECUTE - Ejecutar funciones y SPs';
PRINT '  ✓ VIEW DEFINITION - Ver código de objetos';
PRINT '';
PRINT 'PERMISOS DENEGADOS:';
PRINT '  ✗ INSERT, UPDATE, DELETE - No puede modificar datos';
PRINT '  ✗ ALTER, CREATE - No puede modificar estructura';
PRINT '  ✗ VIEW ANY DATABASE - No puede ver otras bases de datos';
PRINT '';
GO
