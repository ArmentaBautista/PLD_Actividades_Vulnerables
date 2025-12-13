
1. Analiza los archivos que contienen la definición de tablas de sql server:
    1. Persona.sql
    2. Domicilio.sql
    3. PersonaDomicilio.sql
    4. BeneficiarioControlador.sql
    5. DocumentoBeneficiarioControlador.sql
    6. DocumentoKYC.sql

2. Crea en en el directorio "Procedimientos Almacenados", crea los procedimientos almacenados necesarios por cada tabla, para cubrir las siguientes operaciones:
   1. Inserción
   2. Actualización
   3. Eliminación
   4. Consulta por Identificador del registro
3. Debes crear un arvhivo por procedimiento almacenado
4. La nomenclatura de nombrado es: [Verbo][Tabla] ejemplo: InsertarPersona. No utilices ningun otro prefijo.
5. Utiliza el valor de retorno (@RETURN_VALUE) de los procedimientos en sql server, para informar que el resultado fue positivo (0) o negativo (-1).
6. Adicionalmente a los parámetros que determines para los procedimientos almacenados, debes agregar un parámetro más: @RETURN_MESSAGE VARCHAR(MAX) OUTPUT
7. Cada procedimiento almacenado de inserción, debe devover en un parámetro de salida, el valor del Identificador generado para el registro creado
8. Utiliza TRY CATCH dentro de los procedimientos y en caso de error, almacena el mensaje en @RETURN_MESSAGE
9. No uses transacciones explisitas en los procedimientos almacenados.
10. Para los procedimientos almacenados de Actualización y Borrado, @RETURN_VALUE será 0, si y solo si hubo modificación de registros, de lo contrario será -1 y en @RETURN_VALUE incluirse el mensaje "No fue posible realizar la operación, no hubo cambios"
11. Sigue buenas prácticas de diseño y programación, pero sin que contravengan las indicaciones previas a este punto.


