CREATE PROCEDURE [dbo].[ListarMotivosSesionFallida]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [Id],
        [Descripcion]
    FROM [dbo].[MotivoSesionFallida]
    WHERE [EstaActivo] = 1
    ORDER BY [Descripcion];
END
GO
