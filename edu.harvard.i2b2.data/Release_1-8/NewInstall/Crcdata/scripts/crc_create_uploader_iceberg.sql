--------------------------------------------------------------------------------
-- DATAMART_REPORT
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE datamart_report (
  total_patient         INT,
  total_observationfact INT,
  total_event           INT,
  report_date           TIMESTAMP
)
USING iceberg;

--------------------------------------------------------------------------------
-- UPLOAD_STATUS
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE upload_status (
  upload_id       INT,
  upload_label    STRING     NOT NULL,
  user_id         STRING     NOT NULL,
  source_cd       STRING     NOT NULL,
  no_of_record    BIGINT,
  loaded_record   BIGINT,
  deleted_record  BIGINT,
  load_date       TIMESTAMP  NOT NULL,
  end_date        TIMESTAMP,
  load_status     STRING,
  message         STRING,
  input_file_name STRING,
  log_file_name   STRING,
  transform_name  STRING
)
USING iceberg;

--------------------------------------------------------------------------------
-- SET_TYPE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE set_type (
  id          INT,
  name        STRING,
  create_date TIMESTAMP
)
USING iceberg;

--------------------------------------------------------------------------------
-- SOURCE_MASTER
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE source_master (
  source_cd    STRING     NOT NULL,
  description  STRING,
  create_date  TIMESTAMP
)
USING iceberg;

--------------------------------------------------------------------------------
-- SET_UPLOAD_STATUS
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE set_upload_status (
  upload_id      INT,
  set_type_id    INT,
  source_cd      STRING     NOT NULL,
  no_of_record   BIGINT,
  loaded_record  BIGINT,
  deleted_record BIGINT,
  load_date      TIMESTAMP  NOT NULL,
  end_date       TIMESTAMP,
  load_status    STRING,
  message        STRING,
  input_file_name STRING,
  log_file_name   STRING,
  transform_name  STRING
)
USING iceberg;

--------------------------------------------------------------------------------
-- Seed data for SET_TYPE
--------------------------------------------------------------------------------
INSERT INTO set_type VALUES
  (1,'event_set',   current_timestamp()),
  (2,'patient_set', current_timestamp()),
  (3,'concept_set', current_timestamp()),
  (4,'observer_set',current_timestamp()),
  (5,'observation_set',current_timestamp()),
  (6,'pid_set',     current_timestamp()),
  (7,'eid_set',     current_timestamp()),
  (8,'modifier_set',current_timestamp());
