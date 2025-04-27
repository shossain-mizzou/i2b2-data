--------------------------------------------------------------------------------
-- ENCOUNTER_MAPPING
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE ENCOUNTER_MAPPING (
  ENCOUNTER_IDE         STRING    NOT NULL,
  ENCOUNTER_IDE_SOURCE  STRING    NOT NULL,
  PROJECT_ID            STRING    NOT NULL,
  ENCOUNTER_NUM         INT       NOT NULL,
  PATIENT_IDE           STRING    NOT NULL,
  PATIENT_IDE_SOURCE    STRING    NOT NULL,
  ENCOUNTER_IDE_STATUS  STRING,
  UPLOAD_DATE           TIMESTAMP,
  UPDATE_DATE           TIMESTAMP,
  DOWNLOAD_DATE         TIMESTAMP,
  IMPORT_DATE           TIMESTAMP,
  SOURCESYSTEM_CD       STRING,
  UPLOAD_ID             INT
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- PATIENT_MAPPING
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE PATIENT_MAPPING (
  PATIENT_IDE         STRING    NOT NULL,
  PATIENT_IDE_SOURCE  STRING    NOT NULL,
  PATIENT_NUM         INT       NOT NULL,
  PATIENT_IDE_STATUS  STRING,
  PROJECT_ID          STRING    NOT NULL,
  UPLOAD_DATE         TIMESTAMP,
  UPDATE_DATE         TIMESTAMP,
  DOWNLOAD_DATE       TIMESTAMP,
  IMPORT_DATE         TIMESTAMP,
  SOURCESYSTEM_CD     STRING,
  UPLOAD_ID           INT
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- CODE_LOOKUP
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE CODE_LOOKUP (
  TABLE_CD      STRING    NOT NULL,
  COLUMN_CD     STRING    NOT NULL,
  CODE_CD       STRING    NOT NULL,
  NAME_CHAR     STRING,
  LOOKUP_BLOB   STRING,
  UPLOAD_DATE   TIMESTAMP,
  UPDATE_DATE   TIMESTAMP,
  DOWNLOAD_DATE TIMESTAMP,
  IMPORT_DATE   TIMESTAMP,
  SOURCESYSTEM_CD STRING,
  UPLOAD_ID     INT
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- CONCEPT_DIMENSION
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE CONCEPT_DIMENSION (
  CONCEPT_PATH    STRING    NOT NULL,
  CONCEPT_CD      STRING,
  NAME_CHAR       STRING,
  CONCEPT_BLOB    STRING,
  UPDATE_DATE     TIMESTAMP,
  DOWNLOAD_DATE   TIMESTAMP,
  IMPORT_DATE     TIMESTAMP,
  SOURCESYSTEM_CD STRING,
  UPLOAD_ID       INT
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- OBSERVATION_FACT
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE OBSERVATION_FACT (
  ENCOUNTER_NUM       INT       NOT NULL,
  PATIENT_NUM         INT       NOT NULL,
  CONCEPT_CD          STRING    NOT NULL,
  PROVIDER_ID         STRING    NOT NULL,
  START_DATE          TIMESTAMP NOT NULL,
  MODIFIER_CD         STRING    NOT NULL,
  INSTANCE_NUM        INT       NOT NULL,
  VALTYPE_CD          STRING,
  TVAL_CHAR           STRING,
  NVAL_NUM            DECIMAL(18,5),
  VALUEFLAG_CD        STRING,
  QUANTITY_NUM        DECIMAL(18,5),
  UNITS_CD            STRING,
  END_DATE            TIMESTAMP,
  LOCATION_CD         STRING,
  OBSERVATION_BLOB    STRING,
  CONFIDENCE_NUM      DECIMAL(18,5),
  UPDATE_DATE         TIMESTAMP,
  DOWNLOAD_DATE       TIMESTAMP,
  IMPORT_DATE         TIMESTAMP,
  SOURCESYSTEM_CD     STRING,
  UPLOAD_ID           INT,
  TEXT_SEARCH_INDEX   INT
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- PATIENT_DIMENSION
-- TODO: view
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE PATIENT_DIMENSION_V2 (
  PATIENT_NUM        INT       NOT NULL,
  VITAL_STATUS_CD    STRING,
  BIRTH_DATE         TIMESTAMP,
  DEATH_DATE         TIMESTAMP,
  SEX_CD             STRING,
  AGE_IN_YEARS_NUM   INT,
  LANGUAGE_CD        STRING,
  RACE_CD            STRING,
  MARITAL_STATUS_CD  STRING,
  RELIGION_CD        STRING,
  ZIP_CD             STRING,
  STATECITYZIP_PATH  STRING,
  INCOME_CD          STRING,
  PATIENT_BLOB       STRING,
  UPDATE_DATE        TIMESTAMP,
  DOWNLOAD_DATE      TIMESTAMP,
  IMPORT_DATE        TIMESTAMP,
  SOURCESYSTEM_CD    STRING,
  UPLOAD_ID          INT
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- PROVIDER_DIMENSION
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE PROVIDER_DIMENSION (
  PROVIDER_ID       STRING    NOT NULL,
  PROVIDER_PATH     STRING    NOT NULL,
  NAME_CHAR         STRING,
  PROVIDER_BLOB     STRING,
  UPDATE_DATE       TIMESTAMP,
  DOWNLOAD_DATE     TIMESTAMP,
  IMPORT_DATE       TIMESTAMP,
  SOURCESYSTEM_CD   STRING,
  UPLOAD_ID         INT
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- VISIT_DIMENSION
-- TODO: view
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE VISIT_DIMENSION_V2 (
  ENCOUNTER_NUM     INT       NOT NULL,
  PATIENT_NUM       INT       NOT NULL,
  ACTIVE_STATUS_CD  STRING,
  START_DATE        TIMESTAMP,
  END_DATE          TIMESTAMP,
  INOUT_CD          STRING,
  LOCATION_CD       STRING,
  LOCATION_PATH     STRING,
  LENGTH_OF_STAY    INT,
  VISIT_BLOB        STRING,
  UPDATE_DATE       TIMESTAMP,
  DOWNLOAD_DATE     TIMESTAMP,
  IMPORT_DATE       TIMESTAMP,
  SOURCESYSTEM_CD   STRING,
  UPLOAD_ID         INT
)
USING ICEBERG;

--------------------------------------------------------------------------------
-- MODIFIER_DIMENSION
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE MODIFIER_DIMENSION (
  MODIFIER_PATH     STRING    NOT NULL,
  MODIFIER_CD       STRING,
  NAME_CHAR         STRING,
  MODIFIER_BLOB     STRING,
  UPDATE_DATE       TIMESTAMP,
  DOWNLOAD_DATE     TIMESTAMP,
  IMPORT_DATE       TIMESTAMP,
  SOURCESYSTEM_CD   STRING,
  UPLOAD_ID         INT
)
USING ICEBERG;
