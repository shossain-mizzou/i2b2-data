--------------------------------------------------------------------------------
-- QT_QUERY_MASTER
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_query_master (
  query_master_id    INT,
  name               STRING     NOT NULL,
  user_id            STRING     NOT NULL,
  group_id           STRING     NOT NULL,
  master_type_cd     STRING,
  plugin_id          INT,
  create_date        TIMESTAMP  NOT NULL,
  delete_date        TIMESTAMP,
  delete_flag        STRING,
  request_xml        STRING,
  generated_sql      STRING,
  i2b2_request_xml   STRING,
  pm_xml             STRING
)
USING iceberg;

--------------------------------------------------------------------------------
-- QT_QUERY_RESULT_TYPE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_query_result_type (
  result_type_id             INT,
  name                       STRING,
  description                STRING,
  display_type_id            STRING,
  visual_attribute_type_id   STRING,
  user_role_cd               STRING,
  classname                  STRING
)
USING iceberg;

--------------------------------------------------------------------------------
-- QT_QUERY_STATUS_TYPE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_query_status_type (
  status_type_id INT,
  name           STRING,
  description    STRING
)
USING iceberg;

--------------------------------------------------------------------------------
-- QT_QUERY_INSTANCE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_query_instance (
  query_instance_id INT,
  query_master_id   INT,
  user_id           STRING     NOT NULL,
  group_id          STRING     NOT NULL,
  batch_mode        STRING,
  start_date        TIMESTAMP  NOT NULL,
  end_date          TIMESTAMP,
  delete_flag       STRING,
  status_type_id    INT,
  message           STRING
)
USING iceberg;

--------------------------------------------------------------------------------
-- QT_QUERY_RESULT_INSTANCE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_query_result_instance (
  result_instance_id INT,
  query_instance_id  INT,
  result_type_id     INT        NOT NULL,
  set_size           INT,
  start_date         TIMESTAMP  NOT NULL,
  end_date           TIMESTAMP,
  status_type_id     INT        NOT NULL,
  delete_flag        STRING,
  message            STRING,
  description        STRING,
  real_set_size      INT,
  obfus_method       STRING
)
USING iceberg;

--------------------------------------------------------------------------------
-- QT_PATIENT_SET_COLLECTION
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_patient_set_collection (
  patient_set_coll_id BIGINT,
  result_instance_id  INT,
  set_index           INT,
  patient_num         INT
)
USING iceberg;

--------------------------------------------------------------------------------
-- QT_PATIENT_ENC_COLLECTION
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_patient_enc_collection (
  patient_enc_coll_id BIGINT,
  result_instance_id  INT,
  set_index           INT,
  patient_num         INT,
  encounter_num       INT
)
USING iceberg;

--------------------------------------------------------------------------------
-- QT_XML_RESULT
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_xml_result (
  xml_result_id     INT,
  result_instance_id INT,
  xml_value         STRING
)
USING iceberg;

--------------------------------------------------------------------------------
-- QT_ANALYSIS_PLUGIN
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_analysis_plugin (
  plugin_id         INT,
  plugin_name       STRING,
  description       STRING,
  version_cd        STRING,
  parameter_info    STRING,
  parameter_info_xsd STRING,
  command_line      STRING,
  working_folder    STRING,
  commandoption_cd  STRING,
  plugin_icon       STRING,
  status_cd         STRING,
  user_id           STRING,
  group_id          STRING,
  create_date       TIMESTAMP,
  update_date       TIMESTAMP
)
USING iceberg;

--------------------------------------------------------------------------------
-- QT_ANALYSIS_PLUGIN_RESULT_TYPE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_analysis_plugin_result_type (
  plugin_id       INT,
  result_type_id  INT
)
USING iceberg;

--------------------------------------------------------------------------------
-- QT_PRIVILEGE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_privilege (
  protection_label_cd STRING,
  dataprot_cd         STRING,
  hivemgmt_cd         STRING,
  plugin_id           INT
)
USING iceberg;

--------------------------------------------------------------------------------
-- QT_BREAKDOWN_PATH
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_breakdown_path (
  name         STRING,
  value        STRING,
  create_date  TIMESTAMP,
  update_date  TIMESTAMP,
  user_id      STRING
)
USING iceberg;

--------------------------------------------------------------------------------
-- QT_PDO_QUERY_MASTER
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE qt_pdo_query_master (
  query_master_id   INT,
  user_id           STRING     NOT NULL,
  group_id          STRING     NOT NULL,
  create_date       TIMESTAMP  NOT NULL,
  request_xml       STRING,
  i2b2_request_xml  STRING
)
USING iceberg;

-- INIT WITH SEED DATA

INSERT INTO qt_query_status_type(status_type_id, name, description)
VALUES
  (1, 'QUEUED',   ' WAITING IN QUEUE TO START PROCESS'),
  (2, 'PROCESSING','PROCESSING'),
  (3, 'FINISHED', 'FINISHED'),
  (4, 'ERROR',    'ERROR'),
  (5, 'INCOMPLETE','INCOMPLETE'),
  (6, 'COMPLETED','COMPLETED'),
  (7, 'MEDIUM_QUEUE','MEDIUM QUEUE'),
  (8, 'LARGE_QUEUE','LARGE QUEUE'),
  (9, 'CANCELLED','CANCELLED'),
  (10,'TIMEDOUT','TIMEDOUT')
;

INSERT INTO qt_query_result_type(
  result_type_id,
  name,
  description,
  display_type_id,
  visual_attribute_type_id,
  classname,
  user_role_cd
)
VALUES
  (1,   'PATIENTSET',             'Patient set',                 'LIST','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientSetGenerator', NULL),
  (2,   'PATIENT_ENCOUNTER_SET',  'Encounter set',               'LIST','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultEncounterSetGenerator', NULL),
  (3,   'XML',                    'Generic query result',        'CATNUM','LH', NULL,                                         NULL),
  (4,   'PATIENT_COUNT_XML',      'Number of patients',          'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientCountGenerator', NULL),
  (5,   'PATIENT_GENDER_COUNT_XML','Gender patient breakdown',   'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultGenerator', NULL),
  (6,   'PATIENT_VITALSTATUS_COUNT_XML','Vital Status patient breakdown','CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultGenerator', NULL),
  (7,   'PATIENT_RACE_COUNT_XML',  'Race patient breakdown',      'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultGenerator', NULL),
  (8,   'PATIENT_AGE_COUNT_XML',   'Age patient breakdown',       'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultGenerator', NULL),
  (9,   'PATIENTSET',             'Timeline',                    'LIST','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientSetGenerator', NULL),
  (10,  'PATIENT_LOS_XML',        'Length of stay breakdown',    'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientSQLCountGenerator','DATA_LDS'),
  (11,  'PATIENT_TOP20MEDS_XML',  'Top 20 medications breakdown','CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientSQLCountGenerator','DATA_LDS'),
  (12,  'PATIENT_TOP20DIAG_XML',  'Top 20 diagnoses breakdown',  'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientSQLCountGenerator','DATA_LDS'),
  (13,  'PATIENT_INOUT_XML',      'Inpatient and outpatient breakdown','CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientSQLCountGenerator','DATA_LDS'),
  (114, 'PATIENT_DEMOGRAPHIC_REQUEST','Request Demographics Data','CATNUM','LR','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientRequest','DATA_LDS'),
  (115, 'PATIENT_MEDICATION_REQUEST','Request Medication Data',   'CATNUM','LR','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientRequest','DATA_LDS'),
  (116, 'PATIENT_PROCEDURE_REQUEST','Request Procedure Data',     'CATNUM','LR','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientRequest','DATA_LDS'),
  (117, 'PATIENT_DIAGNOSIS_REQUEST','Request Diagnosis Data',     'CATNUM','LR','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientRequest','DATA_LDS'),
  (118, 'PATIENT_LAB_REQUEST',    'Request Lab Data',            'CATNUM','LR','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientRequest','DATA_LDS'),
  (119, 'PATIENT_DEMOGRAPHIC_CSV','Export Demographics Data',   'CATNUM','LX','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientDownload','MANAGER'),
  (120, 'PATIENT_MEDICATION_CSV', 'Export Medication Data',      'CATNUM','LX','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientDownload','MANAGER'),
  (121, 'PATIENT_PROCEDURE_CSV',  'Export Procedure Data',       'CATNUM','LX','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientDownload','MANAGER'),
  (122, 'PATIENT_DIAGNOSIS_CSV',  'Export Diagnosis Data',       'CATNUM','LX','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientDownload','MANAGER'),
  (123, 'PATIENT_LAB_CSV',        'Export Lab Data',             'CATNUM','LX','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientDownload','MANAGER'),
  (124, 'PATIENT_MAPPING_CSV',    'Export Patient Mapping',      'CATNUM','LX','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientDownload','MANAGER'),
  (126, 'PATIENT_MAPPING_REQUEST','Request Patient Mapping',     'CATNUM','LR','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientRequest','DATA_LDS')
;
INSERT INTO qt_privilege(protection_label_cd, dataprot_cd, hivemgmt_cd, plugin_id)
VALUES
  ('pdo_without_blob', 'data_lds', 'user', NULL),
  ('pdo_with_blob','data_deid','user', NULL),
  ('setfinder_qry_with_dataobfsc',    'data_obfsc','user', NULL),
  ('setfinder_qry_without_dataobfsc', 'data_agg',  'user', NULL),
  ('upload', 'data_obfsc','manager', NULL),
  ('setfinder_qry_with_lgtext', 'data_deid','user', NULL),
  ('setfinder_qry_protected', 'data_prot','user', NULL)
;
