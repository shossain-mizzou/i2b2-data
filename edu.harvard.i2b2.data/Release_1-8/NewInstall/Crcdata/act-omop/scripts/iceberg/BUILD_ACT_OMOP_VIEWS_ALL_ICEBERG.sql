-- Spark + Iceberg Compatible SQL

-- Drop existing views
DROP VIEW IF EXISTS VISIT_DIMENSION;
DROP VIEW IF EXISTS PATIENT_DIMENSION;
DROP VIEW IF EXISTS DEVICE_VIEW;
DROP VIEW IF EXISTS DRUG_VIEW;
DROP VIEW IF EXISTS COVID_LAB_VIEW;
DROP VIEW IF EXISTS PROCEDURE_VIEW;
DROP VIEW IF EXISTS OBSERVATION_VIEW;
DROP VIEW IF EXISTS MEASUREMENT_VIEW;
DROP VIEW IF EXISTS ZIPCODE_VIEW;
DROP VIEW IF EXISTS CONDITION_VIEW;
DROP VIEW IF EXISTS VISIT_NS_VIEW;
DROP VIEW IF EXISTS CONDITION_NS_VIEW;
DROP VIEW IF EXISTS DRUG_NS_VIEW;
DROP VIEW IF EXISTS MEASUREMENT_NS_VIEW;
DROP VIEW IF EXISTS OBSERVATION_NS_VIEW;
DROP VIEW IF EXISTS COVID_LAB_NS_VIEW;
DROP VIEW IF EXISTS DEVICE_NS_VIEW;
DROP VIEW IF EXISTS PROCEDURE_NS_VIEW;

-- Drop and recreate the EMPTY_VIEW table as an Iceberg table
DROP TABLE IF EXISTS EMPTY_VIEW;
CREATE TABLE EMPTY_VIEW (
  ENCOUNTER_NUM INT,
  PATIENT_NUM INT,
  CONCEPT_CD STRING,
  PROVIDER_ID STRING,
  START_DATE DATE,
  END_DATE TIMESTAMP,
  MODIFIER_CD STRING,
  INSTANCE_NUM INT,
  VALTYPE_CD STRING,
  LOCATION_CD STRING,
  TVAL_CHAR STRING,
  NVAL_NUM DECIMAL(38,10),
  VALUEFLAG_CD STRING,
  UNITS_CD STRING,
  CONFIDENCE_NUM FLOAT,
  SOURCESYSTEM_CD STRING,
  UPDATE_DATE TIMESTAMP,
  DOWNLOAD_DATE TIMESTAMP,
  IMPORT_DATE TIMESTAMP,
  OBSERVATION_BLOB STRING,
  UPLOAD_ID INT,
  QUANTITY_NUM INT,
  SOURCE_CONCEPT_ID INT,
  SOURCE_VALUE STRING,
  DOMAIN_ID STRING
)
USING ICEBERG;

-- Dimension views
CREATE OR REPLACE VIEW VISIT_DIMENSION AS
SELECT
  visit_occurrence_id AS encounter_num,
  person_id AS patient_num,
  CAST(NULL AS STRING) AS active_status_cd,
  visit_start_date AS start_date,
  visit_end_date AS end_date,
  visit_concept_id AS inout_cd,
  care_site_id AS location_cd,
  CAST(NULL AS STRING) AS location_path,
  datediff(visit_end_date, visit_start_date) AS length_of_stay,
  CAST(NULL AS STRING) AS visit_blob,
  CAST(NULL AS TIMESTAMP) AS update_date,
  CAST(NULL AS TIMESTAMP) AS download_date,
  CAST(NULL AS TIMESTAMP) AS import_date,
  CAST(NULL AS STRING) AS sourcesystem_cd,
  CAST(NULL AS INT) AS upload_id
FROM visit_occurrence;

CREATE OR REPLACE VIEW PATIENT_DIMENSION AS
SELECT
  person_id AS patient_num,
  CASE
    WHEN year_of_birth IS NULL THEN CAST('Y' AS STRING)
    ELSE CAST('N' AS STRING)
  END AS vital_status_cd,
  to_date(
    concat(
      cast(year_of_birth AS STRING), '-',
      lpad(cast(month_of_birth AS STRING),2,'0'), '-',
      lpad(cast(day_of_birth AS STRING),2,'0')
    ), 'yyyy-MM-dd'
  ) AS birth_date,
  CAST(NULL AS DATE) AS death_date,
  CAST(gender_concept_id AS STRING) AS sex_cd,
  floor(datediff(current_date(), birth_datetime)/365) AS age_in_years_num,
  CAST(NULL AS STRING) AS language_cd,
  CAST(race_concept_id AS STRING) AS race_cd,
  CAST(NULL AS STRING) AS marital_status_cd,
  CAST(NULL AS STRING) AS religion_cd,
  CAST(NULL AS STRING) AS zip_cd,
  CAST(NULL AS STRING) AS statecityzip_path,
  CAST(NULL AS STRING) AS income_cd,
  CAST(NULL AS STRING) AS patient_blob,
  CAST(NULL AS TIMESTAMP) AS update_date,
  CAST(NULL AS TIMESTAMP) AS download_date,
  CAST(NULL AS TIMESTAMP) AS import_date,
  CAST(NULL AS STRING) AS sourcesystem_cd,
  CAST(NULL AS INT) AS upload_id,
  CAST(ethnicity_concept_id AS STRING) AS ethnicity_cd
FROM person;

-- Fact table views
CREATE OR REPLACE VIEW CONDITION_VIEW AS
SELECT
  visit_occurrence_id           AS encounter_num,
  person_id                     AS patient_num,
  CAST(condition_concept_id AS STRING)   AS concept_cd,
  COALESCE(CAST(provider_id   AS STRING), '@') AS provider_id,
  condition_start_datetime      AS start_date,
  condition_end_datetime        AS end_date,
  CAST('@'              AS STRING)       AS modifier_cd,
  1                             AS instance_num,
  CAST(NULL           AS STRING)         AS valtype_cd,
  CAST(NULL           AS STRING)         AS location_cd,
  CAST(NULL           AS STRING)         AS tval_char,
  CAST(NULL           AS DECIMAL(38,10)) AS nval_num,
  CAST(NULL           AS STRING)         AS valueflag_cd,
  CAST(NULL           AS STRING)         AS units_cd,
  CAST(NULL           AS FLOAT)          AS confidence_num,
  CAST(NULL           AS STRING)         AS sourcesystem_cd,
  CAST(NULL           AS TIMESTAMP)       AS update_date,
  CAST(NULL           AS TIMESTAMP)       AS download_date,
  CAST(NULL           AS TIMESTAMP)       AS import_date,
  CAST(NULL           AS STRING)         AS observation_blob,-
  CAST(NULL           AS INT)            AS upload_id,
  CAST(NULL           AS INT)            AS quantity_num,
  condition_source_concept_id                AS source_concept_id,
  condition_source_value                     AS source_value,
  'CONDITION'                                AS domain_id
FROM condition_occurrence;

CREATE OR REPLACE VIEW DEVICE_VIEW AS
SELECT
  visit_occurrence_id                     AS encounter_num,
  person_id                               AS patient_num,
  CAST(device_exposure_id      AS STRING) AS concept_cd,
  COALESCE(CAST(provider_id      AS STRING), '@') AS provider_id,
  device_exposure_start_datetime          AS start_date,
  device_exposure_end_datetime            AS end_date,
  COALESCE(CAST(device_type_concept_id AS STRING), '@') AS modifier_cd,
  1                                       AS instance_num,
  CAST(NULL               AS STRING)     AS valtype_cd,
  CAST(NULL               AS STRING)     AS location_cd,
  CAST(NULL               AS STRING)     AS tval_char,
  CAST(NULL               AS DECIMAL(38,10)) AS nval_num,
  CAST(NULL               AS STRING)     AS valueflag_cd,
  CAST(NULL               AS STRING)     AS units_cd,
  CAST(NULL               AS FLOAT)      AS confidence_num,
  CAST(NULL               AS STRING)     AS sourcesystem_cd,
  CAST(NULL               AS TIMESTAMP)  AS update_date,
  CAST(NULL               AS TIMESTAMP)  AS download_date,
  CAST(NULL               AS TIMESTAMP)  AS import_date,
  CAST(NULL               AS STRING)     AS observation_blob,   
  CAST(NULL               AS INT)        AS upload_id,
  CAST(NULL               AS INT)        AS quantity_num,
  device_source_concept_id                AS source_concept_id,
  device_source_value                     AS source_value,
  'DEVICE'                                AS domain_id
FROM device_exposure;       


CREATE OR REPLACE VIEW DRUG_VIEW AS
SELECT
  visit_occurrence_id                                  AS encounter_num,
  person_id                                            AS patient_num,     
  CAST(drug_concept_id      AS STRING)                 AS concept_cd,
  COALESCE(CAST(provider_id AS STRING), '@')           AS provider_id,
  drug_exposure_start_datetime                         AS start_date,
  drug_exposure_end_datetime                           AS end_date,
  CAST('@'                  AS STRING)                 AS modifier_cd,
  1                                                    AS instance_num,
  CAST(NULL                 AS STRING)                 AS valtype_cd,
  CAST(NULL                 AS STRING)                 AS location_cd,
  CAST(NULL                 AS STRING)                 AS tval_char,
  CAST(NULL                 AS DECIMAL(38,10))         AS nval_num,
  CAST(NULL                 AS STRING)                 AS valueflag_cd,
  CAST(NULL                 AS STRING)                 AS units_cd,
  CAST(NULL                 AS FLOAT)                  AS confidence_num,
  CAST(NULL                 AS STRING)                 AS sourcesystem_cd,
  CAST(NULL                 AS TIMESTAMP)               AS update_date,
  CAST(NULL                 AS TIMESTAMP)               AS download_date,
  CAST(NULL                 AS TIMESTAMP)               AS import_date,
  CAST(NULL                 AS STRING)                 AS observation_blob,
  CAST(NULL                 AS INT)                    AS upload_id,
  CAST(NULL                 AS INT)                    AS quantity_num,
  drug_source_concept_id                                AS source_concept_id,
  drug_source_value                                     AS source_value,
  'DRUG'                                                AS domain_id
FROM drug_exposure;  


CREATE OR REPLACE VIEW MEASUREMENT_VIEW AS
SELECT
  visit_occurrence_id                            AS encounter_num,
  person_id                                      AS patient_num,
  CAST(measurement_concept_id  AS STRING)        AS concept_cd,
  COALESCE(CAST(provider_id       AS STRING), '@') AS provider_id,
  measurement_date                               AS start_date,
  CAST(NULL                AS TIMESTAMP)         AS end_date,
  CAST('@'                 AS STRING)            AS modifier_cd,
  1                                              AS instance_num,
  CASE 
    WHEN value_as_number IS NOT NULL THEN 'N' 
    ELSE 'T' 
  END                                            AS valtype_cd,
  CAST(NULL                AS STRING)            AS location_cd,
  CASE
    WHEN operator_concept_id = 4172703 THEN 'E'
    WHEN operator_concept_id = 4171756 THEN 'LT'
    WHEN operator_concept_id = 4172704 THEN 'GT'
    WHEN operator_concept_id = 4171754 THEN 'LE'
    WHEN operator_concept_id = 4171755 THEN 'GE'
    WHEN operator_concept_id IS NULL            THEN 'E'
    ELSE CAST(NULL AS STRING)  
  END                                            AS tval_char,
  value_as_number                                AS nval_num,
  CAST(value_as_concept_id     AS STRING)        AS valueflag_cd,
  unit_source_value                              AS units_cd,
  CAST(NULL                  AS FLOAT)           AS confidence_num,
  CAST(NULL                  AS STRING)          AS sourcesystem_cd,
  CAST(NULL                  AS TIMESTAMP)       AS update_date,
  CAST(NULL                  AS TIMESTAMP)       AS download_date,
  CAST(NULL                  AS TIMESTAMP)       AS import_date,
  CAST(NULL                  AS STRING)          AS observation_blob,  
  CAST(NULL                  AS INT)             AS upload_id,
  CAST(NULL                  AS INT)             AS quantity_num,
  measurement_source_concept_id                  AS source_concept_id,
  measurement_source_value                       AS source_value,
  'MEASUREMENT'                                  AS domain_id
FROM measurement;  


CREATE OR REPLACE VIEW OBSERVATION_VIEW AS
SELECT
  visit_occurrence_id                          AS encounter_num,
  person_id                                    AS patient_num,
  CAST(observation_concept_id AS STRING)       AS concept_cd,
  COALESCE(CAST(provider_id AS STRING), '@')   AS provider_id,
  observation_date                             AS start_date,
  CAST(NULL                AS TIMESTAMP)       AS end_date,
  CAST('@'                 AS STRING)          AS modifier_cd,
  1                                            AS instance_num,
  CASE
    WHEN value_as_number IS NOT NULL THEN 'N'
    ELSE 'T'
  END                                          AS valtype_cd,
  CAST(NULL               AS STRING)           AS location_cd,
  CASE
    WHEN value_as_number IS NOT NULL THEN 'E'
    ELSE CAST(value_as_string AS STRING)        
  END                                          AS tval_char,
  value_as_number                              AS nval_num,
  CAST(value_as_concept_id AS STRING)          AS valueflag_cd,
  unit_source_value                            AS units_cd,
  CAST(NULL               AS FLOAT)            AS confidence_num,
  CAST(NULL               AS STRING)           AS sourcesystem_cd,
  CAST(NULL               AS TIMESTAMP)        AS update_date,
  CAST(NULL               AS TIMESTAMP)        AS download_date,
  CAST(NULL               AS TIMESTAMP)        AS import_date,
  CAST(NULL               AS STRING)           AS observation_blob,  
  CAST(NULL               AS INT)              AS upload_id,
  CAST(NULL               AS INT)              AS quantity_num,
  observation_source_concept_id                AS source_concept_id,
  observation_source_value                     AS source_value,
  'OBSERVATION'                                AS domain_id
FROM observation;  

CREATE OR REPLACE VIEW PROCEDURE_VIEW AS
SELECT
  visit_occurrence_id                      AS encounter_num,
  person_id                                AS patient_num,
  CAST(procedure_concept_id AS STRING)     AS concept_cd,
  COALESCE(CAST(provider_id AS STRING), '@') AS provider_id,
  procedure_datetime                       AS start_date,
  CAST(NULL                AS TIMESTAMP)   AS end_date,
  CAST('@'                 AS STRING)      AS modifier_cd,
  1                                        AS instance_num,
  CAST(NULL               AS STRING)       AS valtype_cd,
  CAST(NULL               AS STRING)       AS location_cd,
  CAST(NULL               AS STRING)       AS tval_char,
  CAST(NULL               AS DECIMAL(38,10)) AS nval_num,
  CAST(NULL               AS STRING)       AS valueflag_cd,
  CAST(NULL               AS STRING)       AS units_cd,
  CAST(NULL               AS FLOAT)        AS confidence_num,
  CAST(NULL               AS STRING)       AS sourcesystem_cd,
  CAST(NULL               AS TIMESTAMP)     AS update_date,
  CAST(NULL               AS TIMESTAMP)     AS download_date,
  CAST(NULL               AS TIMESTAMP)     AS import_date,
  CAST(NULL               AS STRING)       AS observation_blob,  
  CAST(NULL               AS INT)          AS upload_id,
  CAST(NULL               AS INT)          AS quantity_num,
  procedure_source_concept_id              AS source_concept_id,
  procedure_source_value                   AS source_value,
  'PROCEDURE'                              AS domain_id
FROM procedure_occurrence;  

CREATE OR REPLACE VIEW covid_lab_view AS
SELECT
  person_id                                                   AS patient_num,
  CONCAT(
    CAST(measurement_source_concept_id AS STRING),
    ' ',
    CAST(value_as_concept_id         AS STRING)
  )                                                             AS concept_cd,
  visit_occurrence_id                                          AS encounter_num,
  1                                                            AS instance_num,
  COALESCE(provider_id, '@')                                   AS provider_id,
  measurement_datetime                                         AS start_date,
  '@'                                                          AS modifier_cd,
  CAST(NULL AS BINARY)                                         AS observation_blob,   -- explicitly BINARY
  CASE
    WHEN value_as_number IS NOT NULL THEN 'N'
    ELSE 'T'
  END                                                          AS valtype_cd,
  CASE
    WHEN operator_concept_id = 4172703 THEN 'E'
    WHEN operator_concept_id = 4171756 THEN 'LT'
    WHEN operator_concept_id = 4172704 THEN 'GT'
    WHEN operator_concept_id = 4171754 THEN 'LE'
    WHEN operator_concept_id = 4171755 THEN 'GE'
    WHEN operator_concept_id IS NULL
         AND value_as_number IS NOT NULL                      THEN 'E'
    ELSE value_source_value
  END                                                          AS tval_char,
  value_as_number                                              AS nval_num,
  CAST(value_as_concept_id AS STRING)                          AS valueflag_cd,
  CAST(NULL AS INT)                                            AS quantity_num,
  unit_source_value                                            AS units_cd,
  CAST(NULL AS TIMESTAMP)                                      AS end_date,
  CAST(NULL AS STRING)                                         AS location_cd,
  CAST(NULL AS DOUBLE)                                         AS confidence_num,
  CAST(NULL AS STRING)                                         AS sourcesystem_cd,
  CAST(NULL AS TIMESTAMP)                                      AS update_date,
  CAST(NULL AS TIMESTAMP)                                      AS download_date,
  CAST(NULL AS TIMESTAMP)                                      AS import_date,
  CAST(NULL AS INT)                                            AS upload_id,
  measurement_concept_id                                       AS standard_concept_id,
  measurement_source_value                                     AS source_value,
  'MEASUREMENT'                                                AS domain_id
FROM measurement
WHERE CAST(measurement_source_concept_id AS STRING) IN ('586515', '586516', '586517', '586518', '586519', '586520', '586521', '586522', '586523', '586524', '586525', '586526', '586527',
 '586528', '586529', '706154', '706155', '706156', '706157', '706159', '706160', '706161', '706163', '706165', '706166', '706167',
  '706168', '706170', '706171', '706172', '706173', '706174', '706175', '706177', '706178', '706180', '706181', '715260', '715261', '715262',
   '715272', '723459', '723463', '723464', '723465', '723466', '723467', '723468', '723469', '723470', '723471', '723472', '723473', '723474',
    '723475', '723476', '723477', '723478', '723479', '723480', '757677', '757678', '757679', '757680', '757685', '757686', '36659631', '36661369',
     '36661370', '36661371', '36661372', '36661373', '36661374', '36661375', '36661377', '36661378');

CREATE OR REPLACE VIEW visit_ns_view AS
SELECT
  visit_occurrence_id                              AS encounter_num,          -- INT
  person_id                                        AS patient_num,            -- INT
  CAST(visit_source_concept_id   AS STRING)        AS concept_cd,             -- STRING
  COALESCE(provider_id, '@')                       AS provider_id,            -- STRING
  CAST(visit_start_datetime      AS TIMESTAMP)     AS start_date,             -- TIMESTAMP
  CAST(visit_end_datetime        AS TIMESTAMP)     AS end_date,               -- TIMESTAMP
  '@'                                              AS modifier_cd,            -- STRING
  1                                                AS instance_num,           -- INT
  CAST(NULL                     AS STRING)         AS valtype_cd,             -- STRING
  CAST(care_site_id             AS STRING)         AS location_cd,            -- STRING
  CAST(NULL                     AS STRING)         AS tval_char,              -- STRING
  CAST(NULL                     AS DOUBLE)         AS nval_num,               -- DOUBLE
  CAST(NULL                     AS STRING)         AS valueflag_cd,           -- STRING
  CAST(NULL                     AS STRING)         AS units_cd,               -- STRING
  CAST(NULL                     AS FLOAT)          AS confidence_num,         -- FLOAT
  CAST(NULL                     AS STRING)         AS sourcesystem_cd,        -- STRING
  CAST(NULL                     AS TIMESTAMP)      AS update_date,            -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)      AS download_date,          -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)      AS import_date,            -- TIMESTAMP
  CAST(NULL                     AS BINARY)         AS observation_blob,       -- BINARY
  CAST(NULL                     AS INT)            AS upload_id,              -- INT
  CAST(NULL                     AS INT)            AS quantity_num,           -- INT
  CAST(visit_source_concept_id  AS INT)            AS source_concept_id,      -- INT
  CAST(visit_source_value       AS STRING)         AS source_value,           -- STRING
  'VISIT'                                          AS domain_id               -- STRING
FROM visit_occurrence
WHERE CAST(visit_source_concept_id AS STRING) IN (
  '42733800','2414356','2514472','2514478','2514492','2514420','759714','2514415','2514419',
  '2414357','2514491','2514484','2514486','42738975','42738971','2514607','2514481','2514485',
  '759715','2514493','2414398','2414395','2414390','2514487','42738974','2514479','2514488',
  '42738976','2514483','2514494','2414397','2414394','2514399','2101831','2514410','2212758',
  '2414347','2212759','2514422','2514417','2514470','2514474','2514490','2514489','42738973',
  '42628033','2514496','2514495','42738672','2414349','2514473','42628640','2414391','2514510',
  '40756897','2101829','2514433','42738987','2514549','2101773','2514454','2514466','2514457',
  '2213588','42738986','2514548','1389757','2514551','1389758','2514465','42738970','42738966',
  '2213590','42738677','2213578','2213580','42738678','2213596','2213593','2213597','42738339',
  '2514511','2514437','2514434','42738988','927189','1389755','927161','44816370','2314339',
  '2514464','2514515','2514514','2514435','710059','44816369','1389756','2514459','2514458',
  '2514455','42738968','2514456','2213581','2213583','2213591','42738338','2213585','2514563',
  '2213592','2514566','2514565','2514436','43528028','927188','2101774','2314340','2314338',
  '2101832','42738965','2213589','2213595','42738679','2213579','2514562','42738776','44816367',
  '2514460','42738969','2213582','2514567','2514412','2213586','42738336','42738676','2414348',
  '2212760','2514418','2514471','2514482','2414393','2414392','2514424','2514421','42738972',
  '2414345','2414396','2314183','43528027','2514423','2514416','2514480','2414355','1389523',
  '44816368','2514568','2414350','42742446'
);

-- Source fact views (namespace-specific)
CREATE OR REPLACE VIEW CONDITION_NS_VIEW AS
SELECT
  visit_occurrence_id                              AS encounter_num,       -- INT
  person_id                                        AS patient_num,         -- INT
  CAST(condition_source_concept_id AS STRING)      AS concept_cd,          -- STRING
  COALESCE(provider_id, '@')                       AS provider_id,         -- STRING
  CAST(condition_start_datetime AS TIMESTAMP)      AS start_date,          -- TIMESTAMP
  CAST(condition_end_datetime   AS TIMESTAMP)      AS end_date,            -- TIMESTAMP
  '@'                                              AS modifier_cd,         -- STRING
  1                                                AS instance_num,        -- INT

  CAST(NULL                     AS STRING)         AS valtype_cd,          -- STRING
  CAST(NULL                     AS STRING)         AS location_cd,         -- STRING
  CAST(NULL                     AS STRING)         AS tval_char,           -- STRING
  CAST(NULL                     AS DOUBLE)         AS nval_num,            -- DOUBLE
  CAST(NULL                     AS STRING)         AS valueflag_cd,        -- STRING
  CAST(NULL                     AS STRING)         AS units_cd,            -- STRING
  CAST(NULL                     AS FLOAT)          AS confidence_num,      -- FLOAT
  CAST(NULL                     AS STRING)         AS sourcesystem_cd,     -- STRING
  CAST(NULL                     AS TIMESTAMP)      AS update_date,         -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)      AS download_date,       -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)      AS import_date,         -- TIMESTAMP
  CAST(NULL                     AS BINARY)         AS observation_blob,    -- BINARY
  CAST(NULL                     AS INT)            AS upload_id,           -- INT
  CAST(NULL                     AS INT)            AS quantity_num,        -- INT

  CAST(condition_source_concept_id AS INT)         AS source_concept_id,   -- INT
  CAST(condition_source_value      AS STRING)      AS source_value,        -- STRING
  'CONDITION'                                     AS domain_id            -- STRING
FROM condition_occurrence;



CREATE OR REPLACE VIEW device_ns_view AS
SELECT
  visit_occurrence_id                             AS encounter_num,     -- INT
  person_id                                       AS patient_num,       -- INT

  -- use CAST(... AS STRING) instead of ::VARCHAR
  CAST(device_source_concept_id AS STRING)        AS concept_cd,        -- STRING

  -- remove ::VARCHAR, just COALESCE over raw column
  COALESCE(provider_id, '@')                      AS provider_id,       -- STRING

  -- ensure dates are TIMESTAMP
  CAST(device_exposure_start_datetime AS TIMESTAMP) AS start_date,     -- TIMESTAMP
  CAST(device_exposure_end_datetime   AS TIMESTAMP) AS end_date,       -- TIMESTAMP

  -- CAST device_type_concept_id to STRING, then COALESCE
  COALESCE(CAST(device_type_concept_id AS STRING), '@') AS modifier_cd, -- STRING

  1                                               AS instance_num,      -- INT

  -- every NULL must be explicitly cast
  CAST(NULL                     AS STRING)         AS valtype_cd,        -- STRING
  CAST(NULL                     AS STRING)         AS location_cd,       -- STRING
  CAST(NULL                     AS STRING)         AS tval_char,         -- STRING
  CAST(NULL                     AS DOUBLE)         AS nval_num,          -- DOUBLE
  CAST(NULL                     AS STRING)         AS valueflag_cd,      -- STRING
  CAST(NULL                     AS STRING)         AS units_cd,          -- STRING
  CAST(NULL                     AS FLOAT)          AS confidence_num,    -- FLOAT
  CAST(NULL                     AS STRING)         AS sourcesystem_cd,   -- STRING
  CAST(NULL                     AS TIMESTAMP)      AS update_date,       -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)      AS download_date,     -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)      AS import_date,       -- TIMESTAMP

  -- BINARY for blobs
  CAST(NULL                     AS BINARY)         AS observation_blob,  -- BINARY

  CAST(NULL                     AS INT)            AS upload_id,         -- INT
  CAST(NULL                     AS INT)            AS quantity_num,      -- INT

  -- cast source fields to concrete types
  CAST(device_source_concept_id    AS INT)         AS source_concept_id, -- INT
  CAST(device_source_value         AS STRING)      AS source_value,      -- STRING

  'DEVICE'                                       AS domain_id          -- STRING
FROM device_exposure;

CREATE OR REPLACE VIEW drug_ns_view AS
SELECT
  visit_occurrence_id                             AS encounter_num,     -- INT
  person_id                                       AS patient_num,       -- INT
  CAST(drug_source_concept_id   AS STRING)        AS concept_cd,        -- STRING
  COALESCE(provider_id, '@')                      AS provider_id,       -- STRING
  CAST(drug_exposure_start_datetime AS TIMESTAMP) AS start_date,       -- TIMESTAMP
  CAST(drug_exposure_end_datetime   AS TIMESTAMP) AS end_date,         -- TIMESTAMP
  '@'                                             AS modifier_cd,       -- STRING
  1                                               AS instance_num,      -- INT

  CAST(NULL                     AS STRING)         AS valtype_cd,        -- STRING
  CAST(NULL                     AS STRING)         AS location_cd,       -- STRING
  CAST(NULL                     AS STRING)         AS tval_char,         -- STRING
  CAST(NULL                     AS DOUBLE)         AS nval_num,          -- DOUBLE
  CAST(NULL                     AS STRING)         AS valueflag_cd,      -- STRING
  CAST(NULL                     AS STRING)         AS units_cd,          -- STRING
  CAST(NULL                     AS FLOAT)          AS confidence_num,    -- FLOAT
  CAST(NULL                     AS STRING)         AS sourcesystem_cd,   -- STRING
  CAST(NULL                     AS TIMESTAMP)      AS update_date,       -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)      AS download_date,     -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)      AS import_date,       -- TIMESTAMP
  CAST(NULL                     AS BINARY)         AS observation_blob,  -- BINARY
  CAST(NULL                     AS INT)            AS upload_id,         -- INT
  CAST(NULL                     AS INT)            AS quantity_num,      -- INT

  CAST(drug_source_concept_id    AS INT)          AS source_concept_id, -- INT
  CAST(drug_source_value         AS STRING)       AS source_value,      -- STRING
  'DRUG'                                         AS domain_id          -- STRING
FROM drug_exposure;

CREATE OR REPLACE VIEW measurement_ns_view AS
SELECT
  visit_occurrence_id                                              AS encounter_num,   -- INT
  person_id                                                        AS patient_num,     -- INT
  CAST(measurement_source_concept_id AS STRING)                    AS concept_cd,      -- STRING
  COALESCE(provider_id, '@')                                       AS provider_id,     -- STRING
  measurement_date                                                 AS start_date,      -- DATE/TIMESTAMP
  CAST(NULL                      AS TIMESTAMP)                     AS end_date,        -- TIMESTAMP
  '@'                                                              AS modifier_cd,     -- STRING
  1                                                                AS instance_num,    -- INT

  CASE 
    WHEN value_as_number IS NOT NULL THEN 'N'
    ELSE 'T'
  END                                                              AS valtype_cd,      -- STRING

  CAST(NULL                      AS STRING)                        AS location_cd,     -- STRING

  CAST(
    CASE
      WHEN operator_concept_id = 4172703 THEN 'E'
      WHEN operator_concept_id = 4171756 THEN 'LT'
      WHEN operator_concept_id = 4172704 THEN 'GT'
      WHEN operator_concept_id = 4171754 THEN 'LE'
      WHEN operator_concept_id = 4171755 THEN 'GE'
      WHEN operator_concept_id IS NULL                       THEN 'E'
      ELSE NULL
    END AS STRING
  )                                                                AS tval_char,       -- STRING

  value_as_number                                                  AS nval_num,        -- DOUBLE
  CAST(value_as_concept_id        AS STRING)                       AS valueflag_cd,    -- STRING
  unit_source_value                                                AS units_cd,        -- STRING
  CAST(NULL                      AS FLOAT)                         AS confidence_num,  -- FLOAT
  CAST(NULL                      AS STRING)                        AS sourcesystem_cd, -- STRING
  CAST(NULL                      AS TIMESTAMP)                     AS update_date,     -- TIMESTAMP
  CAST(NULL                      AS TIMESTAMP)                     AS download_date,   -- TIMESTAMP
  CAST(NULL                      AS TIMESTAMP)                     AS import_date,     -- TIMESTAMP
  CAST(NULL                      AS BINARY)                        AS observation_blob,-- BINARY
  CAST(NULL                      AS INT)                           AS upload_id,       -- INT
  CAST(NULL                      AS INT)                           AS quantity_num,    -- INT

  CAST(measurement_source_concept_id AS INT)                        AS source_concept_id,-- INT
  CAST(measurement_source_value      AS STRING)                     AS source_value,    -- STRING
  'MEASUREMENT'                                                    AS domain_id        -- STRING
FROM measurement;

CREATE OR REPLACE VIEW observation_ns_view AS
SELECT
  visit_occurrence_id                                           AS encounter_num,   -- INT
  person_id                                                     AS patient_num,     -- INT
  CAST(observation_source_concept_id AS STRING)                 AS concept_cd,      -- STRING
  COALESCE(provider_id, '@')                                    AS provider_id,     -- STRING
  observation_date                                              AS start_date,      -- DATE/TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)                   AS end_date,        -- TIMESTAMP
  '@'                                                           AS modifier_cd,     -- STRING
  1                                                             AS instance_num,    -- INT

  CASE 
    WHEN value_as_number IS NOT NULL THEN 'N' 
    ELSE 'T' 
  END                                                           AS valtype_cd,      -- STRING

  CAST(NULL                     AS STRING)                      AS location_cd,     -- STRING

  CAST(
    CASE 
      WHEN value_as_number IS NOT NULL THEN 'E' 
      ELSE observation_source_value 
    END AS STRING
  )                                                              AS tval_char,       -- STRING

  value_as_number                                               AS nval_num,        -- DOUBLE
  CAST(value_as_concept_id    AS STRING)                         AS valueflag_cd,    -- STRING
  unit_source_value                                             AS units_cd,        -- STRING
  CAST(NULL                     AS FLOAT)                       AS confidence_num,  -- FLOAT
  CAST(NULL                     AS STRING)                      AS sourcesystem_cd, -- STRING
  CAST(NULL                     AS TIMESTAMP)                   AS update_date,     -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)                   AS download_date,   -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)                   AS import_date,     -- TIMESTAMP

  CAST(NULL                     AS BINARY)                      AS observation_blob,-- BINARY
  CAST(NULL                     AS INT)                         AS upload_id,       -- INT
  CAST(NULL                     AS INT)                         AS quantity_num,    -- INT

  CAST(observation_source_concept_id AS INT)                     AS source_concept_id,-- INT
  CAST(observation_source_value      AS STRING)                  AS source_value,    -- STRING
  'OBSERVATION'                                                AS domain_id        -- STRING
FROM observation;

CREATE OR REPLACE VIEW PROCEDURE_NS_VIEW AS
SELECT
  visit_occurrence_id                             AS encounter_num,       -- INT
  person_id                                       AS patient_num,         -- INT
  CAST(procedure_source_concept_id AS STRING)     AS concept_cd,          -- STRING
  COALESCE(CAST(provider_id AS STRING), '@')      AS provider_id,         -- STRING
  procedure_datetime                              AS start_date,          -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)     AS end_date,            -- TIMESTAMP
  '@'                                             AS modifier_cd,         -- STRING
  1                                               AS instance_num,        -- INT
  CAST(NULL                     AS STRING)        AS valtype_cd,          -- STRING
  CAST(NULL                     AS STRING)        AS location_cd,         -- STRING
  CAST(NULL                     AS STRING)        AS tval_char,           -- STRING
  CAST(NULL                     AS DECIMAL(38,10)) AS nval_num,            -- DECIMAL
  CAST(NULL                     AS STRING)        AS valueflag_cd,        -- STRING
  CAST(NULL                     AS STRING)        AS units_cd,            -- STRING
  CAST(NULL                     AS FLOAT)         AS confidence_num,      -- FLOAT
  CAST(NULL                     AS STRING)        AS sourcesystem_cd,     -- STRING
  CAST(NULL                     AS TIMESTAMP)     AS update_date,         -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)     AS download_date,       -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)     AS import_date,         -- TIMESTAMP
  CAST(NULL                     AS BINARY)         AS observation_blob,   -- BINARY ← fixed!
  CAST(NULL                     AS INT)           AS upload_id,           -- INT
  CAST(NULL                     AS INT)           AS quantity_num,        -- INT
  CAST(procedure_source_concept_id AS INT)        AS source_concept_id,   -- INT
  CAST(procedure_source_value      AS STRING)     AS source_value,        -- STRING
  'PROCEDURE'                                    AS domain_id            -- STRING
FROM procedure_occurrence;

CREATE OR REPLACE VIEW ZIPCODE_VIEW AS
SELECT
  0                                                      AS encounter_num,    -- INT
  p.person_id                                            AS patient_num,      -- INT
  CAST(
    CASE
      WHEN length(l.zip) = 3 THEN concat('DEM|ZIP3:', l.zip)
      WHEN length(l.zip) >= 5 THEN concat('DEM|ZIPCODE:', substring(l.zip,1,5))
    END
  AS STRING)                                              AS concept_cd,       -- STRING

  COALESCE(CAST(p.provider_id AS STRING), '@')            AS provider_id,      -- STRING
  p.birth_datetime                                        AS start_date,       -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)             AS end_date,         -- TIMESTAMP
  '@'                                                     AS modifier_cd,      -- STRING
  1                                                       AS instance_num,     -- INT

  CAST(NULL                     AS STRING)                AS valtype_cd,       -- STRING
  CAST(NULL                     AS STRING)                AS location_cd,      -- STRING
  CAST(NULL                     AS STRING)                AS tval_char,        -- STRING
  CAST(NULL                     AS DECIMAL(38,10))         AS nval_num,         -- DECIMAL
  CAST(NULL                     AS STRING)                AS valueflag_cd,     -- STRING
  CAST(NULL                     AS STRING)                AS units_cd,         -- STRING
  CAST(NULL                     AS FLOAT)                 AS confidence_num,   -- FLOAT
  CAST(NULL                     AS STRING)                AS sourcesystem_cd,  -- STRING
  CAST(NULL                     AS TIMESTAMP)             AS update_date,      -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)             AS download_date,    -- TIMESTAMP
  CAST(NULL                     AS TIMESTAMP)             AS import_date,      -- TIMESTAMP

  -- cast this NULL to BINARY so it isn’t void
  CAST(NULL                     AS BINARY)                AS observation_blob, -- BINARY

  CAST(NULL                     AS INT)                   AS upload_id,        -- INT
  CAST(NULL                     AS INT)                   AS quantity_num,     -- INT
  CAST(NULL                     AS INT)                   AS source_concept_id,-- INT

  l.location_source_value                                 AS source_value,     -- STRING
  'LOCATION'                                              AS domain_id         -- STRING
FROM person p
JOIN location l
  ON l.location_id = p.location_id
 AND l.zip IS NOT NULL;