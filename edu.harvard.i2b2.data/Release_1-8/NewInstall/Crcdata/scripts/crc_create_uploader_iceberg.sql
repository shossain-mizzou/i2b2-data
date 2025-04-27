--------------------------------------------------------------------------------
-- DATAMART_REPORT
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE DATAMART_REPORT (
  TOTAL_PATIENT         INT,
  TOTAL_OBSERVATIONFACT INT,
  TOTAL_EVENT           INT,
  REPORT_DATE           TIMESTAMP
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- UPLOAD_STATUS
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE UPLOAD_STATUS (
  UPLOAD_ID        INT,
  UPLOAD_LABEL     STRING   NOT NULL,
  USER_ID          STRING   NOT NULL,
  SOURCE_CD        STRING   NOT NULL,
  NO_OF_RECORD     BIGINT,
  LOADED_RECORD    BIGINT,
  DELETED_RECORD   BIGINT,
  LOAD_DATE        TIMESTAMP NOT NULL,
  END_DATE         TIMESTAMP,
  LOAD_STATUS      STRING,
  MESSAGE          STRING,
  INPUT_FILE_NAME  STRING,
  LOG_FILE_NAME    STRING,
  TRANSFORM_NAME   STRING
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- SET_TYPE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE SET_TYPE (
  ID           INT,
  NAME         STRING,
  CREATE_DATE  TIMESTAMP
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- SOURCE_MASTER
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE SOURCE_MASTER (
  SOURCE_CD    STRING   NOT NULL,
  DESCRIPTION  STRING,
  CREATE_DATE  TIMESTAMP
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- SET_UPLOAD_STATUS
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE SET_UPLOAD_STATUS (
  UPLOAD_ID       INT,
  SET_TYPE_ID     INT,
  SOURCE_CD       STRING   NOT NULL,
  NO_OF_RECORD    BIGINT,
  LOADED_RECORD   BIGINT,
  DELETED_RECORD  BIGINT,
  LOAD_DATE       TIMESTAMP NOT NULL,
  END_DATE        TIMESTAMP,
  LOAD_STATUS     STRING,
  MESSAGE         STRING,
  INPUT_FILE_NAME STRING,
  LOG_FILE_NAME   STRING,
  TRANSFORM_NAME  STRING
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- Seed data for SET_TYPE
--------------------------------------------------------------------------------
INSERT INTO SET_TYPE VALUES
  (1, 'EVENT_SET',      CURRENT_TIMESTAMP()),
  (2, 'PATIENT_SET',    CURRENT_TIMESTAMP()),
  (3, 'CONCEPT_SET',    CURRENT_TIMESTAMP()),
  (4, 'OBSERVER_SET',   CURRENT_TIMESTAMP()),
  (5, 'OBSERVATION_SET',CURRENT_TIMESTAMP()),
  (6, 'PID_SET',        CURRENT_TIMESTAMP()),
  (7, 'EID_SET',        CURRENT_TIMESTAMP()),
  (8, 'MODIFIER_SET',   CURRENT_TIMESTAMP());
