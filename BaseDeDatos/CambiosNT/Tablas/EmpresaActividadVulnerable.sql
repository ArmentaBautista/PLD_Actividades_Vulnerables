

if OBJECT_ID('dbo.EmpresaActividadVulnerable') is NULL
BEGIN
    create table dbo.EmpresaActividadVulnerable
    (
        EmpresaActividadVulnerableId int identity(1,1) primary key,
        EmpresaId int not null,
        ActividadVulnerableId int not null,
        [FechaAlta] [DATETIME] NOT NULL,
        [HoraAlta] [TIME](7) NOT NULL,
        [UsuarioAltaId] [INT] NOT NULL,
        [FechaBaja] [DATETIME] NULL,
        [HoraBaja] [TIME](7) NULL,
        [UsuarioBajaId] [INT] NULL,
        [EstaActivo] [BIT] NOT NULL,

        CONSTRAINT FK_EmpresaActividadVulnerable_Empresa 
            FOREIGN KEY (EmpresaId) REFERENCES Empresa(EmpresaId),
        CONSTRAINT FK_EmpresaActividadVulnerable_ActividadVulnerable 
            FOREIGN KEY (ActividadVulnerableId) REFERENCES ActividadVulnerable(ActividadVulnerableId)
    )

    SELECT 'Se creo la tabla EmpresaActividadVulnerable' as info
END
GO

IF NOT EXISTS(select 1 from sys.indexes i 
                where i.object_id = OBJECT_ID('dbo.EmpresaActividadVulnerable')
                and i.name = 'IX_EmpresaActividadVulnerable_EmpresaId')
BEGIN
   create INDEX IX_EmpresaActividadVulnerable_EmpresaId ON dbo.EmpresaActividadVulnerable(EmpresaId)
   select 'Se creo el indice IX_EmpresaActividadVulnerable_EmpresaId' as info
END
GO

IF NOT EXISTS(select 1 from sys.indexes i 
                where i.object_id = OBJECT_ID('dbo.EmpresaActividadVulnerable')
                and i.name = 'IX_EmpresaActividadVulnerable_ActividadVulnerableId')
BEGIN
   create INDEX IX_EmpresaActividadVulnerable_ActividadVulnerableId ON dbo.EmpresaActividadVulnerable(ActividadVulnerableId)
   select 'Se creo el indice IX_EmpresaActividadVulnerable_ActividadVulnerableId' as info
END
GO

