

|Tabla	|Archivos creados|
|-------|----------------|
|Persona	|InsertarPersona.sql, ActualizarPersona.sql, EliminarPersona.sql, ObtenerPersona.sql|
|Domicilio	|InsertarDomicilio.sql, ActualizarDomicilio.sql, EliminarDomicilio.sql, ObtenerDomicilio.sql|
|PersonaDomicilio	|InsertarPersonaDomicilio.sql, ActualizarPersonaDomicilio.sql, EliminarPersonaDomicilio.sql, ObtenerPersonaDomicilio.sql|
|BeneficiarioControlador	|InsertarBeneficiarioControlador.sql, ActualizarBeneficiarioControlador.sql, EliminarBeneficiarioControlador.sql, ObtenerBeneficiarioControlador.sql, ListarBeneficiarioControladorPorEmpresaIdClienteId.sql|
|DocumentoBeneficiarioControlador	|InsertarDocumentoBeneficiarioControlador.sql, ActualizarDocumentoBeneficiarioControlador.sql, EliminarDocumentoBeneficiarioControlador.sql, ObtenerDocumentoBeneficiarioControlador.sql, ListarDocumentoBeneficiarioControladorPorBeneficiarioControladorId.sql|
|DocumentoKYC	|InsertarDocumentoKYC.sql, ActualizarDocumentoKYC.sql, EliminarDocumentoKYC.sql, ObtenerDocumentoKYC.sql, ListarDocumentoKYCPorEmpresaIdClienteId.sql|

IMPORTANTE:
- Nomenclatura [Verbo][Tabla] sin prefijos
- RETURN 0 = éxito, RETURN -1 = error
- Parámetro @RETURN_MESSAGE VARCHAR(MAX) OUTPUT en todos
- Inserts devuelven el ID generado via parámetro OUTPUT
- TRY/CATCH almacenando ERROR_MESSAGE() en @RETURN_MESSAGE
- Sin transacciones explícitas
- Update/Delete validan @@ROWCOUNT y retornan -1 con mensaje si no hubo cambios
- Eliminación lógica (soft delete) con EstaActivo = 0
