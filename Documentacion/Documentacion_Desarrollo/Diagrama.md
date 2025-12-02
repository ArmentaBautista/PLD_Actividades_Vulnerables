erDiagram
  CLIENTS ||--o{ BENEFICIARIES : tiene
  CLIENTS ||--o{ KYC_DOCUMENTS : posee
  CLIENTS ||--o{ OPERATIONS : ejecuta
  CLIENTS ||--o{ RISK_SCORES : evaluado_por
  OPERATIONS ||--o{ ALERTS : genera
  USERS ||--o{ ALERTS : asigna
  USERS ||--o{ AUDIT_LOGS : realiza

  CLIENTS {
    UUID client_id
    TEXT nombre_razon
    TEXT tipo_cliente
    JSON domicile
  }
  OPERATIONS {
    UUID op_id
    UUID client_id
    VARCHAR actividad_fraccion
    NUMERIC monto
    TIMESTAMP fecha_operacion
    JSON metadata
  }
  RISK_SCORES {
    UUID risk_id
    UUID client_id
    NUMERIC score_num
    VARCHAR nivel
  }
