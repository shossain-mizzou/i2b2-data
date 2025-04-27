--------------------------------------------------------------------------------
-- ENCOUNTER_MAPPING
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE encounter_mapping (
  encounter_ide         STRING    NOT NULL,
  encounter_ide_source  STRING    NOT NULL,
  project_id            STRING    NOT NULL,
  encounter_num         INT       NOT NULL,
  patient_ide           STRING    NOT NULL,
  patient_ide_source    STRING    NOT NULL,
  encounter_ide_status  STRING,
  upload_date           TIMESTAMP,
  update_date           TIMESTAMP,
  download_date         TIMESTAMP,
  import_date           TIMESTAMP,
  sourcesystem_cd       STRING,
  upload_id             INT
)
USING iceberg;

--------------------------------------------------------------------------------
-- PATIENT_MAPPING
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE patient_mapping (
  patient_ide         STRING    NOT NULL,
  patient_ide_source  STRING    NOT NULL,
  patient_num         INT       NOT NULL,
  patient_ide_status  STRING,
  project_id          STRING    NOT NULL,
  upload_date         TIMESTAMP,
  update_date         TIMESTAMP,
  download_date       TIMESTAMP,
  import_date         TIMESTAMP,
  sourcesystem_cd     STRING,
  upload_id           INT
)
USING iceberg;

--------------------------------------------------------------------------------
-- CODE_LOOKUP
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE code_lookup (
  table_cd     STRING    NOT NULL,
  column_cd    STRING    NOT NULL,
  code_cd      STRING    NOT NULL,
  name_char    STRING,
  lookup_blob  STRING,
  upload_date  TIMESTAMP,
  update_date  TIMESTAMP,
  download_date TIMESTAMP,
  import_date  TIMESTAMP,
  sourcesystem_cd STRING,
  upload_id    INT
)
USING iceberg;

--------------------------------------------------------------------------------
-- CONCEPT_DIMENSION
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE concept_dimension (
  concept_path     STRING    NOT NULL,
  concept_cd       STRING,
  name_char        STRING,
  concept_blob     STRING,
  update_date      TIMESTAMP,
  download_date    TIMESTAMP,
  import_date      TIMESTAMP,
  sourcesystem_cd  STRING,
  upload_id        INT
)
USING iceberg;

--------------------------------------------------------------------------------
-- OBSERVATION_FACT
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE observation_fact (
  encounter_num      INT       NOT NULL,
  patient_num        INT       NOT NULL,
  concept_cd         STRING    NOT NULL,
  provider_id        STRING    NOT NULL,
  start_date         TIMESTAMP NOT NULL,
  modifier_cd        STRING    NOT NULL,
  instance_num       INT       NOT NULL,
  valtype_cd         STRING,
  tval_char          STRING,
  nval_num           DECIMAL(18,5),
  valueflag_cd       STRING,
  quantity_num       DECIMAL(18,5),
  units_cd           STRING,
  end_date           TIMESTAMP,
  location_cd        STRING,
  observation_blob   STRING,
  confidence_num     DECIMAL(18,5),
  update_date        TIMESTAMP,
  download_date      TIMESTAMP,
  import_date        TIMESTAMP,
  sourcesystem_cd    STRING,
  upload_id          INT,
  text_search_index  INT
)
USING iceberg;

--------------------------------------------------------------------------------
-- PATIENT_DIMENSION
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE patient_dimension (
  patient_num        INT       NOT NULL,
  vital_status_cd    STRING,
  birth_date         TIMESTAMP,
  death_date         TIMESTAMP,
  sex_cd             STRING,
  age_in_years_num   INT,
  language_cd        STRING,
  race_cd            STRING,
  marital_status_cd  STRING,
  religion_cd        STRING,
  zip_cd             STRING,
  statecityzip_path  STRING,
  income_cd          STRING,
  patient_blob       STRING,
  update_date        TIMESTAMP,
  download_date      TIMESTAMP,
  import_date        TIMESTAMP,
  sourcesystem_cd    STRING,
  upload_id          INT
)
USING iceberg;

--------------------------------------------------------------------------------
-- PROVIDER_DIMENSION
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE provider_dimension (
  provider_id       STRING    NOT NULL,
  provider_path     STRING    NOT NULL,
  name_char         STRING,
  provider_blob     STRING,
  update_date       TIMESTAMP,
  download_date     TIMESTAMP,
  import_date       TIMESTAMP,
  sourcesystem_cd   STRING,
  upload_id         INT
)
USING iceberg;

--------------------------------------------------------------------------------
-- VISIT_DIMENSION
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE visit_dimension (
  encounter_num     INT       NOT NULL,
  patient_num       INT       NOT NULL,
  active_status_cd  STRING,
  start_date        TIMESTAMP,
  end_date          TIMESTAMP,
  inout_cd          STRING,
  location_cd       STRING,
  location_path     STRING,
  length_of_stay    INT,
  visit_blob        STRING,
  update_date       TIMESTAMP,
  download_date     TIMESTAMP,
  import_date       TIMESTAMP,
  sourcesystem_cd   STRING,
  upload_id         INT
)
USING iceberg;

--------------------------------------------------------------------------------
-- MODIFIER_DIMENSION
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE modifier_dimension (
  modifier_path     STRING    NOT NULL,
  modifier_cd       STRING,
  name_char         STRING,
  modifier_blob     STRING,
  update_date       TIMESTAMP,
  download_date     TIMESTAMP,
  import_date       TIMESTAMP,
  sourcesystem_cd   STRING,
  upload_id         INT
)
USING iceberg;
