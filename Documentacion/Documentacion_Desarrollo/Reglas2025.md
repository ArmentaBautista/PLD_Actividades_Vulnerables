

|Regla|¿Por qué?|
|-----|---------|
|Nunca uses el prefijo sp_|SQL Server busca primero en master → impacto en rendimiento y caché|
|Evita prefijos en procedimientos|"usp_, proc_, pr_ son legacy. Hoy se prefiere nombre descriptivo puro"|
|Usa verbos en procedimientos|"Create, Update, Delete, Get, Calculate, Process, Generate"|
|Usa Get para funciones de tabla|Es el estándar que usa Microsoft en todos sus ejemplos actuales|
|Triggers sí pueden llevar tr|Es el único caso donde todavía se acepta casi universalmente prefijo|
|Siempre PascalCase|Coherencia con C#/.NET y con los nombres de clases/entidades|
|"Sé explícito, no abrevies"|Customer_Create es mejor que CustIns o InsCust|



