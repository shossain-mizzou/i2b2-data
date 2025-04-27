--------------------------------------------------------------------------------
-- QT_QUERY_MASTER
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_QUERY_MASTER (
  QUERY_MASTER_ID    INT,
  NAME               STRING     NOT NULL,
  USER_ID            STRING     NOT NULL,
  GROUP_ID           STRING     NOT NULL,
  MASTER_TYPE_CD     STRING,
  PLUGIN_ID          INT,
  CREATE_DATE        TIMESTAMP  NOT NULL,
  DELETE_DATE        TIMESTAMP,
  DELETE_FLAG        STRING,
  REQUEST_XML        STRING,
  GENERATED_SQL      STRING,
  I2B2_REQUEST_XML   STRING,
  PM_XML             STRING
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- QT_QUERY_RESULT_TYPE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_QUERY_RESULT_TYPE (
  RESULT_TYPE_ID             INT,
  NAME                       STRING,
  DESCRIPTION                STRING,
  DISPLAY_TYPE_ID            STRING,
  VISUAL_ATTRIBUTE_TYPE_ID   STRING,
  USER_ROLE_CD               STRING,
  CLASSNAME                  STRING
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- QT_QUERY_STATUS_TYPE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_QUERY_STATUS_TYPE (
  STATUS_TYPE_ID INT,
  NAME           STRING,
  DESCRIPTION    STRING
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- QT_QUERY_INSTANCE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_QUERY_INSTANCE (
  QUERY_INSTANCE_ID INT,
  QUERY_MASTER_ID   INT,
  USER_ID           STRING     NOT NULL,
  GROUP_ID          STRING     NOT NULL,
  BATCH_MODE        STRING,
  START_DATE        TIMESTAMP  NOT NULL,
  END_DATE          TIMESTAMP,
  DELETE_FLAG       STRING,
  STATUS_TYPE_ID    INT,
  MESSAGE           STRING
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- QT_QUERY_RESULT_INSTANCE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_QUERY_RESULT_INSTANCE (
  RESULT_INSTANCE_ID INT,
  QUERY_INSTANCE_ID  INT,
  RESULT_TYPE_ID     INT        NOT NULL,
  SET_SIZE           INT,
  START_DATE         TIMESTAMP  NOT NULL,
  END_DATE           TIMESTAMP,
  STATUS_TYPE_ID     INT        NOT NULL,
  DELETE_FLAG        STRING,
  MESSAGE            STRING,
  DESCRIPTION        STRING,
  REAL_SET_SIZE      INT,
  OBFUS_METHOD       STRING
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- QT_PATIENT_SET_COLLECTION
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_PATIENT_SET_COLLECTION (
  PATIENT_SET_COLL_ID BIGINT,
  RESULT_INSTANCE_ID   INT,
  SET_INDEX            INT,
  PATIENT_NUM          INT
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- QT_PATIENT_ENC_COLLECTION
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_PATIENT_ENC_COLLECTION (
  PATIENT_ENC_COLL_ID BIGINT,
  RESULT_INSTANCE_ID  INT,
  SET_INDEX           INT,
  PATIENT_NUM         INT,
  ENCOUNTER_NUM       INT
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- QT_XML_RESULT
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_XML_RESULT (
  XML_RESULT_ID      INT,
  RESULT_INSTANCE_ID INT,
  XML_VALUE          STRING
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- QT_ANALYSIS_PLUGIN
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_ANALYSIS_PLUGIN (
  PLUGIN_ID           INT,
  PLUGIN_NAME         STRING,
  DESCRIPTION         STRING,
  VERSION_CD          STRING,
  PARAMETER_INFO      STRING,
  PARAMETER_INFO_XSD  STRING,
  COMMAND_LINE        STRING,
  WORKING_FOLDER      STRING,
  COMMANDOPTION_CD    STRING,
  PLUGIN_ICON         STRING,
  STATUS_CD           STRING,
  USER_ID             STRING,
  GROUP_ID            STRING,
  CREATE_DATE         TIMESTAMP,
  UPDATE_DATE         TIMESTAMP
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- QT_ANALYSIS_PLUGIN_RESULT_TYPE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_ANALYSIS_PLUGIN_RESULT_TYPE (
  PLUGIN_ID      INT,
  RESULT_TYPE_ID INT
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- QT_PRIVILEGE
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_PRIVILEGE (
  PROTECTION_LABEL_CD STRING,
  DATAPROT_CD         STRING,
  HIVEMGMT_CD         STRING,
  PLUGIN_ID           INT
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- QT_BREAKDOWN_PATH
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_BREAKDOWN_PATH (
  NAME         STRING,
  VALUE        STRING,
  CREATE_DATE  TIMESTAMP,
  UPDATE_DATE  TIMESTAMP,
  USER_ID      STRING
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- QT_PDO_QUERY_MASTER
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE QT_PDO_QUERY_MASTER (
  QUERY_MASTER_ID   INT,
  USER_ID           STRING     NOT NULL,
  GROUP_ID          STRING     NOT NULL,
  CREATE_DATE       TIMESTAMP  NOT NULL,
  REQUEST_XML       STRING,
  I2B2_REQUEST_XML  STRING
)
USING ICEBERG;

-- INIT WITH SEED DATA

INSERT INTO QT_QUERY_STATUS_TYPE (STATUS_TYPE_ID, NAME, DESCRIPTION)
VALUES
  (1, 'QUEUED',    'WAITING IN QUEUE TO START PROCESS'),
  (2, 'PROCESSING','PROCESSING'),
  (3, 'FINISHED',  'FINISHED'),
  (4, 'ERROR',     'ERROR'),
  (5, 'INCOMPLETE','INCOMPLETE'),
  (6, 'COMPLETED','COMPLETED'),
  (7, 'MEDIUM_QUEUE','MEDIUM QUEUE'),
  (8, 'LARGE_QUEUE','LARGE QUEUE'),
  (9, 'CANCELLED','CANCELLED'),
  (10,'TIMEDOUT','TIMEDOUT')
;

INSERT INTO QT_QUERY_RESULT_TYPE (
  RESULT_TYPE_ID,
  NAME,
  DESCRIPTION,
  DISPLAY_TYPE_ID,
  VISUAL_ATTRIBUTE_TYPE_ID,
  CLASSNAME,
  USER_ROLE_CD
)
VALUES
  (1,   'PATIENTSET',              'Patient set',                  'LIST','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientSetGenerator', NULL),
  (2,   'PATIENT_ENCOUNTER_SET',   'Encounter set',                'LIST','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultEncounterSetGenerator', NULL),
  (3,   'XML',                     'Generic query result',         'CATNUM','LH', NULL,                                      NULL),
  (4,   'PATIENT_COUNT_XML',       'Number of patients',           'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientCountGenerator', NULL),
  (5,   'PATIENT_GENDER_COUNT_XML','Gender patient breakdown',    'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultGenerator', NULL),
  (6,   'PATIENT_VITALSTATUS_COUNT_XML','Vital Status patient breakdown','CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultGenerator', NULL),
  (7,   'PATIENT_RACE_COUNT_XML',   'Race patient breakdown',       'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultGenerator', NULL),
  (8,   'PATIENT_AGE_COUNT_XML',    'Age patient breakdown',        'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultGenerator', NULL),
  (9,   'PATIENTSET',              'Timeline',                     'LIST','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientSetGenerator', NULL),
  (10,  'PATIENT_LOS_XML',         'Length of stay breakdown',     'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientSQLCountGenerator','DATA_LDS'),
  (11,  'PATIENT_TOP20MEDS_XML',   'Top 20 medications breakdown', 'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder.QueryResultPatientSQLCountGenerator','DATA_LDS'),
  (12,  'PATIENT_TOP20DIAG_XML',   'Top 20 diagnoses breakdown',   'CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientSQLCountGenerator','DATA_LDS'),
  (13,  'PATIENT_INOUT_XML',       'Inpatient and outpatient breakdown','CATNUM','LA','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientSQLCountGenerator','DATA_LDS'),
  (114, 'PATIENT_DEMOGRAPHIC_REQUEST','Request Demographics Data','CATNUM','LR','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientRequest','DATA_LDS'),
  (115, 'PATIENT_MEDICATION_REQUEST','Request Medication Data','CATNUM','LR','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientRequest','DATA_LDS'),
  (116, 'PATIENT_PROCEDURE_REQUEST','Request Procedure Data','CATNUM','LR','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientRequest','DATA_LDS'),
  (117, 'PATIENT_DIAGNOSIS_REQUEST','Request Diagnosis Data','CATNUM','LR','edu.harvard.i2b2.crc.dao.setfinder<QueryResultPatientRequest','DATA_LDS'),
  (118, 'PATIENT_LAB_REQUEST',     'Request Lab Data',             'CATNUM','LR','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientRequest','DATA_LDS'),
  (119, 'PATIENT_DEMOGRAPHIC_CSV',  'Export Demographics Data',     'CATNUM','LX','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientDownload','MANAGER'),
  (120, 'PATIENT_MEDICATION_CSV',   'Export Medication Data',       'CATNUM','LX','edu.harvard.i2b2.crc.dao.setfinder<QueryResultPatientDownload','MANAGER'),
  (121, 'PATIENT_PROCEDURE_CSV',    'Export Procedure Data',        'CATNUM','LX','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientDownload','MANAGER'),
  (122, 'PATIENT_DIAGNOSIS_CSV',    'Export Diagnosis Data',        'CATNUM','LX','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientDownload','MANAGER'),
  (123, 'PATIENT_LAB_CSV',          'Export Lab Data',              'CATNUM','LX','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientDownload','MANAGER'),
  (124, 'PATIENT_MAPPING_CSV',      'Export Patient Mapping',       'CATNUM','LX','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientDownload','MANAGER'),
  (126, 'PATIENT_MAPPING_REQUEST','Request Patient Mapping',      'CATNUM','LR','edu.harvard.i2b2.crc.dao.setfinder\QueryResultPatientRequest','DATA_LDS')
;

INSERT INTO QT_PRIVILEGE (PROTECTION_LABEL_CD, DATAPROT_CD, HIVEMGMT_CD, PLUGIN_ID)
VALUES
  ('pdo_without_blob',        'data_lds',   'user',    NULL),
  ('pdo_with_blob',           'data_deid',  'user',    NULL),
  ('setfinder_qry_with_dataobfsc',    'data_obfsc','user', NULL),
  ('setfinder_qry_without_dataobfsc', 'data_agg',  'user', NULL),
  ('upload',                  'data_obfsc','manager', NULL),
  ('setfinder_qry_with_lgtext','data_deid','user',    NULL),
  ('setfinder_qry_protected','data_prot', 'user',    NULL)
;
